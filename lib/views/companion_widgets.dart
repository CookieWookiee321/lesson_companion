import 'package:flutter/material.dart';

import 'student_list_view.dart';
import 'lesson_list_view.dart';
import 'text_input_mode_view.dart';

//==============================================================================
//TEXT FIELDS
//==============================================================================

class TFOutlined extends StatefulWidget {
  const TFOutlined(
      {Key? key,
      required this.name,
      this.controller,
      this.hint,
      this.size,
      this.padded,
      this.onTextChanged})
      : super(key: key);

  final String name;
  final TextEditingController? controller;
  final String? hint;
  final double? size;
  final bool? padded;
  final Function(String text)? onTextChanged;

  @override
  State<TFOutlined> createState() => _TFOutlinedState();
}

class _TFOutlinedState extends State<TFOutlined> {
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
      ),
    );
  }
}

class TFBorderless extends StatefulWidget {
  final String defaultText;
  final String hintText;
  final bool padded;
  final Function(String)? onTextChanged;
  final bool expands;

  const TFBorderless(
      {Key? key,
      this.defaultText = "",
      this.hintText = "",
      this.padded = false,
      this.expands = false,
      this.onTextChanged})
      : super(key: key);

  @override
  State<TFBorderless> createState() => _TFBorderlessState();
}

class _TFBorderlessState extends State<TFBorderless> {
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

class LabelledSwich extends StatefulWidget {
  final String label;

  const LabelledSwich({super.key, required this.label});

  @override
  State<LabelledSwich> createState() => _LabelledSwichState();
}

class _LabelledSwichState extends State<LabelledSwich> {
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
