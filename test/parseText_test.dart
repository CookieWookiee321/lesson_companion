import 'package:lesson_companion/controllers/styler.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';
import 'package:lesson_companion/models/pdf_document/pdf_textspan.dart';
import 'package:pdf/pdf.dart';
import 'package:test/test.dart';
import 'package:lesson_companion/models/styling/pdf_lexer.dart';

void main() {
  test("text match", () async {
    final input = "I **joined** the class and **then** I went *to* school";

    final output = await PdfLexer.parseText(input, PdfSection.body);
    final pdfText = PdfText();
    pdfText.components = output;

    expect(pdfText.toString(), "I joined the class and then I went to school");
    // expect(output.first.size, 9);
    // expect(output.first.color, PdfColors.black);
    // expect(output.first.bold, false);
    // expect(output.first.italic, false);
    // expect(output.first.underline, false);
    // expect(output.first.strikethrough, false);
  });
}
