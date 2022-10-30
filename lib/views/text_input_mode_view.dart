import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lesson_companion/models/data_storage.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/report.dart';
import 'package:lesson_companion/models/student.dart';
import 'package:rich_code_editor/exports.dart';
import 'package:rich_code_editor/rich_code_field.dart';

import '../controllers/companion_methods.dart';
import '../controllers/styler.dart';
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
  late SyntaxHighlighterBase _syntaxHighlighterBase;
  late RichCodeEditingController _textController;
  // final _focusNode = FocusNode(
  //   onKey: (node, event) {
  //     if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
  //       return KeyEventResult.ignored;
  //     }
  //     return KeyEventResult.ignored;
  //   },
  // );

  void _autoInsertMarkers(String char, int currentIndex) {
    assert(char == "q" || char == "e" || char == "i" || char == "[",
        "This method must take a notation marker of either 'i', 'q', 'e', or '<'");

    switch (char) {
      case "[":
        _textController.text =
            "${_textController.text.substring(0, currentIndex)}[]${_textController.text.substring(currentIndex, _textController.text.length)}";
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

    if (!input.contains(stoppingPoint)) sb.writeln(stoppingPoint);

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
    _syntaxHighlighterBase = SyntaxHighlighter();
    _textController =
        RichCodeEditingController(_syntaxHighlighterBase, text: _template);

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
      } else if (keyData.character == "[") {
        _autoInsertMarkers("[", indexNow);
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
                    child: RichCodeField(
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

class SyntaxHighlighter extends SyntaxHighlighterBase {
  BuildContext context;

  SyntaxHighlighter(this.context);

  TextType _getCurrentType(String input) {
    switch (input) {
      case "q\\":
        return TextType.question;
      case "i\\":
        return TextType.info;
      case "e\\":
        return TextType.example;
      default:
        return TextType.sub;
    }
  }

  TextStyle _getCurrentStyle(TextType type) {
    switch (type) {
      case TextType.question:
        return TextStyle(color: Colors.lightBlue, fontSize: 10);
      case TextType.base:
        return TextStyle(
            color: Theme.of(context).colorScheme.onBackground, fontSize: 12);
      case TextType.sub:
        return TextStyle(
            color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 10);
      case TextType.example:
        return TextStyle(
            color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10);
      case TextType.info:
        return TextStyle(color: Colors.orange, fontSize: 10);
    }
  }

  @override
  List<TextSpan> parseText(TextEditingValue tev) {
    final List<TextSpan> components = [];
    var currentType = TextType.base;
    var currentStyle = TextStyle();
    final markerOpeners = ["q\\", "e\\", "i\\", "["];
    final sb = StringBuffer();
    final markerCloser = "\\";
    final markerCloserSub = "]";
    String text = tev.text;

    //check if markers are present
    int start;
    int end;
    String? unprocessed;
    String toProcess;
    for (final opener in markerOpeners) {
      if (text.contains(opener) && text.contains(markerCloser)) {
        start = text.indexOf(opener);
        end = text.indexOf(markerCloser);
        if (start > 0) unprocessed = text.substring(0, start);

        unprocessed ??
            components.add(TextSpan(
                text: unprocessed, style: _getCurrentStyle(TextType.base)));

        //get type of marker
        currentType = _getCurrentType(opener);
        //get style for marker
        currentStyle = _getCurrentStyle(currentType);

        final tempStr = (opener != "[")
            ? text.substring(start + 2, end)
            : text.substring(start + 1, end);
        components.add(TextSpan(text: tempStr, style: currentStyle));
      }
    }

    if (text.contains(other))

      //start looping through characters
      int counter = 0;
    for (final x in tev.text.characters) {
      //build the substring until...
      if (!specialChars.contains(input[i])) {
        sb.write(input[i]);
      } else {
        if (input[i] == "\\") {
          //determine if this is starting text markdown, or completing it
          if (markerOpeners.contains(sb.toString()[sb.length - 1])) {
            // open a new markdown substring, based on the character preceding the opening '\'
            final marker = sb.toString()[sb.length - 1];

            final temp = sb.toString().substring(0, sb.length - 1);
            sb.clear();
            sb.write(temp);

            if (sb.isNotEmpty) {
              final sub = PdfSubstring();
              sub.setText = sb.toString();
              sub.setTextType = currentType;

              components.add(sub);
              sb.clear();
            }

            switch (marker) {
              case "q":
                currentType = TextType.question;
                break;
              case "i":
                currentType = TextType.info;
                break;
              case "e":
                currentType = TextType.example;
                break;
            }
          } else {
            if (currentType != TextType.base) {
              if (currentType == TextType.sub) {
                sb.write(input[i]);
              } else {
                if (sb.isNotEmpty) {
                  final sub = PdfSubstring();
                  sub.setText = sb.toString();
                  sub.setTextType = currentType;

                  components.add(sub);
                  sb.clear();
                }

                currentType = TextType.base;
              }
            }
          }
        } else if (input[i] == "[") {
          // begin new subtext substring
          if (sb.isNotEmpty) {
            final sub = PdfSubstring();
            sub.setText = sb.toString();
            sub.setTextType = currentType;

            components.add(sub);
            sb.clear();
          }
          currentType = TextType.sub;
        } else if (input[i] == "]") {
          // close subtext substring
          if (sb.isNotEmpty) {
            final sub = PdfSubstring();
            sub.setText = sb.toString();
            sub.setTextType = currentType;

            components.add(sub);
            sb.clear();
          }
          currentType = TextType.base;
        }
      }
    }

    final sub = PdfSubstring();
    sub.setText = sb.toString();
    sub.setTextType = currentType;

    components.add(sub);
  }
}
