import 'package:isar/isar.dart';
import 'package:lesson_companion/models/pdf_document/pdf_document.dart';

part 'pdf_substring.g.dart';

@embedded
class PdfSubstring {
  late String _text;
  @enumerated
  late PdfTextType _textType;

  String get setText => _text;

  set setText(String value) {
    _text = value;
  }

  @enumerated
  PdfTextType get setTextType => _textType;

  @enumerated
  set setTextType(PdfTextType value) {
    _textType = value;
  }
}
