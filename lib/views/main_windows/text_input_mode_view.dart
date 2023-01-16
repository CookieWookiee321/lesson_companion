import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lesson_companion/controllers/companion_methods.dart';
import 'package:lesson_companion/controllers/text_mode_input_controller.dart';
import 'package:lesson_companion/models/database.dart';
import 'package:lesson_companion/models/dictionary/free_dictionary.dart';
import 'package:lesson_companion/models/dictionary/look_up.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/report.dart';
import 'package:lesson_companion/models/student.dart';
import 'package:lesson_companion/views/dialogs/lookups/new_language_look_up.dart';
import 'package:lesson_companion/views/main_windows/pdf_preview.dart';

import '../../controllers/styling/companion_lexer.dart';

final _template = """=<
@ Name


@ Date
- ${CompanionMethods.getShortDate(DateTime.now())}

@ Topic


@ New Language


@ Pronunciation


@ Corrections

>=""";

const _rowStart = "-";
const _headingStart = "@";
const _commentStart = "!!";
const _start = "=<";
const _stop = ">=";

//======================================================================
//Text Input Mode View
//======================================================================
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

  //FORMATTING------------------------------------------------------------------

  String _formatTextCell(String input) {
    final preSplitterTabs = "\n\t\t\t";
    final postSplitterTabs = "\n\t\t\t\t\t\t\t";
    String firstString;
    String? secondString;
    bool afterSplitter = false;

    if (input.contains("||")) {
      final splitLine = input.split("||");
      firstString = splitLine[0];
      secondString = splitLine[1];
    } else {
      firstString = input;
      secondString = null;
    }

    // LHS------------------------------------------------------------------
    //handle LHS line breaks
    if (firstString.contains("//")) {
      int totalLineBreaks = 0;

      int i = firstString.indexOf("/");
      while ((i != -1) & (i != firstString.length - 2)) {
        if (firstString[i] == "/" && firstString[i + 1] == "/") {
          totalLineBreaks++;
        }
        i = firstString.indexOf("/", i + 2);
      }

      for (int i = 0; i < totalLineBreaks; i++) {
        int indexOf = firstString.indexOf("//");
        if (indexOf == firstString.length - 2) continue; //TODO: needed? line 93

        if (firstString.substring(indexOf + 2, indexOf + 5) !=
            preSplitterTabs) {
          final aString = "${firstString.substring(0, indexOf)}";
          final bString =
              "${firstString.substring(indexOf + 2, firstString.length)}";
          firstString = "$aString//$preSplitterTabs$bString";
        }
      }
    }

    // RHS------------------------------------------------------------------
    if (secondString != null) {
      //handle RHS line breaks
      if (secondString.contains("//")) {
        int totalLineBreaks = 0;

        int i = secondString.indexOf("/");
        while ((i != -1) & (i != secondString.length - 2)) {
          if (secondString[i] == "/" && secondString[i + 1] == "/") {
            totalLineBreaks++;
          }
          i = secondString.indexOf("/", i + 2);
        }

        for (int j = 0; j < totalLineBreaks; j++) {
          int indexOf = secondString!.indexOf("//");

          final aString = "${secondString.substring(0, indexOf)}";
          final bString =
              "${secondString.substring(indexOf + 2, secondString.length)}";
          secondString = "$aString//$postSplitterTabs$bString";
        }
      }
    }

    if (secondString != null) {
      return "$firstString||$postSplitterTabs$secondString";
    } else {
      return "$firstString";
    }
  }

  void _unformat() {
    String temp = _textController.text;
    temp = temp.replaceAll("\n\t\t", "");
    temp = temp.replaceAll("\n\t\t\t\t\t\t", "");
    temp.replaceAll("\t", "");
    _textController.text = temp;
  }

  String _autoFormat(String input) {
    final sb = StringBuffer();
    final compiledLines = <String>[];
    final lines = input.split("\n");

    //add row start markers
    String checker;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim().length == 0) {
        compiledLines.add(lines[i]);
        continue;
      }

      checker = lines[i].substring(0, 2);
      if (checker[0] == "\t" ||
          checker[0] == _rowStart ||
          checker == _start ||
          checker == _stop ||
          checker[0] == _headingStart ||
          checker.substring(0, 1) == _commentStart) {
        compiledLines.add(lines[i].trimLeft());
        continue;
      }

      lines[i] = "$_rowStart\t${lines[i]}";

      if (lines[i].trim().length != 0) {
        compiledLines.add(lines[i].trim());
      }
    }

    sb.clear();
    for (final l in compiledLines) {
      sb.writeln(_formatTextCell(l));
    }

    if (sb.toString().substring(0, 2) != _start) {
      final temp = sb.toString();
      sb.clear();
      sb.writeln(_start);
      sb.write(temp);
    }

    final stopper =
        sb.toString().substring(sb.toString().length - 3, sb.toString().length);

    if (stopper.trim() != _stop) {
      sb.write(_stop);
    }

    return sb.toString().trim();
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

    _textController.text = _autoFormat(_textController.text);
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
    _unformat();
    String text = _textController.text;
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

          final date;
          final topic;
          final homework;

          date = DateTime.parse(mapping["Date"]!.first);
          topic = mapping["Topic"]!;
          homework = mapping["Homework"];

          //Submit Lesson
          var less = await Database.getLesson(student.name, date);
          if (less != null) {
            less.topic = CompanionMethods.convertListToString(topic!);
            less.homework = homework != null
                ? CompanionMethods.convertListToString(homework!)
                : "";
          } else {
            less = Lesson(
                studentId: studentId!,
                date: date!,
                topic: CompanionMethods.convertListToString(topic!),
                homework: homework != null
                    ? CompanionMethods.convertListToString(homework!)
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

    if (value is RawKeyDownEvent) {
      final baseOffset = _textController.selection.baseOffset;
      final extentOffset = _textController.selection.extentOffset;

      if (CompanionLexer.markers.contains(k.keyLabel)) {
        final baseOffset = _textController.selection.baseOffset;
        final extentOffset = _textController.selection.extentOffset;
        final newText = CompanionMethods.autoInsertBrackets(
            k.keyLabel, _textController, baseOffset, extentOffset);

        _textController.text = newText;
        _textController.selection = TextSelection(
            baseOffset: baseOffset + 1, extentOffset: extentOffset + 1);

        return KeyEventResult.handled;
      } else if (value.isControlPressed) {
        switch (k.keyLabel) {
          case "S":
            _saveReportSync();
            break;
          case "B":
            _textController.text =
                CompanionMethods.insertStyleSyntax("**", _textController);
            _textController.selection = TextSelection(
                baseOffset: baseOffset + 2, extentOffset: extentOffset + 2);
            break;
          case "I":
            _textController.text =
                CompanionMethods.insertStyleSyntax("*", _textController);
            _textController.selection = TextSelection(
                baseOffset: baseOffset + 1, extentOffset: extentOffset + 1);
            break;
          case "U":
            _textController.text =
                CompanionMethods.insertStyleSyntax("_", _textController);
            _textController.selection = TextSelection(
                baseOffset: baseOffset + 1, extentOffset: extentOffset + 1);
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
      }
    }
    return KeyEventResult.ignored;
  }

  void _saveReportSync() {
    _textController.text = _autoFormat(_textController.text);

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
    _textController.text = _autoFormat(_textController.text);

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
                            style: TextStyle(fontSize: _fontSize),
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
                }),
            SpeedDialChild(
                label: "Reset",
                onTap: () {
                  setState(() {
                    _textController.text = _template;
                  });
                }),
            SpeedDialChild(
                label: "Format",
                onTap: () {
                  setState(() {
                    _textController.text = _autoFormat(_textController.text);
                  });
                }),
          ],
        ));
  }
}
