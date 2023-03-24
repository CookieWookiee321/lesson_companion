import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CompanionLexer {
  static const markers = <String>["*", "{", "(", "\"", "[", "_"];

  static Map<String, TextStyle> styles = {
    r"#[A-Za-z0-9]+": TextStyle(fontSize: 16),
    r"\*[A-Za-z0-9]+\*": TextStyle(fontStyle: FontStyle.italic),
    r"\**[A-Za-z0-9]+\**": TextStyle(fontWeight: FontWeight.bold),
    r"\*{3}[A-Za-z0-9]+\*{3}":
        TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
    r"\~~[A-Za-z0-9]+\~~": TextStyle(decoration: TextDecoration.lineThrough),
    r"\_[A-Za-z0-9]+\_": TextStyle(decoration: TextDecoration.underline),
    r"<sub [A-Za-z0-9]+>": TextStyle(fontSize: 10),
    //r"<sup [A-Za-z0-9]+>": TextStyle(fontSize: 10),
    //r"col\([A-Za-z0-9]+, [A-Za-z0-9]+\)": TextStyle(fontStyle: FontStyle.italic),
    //r"lnk\([A-Za-z0-9]+, [A-Za-z0-9]+\) ": TextStyle(fontStyle: FontStyle.italic),
  };

  static List<TextSpan> parseText(String text) {
    final output = <TextSpan>[];
    var placementMap = <int, TextSpan>{};

    //find all matching substrings and organise them into a map
    for (final marker in CompanionLexer.styles.keys) {
      final regex = RegExp(marker);

      if (regex.hasMatch(text)) {
        final matches = regex.allMatches(text).toList();

        for (final match in matches) {
          placementMap[match.start] = TextSpan(
              text: text.substring(match.start, match.end + 1),
              style: CompanionLexer.styles[marker]);
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

  static Map<RegExp, TextStyle> highlighter = {
    // row cell splitter
    RegExp(r"\|{2}"):
        TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
    // cell line break
    RegExp(r"\/{2}"):
        TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
    // heading marker
    RegExp(r"\n\@ .+"): TextStyle(
        color: Color.fromARGB(255, 189, 180, 51), fontWeight: FontWeight.bold),
    // row start marker
    RegExp(r"\n\-"): TextStyle(
        color: Color.fromARGB(255, 176, 144, 56), fontWeight: FontWeight.bold),
    // comments
    RegExp(r"\!\![.]+\n"): TextStyle(color: Colors.grey),
    //TODO: account for bold, and others
    //TODO: make sure all of them match
    //italic, bold, bold and italic
    RegExp(r"\ *{1}[a-zA-z0-9 \&\!\@\#\$\%\'\(\)\/\-\\]+\*{1}"):
        TextStyle(fontStyle: FontStyle.italic),
    RegExp(r"\ *{2}[a-zA-z0-9 \&\!\@\#\$\%\'\(\)\/\-\\]+\*{2}"):
        TextStyle(fontWeight: FontWeight.bold),
    RegExp(r"\ *{3}[a-zA-z0-9 \&\!\@\#\$\%\'\(\)\/\-\\]+\*{3}"):
        TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
    // strikethrough
    RegExp(r"\ ~{2}[a-zA-z0-9 \&\!\@\#\$\%\'\(\)\/\-\\]+\~{2}"):
        TextStyle(decoration: TextDecoration.lineThrough),
    // underline
    RegExp(r"\ _[a-zA-z0-9 \&\!\@\#\$\%\'\(\)\/\-\\]+\_"):
        TextStyle(decoration: TextDecoration.underline),
    //subtext
    // RegExp(r"\<sub [A-Za-z0-9 ]+\>"): TextStyle(fontSize: 10),
    RegExp(r"[A-Za-z0-9]+\{[^}]*\}"): TextStyle(color: Colors.lightBlue),
    // skip marker
    RegExp(r"^\?\?"): TextStyle(
        color: Colors.indigoAccent,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic)
    //r"<sup [A-Za-z0-9]+>": TextStyle(fontSize: 10),
    //r"col\([A-Za-z0-9]+, [A-Za-z0-9]+\)": TextStyle(fontStyle: FontStyle.italic),
    //r"lnk\([A-Za-z0-9]+, [A-Za-z0-9]+\) ": TextStyle(fontStyle: FontStyle.italic),
  };
}
