import 'package:flutter/material.dart';
import 'package:lesson_companion/models/style_snippet.dart';

import '../../companion_widgets.dart';

class SnippetBuilder extends StatefulWidget {
  final StyleSnippet? snippet;

  const SnippetBuilder({super.key, this.snippet});

  @override
  State<SnippetBuilder> createState() => _SnippetBuilderState();
}

class _SnippetBuilderState extends State<SnippetBuilder> {
  final _nameController = TextEditingController();
  final _sizeController = TextEditingController(text: "11");

  String? _snippetName;
  int? _snippetId;

  Color _colour = Colors.black;
  double _size = 11;
  bool _bold = false;
  bool _italic = false;
  bool _underline = false;
  bool _strikethrough = false;

  final List<DropdownMenuItem> _colours = [
    DropdownMenuItem(value: Colors.black, child: Text("black")),
    DropdownMenuItem(value: Color(0xFF0066B3), child: Text("blue")),
    DropdownMenuItem(value: Colors.blueGrey, child: Text("blue grey")),
    DropdownMenuItem(value: Color(0xFF00992B), child: Text("green")),
    DropdownMenuItem(value: Colors.grey[600]!, child: Text("grey")),
    DropdownMenuItem(value: Color(0xFF980095), child: Text("magenta")),
    DropdownMenuItem(value: Color(0xFF995B00), child: Text("orange")),
    DropdownMenuItem(value: Color(0xFF5E09B3), child: Text("purple")),
    DropdownMenuItem(value: Color(0xFFCC1714), child: Text("red")),
    DropdownMenuItem(value: Color(0xFF988F01), child: Text("yellow")),
  ];

  //TODO: Add links functionality

  //----------------------------------------------------------------------------
  // MAIN
  //-----------------------------------------------------------------------------

  @override
  void initState() {
    if (widget.snippet != null) {
      _snippetId = widget.snippet!.id;

      _snippetName = widget.snippet!.marker;
      _nameController.text = _snippetName!;

      _size = widget.snippet!.size;
      _sizeController.text = widget.snippet!.size.toString();

      _colour = widget.snippet!.getColour()!;

      for (final style in widget.snippet!.styles) {
        switch (style) {
          case StyleSnippet.bold:
            _bold = true;
            break;
          case StyleSnippet.italic:
            _italic = true;
            break;
          case StyleSnippet.underline:
            _underline = true;
            break;
          case StyleSnippet.strikethough:
            _strikethrough = true;
            break;
          default:
            continue;
        }
      }
    }

    super.initState();
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
                                  child: Focus(
                                child: TextFieldOutlined(
                                  controller: _sizeController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  onTextChanged: (text) {
                                    setState(() {
                                      if (text.length != 0) {
                                        final temp = double.tryParse(text);
                                        if (temp == null) {
                                          _size = 11.0;
                                          _sizeController.text = "11";
                                          _sizeController.selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset: _sizeController
                                                      .text.length);
                                        } else {
                                          _size = temp;
                                        }
                                      } else {
                                        _size = 11.0;
                                        _sizeController.text = "11";
                                        _sizeController.selection =
                                            TextSelection(
                                                baseOffset: 0,
                                                extentOffset: _sizeController
                                                    .text.length);
                                      }
                                    });
                                  },
                                ),
                                onFocusChange: (isFocussed) {
                                  if (isFocussed) {
                                    _sizeController.selection = TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            _sizeController.text.length);
                                  }
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
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: OutlinedButton(
                onPressed: () async {
                  _onPressedSubmit();
                },
                child: Text("Save")),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // METHODS
  //-----------------------------------------------------------------------------

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
              fontSize: _size * 1.5,
              color: _colour,
              fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
              fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
              decoration: _handleDecor()))
    ];
  }

  List<int> _buildStyleList() {
    final output = <int>[];

    if (_bold) {
      output.add(StyleSnippet.bold);
    }
    if (_italic) {
      output.add(StyleSnippet.italic);
    }
    if (_strikethrough) {
      output.add(StyleSnippet.strikethough);
    }
    if (_underline) {
      output.add(StyleSnippet.underline);
    }

    return output;
  }

  void _onPressedSubmit() async {
    if (_snippetName != null) {
      //build the snippet
      var snippet = await StyleSnippet.getSnippet(_snippetId!);

      if (snippet == null) {
        snippet = StyleSnippet(
            null,
            _snippetName!,
            _size,
            StyleSnippet.colourMap.keys
                .firstWhere((k) => StyleSnippet.colourMap[k] == _colour),
            _buildStyleList());

        await StyleSnippet.saveSnippet(snippet);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "The snippet has been saved.",
          ),
          clipBehavior: Clip.antiAlias,
          showCloseIcon: true,
        ));
      } else {
        snippet.marker = _snippetName!;
        snippet.size = _size;
        snippet.colour = StyleSnippet.colourMap.keys
            .firstWhere((k) => StyleSnippet.colourMap[k] == _colour);
        snippet.styles = _buildStyleList();

        await StyleSnippet.saveSnippet(snippet);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "The snippet has been updated.",
          ),
          clipBehavior: Clip.antiAlias,
          showCloseIcon: true,
        ));
      }

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter a name for the snippet."),
        clipBehavior: Clip.antiAlias,
        showCloseIcon: true,
      ));
    }
  }
}
