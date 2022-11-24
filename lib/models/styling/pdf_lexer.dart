import 'package:lesson_companion/controllers/styler.dart';
import 'package:pdf/widgets.dart';

class PdfLexer {
  static Map<String, TextStyle> styles = {
    r"#[A-Za-z0-9]+": TextStyle(fontWeight: FontWeight.bold),
    r"##[A-Za-z0-9]+": TextStyle(fontWeight: FontWeight.bold),
    r"\*[A-Za-z0-9]+\*": TextStyle(fontStyle: FontStyle.italic),
    r"\**[A-Za-z0-9]+\**": TextStyle(fontWeight: FontWeight.bold),
    r"\***[A-Za-z0-9]+\***":
        TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
    r"\~~[A-Za-z0-9]+\~~": TextStyle(decoration: TextDecoration.lineThrough),
    r"\_[A-Za-z0-9]+\_": TextStyle(decoration: TextDecoration.underline),
    r"sub\<[A-Za-z0-9]+\>": TextStyle(),
    r"col\<[A-Za-z0-9]+ :: [A-Za-z0-9]+\>":
        TextStyle(fontStyle: FontStyle.italic),
    r"lnk\<[A-Za-z0-9]+ :: [A-Za-z0-9]+\>":
        TextStyle(fontStyle: FontStyle.italic),
  };

  static List<TextSpan> parseText(String text, PdfSection section) {
    final double baseHeight;
    final double subHeight;

    switch (section) {
      case PdfSection.h1:
        baseHeight = 20;
        subHeight = 16;
        break;
      case PdfSection.h2:
        baseHeight = 16;
        subHeight = 13;
        break;
      case PdfSection.h3:
        baseHeight = 13;
        subHeight = 11;
        break;
      case PdfSection.body:
        baseHeight = 11;
        subHeight = 9;
        break;
      case PdfSection.footer:
        baseHeight = 10;
        subHeight = 8;
        break;
    }

    final output = <TextSpan>[];
    var placementMap = <int, TextSpan>{};

    //find all matching substrings and organise them into a map
    for (final marker in PdfLexer.styles.keys) {
      final regex = RegExp(marker);

      if (regex.hasMatch(text)) {
        final matches = regex.allMatches(text).toList();

        for (final match in matches) {
          placementMap[match.start] = TextSpan(
              text: text.substring(match.start, match.end + 1),
              style: marker != r"sub<[A-Za-z0-9]+>"
                  ? PdfLexer.styles[marker]!.copyWith(fontSize: baseHeight)
                  : PdfLexer.styles[marker]!.copyWith(fontSize: subHeight));
        }
      }
    }

    //sort the map by index (key)
    final temp = placementMap.entries.toList();
    temp.sort((a, b) => a.key.compareTo(b.key));
    placementMap = Map.fromEntries(temp);

    //get and order the regular text
    int start = 0;
    for (final index in placementMap.keys) {
      final before = text.substring(start, index);
      output.add(TextSpan(text: before));
      output.add(placementMap[index]!);
      start = index + placementMap[index]!.text!.length;
    }

    return output;
  }
}
