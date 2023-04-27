import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lesson_companion/controllers/co_methods.dart';
import 'package:lesson_companion/controllers/styler.dart';
import 'package:lesson_companion/models/database.dart';
import 'package:lesson_companion/models/dictionary/look_up.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';
import 'package:lesson_companion/models/report.dart';
import 'package:lesson_companion/models/report_template.dart';
import 'package:lesson_companion/models/student.dart';
import 'package:lesson_companion/views/companion_widgets.dart';
import 'package:lesson_companion/views/dialogs/lookups/new_language_look_up.dart';
import 'package:lesson_companion/views/main_windows/pdf_preview.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

import '../../controllers/styling/companion_lexer.dart';

final _nonAutoRowStartKeys = [
  "Backspace",
  "Delete",
  "-",
  "@",
  "Arrow Left",
  "Arrow Right",
  "Arrow Up",
  "Arrow Down",
  "Alt Right",
  "Alt Left",
  "Shift Left",
  "Shift Right",
  "Control Left",
  "Control Right",
];

//==============================================================================
// Text Input Mode View
//==============================================================================
class TextEditorView extends StatefulWidget {
  const TextEditorView({Key? key}) : super(key: key);

  @override
  State<TextEditorView> createState() => _TextEditorViewState();
}

class _TextEditorViewState extends State<TextEditorView> {
  final _lookUpReturns = <LookUpReturn>[];

  final _textNode = FocusNode();

  double _fontSize = 13.0;

  String? _name;
  DateTime _date = DateTime.now();
  String? _topic;
  String? _homework;

  RichTextController? _currentController;
  late RichTextController _nameController;
  late RichTextController _dateController;
  late RichTextController _topicController;
  late RichTextController _bodyController;

  static final Map _monthsMap = {
    "Jan": 1,
    "Feb": 2,
    "Mar": 3,
    "Apr": 4,
    "May": 5,
    "Jun": 6,
    "Jul": 7,
    "Aug": 8,
    "Sep": 9,
    "Oct": 10,
    "Nov": 11,
    "Dec": 12
  };

  //MAIN------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FocusScope(
            autofocus: true,
            canRequestFocus: true,
            onKey: (node, event) {
              return _handleKey(
                  controller: _currentController, rawKeyEvent: event);
            },
            child: Column(children: [
              // tool bar
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          // NAME Textfield
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(3, 4, 1, 2),
                            child: TextField(
                              controller: _nameController,
                              onChanged: (newText) {
                                _name = newText;
                              },
                              style: TextStyle(
                                fontSize: _fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 9,
                                ),
                                isDense: true,
                                hintText: "Name",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(1, 4, 3, 2),
                              child: TextFormField(
                                readOnly: true,
                                onTap: () async {
                                  await showDatePicker(
                                    context: context,
                                    initialDate: _date,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2099),
                                  ).then((selectedDate) {
                                    setState(() {
                                      _date = selectedDate!;
                                      _dateController.text =
                                          CoMethods.getShortDate(_date);
                                    });
                                  });
                                },
                                textInputAction: TextInputAction.next,
                                controller: _dateController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 9,
                                  ),
                                ),
                                style: TextStyle(fontSize: _fontSize),
                                maxLines: 1,
                              ),
                            ))
                      ],
                    ),
                    Focus(
                      child: TextFieldOutlined(
                        hint: "Topic",
                        controller: _topicController,
                        size: _fontSize,
                        onTextChanged: (text) {
                          _topic = text;
                        },
                      ),
                      onFocusChange: (_) {
                        _currentController = _topicController;
                      },
                    ),
                  ],
                ),
              ),
              // main text field
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Focus(
                            child: RawKeyboardListener(
                              focusNode: _textNode,
                              autofocus: true,
                              child: TextField(
                                controller: _bodyController,
                                onSubmitted: ((_) {
                                  _bodyController.selection =
                                      TextSelection.collapsed(offset: 0);
                                }),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 9,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: _fontSize,
                                  fontFamily: "Roboto",
                                ),
                                maxLines: null,
                                expands: true,
                              ),
                            ),
                            onFocusChange: (_) {
                              _currentController = _bodyController;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: ElevatedButton(
                    onPressed: _onPressedSubmit,
                    child: const Text("Submit"),
                  ))
            ])));
  }

  @override
  initState() {
    _bodyController = RichTextController(
        patternMatchMap: CompanionLexer.highlighter,
        onMatch: (_) {},
        deleteOnBack: false);
    _bodyController.text = _template;

    _nameController = RichTextController(
        patternMatchMap: CompanionLexer.highlighter,
        onMatch: (_) {},
        deleteOnBack: false);
    _dateController = RichTextController(
        patternMatchMap: CompanionLexer.highlighter,
        onMatch: (_) {},
        deleteOnBack: false);
    _dateController.text = CoMethods.getDateString(_date);
    _topicController = RichTextController(
        patternMatchMap: CompanionLexer.highlighter,
        onMatch: (_) {},
        deleteOnBack: false);

    super.initState();
  }

  @override
  void dispose() {
    Database.saveSetting(SharedPrefOption.fontSize, _fontSize);

    window.onKeyData = null;
    _bodyController.dispose();
    super.dispose();
  }

  Widget _templateListView(AsyncSnapshot snapshot) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            snapshot.data![index].text!,
            softWrap: true,
          ),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Load Template"),
                  content: Text(
                      "Are you sure you want to load this template to the editor?\nThis will remove all current text"),
                  actions: [
                    OutlinedButton(
                        onPressed: () {
                          _bodyController.text = snapshot.data![index].text!;
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Text("Yes")),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No"))
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _newTemplateDialog() {
    String? _templateBody;

    return AlertDialog(
      content: TextFieldBorderless(
        onTextChanged: (p0) {
          _templateBody = p0;
        },
      ),
      actions: [
        TextButton(
            onPressed: () async {
              if (_templateBody != null && _templateBody!.isNotEmpty) {
                await ReportTemplate.save(ReportTemplate(text: _templateBody));
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please enter a body for the template.")));
              }
            },
            child: Text("OK"))
      ],
    );
  }

  //FORMATTING------------------------------------------------------------------

  String _unformat() {
    String temp = _bodyController.text;
    temp = temp.replaceAll("\n  ", "");
    temp = temp.replaceAll("\n    ", "");
    return temp;
  }

  String _format(String input) {
    final sb = StringBuffer();
    final whitespacePostSplit = "    ";
    final whitespacePreSplit = "  ";

    bool afterSplit = false;

    for (int i = 0; i < input.length; i++) {
      switch (input[i]) {
        case "@":
          sb.write("\n\n${input[i]}");
          break;
        case "|":
          if (input[i - 1] == "|") {
            if (!afterSplit) {
              if (input.substring(i + 1, i + 6) != "\n    ") {
                sb.write("${input[i]}\n$whitespacePostSplit");
              } else {
                sb.write("${input[i]}\n");
              }
              afterSplit = true;
            } else {
              //only one splitter is allowed per row
              sb.write(input[i]);
            }
          } else {
            sb.write(input[i]);
          }
          break;
        case "/":
          if (input[i - 1] == "/") {
            if (afterSplit) {
              if (input.substring(i + 1, i + 6) != "\n    ") {
                sb.write("${input[i]}\n$whitespacePostSplit");
              } else {
                sb.write("${input[i]}\n");
              }
            } else {
              if (input.substring(i + 1, i + 4) != "\n  ") {
                sb.write("${input[i]}\n$whitespacePreSplit");
              } else {
                sb.write("${input[i]}\n");
              }
            }
          } else {
            sb.write(input[i]);
          }
          break;
        case "-":
          if (input[i - 1] == "\n") {
            if (input[1 + 1] != " ") {
              sb.write("\n${input[i]} ");
            } else {
              sb.write("\n${input[i]}");
            }
            afterSplit = false;
          } else {
            sb.write(input[i]);
          }
          break;
        case ">":
          if (input[i - 1] == "\n" && input[i + 1] == "=") {
            sb.write("\n\n${input[i]}");
          } else {
            sb.write(input[i]);
          }
          break;
        case "\t":
          //skip tabs
          break;
        case "\n":
          //skip line breaks
          break;
        default:
          sb.write(input[i]);
      }
    }
    return sb.toString();
  }

  String _autoStartRow(String keyLabel, int minOffset) {
    final sb = StringBuffer();
    sb.write(_bodyController.text);

    final strA = sb.toString().substring(0, minOffset);
    final strB = sb.toString().substring(minOffset, sb.toString().length);

    return "$strA- $strB";
  }

  String _autoCellBreak(int caretIndex) {
    final sb = StringBuffer();
    sb.write(_bodyController.text);

    final strA = sb.toString().substring(0, caretIndex);
    final strB = sb.toString().substring(caretIndex, sb.toString().length);

    return "$strA|\n    $strB";
  }

  String _autoLineBreak(int caretIndex, bool afterSplitter) {
    final sb = StringBuffer();
    sb.write(_bodyController.text);

    final strA = sb.toString().substring(0, caretIndex);
    final strB = sb.toString().substring(caretIndex, sb.toString().length);

    if (afterSplitter) {
      return "$strA/\n    $strB";
    } else {
      return "$strA/\n  $strB";
    }
  }

  Future<Student> _getOrCreateStudent() async {
    var student = await Student.getByName(_name!);
    if (student == null) {
      student = Student.newStudent(name: _name!);
      await Student.save(student);
    }
    return student;
  }

  Future<Lesson> _getOrCreateLesson(int id) async {
    var lesson = await Lesson.getLesson(_name, _date);
    if (lesson == null) {
      lesson = Lesson(
          studentId: id, date: _date, topic: _topic!, homework: _homework);
    } else {
      lesson.date = _date;
      lesson.topic = _topic!;
      lesson.homework = _homework;
    }
    await Lesson.saveLesson(lesson);
    return lesson;
  }

  //LOOK UP---------------------------------------------------------------------

  Future<bool> _lookUpWords() async {
    List<String> temp = [];

    final connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
            "No Internet connection detected. Please make sure you are connected to use this feature."),
        clipBehavior: Clip.antiAlias,
        showCloseIcon: true,
      ));
      return false;
    }

    _bodyController.text = _format(_bodyController.text);
    final indexStart = _bodyController.text.indexOf("@ New Language");
    final indexEnd = (_bodyController.text.indexOf("@", indexStart + 1) != -1)
        ? _bodyController.text.indexOf("@", indexStart + 1)
        : _bodyController.text.indexOf(">=");
    final chunk = _bodyController.text.substring(indexStart, indexEnd);
    final terms = chunk.split("\n-");

    //skip the first term as it is just the heading
    for (int i = 1; i < terms.length; i++) {
      if (terms[i].trim().length == 0) continue;

      final String thisTerm;

      if (terms[i].contains("||")) {
        thisTerm = terms[i].trim().substring(0, terms[i].trim().indexOf("||"));
      } else {
        thisTerm = terms[i].trim();
      }

      if (thisTerm.isNotEmpty && thisTerm != "-") {
        temp.add(thisTerm);
      }
    }

    if (temp.isNotEmpty) {
      _lookUpReturns.addAll(await showDialog(
          context: context,
          builder: ((context) {
            return NewLanguageLookUpDialog(
                lookUpQueries: temp, controller: _bodyController);
          })));
      return true;
    }
    return false;
  }

  //OTHER-----------------------------------------------------------------------
  void _onPressedSubmit() async {
    // text processed without tabspaces
    String text = _unformat();

    final student = await _getOrCreateStudent();
    final lesson = await _getOrCreateLesson(student.id);

    // TODO: This validation needs to be better
    if (_bodyController.text != _template) {
      final report = Report(
          studentId: student.id,
          lessonId: lesson.id,
          date: _date,
          topic: _topic!,
          body: text);

      final pdfDoc = await report.toPdfDoc();
      final pdfTopic = PdfText();
      await pdfTopic.process(_topic!, PdfSection.h2);
      pdfDoc.topic = pdfTopic;

      Navigator.push<bool>(context, MaterialPageRoute(
        builder: (context) {
          return PdfPreviewPage(pdfDocument: pdfDoc);
        },
      ));
    }

    // TODO: This code is for a depreciated method of batch-adding lessons.
    // TODO: Implement later in a seperate mode?
    // final lReports = (text.contains("===")) ? text.split("===") : null;
    // if (lReports != null) {
    //   for (final reportChunk in lReports) {
    //     final reportObj = Report(
    //         studentId: student.id,
    //         lessonId: lesson.id,
    //         date: _date,
    //         topic: _topic!,
    //         body: reportChunk);

    //     final pdfDoc = await reportObj.toPdfDoc();
    //     Navigator.push(context, MaterialPageRoute(
    //       builder: (context) {
    //         return PdfPreviewPage(pdfDocument: pdfDoc);
    //       },
    //     ));
    //   }
    // } else {}
  }

  String _shiftRow(String keyLabel) {
    final text = _bodyController.text;

    int counterStart = _bodyController.selection.baseOffset;
    while (true) {
      if (text.substring(counterStart, counterStart + 2) == "\n-" ||
          text.substring(counterStart, counterStart + 2) == "\n@") {
        counterStart++;
        break;
      }
      counterStart--;
    }

    String tMarker = "-";
    int counterEnd = text.indexOf(tMarker, counterStart + 1);
    if (counterEnd == -1) {
      tMarker = "@";
      counterEnd = text.indexOf(tMarker, counterStart + 1);
    }
    while (true) {
      if (text[counterEnd - 1] == "\n") {
        break;
      }
      counterEnd = text.indexOf(tMarker, counterStart + 1);
    }

    final chunkAct = text.substring(counterStart, counterEnd);

    if (keyLabel == "Arrow Up") {
      //shift up
      return "";
    } else {
      //shift down
      final counterOldEnd = counterEnd;
      counterEnd = counterStart;
      counterStart = counterStart - 2;

      while (true) {
        final substring = text.substring(counterStart, counterStart + 2);
        if (substring == "\n-" || substring == "\n@") {
          counterStart++;
          break;
        }
        counterStart--;
      }

      final chunkReact = text.substring(counterStart, counterEnd);

      return text.substring(0, counterStart) +
          chunkAct.trim() +
          "\n" +
          chunkReact.trim() +
          "\n" +
          text.substring(counterOldEnd, text.length);
    }
  }

  KeyEventResult _handleKey(
      {required TextEditingController? controller,
      required RawKeyEvent rawKeyEvent}) {
    if (controller == null) return KeyEventResult.ignored;

    final k = rawKeyEvent.logicalKey;

    // this character is used to format the final report
    if (k.keyLabel == "^") {
      return KeyEventResult.handled;
    }

    if (rawKeyEvent is RawKeyDownEvent) {
      // print(k.keyLabel);

      final List<int> caretIndex = [
        controller.selection.baseOffset,
        controller.selection.extentOffset
      ];

      if (CompanionLexer.markers.contains(k.keyLabel)) {
        final newText = CoMethods.autoInsertBrackets(
            k.keyLabel, controller, caretIndex[0], caretIndex[1]);

        controller.text = newText;
        controller.selection = TextSelection(
            baseOffset: caretIndex[0] + 1, extentOffset: caretIndex[1] + 1);

        return KeyEventResult.handled;
      } else if (rawKeyEvent.isControlPressed) {
        switch (k.keyLabel) {
          case "Arrow Up":
          case "Arrow Down":
            controller.text = _shiftRow(k.keyLabel);
            controller.selection = TextSelection(
                baseOffset: caretIndex[0], extentOffset: caretIndex[1]);
            break;
          case "S":
            //_saveReportSync();
            break;
          case "B":
            controller.text = CoMethods.insertStyleSyntax("**", controller);
            controller.selection = TextSelection(
                baseOffset: caretIndex[0] + 2, extentOffset: caretIndex[1] + 2);
            break;
          case "I":
            controller.text = CoMethods.insertStyleSyntax("*", controller);
            controller.selection = TextSelection(
                baseOffset: caretIndex[0] + 1, extentOffset: caretIndex[1] + 1);
            break;
          case "U":
            controller.text = CoMethods.insertStyleSyntax("_", controller);
            controller.selection = TextSelection(
                baseOffset: caretIndex[0] + 1, extentOffset: caretIndex[1] + 1);
            break;
          case "Enter":
            final fullText = controller.text;

            final before;
            final middle = "\n";
            final after;
            final newSelectionIndex;

            final indexNextLineEnd =
                fullText.indexOf("\n", controller.selection.baseOffset);

            if (indexNextLineEnd != -1) {
              before = fullText.substring(0, indexNextLineEnd);
              after = fullText.substring(indexNextLineEnd, fullText.length);
              newSelectionIndex = indexNextLineEnd;
            } else {
              before = fullText;
              after = "";
              newSelectionIndex = fullText.length + 1;
            }

            controller.text = "$before$middle$after";
            controller.selection =
                TextSelection.collapsed(offset: newSelectionIndex + 1);

            return KeyEventResult.handled;
          case "Numpad Add":
            //increase font size
            setState(() {
              _fontSize++;
            });
            break;
          case "Numpad Subtract":
            //decrease font size
            setState(() {
              _fontSize--;
            });
            break;
          // TODO: this is just a copy from "Enter"'s body
          case "V":
          // TODO: create new line marker if controller is main one
          default:
        }
        return KeyEventResult.ignored;
      } else {
        if (!_nonAutoRowStartKeys.contains(k.keyLabel) && //auto-start row
            _bodyController.text[caretIndex[0] - 1] == "\n") {
          final indexMin =
              (caretIndex[0] < caretIndex[1]) ? caretIndex[0] : caretIndex[1];

          _bodyController.text = _autoStartRow(k.keyLabel, indexMin);
          _bodyController.selection = TextSelection(
              baseOffset: caretIndex[0] + 2, extentOffset: caretIndex[1] + 2);
        } else if (k.keyLabel == "|" && //auto-go to new line for RHS cell entry
            (_bodyController.text[caretIndex[0] - 1] == "|")) {
          _bodyController.text = _autoCellBreak(caretIndex[0]);
          _bodyController.selection = TextSelection(
              baseOffset: caretIndex[0] + 6, extentOffset: caretIndex[1] + 6);
          return KeyEventResult.handled;
        } else if (k.keyLabel == "/" && //auto-make line break in cell
            (_bodyController.text[caretIndex[0] - 1] == "/")) {
          int lineStartIndex = 0;
          int thisIndex;

          if (_bodyController.text.contains("\n-")) {
            thisIndex = _bodyController.text.indexOf("\n-");

            while (thisIndex < caretIndex[0]) {
              lineStartIndex = thisIndex;
              thisIndex =
                  _bodyController.text.indexOf("\n-", lineStartIndex + 1);

              if (thisIndex == -1) {
                lineStartIndex = _bodyController.text.indexOf("\n-");
                break;
              }
            }
          } else {
            thisIndex = _bodyController.text.indexOf("\n");
          }

          final start = lineStartIndex;
          final end = caretIndex[0];

          final line = _bodyController.text.substring(start, end);
          if (line.contains("||") && (line.indexOf("||") < caretIndex[0])) {
            _bodyController.text = _autoLineBreak(caretIndex[0], true);
            _bodyController.selection = TextSelection(
                baseOffset: caretIndex[0] + 6, extentOffset: caretIndex[1] + 6);
          } else {
            _bodyController.text = _autoLineBreak(caretIndex[0], false);
            _bodyController.selection = TextSelection(
                baseOffset: caretIndex[0] + 4, extentOffset: caretIndex[1] + 4);
          }
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  void _duplicateCorrections() {
    _bodyController.text = _format(_bodyController.text);

    final fullText = _bodyController.text;
    final StringBuffer sb = StringBuffer();

    // get the full "Corrections" text chunk
    final indexStart = fullText.indexOf("@ Corrections") + 14;
    final indexEnd;
    if (fullText.indexOf("@", indexStart) != -1) {
      indexEnd = fullText.indexOf("@", indexStart);
    } else {
      indexEnd = fullText.indexOf(">=");
    }

    final nl = fullText.substring(indexStart, indexEnd).split("\n");

    for (final line in nl) {
      if (line.isEmpty || line.trim().length == 0) continue;
      if (line.endsWith(" ??")) {
        sb.writeln(line.substring(0, line.length - 3));
        continue;
      }

      if (!line.contains("||")) {
        sb.writeln("${line.trim()} || ${line.substring(2)}");
      } else {
        sb.writeln(line);
      }
    }

    final before = fullText.substring(0, indexStart);
    final middle = sb.toString().trim();
    final after = fullText.substring(indexEnd, fullText.length);

    _bodyController.text = "$before\n$middle\n\n$after";
  }

  DateTime? _convertStringToDateTime(String day, String month, String year) {
    if (!CoMethods.tryParseToInt(day) || !CoMethods.tryParseToInt(year))
      return null;
    if (!_monthsMap.keys.contains(month)) return null;

    int yearNum = int.parse(year);

    if (yearNum > DateTime.now().year || yearNum < 2000) return null;

    int dayNum = int.parse(day);
    int monthNum = _monthsMap[month];

    return DateFormat("yyyy-MM-dd").parse("$yearNum-$monthNum-$dayNum");
  }
}

// The storage area-------------------------------------------------------------

final _template = """@ New Language


@ Pronunciation


@ Corrections
""";
