import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lesson_companion/models/pdf_document/pdf_textspan.dart';
import 'package:lesson_companion/models/styling/pdf_lexer.dart';
import 'package:pdf/pdf.dart' as p;
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
    // for (final entry in map.entries) {
    //   int index = entry.key;
    //   for (final character in entry.value.text.characters) {
    //     if (!spans.containsKey(index)) {
    //       spans[index] = PdfTextSpan(text: character);
    //     }

    //     if (!spans[index]!.bold) {
    //       if (entry.value.bold) {
    //         spans[index]!.bold = true;
    //       }
    //     }
    //     if (!spans[index]!.italic) {
    //       if (entry.value.italic) {
    //         spans[index]!.italic = true;
    //       }
    //     }
    //     if (!spans[index]!.underline) {
    //       if (entry.value.underline) {
    //         spans[index]!.underline = true;
    //       }
    //     }
    //     if (!spans[index]!.strikethrough) {
    //       if (entry.value.strikethrough) {
    //         spans[index]!.strikethrough = true;
    //       }
    //     }
    //     if (spans[index]!.color == p.PdfColors.black) {
    //       if (entry.value.color != p.PdfColors.black) {
    //         spans[index]!.color == p.PdfColors.black;
    //       }
    //     }
    //   }
    // }

    // //compile return list
    // final List<w.TextSpan> output = [];
    // for (final span in spans.entries) {
    //   final decoration;
    //   if (span.value.strikethrough && span.value.underline) {
    //     decoration = w.TextDecoration.combine(
    //         [w.TextDecoration.lineThrough, w.TextDecoration.underline]);
    //   } else if (span.value.strikethrough) {
    //     decoration = w.TextDecoration.lineThrough;
    //   } else if (span.value.underline) {
    //     decoration = w.TextDecoration.underline;
    //   } else {
    //     decoration = null;
    //   }

    //   //get correct font
    //   final w.Font font =
    //       w.Font.ttf(await rootBundle.load("lib/assets/Andika-Regular.ttf"));

    //   //build and add the result
    //   output.add(w.TextSpan(
    //       text: span.value.text,
    //       style: w.TextStyle(
    //           font: font,
    //           color: span.value.color,
    //           fontSize: span.value.size,
    //           fontWeight:
    //               span.value.bold ? w.FontWeight.bold : w.FontWeight.normal,
    //           fontStyle:
    //               span.value.italic ? w.FontStyle.italic : w.FontStyle.normal,
    //           decoration: decoration)));
    // }
    // return w.RichText(text: w.TextSpan(children: output));
    return w.RichText(text: w.TextSpan(text: "Hello"));
  }
}
