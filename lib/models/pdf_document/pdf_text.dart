import 'package:isar/isar.dart';
import 'package:lesson_companion/models/pdf_document/pdf_substring.dart';

part 'pdf_text.g.dart';

enum ColorOption { purple, orange, green, regular, gray }

@embedded
class PdfText {
  List<PdfSubstring> components = [];

  // void input(String input) {
  //   components.clear();

  //   var currentType = StyleOptions.regular;
  //   final markerOpeners = ["q", "e", "i", "#"];
  //   final sb = StringBuffer();
  //   final specialChars = ["\\", "[", "]"];

  //   input = input.replaceAll('//', '\n');

  //   //start looping through characters
  //   for (int i = 0; i < input.length; i++) {
  //     //build the substring until...
  //     if (!specialChars.contains(input[i])) {
  //       sb.write(input[i]);
  //     } else {
  //       if (input[i] == "\\") {
  //         //determine if this is starting text markdown, or completing it
  //         if (sb.length != 0 &&
  //             markerOpeners.contains(sb.toString()[sb.length - 1])) {
  //           // open a new markdown substring, based on the character preceding the opening '\'
  //           final marker = sb.toString()[sb.length - 1];

  //           final temp = sb.toString().substring(0, sb.length - 1);
  //           sb.clear();
  //           sb.write(temp);

  //           if (sb.isNotEmpty) {
  //             final sub = PdfSubstring();
  //             sub.setText = sb.toString();
  //             sub.setTextType = currentType;

  //             components.add(sub);
  //             sb.clear();
  //           }

  //           switch (marker) {
  //             case "q":
  //               currentType = StyleOptions.question;
  //               break;
  //             case "i":
  //               currentType = StyleOptions.info;
  //               break;
  //             case "e":
  //               currentType = StyleOptions.example;
  //               break;
  //             case "#":
  //               currentType = StyleOptions.tableHeader;
  //               break;
  //           }
  //         } else {
  //           if (currentType != StyleOptions.regular) {
  //             if (currentType == StyleOptions.tableHeader) {
  //               sb.write(input[i]);
  //             }
  //             if (currentType == StyleOptions.sub) {
  //               sb.write(input[i]);
  //             } else {
  //               if (sb.isNotEmpty) {
  //                 final sub = PdfSubstring();
  //                 sub.setText = sb.toString();
  //                 sub.setTextType = currentType;

  //                 components.add(sub);
  //                 sb.clear();
  //               }

  //               currentType = StyleOptions.regular;
  //             }
  //           }
  //         }
  //       } else if (input[i] == "[") {
  //         // begin new subtext substring
  //         if (sb.isNotEmpty) {
  //           final sub = PdfSubstring();
  //           sub.setText = sb.toString();
  //           sub.setTextType = currentType;

  //           components.add(sub);
  //           sb.clear();
  //         }
  //         currentType = StyleOptions.sub;
  //       } else if (input[i] == "]") {
  //         // close subtext substring
  //         if (sb.isNotEmpty) {
  //           final sub = PdfSubstring();
  //           sub.setText = sb.toString();
  //           sub.setTextType = currentType;

  //           components.add(sub);
  //           sb.clear();
  //         }
  //         currentType = StyleOptions.regular;
  //       }
  //     }
  //   }

  //   final sub = PdfSubstring();
  //   sub.setText = sb.toString();
  //   sub.setTextType = currentType;

  //   components.add(sub);
  // }

  void process(String input) {
    String text = input;
    int _indexBracketStart;
    int _indexBracketEnd;
    int? _indexMarkerStart;
    String _textUpTo;
    ColorOption _colour = ColorOption.regular;

    if (text.contains('[') && text.contains(']')) {
      while (text.contains('[') && text.contains(']')) {
        _colour = ColorOption.regular;
        _indexBracketStart = text.indexOf('[');
        _indexBracketEnd = text.indexOf(']');
        _textUpTo = text.substring(0, _indexBracketStart);
        _indexMarkerStart;

        //get the start of the marker substring

        //the markdown text begins the line, and is simple
        if (_textUpTo.length == 0) {
          final x = PdfSubstring();
          x.text = text.substring(_indexBracketStart, _indexBracketEnd);
          x.color = ColorOption.gray;

          components.add(x);

          text = text.substring(_indexBracketEnd, text.length);
          continue;
        }

        //isolate the markdown substring
        for (int i = _textUpTo.length; i >= 0; i--) {
          if (_textUpTo[i] == " ") {
            _indexMarkerStart = i + 1;
            break;
          }
        }

        //identify what the markers indicate
        final markdownSubstring =
            text.substring(_indexMarkerStart!, _indexBracketStart);
        _colour = ColorOption.regular;
        bool isBold = false;
        bool isItalic = false;
        bool isUnderlined = false;
        bool afterPeriod = false;

        for (int i = 0; i < markdownSubstring.length; i++) {
          if (!afterPeriod) {
            //handle colours
            switch (text[i]) {
              case "p":
                _colour = ColorOption.purple;
                break;
              case "g":
                _colour = ColorOption.green;
                break;
              case "o":
                _colour = ColorOption.orange;
                break;
              default:
                if (text[i] == "b" || text[i] == "g" || text[i] == "o") {
                  i--;
                } else {
                  throw Exception(
                      "Unexpected colour marker caught in a markdown substring");
                }
                break;
            }
            afterPeriod = true;
          } else {
            //handle styling
            switch (text[i]) {
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

        final x = PdfSubstring();
        x.text = text.substring(_indexBracketStart, _indexBracketEnd);
        x.color = _colour;
        x.bold = isBold;
        x.italic = isItalic;
        x.underlined = isUnderlined;

        components.add(x);
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
