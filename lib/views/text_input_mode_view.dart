import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lesson_companion/models/data_storage.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/report.dart';
import 'package:lesson_companion/models/student.dart';

import '../controllers/companion_methods.dart';
import '../controllers/text_mode_input_controller.dart';
import 'companion_widgets.dart';

//   final template = """* Name
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

final _template = """* Name


* Date
${CompanionMethods.getShortDate(DateTime.now())}

* Topic


* Homework


* New Language


* Pronunciation


* Corrections


===""";

class TextInputModeView extends StatefulWidget {
  const TextInputModeView({Key? key}) : super(key: key);

  @override
  State<TextInputModeView> createState() => _TextInputModeViewState();
}

class _TextInputModeViewState extends State<TextInputModeView> {
  final _textController = TextEditingController(text: _template);
  // final _focusNode = FocusNode(
  //   onKey: (node, event) {
  //     if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
  //       return KeyEventResult.ignored;
  //     }
  //     return KeyEventResult.ignored;
  //   },
  // );

  void _autoInsertMarkers(String char, int currentIndex) {
    assert(char == "q" || char == "e" || char == "i" || char == "<",
        "This method must take a notation marker of either 'i', 'q', 'e', or '<'");

    switch (char) {
      case "<":
        _textController.text =
            "${_textController.text.substring(0, currentIndex)}>${_textController.text.substring(currentIndex, _textController.text.length)}";
        break;
      default:
        _textController.text =
            "${_textController.text.substring(0, currentIndex)}\\\\${_textController.text.substring(currentIndex, _textController.text.length)}";
        break;
    }
    _textController.selection = TextSelection(
        baseOffset: currentIndex + 1, extentOffset: currentIndex + 1);
  }

  String _autoFormatAll(String input) {
    final sb = StringBuffer();
    const stoppingPoint = "===";

    for (var line in _textController.text.split("\n")) {
      if (line.isNotEmpty) {
        if (line[0] != "*" && line != stoppingPoint) {
          if (line[0] != "-") {
            line = "- $line";
          }
        }
      } else {
        line = "- $line";
      }

      sb.writeln(line);
    }

    return sb.toString();
  }

  Map<String, List<String>> _mapTextInput(String text) {
    String currentHeading = "";
    final headingPrefix = "*";
    final linePrefix = "-";
    Map<String, List<String>> mappings = {};
    List<String> currentEntryList = [];

    //loop through each line in text
    for (var line in text.split("\n")) {
      //don't read blank lines
      if (line.trim().isEmpty || line.trim() == "-") continue;
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
    window.onKeyData = (keyData) {
      final indexNow = _textController.selection.base.offset;
      if (keyData.logical == LogicalKeyboardKey.backslash.keyId) {
        final marker = _textController.text[indexNow - 1];

        if (keyData.type == KeyEventType.down) {
          if (marker == "q" || marker == "e" || marker == "i") {
            _autoInsertMarkers(marker, indexNow);
            return true;
          }
        }
      } else if (keyData.logical == LogicalKeyboardKey.comma &&
          keyData.logical == LogicalKeyboardKey.shift) {
        _autoInsertMarkers("<", indexNow);
        return true;
      }

      return false;
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
    void _onPressedSubmit() async {
      String text = _textController.text;
      if (TextInputModeMethods.checkNeededHeadings(text)) {
        try {
          text = _autoFormatAll(text);

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
              await report.create();
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("All lessons saved successfully")));
          _textController.text = _template;
        } on InputException {
          final we =
              InputException("Name, Date, and Topic are required fields");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(we.cause)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Failed to submit lesson.\nThere is a problem with the text format.")));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Text Input Mode"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                    value: 0,
                    child: ElevatedButton(
                      onPressed: () {
                        TextInputModeMethods.pickFile();
                      },
                      child: const Text("Input from file"),
                    )),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(13.0, 6.0, 13.0, 0.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _textController,
                  onSubmitted: ((value) {}),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                  ),
                  style: const TextStyle(fontSize: 11),
                  maxLines: null,
                  expands: true,
                ))
              ],
            ),
          )),
          Padding(
              padding: const EdgeInsets.fromLTRB(2, 5, 5, 2),
              child: ElevatedButton(
                  onPressed: _onPressedSubmit, child: const Text("Submit")))
        ],
      ),
      bottomNavigationBar: const BottomBar(),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.more,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          hoverColor: Theme.of(context).colorScheme.tertiary,
          onPressed: () {
            //TODO: Extend bar to search bar
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
