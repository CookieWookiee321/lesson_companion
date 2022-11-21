import 'package:flutter/material.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';

class RichTextEditingController extends TextEditingController {
  late final Pattern pattern;
  String pureText = '';
  final Map<String, TextStyleBuilder> map = {
    r"b\[[^\]]*\]": TextStyleBuilder(bold: true),
    r"u\[[^\]]*\]": TextStyleBuilder(underlined: true),
    r"i\[[^\]]*\]": TextStyleBuilder(italic: true),
    r"s\[[^\]]*\]": TextStyleBuilder(colour: ColorOption.silver, size: 9),
    r"o\[[^\]]*\]": TextStyleBuilder(colour: ColorOption.orange, size: 9),
    r"g\[[^\]]*\]": TextStyleBuilder(colour: ColorOption.green, size: 9),
    r"p\[[^\]]*\]": TextStyleBuilder(colour: ColorOption.purple, size: 9),
    r"s\.b\[[^\]]*\]":
        TextStyleBuilder(colour: ColorOption.silver, size: 9, bold: true),
    r"s\.i\[[^\]]*\]":
        TextStyleBuilder(colour: ColorOption.silver, size: 9, italic: true),
    r"s\.u\[[^\]]*\]":
        TextStyleBuilder(colour: ColorOption.silver, size: 9, underlined: true),
    r"s\.bi\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.silver, size: 9, bold: true, italic: true),
    r"s\.ib\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.silver, size: 9, bold: true, italic: true),
    r"s\.bu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.silver, size: 9, bold: true, underlined: true),
    r"s\.ub\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.silver, size: 9, bold: true, underlined: true),
    r"s\.ui\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.silver, size: 9, italic: true, underlined: true),
    r"s\.iu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.silver, size: 9, italic: true, underlined: true),
    r"s\.ibu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.silver,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"s\.iub\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.silver,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"s\.biu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.silver,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"s\.bui\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.silver,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"s\.ubi\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.silver,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"s\.uib\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.silver,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"o\.b\[[^\]]*\]":
        TextStyleBuilder(colour: ColorOption.orange, size: 9, bold: true),
    r"o\.i\[[^\]]*\]":
        TextStyleBuilder(colour: ColorOption.orange, size: 9, italic: true),
    r"o\.u\[[^\]]*\]":
        TextStyleBuilder(colour: ColorOption.orange, size: 9, underlined: true),
    r"o\.bi\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.orange, size: 9, bold: true, italic: true),
    r"o\.ib\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.orange, size: 9, bold: true, italic: true),
    r"o\.bu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.orange, size: 9, bold: true, underlined: true),
    r"o\.ub\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.orange, size: 9, bold: true, underlined: true),
    r"o\.ui\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.orange, size: 9, italic: true, underlined: true),
    r"o\.iu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.orange, size: 9, italic: true, underlined: true),
    r"o\.ibu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.orange,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"o\.iub\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.orange,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"o\.biu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.orange,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"o\.bui\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.orange,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"o\.ubi\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.orange,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"o\.uib\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.orange,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"g\.b\[[^\]]*\]":
        TextStyleBuilder(colour: ColorOption.green, size: 9, bold: true),
    r"g\.i\[[^\]]*\]":
        TextStyleBuilder(colour: ColorOption.green, size: 9, italic: true),
    r"g\.u\[[^\]]*\]":
        TextStyleBuilder(colour: ColorOption.green, size: 9, underlined: true),
    r"g\.bi\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.green, size: 9, bold: true, italic: true),
    r"g\.ib\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.green, size: 9, bold: true, italic: true),
    r"g\.bu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.green, size: 9, bold: true, underlined: true),
    r"g\.ub\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.green, size: 9, bold: true, underlined: true),
    r"g\.ui\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.green, size: 9, italic: true, underlined: true),
    r"g\.iu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.green, size: 9, italic: true, underlined: true),
    r"g\.ibu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.green,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"g\.iub\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.green,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"g\.biu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.green,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"g\.bui\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.green,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"g\.ubi\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.green,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"g\.uib\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.green,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"p\.b\[[^\]]*\]":
        TextStyleBuilder(colour: ColorOption.purple, size: 9, bold: true),
    r"p\.i\[[^\]]*\]":
        TextStyleBuilder(colour: ColorOption.purple, size: 9, italic: true),
    r"p\.u\[[^\]]*\]":
        TextStyleBuilder(colour: ColorOption.purple, size: 9, underlined: true),
    r"p\.bi\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.purple, size: 9, bold: true, italic: true),
    r"p\.ib\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.purple, size: 9, bold: true, italic: true),
    r"p\.bu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.purple, size: 9, bold: true, underlined: true),
    r"p\.ub\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.purple, size: 9, bold: true, underlined: true),
    r"p\.ui\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.purple, size: 9, italic: true, underlined: true),
    r"p\.iu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.purple, size: 9, italic: true, underlined: true),
    r"p\.ibu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.purple,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"p\.iub\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.purple,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"p\.biu\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.purple,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"p\.bui\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.purple,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"p\.ubi\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.purple,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
    r"p\.uib\[[^\]]*\]": TextStyleBuilder(
        colour: ColorOption.purple,
        size: 9,
        italic: true,
        underlined: true,
        bold: true),
  };

  RichTextFieldController() {
    pattern = RegExp(map.keys.map((key) => key).join('|'), multiLine: true);
  }

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    final List<InlineSpan> children = [];
    text.splitMapJoin(pattern, onMatch: (Match match) {
      String? formattedText;
      String? textPattern;
      final patterns = map.keys.toList();

      TextStyle? textStyle;
      for (int i = 0; i < patterns.length; i++) {
        if (RegExp(patterns[i]).hasMatch(match[0]!)) {
          formattedText = match[0];
          textPattern = patterns[i];
          textStyle = map[patterns[i]]!.build();
          break;
        }
      }

      //make textspan obj
      children.add(TextSpan(text: formattedText, style: textStyle!));
      return "";
    }, onNonMatch: (String text) {
      children.add(TextSpan(text: text, style: style));
      return "";
    });
    return TextSpan(style: style, children: children);
  }
}

class TextStyleBuilder {
  final ColorOption colour;
  final double size;
  final bool bold;
  final bool italic;
  final bool underlined;

  TextStyleBuilder(
      {this.colour = ColorOption.regular,
      this.size = 11,
      this.bold = false,
      this.italic = false,
      this.underlined = false});

  TextStyle build() {
    final _colour;
    switch (colour) {
      case ColorOption.purple:
        _colour = Colors.purple[800];
        break;
      case ColorOption.orange:
        _colour = Colors.orange[600];
        break;
      case ColorOption.green:
        _colour = Colors.green[600];
        break;
      case ColorOption.regular:
        _colour = Colors.black;
        break;
      case ColorOption.silver:
        _colour = Colors.grey[600];
        break;
    }

    return TextStyle(
        color: _colour,
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        decoration: underlined ? TextDecoration.underline : null);
  }
}
