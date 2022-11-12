import 'package:flutter/material.dart';

//==============================================================================
//TextField Outlined
//==============================================================================
class TextFieldOutlined extends StatefulWidget {
  const TextFieldOutlined(
      {Key? key,
      this.initialText = "",
      this.controller,
      this.hint,
      this.size,
      this.padded,
      this.readOnly = false,
      this.onTextChanged})
      : super(key: key);

  //TODO: Must assert no init value with controller

  final String initialText;
  final TextEditingController? controller;
  final String? hint;
  final double? size;
  final bool? padded;
  final bool readOnly;
  final Function(String text)? onTextChanged;

  @override
  State<TextFieldOutlined> createState() => _TextFieldOutlinedState();
}

class _TextFieldOutlinedState extends State<TextFieldOutlined> {
  TextEditingController? _controller;

  @override
  void initState() {
    if (widget.controller != null) {
      _controller = widget.controller;
    } else {
      _controller = TextEditingController(text: widget.initialText);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padded != null
          ? const EdgeInsets.fromLTRB(13.0, 6.0, 13.0, 0.0)
          : const EdgeInsets.fromLTRB(2.0, 6.0, 2.0, 0.0),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: widget.hint,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        ),
        style: TextStyle(fontSize: widget.size),
        maxLines: null,
        onChanged: widget.onTextChanged,
        controller: _controller,
      ),
    );
  }
}

//==============================================================================
//TextField Borderless
//==============================================================================
class TextFieldBorderless extends StatefulWidget {
  final String defaultText;
  final String hintText;
  final bool padded;
  final Function(String)? onTextChanged;
  final bool expands;

  const TextFieldBorderless(
      {Key? key,
      this.defaultText = "",
      this.hintText = "",
      this.padded = false,
      this.expands = false,
      this.onTextChanged})
      : super(key: key);

  @override
  State<TextFieldBorderless> createState() => _TextFieldBorderlessState();
}

class _TextFieldBorderlessState extends State<TextFieldBorderless> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padded
          ? const EdgeInsets.fromLTRB(13.0, 6.0, 13.0, 0.0)
          : const EdgeInsets.fromLTRB(2.0, 6.0, 2.0, 0.0),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            onChanged: widget.onTextChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            ),
            style: const TextStyle(fontSize: 11),
            maxLines: null,
            initialValue: widget.defaultText,
            expands: widget.expands,
          ))
        ],
      ),
    );
  }
}

//==============================================================================
//Bottom Bar
//==============================================================================
class LabelledSwitch extends StatefulWidget {
  final String label;

  const LabelledSwitch({super.key, required this.label});

  @override
  State<LabelledSwitch> createState() => _LabelledSwitchState();
}

class _LabelledSwitchState extends State<LabelledSwitch> {
  bool _isOn = true;

  void _onSwitched(bool isOn) {
    setState(() {
      isOn ? _isOn = false : _isOn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(widget.label)),
        Switch(
            value: _isOn,
            onChanged: (state) => setState(() {
                  _onSwitched(state);
                }))
      ],
    );
  }
}
