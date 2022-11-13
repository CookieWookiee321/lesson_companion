import 'package:isar/isar.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';

part 'pdf_substring.g.dart';

@embedded
class PdfSubstring {
  late String text;
  @enumerated
  late ColorOption color;
  late bool bold = false;
  late bool italic = false;
  late bool underlined = false;
}
