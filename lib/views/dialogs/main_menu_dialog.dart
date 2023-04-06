import 'package:flutter/material.dart';
import 'package:lesson_companion/models/database.dart';
import 'package:lesson_companion/models/report_template.dart';

import '../../main.dart';
import '../companion_widgets.dart';
import 'snippets/snippet_list.dart';

//------------------------------------------------------------------------------
// MenuMainDialog
//------------------------------------------------------------------------------

class MenuMainDialog extends StatefulWidget {
  const MenuMainDialog({super.key});

  @override
  State<MenuMainDialog> createState() => _MenuMainDialogState();
}

class _MenuMainDialogState extends State<MenuMainDialog> {
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
              return AppearanceMenuDialog();
            }));
        break;
    }
  }

  Widget _reportOptionMenu() {
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
        _optionCard(
            "Manage Templates",
            FutureBuilder(
              future: ReportTemplate.getAll(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        ListView.builder(
                          itemBuilder: (context, index) {
                            return ExpansionTile(
                              title: Text(
                                snapshot.data![index].text!,
                                overflow: TextOverflow.ellipsis,
                              ),
                              children: [
                                OutlinedButton(
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ReportTemplateEditorDialog(
                                            reportTemplate:
                                                snapshot.data![index],
                                          );
                                        },
                                      );
                                    },
                                    child: Text("Edit")),
                                OutlinedButton(
                                    onPressed: () async {},
                                    child: Text("Delete"))
                              ],
                            );
                          },
                        ),
                        FloatingActionButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return ReportTemplateEditorDialog();
                                });
                          },
                          child: Icon(Icons.hdr_plus),
                        )
                      ],
                    );
                  } else {
                    // error
                    return Center(
                      child: Text("Failed to load templates"),
                    );
                  }
                } else {
                  // error
                  return Center(
                    child: Text("No templates have been saved"),
                  );
                }
              },
            ))
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
}

//------------------------------------------------------------------------------
// AppearanceMenu
//------------------------------------------------------------------------------

class AppearanceMenuDialog extends StatefulWidget {
  const AppearanceMenuDialog({super.key});

  @override
  State<AppearanceMenuDialog> createState() => _AppearanceMenuDialogState();
}

class _AppearanceMenuDialogState extends State<AppearanceMenuDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Appearance Options"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            //DarkMode switch
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

//------------------------------------------------------------------------------
// ReportTemplateEditorDialog
//------------------------------------------------------------------------------

class ReportTemplateEditorDialog extends StatefulWidget {
  const ReportTemplateEditorDialog({super.key, this.reportTemplate = null});

  final ReportTemplate? reportTemplate;

  @override
  State<ReportTemplateEditorDialog> createState() =>
      _ReportTemplateEditorDialogState();
}

class _ReportTemplateEditorDialogState
    extends State<ReportTemplateEditorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Template Editor"),
      content: Column(
        children: [
          Expanded(
            child: TextFieldOutlined(
              initialText: widget.reportTemplate!.text!,
              onTextChanged: (text) {
                widget.reportTemplate!.text = text;
              },
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
          OutlinedButton(
              onPressed: () async {
                await ReportTemplate.save(widget.reportTemplate!);
                Navigator.pop(context);
                setState(() {});
              },
              child: Text("Save"))
        ],
      ),
    );
  }
}
