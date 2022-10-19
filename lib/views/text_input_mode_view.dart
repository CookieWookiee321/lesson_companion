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

final _template = """* Name
-
* Date
- ${CompanionMethods.getShortDate(DateTime.now())}
* Topic
-
* Homework
-
* New Language
-
* Pronunciation
-
* Corrections
-
===""";

class TextInputModeView extends StatefulWidget {
  const TextInputModeView({Key? key}) : super(key: key);

  @override
  State<TextInputModeView> createState() => _TextInputModeViewState();
}

class _TextInputModeViewState extends State<TextInputModeView> {
  final _linePrefix = "- ";
  final _textController = TextEditingController(text: _template);
  final _focusNode = FocusNode(
    onKey: (node, event) {
      if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
        return KeyEventResult.ignored;
      }
      return KeyEventResult.ignored;
    },
  );

  void _autoFormat() {
    final sb = StringBuffer();
    const stoppingPoint = "===";

    for (var line in _textController.text.split("\n")) {
      if (line.isNotEmpty & (line != stoppingPoint)) {
        if (line[0] != "*") {
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
      if (keyData.logical == LogicalKeyboardKey.enter.keyId) {
        if (keyData.type == KeyEventType.down) {
          _autoFormat();
          return true;
        }
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
                  onPressed: () async {
                    if (TextInputModeMethods.checkNeededHeadings(
                        _textController.text)) {
                      try {
                        _autoFormat();
                        final report = Report();
                        await report.buildFromText(_textController.text);
                        report.create();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Lesson & report saved successfully")));
                        _textController.text = _template;
                      } on InputException {
                        final we = InputException(
                            "Name, Date, and Topic are required fields");
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(we.cause)));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Failed to submit lesson.\nThere is a problem with the text format.")));
                    }
                  },
                  child: const Text("Submit")))
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
