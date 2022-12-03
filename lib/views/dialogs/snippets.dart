import 'package:flutter/material.dart';
import 'package:lesson_companion/models/style_snippet.dart';
import 'package:lesson_companion/models/styling/pdf_lexer.dart';
import 'package:lesson_companion/views/companion_widgets.dart';

class NewSnippetDialogMenu extends StatefulWidget {
  const NewSnippetDialogMenu({super.key});

  @override
  State<NewSnippetDialogMenu> createState() => _NewSnippetDialogMenuState();
}

class _NewSnippetDialogMenuState extends State<NewSnippetDialogMenu> {
  final _nameController = TextEditingController();
  final _sizeController = TextEditingController(text: "14");

  String? _snippetName;

  Color _colour = Colors.black;
  double _size = 14;
  bool _bold = false;
  bool _italic = false;
  bool _underline = false;
  bool _strikethrough = false;
  //TODO: Add links functionality

  final List<DropdownMenuItem> _colours = [
    DropdownMenuItem(value: Colors.black, child: Text("black")),
    DropdownMenuItem(value: Colors.blue, child: Text("blue")),
    DropdownMenuItem(value: Colors.blueGrey, child: Text("blue grey")),
    DropdownMenuItem(value: Colors.green, child: Text("green")),
    DropdownMenuItem(value: Colors.grey, child: Text("grey")),
    DropdownMenuItem(value: Colors.orange, child: Text("orange")),
    DropdownMenuItem(value: Colors.pink, child: Text("pink")),
    DropdownMenuItem(value: Colors.purple, child: Text("purple")),
    DropdownMenuItem(value: Colors.red, child: Text("red")),
    DropdownMenuItem(value: Colors.yellow, child: Text("yellow")),
  ];

  List<TextSpan> _buildPreview() {
    TextDecoration? _handleDecor() {
      if (_underline && _strikethrough) {
        return TextDecoration.combine(
            [TextDecoration.lineThrough, TextDecoration.underline]);
      } else if (_underline) {
        return TextDecoration.underline;
      } else if (_strikethrough) {
        return TextDecoration.lineThrough;
      } else {
        return null;
      }
    }

    return [
      TextSpan(
          text: "sample text",
          style: TextStyle(
              fontSize: _size,
              color: _colour,
              fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
              fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
              decoration: _handleDecor()))
    ];
  }

  List<StyleSnippetSpan> _buildStyleList() {
    final sss = StyleSnippetSpan();

    sss.setColour(_colour);
    sss.size = _size;
    sss.styles = [];
    if (_bold && _italic) {
      sss.styles.add(StylingOption.bold);
      sss.styles.add(StylingOption.italic);
    } else if (_bold) {
      sss.styles.add(StylingOption.bold);
    } else if (_italic) {
      sss.styles.add(StylingOption.italic);
    }

    if (_underline) {
      sss.styles.add(StylingOption.underline);
    }

    if (_strikethrough) {
      sss.styles.add(StylingOption.strikethrough);
    }
    return [sss];
  }

  void _onPressedSubmit() async {
    if (_snippetName != null) {
      final list = _buildStyleList();
      final snippet = StyleSnippet(_snippetName!, list);
      await StyleSnippet.saveLesson(snippet);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("The snippet has been saved.")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter a name for the snippet.")));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Style Snippet"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //TODO:focus on fixed things first, then add customisation later
          Text("Snippet Name"),
          TextFieldOutlined(
            controller: _nameController,
            textAlign: TextAlign.center,
            onTextChanged: (text) {
              _snippetName = text;
            },
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                borderRadius: BorderRadius.circular(4.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                children: [
                  Text("Styles"),
                  //colour + size
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Size"),
                              Expanded(
                                  child: TextFieldOutlined(
                                controller: _sizeController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                onTextChanged: (text) {
                                  setState(() {
                                    final temp = double.tryParse(text);
                                    if (temp == null) {
                                      _size = 14.0;
                                      _sizeController.text = "14";
                                    } else {
                                      _size = temp;
                                    }
                                  });
                                },
                              ))
                            ],
                          ),
                        ),
                        Expanded(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Colour"),
                            Expanded(
                                child: DropdownButton(
                              value: _colour,
                              items: _colours,
                              onChanged: (value) {
                                setState(() {
                                  _colour = value;
                                });
                              },
                            ))
                          ],
                        ))
                      ],
                    ),
                  ),
                  Row(),
                  //bold + italic
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Checkbox(
                              value: _bold,
                              onChanged: (value) {
                                setState(() {
                                  _bold = value!;
                                });
                              }),
                          Text("bold"),
                        ],
                      )),
                      Expanded(
                          child: Row(
                        children: [
                          Checkbox(
                              value: _italic,
                              onChanged: (value) {
                                setState(() {
                                  _italic = value!;
                                });
                              }),
                          Text("italic"),
                        ],
                      ))
                    ],
                  ),
                  //underline + strikethrough
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Checkbox(
                              value: _underline,
                              onChanged: (value) {
                                setState(() {
                                  _underline = value!;
                                });
                              }),
                          Text("underline"),
                        ],
                      )),
                      Expanded(
                          child: Row(
                        children: [
                          Checkbox(
                              value: _strikethrough,
                              onChanged: (value) {
                                setState(() {
                                  _strikethrough = value!;
                                });
                              }),
                          Text("strikethrough"),
                        ],
                      ))
                    ],
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        _onPressedSubmit();
                      },
                      child: Text("Save"))
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          Text("Preview"),
          //readonly textfield with changes applied on the fly
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                borderRadius: BorderRadius.circular(4.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: RichText(text: TextSpan(children: _buildPreview())),
            ),
          )
        ],
      ),
    );

    // AlertDialog(
    //     title: Text("New Snippet"),
    //     scrollable: true,
    //     content:
    // Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         //TODO:focus on fixed things first, then add customisation later
    //         Text("Snippet Name"),
    //         TextFieldOutlined(
    //           controller: _nameController,
    //           textAlign: TextAlign.center,
    //           onTextChanged: (text) {
    //             _snippetName = text;
    //           },
    //         ),
    //         Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
    //         Container(
    //           decoration: BoxDecoration(
    //               border: Border.all(
    //                   color: Theme.of(context).colorScheme.onSurfaceVariant),
    //               borderRadius: BorderRadius.circular(4.0)),
    //           child: Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 4.0),
    //             child: Column(
    //               children: [
    //                 Text("Styles"),
    //                 //colour + size
    //                 IntrinsicHeight(
    //                   child: Row(
    //                     children: [
    //                       Expanded(
    //                         child: Column(
    //                           mainAxisSize: MainAxisSize.min,
    //                           children: [
    //                             Text("Size"),
    //                             Expanded(
    //                                 child: TextFieldOutlined(
    //                               controller: _sizeController,
    //                               keyboardType: TextInputType.number,
    //                               textAlign: TextAlign.center,
    //                               onTextChanged: (text) {
    //                                 setState(() {
    //                                   final temp = double.tryParse(text);
    //                                   if (temp == null) {
    //                                     _size = 14.0;
    //                                     _sizeController.text = "14";
    //                                   } else {
    //                                     _size = temp;
    //                                   }
    //                                 });
    //                               },
    //                             ))
    //                           ],
    //                         ),
    //                       ),
    //                       Expanded(
    //                           child: Column(
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Text("Colour"),
    //                           Expanded(
    //                               child: DropdownButton(
    //                             value: _colour,
    //                             items: _colours,
    //                             onChanged: (value) {
    //                               setState(() {
    //                                 _colour = value;
    //                               });
    //                             },
    //                           ))
    //                         ],
    //                       ))
    //                     ],
    //                   ),
    //                 ),
    //                 Row(),
    //                 //bold + italic
    //                 Row(
    //                   children: [
    //                     Expanded(
    //                         child: Row(
    //                       children: [
    //                         Checkbox(
    //                             value: _bold,
    //                             onChanged: (value) {
    //                               setState(() {
    //                                 _bold = value!;
    //                               });
    //                             }),
    //                         Text("bold"),
    //                       ],
    //                     )),
    //                     Expanded(
    //                         child: Row(
    //                       children: [
    //                         Checkbox(
    //                             value: _italic,
    //                             onChanged: (value) {
    //                               setState(() {
    //                                 _italic = value!;
    //                               });
    //                             }),
    //                         Text("italic"),
    //                       ],
    //                     ))
    //                   ],
    //                 ),
    //                 //underline + strikethrough
    //                 Row(
    //                   children: [
    //                     Expanded(
    //                         child: Row(
    //                       children: [
    //                         Checkbox(
    //                             value: _underline,
    //                             onChanged: (value) {
    //                               setState(() {
    //                                 _underline = value!;
    //                               });
    //                             }),
    //                         Text("underline"),
    //                       ],
    //                     )),
    //                     Expanded(
    //                         child: Row(
    //                       children: [
    //                         Checkbox(
    //                             value: _strikethrough,
    //                             onChanged: (value) {
    //                               setState(() {
    //                                 _strikethrough = value!;
    //                               });
    //                             }),
    //                         Text("strikethrough"),
    //                       ],
    //                     ))
    //                   ],
    //                 ),
    //                 OutlinedButton(
    //                     onPressed: () async {
    //                       _onPressedSubmit();
    //                     },
    //                     child: Text("Save"))
    //               ],
    //             ),
    //           ),
    //         ),
    //         Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
    //         Text("Preview"),
    //         //readonly textfield with changes applied on the fly
    //         Container(
    //           decoration: BoxDecoration(
    //               color: Colors.white,
    //               border: Border.all(
    //                   color: Theme.of(context).colorScheme.onSurfaceVariant),
    //               borderRadius: BorderRadius.circular(4.0)),
    //           child: Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
    //             child: RichText(text: TextSpan(children: _buildPreview())),
    //           ),
    //         )
    //       ],
    //     )
    // );
  }
}

class SnippetDialogMenu extends StatefulWidget {
  const SnippetDialogMenu({super.key});

  @override
  State<SnippetDialogMenu> createState() => SnippetDialogMenuState();
}

class SnippetDialogMenuState extends State<SnippetDialogMenu> {
  AlertDialog _snippetEditMenu() {
    return AlertDialog(
      title: Text("Style Snippet Menu"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        OutlinedButton(onPressed: null, child: Text("Edit")),
        Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
        OutlinedButton(onPressed: null, child: Text("Delete"))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Style Snippet Menu"),
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer)),
                      child: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: FutureBuilder(
                            future: StyleSnippet.getAllSnippets(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return ListView(
                                    shrinkWrap: true,
                                    children: [
                                      ...snapshot.data!.map((e) {
                                        return ListTile(
                                          leading: Text(e.marker),
                                          title: RichText(
                                              text: TextSpan(text: "hello")),
                                        );
                                      })
                                    ],
                                  );
                                }
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ))),
                ),
                IconButton(
                    icon: Icon(Icons.exposure_plus_1),
                    onPressed: () async => await showDialog(
                          context: context,
                          builder: (context) => NewSnippetDialogMenu(),
                        ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
