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
import 'package:lesson_companion/views/main_windows/pdf_preview.dart';

final _template = """=<
# Name


# Date
- ${CompanionMethods.getShortDate(DateTime.now())}

# Topic


# New Language


# Pronunciation


# Corrections

>=""";

const _rowStart = "- ";
const _headingStart = "# ";
const _commentStart = "!@";
const _start = "=<";
const _stop = ">=";

//TODO: Fix the auto-completion (in edit)

//======================================================================
//Text Input Mode View
//======================================================================
class TextInputModeView extends StatefulWidget {
  const TextInputModeView({Key? key}) : super(key: key);

  @override
  State<TextInputModeView> createState() => _TextInputModeViewState();
}

class _TextInputModeViewState extends State<TextInputModeView> {
  static const _markers = <String>["*", "{", "(", "\"", "[", "_"];

  final _lookUps = <LookUp>[];
  final _lookUpCards = <LookUpCard>[];
  final _lookUpReturns = <LookUpReturn>[];

  int? _currentReportId;

  final _textController = TextEditingController();
  bool _inFocus = false;
  bool _loading = false;
  final _textNode = FocusNode();

  //FORMATTING------------------------------------------------------------------

  String _autoFormatAll(String input) {
    final sb = StringBuffer();

    final lines = _textController.text.split("\n");

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim().length == 0 ||
          lines[i].substring(0, 2) == _start ||
          lines[i].substring(0, 2) == _stop ||
          lines[i].substring(0, 2) == _headingStart ||
          lines[i].substring(0, 2) == _rowStart ||
          lines[i].substring(0, 2) == _commentStart) {
        sb.write(lines[i]);
        if (i != lines.length) sb.write("\n");
        continue;
      }

      lines[i] = "$_rowStart${lines[i]}";

      sb.write(lines[i]);
      if (i != lines.length) sb.write("\n");
    }

    if (!input.contains(_start)) {
      final temp = sb.toString();
      sb.clear();
      sb.writeln(_start);
      sb.write(temp);
    }
    if (!input.contains(_stop)) sb.write(_stop);

    return sb.toString().substring(0, sb.length);
  }

  //LOOK UP---------------------------------------------------------------------

  void _switchLoading() {
    setState(() {
      _loading = (_loading) ? false : true;
    });
  }

  Future<bool> _lookUpWords() async {
    final connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
              "No Internet connection detected. Please make sure you are connected to use this feature.")));
      return false;
    }

    List<LookUp> temp = [];
    _textController.text = _autoFormatAll(_textController.text);
    final indexStart = _textController.text.indexOf("# New Language");
    final indexEnd = (_textController.text.indexOf("#", indexStart + 1) != -1)
        ? _textController.text.indexOf("#", indexStart + 1)
        : _textController.text.indexOf(">=");
    final chunk = _textController.text.substring(indexStart, indexEnd);
    final terms = chunk.split("\n-");

    //skip the first term as it is just the heading
    for (int i = 1; i < terms.length; i++) {
      if (terms[i].trim().length == 0) continue;

      final thisTerm;

      if (terms[i].contains("||")) {
        thisTerm = terms[i].trim().substring(0, terms[i].trim().indexOf("||"));
      } else {
        thisTerm = terms[i].trim();
      }

      final url = "https://api.dictionaryapi.dev/api/v2/entries/en/${thisTerm}";
      final dictionary = await FreeDictionary.fetchJson(url);

      if (dictionary != null) {
        temp.add(LookUp(dictionary));
      }
    }

    if (temp.isNotEmpty) {
      _lookUps.clear();
      _lookUpCards.clear();
      _lookUpReturns.clear();
      _lookUps.addAll(temp);

      for (final lu in _lookUps) {
        final lur = LookUpReturn(lu.term);
        if (lu.term.trim().isNotEmpty) _lookUpReturns.add(lur);
        _lookUpCards.add(LookUpCard(
          input: lu,
          output: lur,
        ));
      }

      await showDialog(
          context: context,
          builder: ((context) {
            return _lookUpNewLanguageDialog();
          }));
      return true;
    }
    return false;
  }

  AlertDialog _lookUpNewLanguageDialog() {
    return AlertDialog(
      title: Text("Dictionary Results"),
      content: SingleChildScrollView(
        child: Column(children: [
          //List of entries
          ..._lookUpCards.map((card) => card),
          //Button
          ElevatedButton(
            child: Text("OK"),
            onPressed: () {
              _processLookUpNewLanguageResults();
              Navigator.pop(context);
            },
          )
        ]),
      ),
    );
  }

  void _processLookUpNewLanguageResults() {
    final sb = StringBuffer();
    final fullText = _textController.text;
    final indexHeading = fullText.indexOf("# New Language");
    int indexEnding = fullText.indexOf("#", indexHeading + 1);
    if (indexEnding == -1) {
      indexEnding = fullText.indexOf(">=");
    }
    final newLanguage = fullText.substring(
        fullText.indexOf("\n", indexHeading) + 1, indexEnding);
    final lines = newLanguage.split("\n");

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].isEmpty || lines[i][0] != "-") continue;

      final trueTerm = lines[i].substring(2, lines[i].length).trim();

      if (trueTerm.isEmpty) continue;

      final lur;
      try {
        lur = _lookUpReturns.where((element) => element.term == trueTerm).first;
      } on StateError {
        continue;
      }

      //TODO: Replace with style snippet - snippets must be applied to fields
      String fullDefinition = "${lur.term} //pos{${lur.partOfSpeech}}";
      if (lur.example != null) {
        fullDefinition =
            "$fullDefinition || ${lur.definition} //eg{${lur.example}}";
      } else {
        fullDefinition = "$fullDefinition || ${lur.definition}";
      }
      lines[i] = fullDefinition;
    }

    sb.writeln(" New Language");
    lines.forEach((element) {
      if (element.isNotEmpty && element[0] != "-") {
        sb.writeln("- $element");
      } else {
        if (element != "- >=") {
          sb.writeln("$element");
        }
      }
    });
    sb.writeln();

    //highlight the whole original term and replace it
    final before = fullText.substring(0, indexHeading + 1);
    final after = fullText.substring(indexEnding);
    print(before + "\n");
    print(sb.toString() + "\n");
    print(after);
    _textController.text = "$before${sb.toString()}$after";
  }

  //OTHER-----------------------------------------------------------------------

  void _onPressedSubmit() async {
    _textController.text = _autoFormatAll(_textController.text);
    String text = _textController.text;
    if (TextInputModeMethods.checkNeededHeadings(text)) {
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
      if (_markers.contains(k.keyLabel)) {
        final i = _textController.selection.baseOffset;
        final e = _textController.selection.extentOffset;
        final newText =
            CompanionMethods.autoInsert(k.keyLabel, _textController, i, e);
        _textController.text = newText;
        _textController.selection =
            TextSelection(baseOffset: i + 1, extentOffset: e + 1);
        return KeyEventResult.handled;
      } else if (value.isControlPressed && k.keyLabel == "Enter") {
        return KeyEventResult.handled;
      }
    } else if (value is RawKeyUpEvent) {
      if (value.isControlPressed) {
        switch (k.keyLabel) {
          case "S":
            _saveReportSync();
            break;
          case "B":
            // make bold
            final before;
            final middle = "\n";
            final after;

            final indexNextLineEnd = _textController.text
                .indexOf("\n", _textController.selection.baseOffset);
            break;
          case "Enter":
            // new line
            final before;
            final middle = "\n";
            final after;
            final newSelectionIndex;

            final indexNextLineEnd = _textController.text
                .indexOf("\n", _textController.selection.baseOffset);

            if (indexNextLineEnd != -1) {
              before = _textController.text.substring(0, indexNextLineEnd);
              after = _textController.text
                  .substring(indexNextLineEnd, _textController.text.length);
              newSelectionIndex = indexNextLineEnd;
            } else {
              before = _textController.text;
              after = "";
              newSelectionIndex = _textController.text.length + 1;
            }

            _textController.text = "$before$middle$after";
            _textController.selection =
                TextSelection.collapsed(offset: newSelectionIndex);
            return KeyEventResult.handled;
          default:
        }
        return KeyEventResult.ignored;
      }
    }
    return KeyEventResult.ignored;
  }

  void _saveReportSync() {
    _textController.text = _autoFormatAll(_textController.text);

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

  //MAIN------------------------------------------------------------------------

  @override
  initState() {
    _textController.text = _template;
    super.initState();
  }

  @override
  void dispose() {
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
                            //TODO: auto-completion
                            child: RawKeyboardListener(
                          focusNode: _textNode,
                          autofocus: true,
                          child: TextField(
                            controller: _textController,
                            onSubmitted: ((value) {}),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 9),
                            ),
                            style: const TextStyle(fontSize: 11),
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
                    padding: const EdgeInsets.fromLTRB(2, 5, 5, 2),
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
                label: "Format",
                onTap: () {
                  setState(() {
                    _textController.text = _autoFormatAll(_textController.text);
                  });
                }),
            SpeedDialChild(
                label: "Reset",
                onTap: () {
                  setState(() {
                    _textController.text = _template;
                  });
                }),
            SpeedDialChild(
                label: "New Language Look-Up",
                onTap: () async {
                  _switchLoading();
                  _lookUpWords().then((value) {
                    _switchLoading();
                  });
                }),
          ],
        ));
  }
}

//======================================================================
//Look Up Card
//======================================================================
class LookUpCard extends StatefulWidget {
  final LookUp input;
  final LookUpReturn output;

  const LookUpCard({super.key, required this.input, required this.output});

  @override
  State<LookUpCard> createState() => _LookUpCardState();
}

class _LookUpCardState extends State<LookUpCard> {
  String? _partOfSpeech;
  String? _definition;
  String? _example;
  Map<String?, String?> _mapping = {};

  final _exampleController = TextEditingController();

  List<DropdownMenuItem> _definitionDropdownMenuItem(String partOfSpeech) {
    List<DropdownMenuItem> output = [];

    widget.input.lookUpDetails
        .where((element) => element.partOfSpeech == partOfSpeech)
        .toList()
        .forEach((element) {
      for (final e in element.definitionsAndExamples.entries) {
        if (!output.contains(DropdownMenuItem(
            value: e.key,
            child: Text(e.key, overflow: TextOverflow.visible)))) {
          output.add(DropdownMenuItem(
              value: e.key,
              child: Text(e.key, overflow: TextOverflow.visible)));
          _mapping[e.key] = e.value;
        }
      }
    });

    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Term + Part of speech----------------------------------------------
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  widget.input.term.toUpperCase(),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
                // Parts of speech------------------------------------------------
                DropdownButton(
                    style: TextStyle(fontSize: 13),
                    isDense: true,
                    items: [
                      ...widget.input.lookUpDetails.map((e) {
                        return DropdownMenuItem(
                            value: e.partOfSpeech, child: Text(e.partOfSpeech));
                      })
                    ],
                    value: _partOfSpeech,
                    onChanged: (value) {
                      setState(() {
                        _partOfSpeech = value;
                        widget.output.partOfSpeech = _partOfSpeech;
                      });
                    })
              ],
            ),
          ),
          // Definitions--------------------------------------------------------
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
            child: DropdownButton(
                isExpanded: true,
                style: TextStyle(fontSize: 13),
                hint: Text("Defintion"),
                value: _definition,
                items: _partOfSpeech != null
                    ? _definitionDropdownMenuItem(_partOfSpeech!)
                    : null,
                onChanged: (value) {
                  if (_partOfSpeech != null) {
                    setState(() {
                      _definition = value;
                      widget.output.definition = _definition;
                      _example = _mapping[_definition];
                      _exampleController.text =
                          _example ?? "[No example available]";
                      widget.output.example = _example;
                      if (widget.output.example != null) {
                        widget.output.example!.replaceAll("; ", "//> ");
                      }
                    });
                  }
                }),
          ),
          // Examples-----------------------------------------------------------
          TextField(
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(hintText: "example", isDense: true),
            maxLines: null,
            controller: _exampleController,
            readOnly: _example != null ? false : true,
          )
        ],
      ),
    ));
  }
}
