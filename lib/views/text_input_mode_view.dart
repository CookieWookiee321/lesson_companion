import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lesson_companion/models/report.dart';

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

  void _autoFormatAll() {
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

    _textController.text = sb.toString();
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
      if (TextInputModeMethods.checkNeededHeadings(_textController.text)) {
        try {
          _autoFormatAll();
          final report = Report();
          await report.buildFromText(_textController.text);

          // if (!await DataStorage.checkStudentExistsById(
          //     report.id)) final student = Student.known(report.id, );
          report.create();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Lesson & report saved successfully")));
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
    );
  }
}

// class TextFieldColorizer extends TextEditingController {
//   final Map<String, TextStyle> map;
//   final Pattern pattern;

//   TextFieldColorizer(this.map)
//       : pattern = RegExp(
//             map.keys.map((e) {
//               return e;
//             }).join('|'),
//             multiLine: true);

//   @override
//   set text(String newText) {
//     value = value.copyWith(
//         text: newText,
//         selection: TextSelection.collapsed(offset: newText.length),
//         composing: TextRange.empty);
//   }

//   @override
//   TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
//     final List<InlineSpan> children = [];
//     String patternMatched;
//     String formatText;
//     TextStyle myStyle;
//     text.splitMapJoin(
//       pattern,
//       onMatch: (Match match) {
//         myStyle = map[match[0]] ??
//             map[map.keys.firstWhere(
//               (e) {
//                 bool ret = false;
//                 RegExp(e).allMatches(text)
//                   ..forEach((element) {
//                     if (element.group(0) == match[0]) {
//                       patternMatched = e;
//                       ret = true;
//                       return true;
//                     }
//                   });
//                 return ret;
//               },
//             )];

//         if (patternMatched == r"_(.*?)\_") {
//           formatText = match[0].replaceAll("_", " ");
//         } else if (patternMatched == r'\*(.*?)\*') {
//           formatText = match[0].replaceAll("*", " ");
//         } else if (patternMatched == "~(.*?)~") {
//           formatText = match[0].replaceAll("~", " ");
//         } else if (patternMatched == r'```(.*?)```') {
//           formatText = match[0].replaceAll("```", "   ");
//         } else {
//           formatText = match[0];
//         }
//         children.add(TextSpan(
//           text: formatText,
//           style: style.merge(myStyle),
//         ));
//         return "";
//       },
//       onNonMatch: (String text) {
//         children.add(TextSpan(text: text, style: style));
//         return "";
//       },
//     );

//     return TextSpan(style: style, children: children);
//   }
// }
