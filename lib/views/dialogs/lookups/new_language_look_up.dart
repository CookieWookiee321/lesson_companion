import 'package:flutter/material.dart';

import '../../../models/dictionary/free_dictionary.dart';
import '../../../models/dictionary/look_up.dart';

class NewLanguageLookUpDialog extends StatefulWidget {
  const NewLanguageLookUpDialog(
      {super.key, required this.lookUpQueries, required this.controller});

  final List<String> lookUpQueries;
  final TextEditingController controller;

  @override
  State<NewLanguageLookUpDialog> createState() =>
      _NewLanguageLookUpDialogState();
}

class _NewLanguageLookUpDialogState extends State<NewLanguageLookUpDialog> {
  final List<LookUpReturn> _lookUpReturns = [];

  Future<List<NewLanguageLookUpCard>> _lookUpWords() async {
    final List<NewLanguageLookUp> tempLookUps = [];
    final List<NewLanguageLookUpCard> _lookUpCards = [];

    //skip the first term as it is just the heading
    for (final thisTerm in widget.lookUpQueries) {
      final url = "https://api.dictionaryapi.dev/api/v2/entries/en/${thisTerm}";
      final dictionary = await FreeDictionary.fetchJson(url);

      if (dictionary != null) {
        tempLookUps.add(NewLanguageLookUp(dictionary));
      }
    }

    if (tempLookUps.isNotEmpty) {
      for (final lookUpQuery in tempLookUps) {
        final lookUpReturn = LookUpReturn(lookUpQuery.term);
        if (lookUpQuery.term.trim().isNotEmpty)
          _lookUpReturns.add(lookUpReturn);
        _lookUpCards.add(NewLanguageLookUpCard(
          input: lookUpQuery,
          output: lookUpReturn,
        ));
      }
    }
    return _lookUpCards;
  }

  void _processLookUpNewLanguageResults() {
    final sb = StringBuffer();
    final fullText = widget.controller.text;
    final indexHeading = fullText.indexOf("@ New Language");
    int indexEnding = fullText.indexOf("@", indexHeading + 1);
    if (indexEnding == -1) indexEnding = fullText.indexOf(">=");
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
      String fullDefinition = "${lur.term} //\n  pos{${lur.partOfSpeech}}";
      if (lur.example != null) {
        fullDefinition =
            "$fullDefinition ||\n    ${lur.definition} //\n    eg{${lur.example}}";
      } else {
        fullDefinition = "$fullDefinition ||\n    ${lur.definition}";
      }
      if (fullDefinition.contains("’")) {
        fullDefinition.replaceAll("’", "'");
      }
      lines[i] = fullDefinition;
    }

    sb.writeln(" New Language");
    lines.forEach((line) {
      if (line.trim().isNotEmpty && line[0] != "-") {
        sb.writeln("- $line");
      } else {
        if (line != "- >=") {
          sb.writeln("$line");
        }
      }
    });
    sb.writeln("\n\n");

    //highlight the whole original term and replace it
    final before = fullText.substring(0, indexHeading + 1);
    final after = fullText.substring(indexEnding);
    print(before + "\n");
    print(sb.toString() + "\n");
    print(after);
    widget.controller.text = "$before ${sb.toString().trim()}\n$after";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Dictionary Results"),
      content: SingleChildScrollView(
        child: FutureBuilder(
          future: _lookUpWords(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return Column(children: [
                    //List of entries
                    ...snapshot.data!.map((card) => card),
                    //Button
                    ElevatedButton(
                      child: Text("OK"),
                      onPressed: () {
                        _processLookUpNewLanguageResults();
                        Navigator.pop(context, _lookUpReturns);
                      },
                    )
                  ]);
                } else {
                  return Center(
                    child: Text("Failed to return results"),
                  );
                }
              } else {
                return Center(
                  child: Text("Failed to return results"),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: Text("Failed to return results"),
            );
          },
        ),
      ),
    );
  }
}

//======================================================================
//Look Up Card
//======================================================================
class NewLanguageLookUpCard extends StatefulWidget {
  final NewLanguageLookUp input;
  final LookUpReturn output;

  const NewLanguageLookUpCard(
      {super.key, required this.input, required this.output});

  @override
  State<NewLanguageLookUpCard> createState() => _NewLanguageLookUpCardState();
}

class _NewLanguageLookUpCardState extends State<NewLanguageLookUpCard> {
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
            value: e.key, child: Text(e.key, overflow: TextOverflow.fade)))) {
          output.add(DropdownMenuItem(
              value: e.key, child: Text(e.key, overflow: TextOverflow.fade)));
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
                itemHeight: null,
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
            readOnly: true,
          )
        ],
      ),
    ));
  }
}
