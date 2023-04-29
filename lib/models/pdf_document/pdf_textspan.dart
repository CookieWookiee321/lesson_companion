import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart' as p;

class PdfTextSpan {
  String text;
  bool? bold;
  bool? italic;
  bool? strikethrough;
  bool? underline;
  TextStyle? style;

  PdfTextSpan({required this.text, this.style = null}) {
    if (this.style == null) this.style = TextStyle();
  }

  PdfTextSpan.builder(
      {required this.text,
      size = 11,
      color = p.PdfColors.black,
      this.bold = false,
      this.italic = false,
      this.strikethrough = false,
      this.underline = false}) {
    final TextDecoration? decoration;
    if (this.strikethrough! && this.underline!) {
      decoration = TextDecoration.combine(
          [TextDecoration.lineThrough, TextDecoration.underline]);
    } else if (!this.strikethrough! && this.underline!) {
      decoration = TextDecoration.underline;
    } else if (this.strikethrough! && !this.underline!) {
      decoration = TextDecoration.lineThrough;
    } else {
      decoration = null;
    }

    this.style = TextStyle(
        fontSize: size,
        fontStyle: (this.italic!) ? FontStyle.italic : null,
        fontWeight: (this.bold!) ? FontWeight.bold : null,
        color: Color(color),
        decoration: decoration);
  }
}
