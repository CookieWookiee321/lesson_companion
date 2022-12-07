import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lesson_companion/models/database.dart';
import 'package:lesson_companion/models/dictionary/free_dictionary.dart';
import 'package:lesson_companion/models/dictionary/look_up.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/report.dart';
import 'package:lesson_companion/models/student.dart';
import 'package:lesson_companion/views/pdf_preview.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../controllers/COMPANION_METHODS.dart';
import '../controllers/text_mode_input_controller.dart';

final _template =
    """=< !@This is a commented line - it will not be processed in the report
  * Name
      Enter the student's name here

  * Date
      ${CompanionMethods.getShortDate(DateTime.now())}

  * Topic
      Enter one topic
      Per line p.i[and style text like this]

  * Homework
      Homework works
      The same way [and subtext is also allowed,] p.bi[which can be styled in various ways]

  * New Language
      select
      "Auto-look up"
      in
      the
      menu

  * Corrections
      Tables work a little bit differently ||
          as you can break up text by cells
      You can show the end of the left-hand column cell ||
          by using the specific marker
      You can format these cells more by using g[mark]-o[down] u[formatting] bu[like this] ||
          p.bi[You can mix and reposition]//g.uib[these as much as you want]
      There is no limit to the length of text in a cell
      Leave out the "new-cell" marker to take away the border between cells
      s.b[Or you could make a mini-heading like this]
      o.bui[It's all up to you]
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
  final List<LookUp> _lookUps = [];
  final List<LookUpCard> _lookUpCards = [];
  final List<LookUpReturn> _lookUpReturns = [];

  final _textController = TextEditingController();
  bool _inFocus = false;
  bool _loading = false;

  //FORMATTING------------------------------------------------------------------

  //TODO: DO not implement this until you have a solid idea of the final formatting
  String _format(String input) {
    final sbTotal = StringBuffer();
    final sbSection = StringBuffer();

    //isolate each heading:
    final parts = input.split("*");
    //get each section
    for (String p in parts) {
      if (p.isEmpty) continue;
      //get each line of section
      final lines = p.split(";");

      final spl = lines[0].split("\n");
      //skip heading
      String heading = spl[0];
      heading = "* ${heading.trim()}";

      String? firstLine = spl[1];
      //loop through other lines
      for (String l in lines) {
        if (l.trim().isEmpty) continue;

        if (firstLine != null) {
          l = firstLine;
          firstLine = null;
        }

        if (l.trim() == "===") {
          continue;
        }

        final firstChars = l.substring(0, 2);
        if (firstChars != "-\t") {
          l = "-\t${l.trim()}";
        }
        if (l.contains("||")) {
          final cells = l.split("||");
          String lhs = cells[0];
          String rhs = cells[1];

          if (lhs.contains("//")) {
            lhs = lhs.replaceAll("//", "\n\t");
          }

          rhs = "\t\t${rhs.trim()}";
          if (rhs.contains("//")) {
            rhs = rhs.replaceAll("//", "\n\t\t");
          }

          l = "$lhs ||\n$rhs";
        }
        sbSection.writeln("$l;");
      }

      final section = sbSection.toString();
      sbTotal.writeln("$heading\n$section");
      sbSection.clear();
    }

    return "${sbTotal.toString()}===\n";
  }

  String _autoFormatAll(String input) {
    final sb = StringBuffer();

    for (var line in _textController.text.split("\n")) {
      if (line.trim().length == 0 ||
          line.substring(0, 2) == _start ||
          line.substring(0, 2) == _stop ||
          line.substring(0, 2) == _headingStart ||
          line.substring(0, 2) == _rowStart ||
          line.substring(0, 2) == _commentStart) {
        sb.writeln(line);
        continue;
      }

      line = "$_rowStart$line";

      sb.writeln(line);
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
      fullText.indexOf("\n", indexHeading) + 1,
    );
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
      String fullDefinition = "${lur.term} pos{(${lur.partOfSpeech})}";
      if (lur.example != null) {
        fullDefinition = "$fullDefinition //eg{> ${lur.example}}";
      }
      fullDefinition = "$fullDefinition || ${lur.definition}";
      lines[i] = fullDefinition;
    }

    sb.writeln(" New Language");
    lines.forEach((element) {
      if (element.isNotEmpty && element[0] != "-") {
        sb.writeln("- $element");
      } else {
        if (element != "- ===") {
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
          var lesson = Lesson(
              studentId: studentId!,
              date: date!,
              topic: CompanionMethods.convertListToString(topic!),
              homework: homework != null
                  ? CompanionMethods.convertListToString(homework!)
                  : "");
          //check if Lesson exists
          if (!await Database.checkLessonExists(studentId!, date!)) {
            //if not, create new entry
            await Database.saveLesson(lesson);
            print(
                "Lesson saved: ${mapping["Name"]!.first} >> ${mapping["Topic"]!.first}");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Lesson saved: ${mapping["Name"]!.first} >> ${mapping["Topic"]!.first}")));
          }

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

  //MAIN------------------------------------------------------------------------

  @override
  initState() {
    _textController.text = _template;

    window.onKeyData = (keyData) {
      if (_inFocus) {
        final indexNow = _textController.selection.base.offset;
        if (keyData.logical == LogicalKeyboardKey.backslash.keyId) {
          final marker = _textController.text[indexNow - 1];

          CompanionMethods.autoInsert(marker, _textController, indexNow);
          return true;
        } else if (keyData.character != null) {
          CompanionMethods.autoInsert(
              keyData.character!, _textController, indexNow);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    };
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
    return Focus(
      child: Scaffold(
          body: ModalProgressHUD(
            child: Column(
              children: [
                Expanded(
                    child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      children: [
                        Expanded(
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
            inAsyncCall: _loading,
          ),
          floatingActionButton: SpeedDial(
            icon: Icons.more,
            children: [
              SpeedDialChild(
                  label: "Dictionary Look-Up",
                  onTap: () async {
                    _switchLoading();
                    _lookUpWords().then((value) {
                      _switchLoading();
                    });
                  }),
              SpeedDialChild(
                  label: "Format Text",
                  onTap: () {
                    setState(() {
                      _textController.text =
                          _autoFormatAll(_textController.text);
                    });
                  }),
              SpeedDialChild(
                  label: "Reset Text",
                  onTap: () {
                    setState(() {
                      _textController.text = _template;
                    });
                  })
            ],
          )),
      onFocusChange: (value) {
        setState(() {
          _inFocus = value;
        });
      },
    );
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
                style: TextStyle(fontSize: 13),
                hint: Text("Defintion"),
                isDense: true,
                isExpanded: true,
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
