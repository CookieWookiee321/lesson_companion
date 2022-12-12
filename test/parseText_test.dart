import 'package:lesson_companion/controllers/styler.dart';
import 'package:lesson_companion/models/pdf_document/pdf_textspan.dart';
import 'package:pdf/pdf.dart';
import 'package:test/test.dart';
import 'package:lesson_companion/models/styling/pdf_lexer.dart';

void main() {
  test("text match", () async {
    final input = "Talk sh1{Hello}";

    final output = await PdfLexer.parseText(input, PdfSection.body);

    expect(output.first.text, "Talk");
    // expect(output.first.size, 9);
    // expect(output.first.color, PdfColors.black);
    // expect(output.first.bold, false);
    // expect(output.first.italic, false);
    // expect(output.first.underline, false);
    // expect(output.first.strikethrough, false);
  });

  test("text match", () async {
    final input = "Talk sh1{Hello}";

    final output = await PdfLexer.parseText(input, PdfSection.body);

    expect(output[2].text, "Hello");
    // expect(output[1].size, 9);
    // expect(output[1].color, PdfColors.black);
    // expect(output[1].bold, false);
    // expect(output[1].italic, false);
    // expect(output[1].underline, false);
    // expect(output[1].strikethrough, false);
  });
}
