import 'package:isar/isar.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table_row.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';

part 'pdf_table.g.dart';

@embedded
class PdfTableModel {
  PdfText? _heading;
  List<PdfTableRowModel>? _rows;

  PdfText? get heading => _heading;

  set heading(PdfText? value) {
    _heading = value;
  }

  List<PdfTableRowModel>? get rows => _rows;

  set rows(List<PdfTableRowModel>? value) {
    _rows = value;
  }
}
