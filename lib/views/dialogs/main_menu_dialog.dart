import 'package:flutter/material.dart';
import 'package:lesson_companion/models/database.dart';

import '../../main.dart';
import '../companion_widgets.dart';
import 'snippets/snippet_list.dart';

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
              return AppearanceMenu();
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

class AppearanceMenu extends StatefulWidget {
  const AppearanceMenu({super.key});

  @override
  State<AppearanceMenu> createState() => _AppearanceMenuState();
}

class _AppearanceMenuState extends State<AppearanceMenu> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Appearance Options"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Text("Dark Mode")),
              FutureBuilder(
                future: Database.getSetting(SharedPrefOption.darkMode),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Switch(
                        value: snapshot.data,
                        onChanged: (value) async {
                          await Database.saveSetting(
                              SharedPrefOption.darkMode, value);
                          setState(() {
                            final theme =
                                value ? ThemeMode.dark : ThemeMode.light;
                            MyApp.of(context).changeTheme(theme);
                          });
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
  }
}
