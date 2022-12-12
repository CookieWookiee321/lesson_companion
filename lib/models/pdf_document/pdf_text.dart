import 'package:lesson_companion/models/pdf_document/pdf_textspan.dart';
import 'package:lesson_companion/models/styling/pdf_lexer.dart';
import 'package:pdf/widgets.dart' as w;

import '../../controllers/styler.dart';

enum ColorOption { purple, orange, green, regular, silver }

class PdfText {
  List<PdfTextSpan> components = [];

  Future<void> process(String input, PdfSection section) async {
    String text = input;
    //handle new lines
    text = text.replaceAll("//", "\n");
    components = await PdfLexer.parseText(text, section);
  }

  ///Returns a plain text version of the substrings which make up the PdfText object
  @override
  String toString() {
    final sb = StringBuffer();

    for (final c in components) {
      sb.write(c.text);
    }

    return sb.toString();
  }

  DateTime parseToDateTime() {
    var parts = this.toString().split(" ");
    String monthNum;
    switch (parts[1]) {
      case "Jan":
        monthNum = "01";
        break;
      case "Feb":
        monthNum = "02";
        break;
      case "Mar":
        monthNum = "03";
        break;
      case "Apr":
        monthNum = "04";
        break;
      case "May":
        monthNum = "05";
        break;
      case "Jun":
        monthNum = "06";
        break;
      case "Jul":
        monthNum = "07";
        break;
      case "Aug":
        monthNum = "08";
        break;
      case "Sep":
        monthNum = "09";
        break;
      case "Oct":
        monthNum = "10";
        break;
      case "Nov":
        monthNum = "11";
        break;
      default:
        monthNum = "12";
        break;
    }

    String dayNum = parts[0];
    if (dayNum.length == 1) {
      dayNum = "0$dayNum";
    }

    return DateTime.parse("${parts[2]}-$monthNum-$dayNum 00:00:00");
  }

  w.RichText toRichText() {
    final textSpans = <w.TextSpan>[];

    for (final pdfTextSpan in components) {
      final w.TextDecoration? decor;
      if (pdfTextSpan.strikethrough && pdfTextSpan.underline) {
        decor = w.TextDecoration.combine(
            [w.TextDecoration.underline, w.TextDecoration.lineThrough]);
      } else if (pdfTextSpan.strikethrough) {
        decor = w.TextDecoration.lineThrough;
      } else if (pdfTextSpan.underline) {
        decor = w.TextDecoration.underline;
      } else {
        decor = null;
      }

      final span = w.TextSpan(
          text: pdfTextSpan.text,
          style: w.TextStyle(
              fontSize: pdfTextSpan.size,
              decoration: decor != null ? decor : null,
              color: pdfTextSpan.color,
              fontWeight:
                  pdfTextSpan.bold ? w.FontWeight.bold : w.FontWeight.normal,
              fontStyle: pdfTextSpan.italic
                  ? w.FontStyle.italic
                  : w.FontStyle.normal));

      textSpans.add(span);
    }
    return w.RichText(text: w.TextSpan(children: textSpans));
  }
}
