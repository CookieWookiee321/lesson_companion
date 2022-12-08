import 'package:flutter/material.dart';
import 'package:lesson_companion/controllers/companion_methods.dart';
import 'package:lesson_companion/models/database.dart';
import 'package:lesson_companion/models/style_snippet.dart';
import 'package:lesson_companion/views/companion_widgets.dart';
import 'package:lesson_companion/views/dialogs/snippets.dart';

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
>Questions are in light blue, and are indicated like so - "q\\sample\\"
>Examples are bolded and in green, and are indicated like so - "e\\sample\\"
>Informtion is in orange, and is indicated like so - "i\\sample\\"
>NOTE: There is nothing stopping you from using the different styles for your own purposes, and not as they are outlined here. They are just named based on their original functions.
>E.g. "q\\What did you do yesterday?\\//I go to school||I went to school//i\\remember to use past tense verbs.\\//e\\go >> went\\"
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

class MenuMainDialog extends StatefulWidget {
  const MenuMainDialog({super.key});

  @override
  State<MenuMainDialog> createState() => _MenuMainDialogState();
}

class _MenuMainDialogState extends State<MenuMainDialog> {
  ///Menu names are [Style Snippets], [Report Options], [Appearance Options]
  Future<void> _go(BuildContext context, String menuName) async {
    switch (menuName) {
      case "Style Snippets":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SnippetList()));
        break;
      case "Report Options":
        await showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                title: Text("Report Options"),
                scrollable: true,
                content: _reportOptionMenu(),
              );
            }));
        break;
      case "Appearance Options":
        await showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                title: Text("Appearance Options"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text("Dark Mode")),
                        FutureBuilder(
                          future:
                              Database.getSetting(SharedPrefOption.darkMode),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Switch(
                                  value: snapshot.data,
                                  onChanged: (value) async {
                                    await Database.saveSetting(
                                        SharedPrefOption.darkMode, value);
                                    setState(() {});
                                  });
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ),
              );
            }));
        break;
    }
  }

  Column _reportOptionMenu() {
    return Column(
      children: [
        _optionCard(
            "Table Name Defaults:",
            TextFieldOutlined(
              initialText: "New Language\nPronunciation\nCorrections",
              size: 13,
            )),
        _optionCard(
            "Report Footer:",
            FutureBuilder(
              future: Database.getSetting(SharedPrefOption.footer),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return TextFieldOutlined(
                      initialText: snapshot.data as String,
                      size: 13,
                      readOnly: false,
                      onTextChanged: (text) async {
                        await Database.saveSetting(
                            SharedPrefOption.footer, text);
                      },
                    );
                  } else {
                    return TextFieldOutlined(
                      initialText: "Could not load saved footer",
                      size: 13,
                      readOnly: true,
                    );
                  }
                }
                return CircularProgressIndicator();
              },
            )),
      ],
    );
  }

  Card _optionCard(String heading, Widget option) {
    return Card(
        child: Padding(
            child: Column(
              children: [
                Container(
                  child: Text(
                    heading,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).colorScheme.secondary))),
                ),
                option
              ],
            ),
            padding: EdgeInsets.all(4.0)));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Main Menu"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
              child: Text("Style Snippets"),
              onPressed: () async => await _go(context, "Style Snippets")),
          Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          OutlinedButton(
            child: Text("Appearance Options"),
            onPressed: () async => await _go(context, "Appearance Options"),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          OutlinedButton(
            child: Text("Report Options"),
            onPressed: () async {
              await _go(context, "Report Options");
              setState(() {});
            },
          )
        ],
      ),
    );
  }
}
