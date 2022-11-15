import 'package:isar/isar.dart';
import 'package:lesson_companion/controllers/companion_methods.dart';
import 'package:lesson_companion/models/pdf_document/pdf_substring.dart';

part 'pdf_text.g.dart';

final markerCombinations = [
  'b',
  'i',
  'u',
  'p',
  'o',
  'g',
  's',
  'bi',
  'bu',
  'ib',
  'iu',
  'ub',
  'ui',
  'biu',
  'bui',
  'ibu',
  'iub',
  'ubi',
  'uib',
  'g.b',
  'g.i',
  'g.u',
  'p.b',
  'p.i',
  'p.u',
  'o.b',
  'o.i',
  'o.u',
  's.b',
  's.i',
  's.u',
  'g.bi',
  'g.bu',
  'g.ib',
  'g.iu',
  'g.ub',
  'g.ui',
  'p.bi',
  'p.bu',
  'p.ib',
  'p.iu',
  'p.ub',
  'p.ui',
  'o.bi',
  'o.bu',
  'o.ib',
  'o.iu',
  'o.ub',
  'o.ui',
  's.bi',
  's.bu',
  's.ib',
  's.iu',
  's.ub',
  's.ui',
  'g.biu',
  'g.bui',
  'g.ibu',
  'g.iub',
  'g.ubi',
  'g.uib',
  'p.biu',
  'p.bui',
  'p.ibu',
  'p.iub',
  'p.ubi',
  'p.uib',
  'o.biu',
  'o.bui',
  'o.ibu',
  'o.iub',
  'o.ubi',
  'o.uib',
  's.biu',
  's.bui',
  's.ibu',
  's.iub',
  's.ubi',
  's.uib'
];

enum ColorOption { purple, orange, green, regular, silver }

@embedded
class PdfText {
  List<PdfSubstring> components = [];

  void process(String input) {
    String text = input;
    int _indexBracketStart;
    int _indexBracketEnd;
    int? _indexMarkerStart;
    String _textUpToBracket;
    ColorOption _colour = ColorOption.regular;

    //handle new lines
    text = text.replaceAll("//", "\n");

    if (text.contains('[') && text.contains(']')) {
      while (text.contains('[') && text.contains(']')) {
        _colour = ColorOption.regular;
        _indexBracketStart = text.indexOf('[');
        _indexBracketEnd = text.indexOf(']');
        _textUpToBracket = text.substring(0, _indexBracketStart);
        _indexMarkerStart;

        //the markdown text begins the line, and is simple
        if (_textUpToBracket.length == 0) {
          final x = PdfSubstring();
          x.text = text.substring(_indexBracketStart, _indexBracketEnd + 1);
          x.color = ColorOption.silver;

          components.add(x);

          text = text.substring(_indexBracketEnd + 1, text.length);
          continue;
        }

        //isolate the markdown substring
        for (int i = _textUpToBracket.length - 1; i >= 0; i--) {
          if (!CompanionMethods.isLetter(_textUpToBracket[i]) &&
              _textUpToBracket[i] != ".") {
            _indexMarkerStart = i + 1;
            break;
          }

          if (i == 0) {
            _indexMarkerStart = 0;
          }
        }

        //identify what the markers indicate
        final markdownSubstring =
            text.substring(_indexMarkerStart!, _indexBracketStart);

        if (markdownSubstring.length > 0 &&
            !markerCombinations.contains(markdownSubstring)) {
          throw Exception(
              "One of your styling markers is incorrect (i.e. the letters like \"p.bu\").\nFor help, please check the starter guide.");
        }

        _colour = ColorOption.regular;
        bool isBold = false;
        bool isItalic = false;
        bool isUnderlined = false;
        bool afterPeriod = false;

        for (int i = 0; i < markdownSubstring.length; i++) {
          if (markdownSubstring[i] == ".") continue;

          if (!afterPeriod) {
            //handle colours
            switch (markdownSubstring[i]) {
              case "p":
                _colour = ColorOption.purple;
                break;
              case "g":
                _colour = ColorOption.green;
                break;
              case "o":
                _colour = ColorOption.orange;
                break;
              case "s":
                _colour = ColorOption.silver;
                break;
              default:
                i--;

                break;
            }
            afterPeriod = true;
          } else {
            //handle styling
            switch (markdownSubstring[i]) {
              case "b":
                isBold = true;
                break;
              case "i":
                isItalic = true;
                break;
              case "u":
                isUnderlined = true;
                break;
              default:
                throw Exception(
                    "Unexpected style marker caught in a markdown substring");
            }
          }
        }

        final textBefore;
        // check if any text preceeded the markdown
        if (_indexMarkerStart != 0 &&
            text.substring(0, _indexBracketStart) != markdownSubstring) {
          textBefore = text.substring(0, _indexMarkerStart);

          //assign PdfSubstring obj for regular text
          final pdfSubPreceeding = PdfSubstring();
          pdfSubPreceeding.text = textBefore;
          pdfSubPreceeding.color = ColorOption.regular;
          components.add(pdfSubPreceeding);
        }

        //assign PdfSubstring obj for markdown
        final pdfSubMarkdown = PdfSubstring();
        pdfSubMarkdown.text =
            text.substring(_indexBracketStart + 1, _indexBracketEnd);
        pdfSubMarkdown.color = _colour;
        pdfSubMarkdown.bold = isBold;
        pdfSubMarkdown.italic = isItalic;
        pdfSubMarkdown.underlined = isUnderlined;
        components.add(pdfSubMarkdown);

        //set the main text str for the next iteration
        text = text.substring(_indexBracketEnd + 1, text.length);
      }
      if (text.length > 0) {
        //assign PdfSubstring obj for regular text
        final pdfRestOfText = PdfSubstring();
        pdfRestOfText.text = text;
        pdfRestOfText.color = ColorOption.regular;
        components.add(pdfRestOfText);
      }
    } else {
      final pdfText = PdfSubstring();
      pdfText.text = text;
      pdfText.color = _colour;
      components.add(pdfText);
    }
  }

  @override

  ///Returns a plain text version of the substrings which make up the PdfText obj
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
      case "January":
        monthNum = "01";
        break;
      case "February":
        monthNum = "02";
        break;
      case "March":
        monthNum = "03";
        break;
      case "April":
        monthNum = "04";
        break;
      case "May":
        monthNum = "05";
        break;
      case "June":
        monthNum = "06";
        break;
      case "July":
        monthNum = "07";
        break;
      case "August":
        monthNum = "08";
        break;
      case "September":
        monthNum = "09";
        break;
      case "October":
        monthNum = "10";
        break;
      case "November":
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
}
