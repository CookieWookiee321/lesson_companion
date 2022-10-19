import 'package:isar/isar.dart';
import 'package:lesson_companion/models/pdf_document/pdf_document.dart';
import 'package:lesson_companion/models/pdf_document/pdf_substring.dart';
part 'pdf_text.g.dart';

@embedded
class PdfText {
  List<PdfSubstring> components = [];

  void input(String input) {
    components.clear();

    var currentType = PdfTextType.base;
    final markerOpeners = ["q", "e", "i"];
    final sb = StringBuffer();
    final specialChars = ["\\", "<", ">"];

    input = input.replaceAll('//', '\n');

    //start looping through characters
    for (int i = 0; i < input.length; i++) {
      //build the substring until...
      if (!specialChars.contains(input[i])) {
        sb.write(input[i]);
      } else {
        if (input[i] == "\\") {
          //determine if this is starting text markdown, or completing it
          if (markerOpeners.contains(sb.toString()[sb.length - 1])) {
            // open a new markdown substring, based on the character preceding the opening '\'
            final marker = sb.toString()[sb.length - 1];

            final temp = sb.toString().substring(0, sb.length - 1);
            sb.clear();
            sb.write(temp);

            if (sb.isNotEmpty) {
              final sub = PdfSubstring();
              sub.setText = sb.toString();
              sub.setTextType = currentType;

              components.add(sub);
              sb.clear();
            }

            switch (marker) {
              case "q":
                currentType = PdfTextType.question;
                break;
              case "i":
                currentType = PdfTextType.info;
                break;
              case "e":
                currentType = PdfTextType.example;
                break;
            }
          } else {
            if (currentType != PdfTextType.base) {
              if (currentType == PdfTextType.sub) {
                sb.write(input[i]);
              } else {
                if (sb.isNotEmpty) {
                  final sub = PdfSubstring();
                  sub.setText = sb.toString();
                  sub.setTextType = currentType;

                  components.add(sub);
                  sb.clear();
                }

                currentType = PdfTextType.base;
              }
            }
          }
        } else if (input[i] == "<") {
          // begin new subtext substring
          if (sb.isNotEmpty) {
            final sub = PdfSubstring();
            sub.setText = sb.toString();
            sub.setTextType = currentType;

            components.add(sub);
            sb.clear();
          }
          currentType = PdfTextType.sub;
        } else if (input[i] == ">") {
          // close subtext substring
          if (sb.isNotEmpty) {
            final sub = PdfSubstring();
            sub.setText = sb.toString();
            sub.setTextType = currentType;

            components.add(sub);
            sb.clear();
          }
          currentType = PdfTextType.base;
        }
      }
    }

    final sub = PdfSubstring();
    sub.setText = sb.toString();
    sub.setTextType = currentType;

    components.add(sub);
  }

  @override

  ///Returns a plain text version of the substrings which make up the PdfText obj
  String toString() {
    final sb = StringBuffer();

    for (final c in components) {
      sb.write(c.setText);
    }

    return sb.toString();
  }
}
