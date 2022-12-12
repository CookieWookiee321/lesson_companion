import 'package:lesson_companion/models/pdf_document/pdf_text.dart';

class PdfTableRowModel {
  PdfText? _lhs;
  PdfText? _rhs;

  PdfText? get lhs => _lhs;

  set lhs(PdfText? value) {
    _lhs = value;
  }

  PdfText? get rhs => _rhs;

  set rhs(PdfText? value) {
    _rhs = value;
  }
}
