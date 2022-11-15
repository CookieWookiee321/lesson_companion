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
// Serdar

// * Date
// 2022/11/10

// * Topic
// Speaking practice

// * New Language
// moment of silence s.b[(noun)]//g.b[The crowd observed a moment of silence for those who died in the tragedy.]||a short period of silent thought or prayer
// in trouble s.o[(adjective)]//g.b[He would have been in real trouble if he had been caught.]||Someone who is in trouble is in a situation that is a problem or difficulty, esp. with the law
// empty threat s.o[(noun)]//g.b[Don't make empty threats that you have no intention of backing up with action.]||a threat that someone does not really mean

// * Pronunciation
// moment of silence||MOE-muhn-tov-SY-lens
// organised||OR-ga-nyzd
// appearance||uh-PEER-ens

// * Corrections
// Homage to at 9:05am||Everybody pays homage to him at 9:05am
// nine zero five (9:05)||nine oh five
// Connection very bad||The connection is very bad
// this country's whole peoples||All of this country's people//All of the people in this country
// They anniversary for him||They celebrate the anniversary of his death
// I running away from my manager//o[don't use "ing" grammar so much]||I run away from my manage//g[use: present simple tense - for routines & habits]
// My manager will send you far branch || (He) will send me to a far branch

// ===""";

final _template = """* Name
Enter the student's name here

* Date
${CompanionMethods.getShortDate(DateTime.now())}

* Topic
Enter one topic
Per line [and enter subtext like this]

* Homework
Homework words
The same way [and subtext is also allowed,] p.bi[which can be styled in various ways]

* New Language
select
"Auto-look up"
in
the
menu

* Corrections
Tables work a little bit differently || as you can break up text by cells
You can show the end of the left-hand column cell || by using the specific marker
You can format these cells more by using g[mark]-o[down] u[formatting] bu[like this] || p.bi[You can mix and reposition]//g.uib[these as much as you want]
There is no limit to the length of text in a cell
Leave out the "new-cell" marker to take away the border between cells
#You can make a new heading within a table like this
[Or you could make a mini-heading like this]
o.b[It's all up to you]
""";

final markerOptions = [
  'g.b',
  'g.i',
  'g.u',
  'p.b',
  'p.i',
  'p.u',
  'o.b',
  'o.i',
  'o.u',
  's.b',
  's.i',
  's.u',
  'g.bi',
  'g.bu',
  'g.ib',
  'g.iu',
  'g.ub',
  'g.ui',
  'p.bi',
  'p.bu',
  'p.ib',
  'p.iu',
  'p.ub',
  'p.ui',
  'o.bi',
  'o.bu',
  'o.ib',
  'o.iu',
  'o.ub',
  'o.ui',
  's.bi',
  's.bu',
  's.ib',
  's.iu',
  's.ub',
  's.ui',
  'g.biu',
  'g.bui',
  'g.ibu',
  'g.iub',
  'g.ubi',
  'g.uib',
  'p.biu',
  'p.bui',
  'p.ibu',
  'p.iub',
  'p.ubi',
  'p.uib',
  'o.biu',
  'o.bui',
  'o.ibu',
  'o.iub',
  'o.ubi',
  'o.uib',
  's.biu',
  's.bui',
  's.ibu',
  's.iub',
  's.ubi',
  's.uib'
];

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
  final _textController = TextEditingController();
  bool _inFocus = false;

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
            try {
              final report = Report();
              await report.fromMap(mapping);
              final pdfDoc = await report.createPdf();
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

  void _lookUpWords() async {
    List<LookUp> results = [];
    _textController.text = _autoFormatAll(_textController.text);
    final indexStart = _textController.text.indexOf("* New Language");
    final chunk = _textController.text.substring(
        indexStart, _textController.text.indexOf("*", indexStart + 1));
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
            icon: Icons.more,
            children: [
              SpeedDialChild(
                  label: "Reset to Default",
                  onTap: () {
                    setState(() {
                      _textController.text = _template;
                    });
                  }),
              SpeedDialChild(label: "Dictionary Look-Up", onTap: _lookUpWords),
              SpeedDialChild(
                  label: "Format",
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

//======================================================================
//Look Up Card
//======================================================================
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

  // String _getExampleFieldValue() {
  //   if (_definition == null) return "";
  //   if (_example == null) return "";
  //   if
  // }

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
