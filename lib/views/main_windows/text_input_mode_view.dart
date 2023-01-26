import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lesson_companion/controllers/companion_methods.dart';
import 'package:lesson_companion/controllers/text_mode_input_controller.dart';
import 'package:lesson_companion/models/database.dart';
import 'package:lesson_companion/models/dictionary/look_up.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/report.dart';
import 'package:lesson_companion/models/student.dart';
import 'package:lesson_companion/views/dialogs/lookups/new_language_look_up.dart';
import 'package:lesson_companion/views/main_windows/pdf_preview.dart';

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

final _nonSplitterKeys = [
  "Backspace",
  "Delete",
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

const _rowStart = "-";
const _headingStart = "@";
const _commentStart = "!!";
const _start = "=<";
const _stop = ">=";

//==============================================================================
// Text Input Mode View
//==============================================================================
class TextInputModeView extends StatefulWidget {
  const TextInputModeView({Key? key}) : super(key: key);

  @override
  State<TextInputModeView> createState() => _TextInputModeViewState();
}

class _TextInputModeViewState extends State<TextInputModeView> {
  final _lookUps = <NewLanguageLookUp>[];
  final _lookUpCards = <NewLanguageLookUpCard>[];
  final _lookUpReturns = <LookUpReturn>[];

  int? _currentReportId;

  final _textController = TextEditingController();
  bool _inFocus = false;
  bool _loading = false;
  final _textNode = FocusNode();

  double _fontSize = 11.0;

  //MAIN------------------------------------------------------------------------

  @override
  initState() {
    _textController.text = _template;
    super.initState();
  }

  @override
  void dispose() {
    Database.saveSetting(SharedPrefOption.fontSize, _fontSize);

    window.onKeyData = null;
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FocusScope(
          autofocus: true,
          canRequestFocus: true,
          onKey: (node, event) {
            return _handleKey(event);
          },
          child: Focus(
            child: Column(
              children: [
                Expanded(
                    child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      children: [
                        Expanded(
                            child: RawKeyboardListener(
                          focusNode: _textNode,
                          autofocus: true,
                          child: TextField(
                            controller: _textController,
                            onSubmitted: ((value) {
                              _textController.selection =
                                  TextSelection.collapsed(offset: 0);
                            }),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 9),
                            ),
                            style: TextStyle(
                                fontSize: _fontSize, fontFamily: "Roboto"),
                            maxLines: null,
                            expands: true,
                          ),
                          onKey: null,
                        )),
                      ],
                    ),
                  ),
                )),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                        onPressed: _onPressedSubmit,
                        child: const Text("Submit")))
              ],
            ),
            onFocusChange: (value) {
              setState(() {
                _inFocus = value;
              });
            },
          ),
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.more,
          children: [
            SpeedDialChild(
                label: "Look Up New Language",
                onTap: () async {
                  _switchLoading();
                  _lookUpWords().then((value) {
                    _switchLoading();
                  });
                }),
            SpeedDialChild(
                label: "Duplicate Corrections",
                onTap: () {
                  _duplicateCorrections();
                  _textController.text = _format(_textController.text);
                }),
            SpeedDialChild(
                label: "Reset",
                onTap: () {
                  setState(() {
                    _textController.text = _template;
                  });
                }),
            SpeedDialChild(
                label: "Unformat",
                onTap: () {
                  setState(() {
                    _textController.text = _unformat();
                  });
                }),
            SpeedDialChild(
                label: "Format",
                onTap: () {
                  setState(() {
                    _textController.text = _format(_textController.text);
                  });
                }),
          ],
        ));
  }

  //FORMATTING------------------------------------------------------------------

  String _unformat() {
    String temp = _textController.text;
    temp = temp.replaceAll("\n\t\t", "");
    temp = temp.replaceAll("\n\t\t\t\t", "");
    temp = temp.replaceAll("\t", "");
    return temp;
  }

  String _format(String input) {
    final sb = StringBuffer();
    final whitespacePostSplit = "\t\t\t\t";
    final whitespacePreSplit = "\t\t";

    bool afterSplit = false;

    for (int i = 0; i < input.length; i++) {
      switch (input[i]) {
        case "@":
          sb.write("\n\n${input[i]}");
          break;
        case "|":
          if (input[i - 1] == "|") {
            if (!afterSplit) {
              sb.write("${input[i]}\n$whitespacePostSplit");
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
              sb.write("${input[i]}\n$whitespacePostSplit");
            } else {
              sb.write("${input[i]}\n$whitespacePreSplit");
            }
          } else {
            sb.write(input[i]);
          }
          break;
        case "-":
          if (input[i - 1] == "\n") {
            sb.write("\n${input[i]}\t");
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
    return sb.toString().replaceAll("\n- ", "\n-\t");
  }

  String _autoStartRow(String keyLabel, int minOffset) {
    final sb = StringBuffer();
    sb.write(_textController.text);

    final strA = sb.toString().substring(0, minOffset);
    final strB = sb.toString().substring(minOffset, sb.toString().length);

    return "$strA-\t$strB";
  }

  String _autoCellBreak(int caretIndex) {
    final sb = StringBuffer();
    sb.write(_textController.text);

    final strA = sb.toString().substring(0, caretIndex);
    final strB = sb.toString().substring(caretIndex, sb.toString().length);

    return "$strA|\n\t\t\t\t$strB";
  }

  String _autoLineBreak(int caretIndex, bool afterSplitter) {
    final sb = StringBuffer();
    sb.write(_textController.text);

    final strA = sb.toString().substring(0, caretIndex);
    final strB = sb.toString().substring(caretIndex, sb.toString().length);

    if (afterSplitter) {
      return "$strA/\n\t\t\t\t$strB";
    } else {
      return "$strA/\n\t\t$strB";
    }
  }

  //LOOK UP---------------------------------------------------------------------

  void _switchLoading() {
    setState(() {
      _loading = (_loading) ? false : true;
    });
  }

  Future<bool> _lookUpWords() async {
    List<String> temp = [];

    final connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
              "No Internet connection detected. Please make sure you are connected to use this feature.")));
      return false;
    }

    _textController.text = _format(_textController.text);
    final indexStart = _textController.text.indexOf("@ New Language");
    final indexEnd = (_textController.text.indexOf("@", indexStart + 1) != -1)
        ? _textController.text.indexOf("@", indexStart + 1)
        : _textController.text.indexOf(">=");
    final chunk = _textController.text.substring(indexStart, indexEnd);
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
                lookUpQueries: temp, controller: _textController);
          })));
      return true;
    }
    return false;
  }

  //OTHER-----------------------------------------------------------------------

  void _onPressedSubmit() async {
    //_textController.text = _autoFormat(_textController.text);
    String text = _unformat();
    if (TextModeMethods.checkNeededHeadings(text)) {
      try {
        while (text.contains("=<") && text.contains(">=")) {
          final start = text.indexOf("=<");
          final stop = text.indexOf(">=");
          final singleEntry = text.substring(start + 2, stop);
          text = text.substring(stop + 2, text.length);

          final report = Report(singleEntry);
          final mapping = report.toMap(singleEntry);

          //check if Student exists
          final student = Student();
          final studentId;
          if (!await Database.checkStudentExistsByName(
              mapping["Name"]!.first)) {
            //if not, create new Hive entry
            student.name = mapping["Name"]!.first;
            student.active = true;
            await Database.saveStudent(student);
          }
          studentId = await Database.getStudentId(mapping["Name"]!.first);

          if (student.name != null) {
            student.id = studentId!;
          } else {
            student.name = mapping["Name"]!.first;
            student.active = true;
            student.id = studentId!;
          }

          //format the Date string
          if (mapping["Date"]!.first.toString().contains('/')) {
            mapping["Date"]!.first =
                mapping["Date"]!.first.replaceAll('/', '-');
          }
          if (mapping["Date"]!.first.toString().split('-')[2].length == 1) {
            final tempList = mapping["Date"]!.first.toString().split('-');
            final tempDay = "0${tempList[2]}";
            mapping["Date"]!.first = "${tempList[0]}-${tempList[1]}-$tempDay";
          }

          final date = DateTime.parse(mapping["Date"]!.first);
          final topic = mapping["Topic"]!;
          final homework = mapping["Homework"];

          //Submit Lesson
          var less = await Database.getLesson(student.name, date);
          if (less != null) {
            less.topic = CompanionMethods.convertListToString(topic);
            less.homework = homework != null
                ? CompanionMethods.convertListToString(homework)
                : "";
          } else {
            less = Lesson(
                studentId: studentId!,
                date: date,
                topic: CompanionMethods.convertListToString(topic),
                homework: homework != null
                    ? CompanionMethods.convertListToString(homework)
                    : "");
          }

          await Database.saveLesson(less);
          print(
              "Lesson saved: ${mapping["Name"]!.first} >> ${mapping["Topic"]!.first}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Lesson saved: ${mapping["Name"]!.first} >> ${mapping["Topic"]!.first}")));

          if (mapping.keys.length > 4 ||
              (mapping.keys.length == 4 &&
                  !mapping.keys.contains("Homework"))) {
            try {
              final pdfDoc = await report.toPdfDoc();
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return PdfPreviewPage(pdfDocument: pdfDoc);
                },
              ));
            } on Exception {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Report could not be made.\nYou may have made a mistake with you notation markers.\nPlease check them again")));
            }
          }
        }
      } on InputException {
        final we = InputException("Name, Date, and Topic are required fields");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(we.cause)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Failed to submit lesson.\nThere is a problem with the text format.")));
    }
  }

  KeyEventResult _handleKey(RawKeyEvent value) {
    final k = value.logicalKey;

    // this character is used to format the final report
    if (k.keyLabel == "^") {
      return KeyEventResult.handled;
    }

    if (value is RawKeyDownEvent) {
      print(k.keyLabel);

      final List<int> caretIndex = [
        _textController.selection.baseOffset,
        _textController.selection.extentOffset
      ];

      if (CompanionLexer.markers.contains(k.keyLabel)) {
        final newText = CompanionMethods.autoInsertBrackets(
            k.keyLabel, _textController, caretIndex[0], caretIndex[1]);

        _textController.text = newText;
        _textController.selection = TextSelection(
            baseOffset: caretIndex[0] + 1, extentOffset: caretIndex[1] + 1);

        return KeyEventResult.handled;
      } else if (value.isControlPressed) {
        switch (k.keyLabel) {
          case "S":
            //_saveReportSync();
            break;
          case "B":
            _textController.text =
                CompanionMethods.insertStyleSyntax("**", _textController);
            _textController.selection = TextSelection(
                baseOffset: caretIndex[0] + 2, extentOffset: caretIndex[1] + 2);
            break;
          case "I":
            _textController.text =
                CompanionMethods.insertStyleSyntax("*", _textController);
            _textController.selection = TextSelection(
                baseOffset: caretIndex[0] + 1, extentOffset: caretIndex[1] + 1);
            break;
          case "U":
            _textController.text =
                CompanionMethods.insertStyleSyntax("_", _textController);
            _textController.selection = TextSelection(
                baseOffset: caretIndex[0] + 1, extentOffset: caretIndex[1] + 1);
            break;
          case "Enter":
            final fullText = _textController.text;

            final before;
            final middle = "\n";
            final after;
            final newSelectionIndex;

            final indexNextLineEnd =
                fullText.indexOf("\n", _textController.selection.baseOffset);

            if (indexNextLineEnd != -1) {
              before = fullText.substring(0, indexNextLineEnd);
              after = fullText.substring(indexNextLineEnd, fullText.length);
              newSelectionIndex = indexNextLineEnd;
            } else {
              before = fullText;
              after = "";
              newSelectionIndex = fullText.length + 1;
            }

            _textController.text = "$before$middle$after";
            _textController.selection =
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
          default:
        }
        return KeyEventResult.ignored;
      } else {
        if (!_nonAutoRowStartKeys.contains(k.keyLabel) && //auto-start row
            _textController.text[caretIndex[0] - 1] == "\n") {
          final indexMin =
              (caretIndex[0] < caretIndex[1]) ? caretIndex[0] : caretIndex[1];

          _textController.text = _autoStartRow(k.keyLabel, indexMin);
          _textController.selection = TextSelection(
              baseOffset: caretIndex[0] + 2, extentOffset: caretIndex[1] + 2);
        } else if (k.keyLabel == "|" && //auto-go to new line for RHS cell entry
            (_textController.text[caretIndex[0] - 1] == "|")) {
          _textController.text = _autoCellBreak(caretIndex[0]);
          _textController.selection = TextSelection(
              baseOffset: caretIndex[0] + 4, extentOffset: caretIndex[1] + 4);
          return KeyEventResult.handled;
        } else if (k.keyLabel == "/" && //auto-make line break in cell
            (_textController.text[caretIndex[0] - 1] == "/")) {
          int lineStartIndex = 0;
          int thisIndex;

          if (_textController.text.contains("\n-")) {
            thisIndex = _textController.text.indexOf("\n-");

            while (thisIndex < caretIndex[0]) {
              lineStartIndex = thisIndex;
              thisIndex =
                  _textController.text.indexOf("\n-", lineStartIndex + 1);

              if (thisIndex == -1) {
                lineStartIndex = _textController.text.indexOf("\n-");
                break;
              }
            }
          } else {
            thisIndex = _textController.text.indexOf("\n");
          }

          final start = lineStartIndex;
          final end = caretIndex[0];

          final line = _textController.text.substring(start, end);
          if (line.contains("||") && (line.indexOf("||") < caretIndex[0])) {
            _textController.text = _autoLineBreak(caretIndex[0], true);
            _textController.selection = TextSelection(
                baseOffset: caretIndex[0] + 6, extentOffset: caretIndex[1] + 6);
          } else {
            _textController.text = _autoLineBreak(caretIndex[0], false);
            _textController.selection = TextSelection(
                baseOffset: caretIndex[0] + 4, extentOffset: caretIndex[1] + 4);
          }
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  void _saveReportSync() {
    _textController.text = _format(_textController.text);

    final report;
    if (_currentReportId != null) {
      report = Report.getReportSync(_currentReportId!);

      if (report == null) {
        final newReport = Report(_textController.text);
        Report.saveReportSync(newReport);
        _currentReportId = newReport.id;
      } else {
        report.text = _textController.text;
        Report.saveReportSync(report);
      }
    } else {
      final newReport = Report(_textController.text);
      Report.saveReportSync(newReport);
      _currentReportId = newReport.id;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Report saved")));
  }

  void _duplicateCorrections() {
    _textController.text = _format(_textController.text);

    final fullText = _textController.text;
    final StringBuffer sb = StringBuffer();

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

      if (!line.contains("||")) {
        sb.writeln("${line.trim()} || ${line.substring(2)}");
      } else {
        sb.writeln(line);
      }
    }

    final before = fullText.substring(0, indexStart);
    final middle = sb.toString().trim();
    final after = fullText.substring(indexEnd, fullText.length);

    _textController.text = "$before\n$middle\n\n$after";
  }
}

// The storage area-------------------------------------------------------------

final _template = """=<

@ Name


@ Date
-\t${CompanionMethods.getShortDate(DateTime.now())}

@ Topic


@ New Language


@ Pronunciation


@ Corrections


>=""";
