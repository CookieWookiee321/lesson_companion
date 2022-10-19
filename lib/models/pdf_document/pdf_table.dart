import 'package:isar/isar.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table_row.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';

part 'pdf_table.g.dart';

@embedded
class PdfTable {
  PdfText? _heading;
  List<PdfTableRow>? _rows;

  PdfText? get heading => _heading;

  set heading(PdfText? value) {
    _heading = value;
  }

  List<PdfTableRow>? get rows => _rows;

  set rows(List<PdfTableRow>? value) {
    _rows = value;
  }
}
