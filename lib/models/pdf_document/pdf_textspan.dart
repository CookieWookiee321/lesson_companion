import 'package:pdf/pdf.dart' as p;

class PdfTextSpan {
  String text;
  double size;
  p.PdfColor color;
  bool bold;
  bool italic;
  bool underline;
  bool strikethrough;

  PdfTextSpan(
      {required this.text,
      this.size = 11,
      this.color = p.PdfColors.black,
      this.bold = false,
      this.italic = false,
      this.strikethrough = false,
      this.underline = false});
}
