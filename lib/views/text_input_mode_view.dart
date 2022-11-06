import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lesson_companion/models/data_storage.dart';
import 'package:lesson_companion/models/dictionary/free_dictionary.dart';
import 'package:lesson_companion/models/dictionary/look_up.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/report.dart';
import 'package:lesson_companion/models/student.dart';
import 'package:lesson_companion/views/pdf_preview.dart';

import '../controllers/companion_methods.dart';
import '../controllers/text_mode_input_controller.dart';

// final _template = """* Name
// Test
// * Date
// ${CompanionMethods.getShortDate(DateTime.now())}
// * Topic
// Topic 1
// Topic 2
// * Homework
// Homework 1
// Homework 2
// * New Language
// This e\\example\\ i\\info\\ q\\question\\ <subtext> || That e\\example\\ i\\info\\ q\\question\\
// e\\example\\ i\\info\\ This q\\question\\ <subtext> || That
// * Pronunciation
// This <subtext> ||
// e\\example\\ i\\info\\ This q\\question\\ <subtext> || That e\\example\\ i\\info\\ q\\question\\
// * Corrections
// This e\\example\\ i\\info\\ q\\question\\ <subtext> || That e\\example\\ i\\info\\ q\\question\\
// e\\example\\ i\\info\\ This q\\question\\ <subtext>
// ===""";

//TODO: Fix the auto-completion (in edit)

final _template =
    """>Lines like this will not be processed, so please replace them with your own information.
>Simply enter the data under the appropraite heading.
>This template can be replaced by choosing "Change template" from the lower-hand side button on the screen.

>These four fields will dictate the header of the report.
* Name
>This is a required field. Only one entry is allowed here.
>Each student must have a unique name.
>If you have multiple students with the same first name, consider including their surnames, or some kind of distinguishing feature in brackets.
>NOTE: The only field where text in rounded brackets will not be printed is this field. They have no special features in other fields.
>E.g. "Jason", "Jason Friedman", or "Jason (from Germany)"
* Date
>This is a required field. Only one entry is allowed here.
>Please enter the data format as either YYYY/MM/DD or YYYY-MM-DD.
>E.g. "2021/04/16" or "2021-04-16"
${CompanionMethods.getShortDate(DateTime.now())}
* Topic
>This is a required field. Multiple entries are allowed here, one per line.
>At this point, you can begin with styling the report too.
>Subtext is allowed here, in addition to the default text style.
>Subtext is indicated by placing text in square brackets.
>E.g:
>"Adverbs of Frquency (Page 1-4) [Grammar]
>Mingle Activities [Speaking]"
>NOTE: Text in rounded brackets "()" will be printed normally.
* Homework
>Multiple entries are allowed here, one per line.
>This field is optional. Leaving it blank will leave it out of the report entirely.

>The following 3 three fields dictate the tables of the report.
>They work slightly differently from the header fields.
>These can each take as many entries as you want.
>Also, feel free to change the names of the headings.
>NOTE: Some features are tied to specific heading names (See below)

>You can simply write a new line to place text into a table row.
>If you want to have a row with two columns, then use a double-pipe "||" marker after the left-hand text to begin writing the right-hand text
>For now, each entry MUST be placed on one line. An entry will end when the ENTER key is pressed to go to a new line.

>Notation Markers:
>As indicated previously, text mark down and styling is available in Lesson Companion.
>Line breaks WITHIN A TABLE CELL is indicated with a double-forward slash "//".
>Subtext is indicated inside square brackets - "[sample]"
>Questions are in light blue, and are indicated like so - "q\sample\"
>Examples are bolded and in green, and are indicated like so - "e\sample\"
>Informtion is in orange, and is indicated like so - "i\sample\"
>NOTE: There is nothing stopping you from using the different styles for your own purposes, and not as they are outlined here. They are just named based on their original functions.
>E.g. "q\What did you do yesterday?\//I go to school||I went to school//i\remember to use past tense verbs.\//e\go >> went\"
>The above example has two cells in the row. The first has blue question text, then the original sentence from the student on a new line within the same cell.
>The right-hand side cell has the correct sentence form, followed by an explanation of the correction on a new line in the cell, and then, on another new line, a clearer indication of the change which was made.

* New Language
>Auto-Look Up:
>If you want to utilise the dictionary auto-lookup feature, then the "New Language" heading name is a required one.
>Place each entry on a new line, and with no other text included (including no mark down features or notation markers).
>After looking up the details online, any results will be shown in a dialog window.
>You can choose what to include and what not to include in your report, and then can edit the details after.
* Pronunciation
>Automatic Linking:
>Anything placed in this section will link to Forvo.com, which is a pronuncation help website.
>Only text in the left-hand column will be linked automatically
* Corrections
>This section has no special features, but is just included for general purposes as a default.
===""";

class TextInputModeView extends StatefulWidget {
  const TextInputModeView({Key? key}) : super(key: key);

  @override
  State<TextInputModeView> createState() => _TextInputModeViewState();
}

class _TextInputModeViewState extends State<TextInputModeView> {
  final _textController = TextEditingController();
  bool _inFocus = false;

  String _autoFormatAll(String input) {
    final sb = StringBuffer();
    const stoppingPoint = "===";
    final commentPrefix = ">";

    for (var line in _textController.text.split("\n")) {
      if (line.length > 0) {
        if (line[0] != "*" &&
            line != stoppingPoint &&
            line[0] != commentPrefix) {
          if (line[0] != "-") {
            line = "- $line";
          }
        }
      } else {
        line = "- $line";
      }

      sb.writeln(line);
    }

    if (!input.contains(stoppingPoint)) sb.writeln(stoppingPoint);

    return sb.toString();
  }

  Map<String, List<String>> _mapTextInput(String text) {
    String currentHeading = "";
    final headingPrefix = "*";
    final linePrefix = "-";
    final commentPrefix = ">";
    Map<String, List<String>> mappings = {};
    List<String> currentEntryList = [];

    //loop through each line in text
    for (var line in text.split("\n")) {
      //don't read blank lines
      if (line.trim().isEmpty || line.trim() == "-" || line[0] == commentPrefix)
        continue;
      if (line.trim() == "===") continue;

      //check if the line contains a heading or not
      if (line[0] != headingPrefix) {
        if (line[0] == linePrefix) {
          final temp = line.substring(1).trim();
          //add the line to the housing List obj
          currentEntryList.add(temp);
        }
      } else {
        //add the list of entries for the heading which was just processed
        if (currentEntryList.isNotEmpty) {
          mappings[currentHeading] = currentEntryList;
          currentEntryList = [];
        }

        //if a new heading is detected
        final currentHeadingUnchecked = line.substring(1).trim();
        //determine if the heading is pre-defined + update the currentHeading var
        switch (currentHeadingUnchecked.toUpperCase()) {
          case "NAME":
            currentHeading = "Name";
            break;
          case "DATE":
            currentHeading = "Date";
            break;
          case "TOPIC":
            currentHeading = "Topic";
            break;
          case "HOMEWORK":
            currentHeading = "Homework";
            break;
          default:
            currentHeading = currentHeadingUnchecked;
            break;
        }
      }
    }
    if (currentEntryList.isNotEmpty) {
      mappings[currentHeading] = currentEntryList;
    }

    return mappings;
  }

  void _onPressedSubmit() async {
    _textController.text = _autoFormatAll(_textController.text);
    String text = _textController.text;
    if (TextInputModeMethods.checkNeededHeadings(text)) {
      try {
        while (text.contains("===")) {
          final stoppingPoint = text.indexOf("===");
          final singleEntry = text.substring(0, stoppingPoint);
          text = text.substring(stoppingPoint + 3, text.length);

          final mapping = _mapTextInput(singleEntry);

          //check if Student exists
          final student = Student();
          final studentId;
          if (!await DataStorage.checkStudentExistsByName(
              mapping["Name"]!.first)) {
            //if not, create new Hive entry
            student.name = mapping["Name"]!.first;
            student.active = true;
            await DataStorage.saveStudent(student);
          }
          studentId = await DataStorage.getStudentId(mapping["Name"]!.first);

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
          if (!await DataStorage.checkLessonExists(studentId!, date!)) {
            //if not, create new entry
            await DataStorage.saveLesson(lesson);
            print(
                "Lesson saved: ${mapping["Name"]!.first} >> ${mapping["Topic"]!.first}");
          }

          if (mapping.keys.length > 4 ||
              (mapping.keys.length == 4 &&
                  !mapping.keys.contains("Homework"))) {
            final report = Report();
            await report.fromMap(mapping);
            final pdfDoc = await report.create();
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return PdfPreviewPage(pdfDocument: pdfDoc);
              },
            ));
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
          body: Column(
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                        ),
                        style: const TextStyle(fontSize: 11),
                        maxLines: null,
                        expands: true,
                      ))
                    ],
                  ),
                ),
              )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(2, 5, 5, 2),
                  child: ElevatedButton(
                      onPressed: _onPressedSubmit, child: const Text("Submit")))
            ],
          ),
          floatingActionButton: SpeedDial(
            children: [
              SpeedDialChild(
                  label: "Reset to default template",
                  onTap: () {
                    setState(() {
                      _textController.text = _template;
                    });
                  }),
              SpeedDialChild(
                label: "Dictionary look-up",
                onTap: () async {
                  List<LookUp> results = [];
                  _textController.text = _autoFormatAll(_textController.text);
                  final indexStart =
                      _textController.text.indexOf("* New Language");
                  final chunk = _textController.text.substring(indexStart,
                      _textController.text.indexOf("*", indexStart + 1));
                  final terms = chunk.split("\n-");

                  //skip the first term as it is just the heading
                  for (int i = 1; i < terms.length; i++) {
                    if (terms[i].trim().length == 0) continue;

                    final thisTerm;

                    if (terms[i].contains("||")) {
                      thisTerm = terms[i]
                          .trim()
                          .substring(0, terms[i].trim().indexOf("||"));
                    } else {
                      thisTerm = terms[i].trim();
                    }

                    final url =
                        "https://api.dictionaryapi.dev/api/v2/entries/en/${thisTerm}";
                    final dictionary = await FreeDictionary.fetchJson(url);

                    if (dictionary != null) {
                      results.add(LookUp(dictionary));
                    }
                  }

                  if (results.isNotEmpty) {
                    await showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            title: Text("Dictionary Results"),
                            content: SingleChildScrollView(
                              child: Column(children: [
                                ...results.map((term) {
                                  return term.details.isNotEmpty
                                      ? LookUpCard(
                                          details: term,
                                        )
                                      : Container();
                                })
                              ]),
                            ),
                          );
                        }));
                  }
                },
              ),
              SpeedDialChild(
                  label: "Format report",
                  onTap: () {
                    setState(() {
                      _textController.text =
                          _autoFormatAll(_textController.text);
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

class LookUpCard extends StatefulWidget {
  final LookUp details;

  const LookUpCard({super.key, required this.details});

  @override
  State<LookUpCard> createState() => _LookUpCardState();
}

class _LookUpCardState extends State<LookUpCard> {
  String? _partOfSpeech;
  String? _definition;
  String? _example;
  Map<String?, String?> _mapping = {};

  @override
  void initState() {
    super.initState();
  }

  List<DropdownMenuItem> _definitionDropdownMenuItem(String partOfSpeech) {
    List<DropdownMenuItem> output = [];

    widget.details.details
        .where((element) => element.partOfSpeech == partOfSpeech)
        .toList()
        .forEach((element) {
      for (final e in element.definitionsAndExamples.entries) {
        if (!output
            .contains(DropdownMenuItem(value: e.key, child: Text(e.key)))) {
          output.add(DropdownMenuItem(value: e.key, child: Text(e.key)));
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
          Row(
            children: [
              Expanded(child: Text(widget.details.term)),
              DropdownButton(
                  items: [
                    ...widget.details.details.map((e) {
                      return DropdownMenuItem(
                          value: e.partOfSpeech, child: Text(e.partOfSpeech));
                    })
                  ],
                  value: _partOfSpeech,
                  onChanged: (value) {
                    setState(() {
                      _partOfSpeech = value;
                    });
                  })
            ],
          ),
          DropdownButton(
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
                    _example = _mapping[_definition];
                  });
                }
              }),
          TextFormField(
            initialValue: _example ?? "",
            readOnly: true,
          )
        ],
      ),
    ));
  }
}
