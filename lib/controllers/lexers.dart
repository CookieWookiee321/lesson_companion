import 'package:flutter/material.dart';
import 'package:lesson_companion/controllers/styler.dart';
import 'package:lesson_companion/models/pdf_document/pdf_textspan.dart';
import 'package:lesson_companion/models/style_snippet.dart';
import 'package:pdf/pdf.dart' as p;

enum lexerColours {
  cellSplitter,
  lineSplitter,
}

class CompanionLexer {
  static const markers = <String>["*", "{", "(", "\"", "[", "_"];

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
    RegExp(r"^\@ .+"): TextStyle(
        color: Color.fromARGB(255, 189, 180, 51), fontWeight: FontWeight.bold),
    // row start marker
    RegExp(r"\n\-"): TextStyle(
        color: Color.fromARGB(255, 176, 144, 56), fontWeight: FontWeight.bold),
    // comments
    RegExp(r"\!\![.]+\n"): TextStyle(color: Colors.grey),
    //italic, bold, bold and italic
    //TODO: ok?
    RegExp(r"(?<!\*)\*\*\*[^*]+\*\*\*(?!\*)"):
        TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
    //TODO: ok?
    RegExp(r"(?<!\*)\*\*[^*]+\*\*(?!\*)"):
        TextStyle(fontWeight: FontWeight.bold),
    RegExp(r"(?<!\*)\*[^*]+\*(?!\*)"): TextStyle(fontStyle: FontStyle.italic),
    // strikethrough
    RegExp(r"\s~{2}[ \w&!@#$%\'()\/*\-]+~{2}"):
        TextStyle(decoration: TextDecoration.lineThrough),
    // underline
    RegExp(r"\s\_[a-zA-z0-9 \&\!\@\#\$\%\'\(\)\/\-]+\_"):
        TextStyle(decoration: TextDecoration.underline),
    // subtext
    RegExp(r"[A-Za-z0-9]+\{[^}]*\}"): TextStyle(color: Colors.lightBlue),
    // skip marker
    RegExp(r"^\?\?"): TextStyle(
        color: Colors.indigoAccent,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic)
  };

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
}

enum StylingOption {
  bold,
  italic,
  boldAndItalic,
  coloured,
  subtext,
  underline,
  strikethrough,
  link,
  snippet
}

class PdfLexer {
  static Map<String, StylingOption> styles = {
    r"(?<!\S)(\*{1})[^*]+\1(?!\S)": StylingOption.italic,
    r"(?<!\S)(\*{2})[^*]+\1(?!\S)": StylingOption.bold,
    r"(?<!\S)(\*{3})[^*]+\1(?!\S)": StylingOption.boldAndItalic,
    r"\B\~{2}[^*]+\~{2}\B": StylingOption.strikethrough,
    r"(?<!\S)(\_{1})[^*]+\1(?!\S)": StylingOption.underline,
    r"sub\<.*?\>": StylingOption.subtext,
    r"col<([A-Za-z0-9]+( [A-Za-z0-9]+)+) :: [a-zA-Z]+>": StylingOption.coloured,
    r"[A-Za-z0-9]+\{[^}]*\}": StylingOption.snippet
  };

  static Future<List<PdfTextSpan>> toPdfTextSpanList(
      String text, PdfSection section) async {
    // SEPERATE
    final unorderedStyleMap = await _mapPositionToStyle(text, section);
    // ORDER
    if (unorderedStyleMap.length > 1) {
      final styleMapEntryList = unorderedStyleMap.entries.toList();
      styleMapEntryList.sort((a, b) => a.key.compareTo(b.key));
      final orderedStyleMap = Map.fromEntries(styleMapEntryList);
      return orderedStyleMap.values.toList();
    } else {
      // if no styling present, full text added with default settings
      return [unorderedStyleMap.values.first];
    }
  }

  static Future<Map<int, PdfTextSpan>> _mapPositionToStyle(
      String text, PdfSection section) async {
    final _replaceMarker = "^";

    var output = <int, PdfTextSpan>{};
    final sb = StringBuffer();
    sb.write(text);
    double baseHeight;
    double subHeight;

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

    //find all matching substrings and organise them into a map
    int numMatches = 0;
    for (final expression in PdfLexer.styles.keys) {
      if (!RegExp(expression).hasMatch(text)) continue;
      numMatches++;
      final matches = RegExp(expression).allMatches(text);

      double size = 12;
      bool bold = false;
      bool italic = false;
      bool underline = false;
      bool strikethrough = false;
      p.PdfColor color = p.PdfColor(255, 255, 255);

      for (final match in matches) {
        switch (styles[expression]) {
          case StylingOption.bold:
            bold = true;
            break;
          case StylingOption.italic:
            italic = true;
            break;
          case StylingOption.boldAndItalic:
            bold = true;
            italic = true;
            break;
          case StylingOption.coloured:
            color = PdfStyler.parseTextColour(match.toString());
            break;
          case StylingOption.subtext:
            size = subHeight;
            break;
          case StylingOption.underline:
            underline = true;
            break;
          case StylingOption.strikethrough:
            strikethrough = true;
            break;
          case StylingOption.link:
            underline = true;
            color = p.PdfColors.blue;
            break;
          default: // snippet
            final snippetName = match.input
                .substring(match.start, match.input.indexOf("{", match.start));
            final snippet = await StyleSnippet.getSnippetByName(snippetName);

            if (snippet != null) {
              baseHeight = snippet.size;

              final colour = snippet.getPdfColour();
              if (colour != null) color = colour;

              for (final style in snippet.styles) {
                switch (style) {
                  case 1:
                    bold = true;
                    break;
                  case 2:
                    italic = true;
                    break;
                  case 3:
                    underline = true;
                    break;
                  case 4:
                    strikethrough = true;
                    break;
                  default:
                    continue;
                }
              }
              break;
            }
        }

        final thisPdfTextSpan = PdfTextSpan.builder(
            text: _removeSyntaxMarkers(
                input: match.input.toString().substring(match.start, match.end),
                regExp: expression),
            size: baseHeight,
            italic: italic,
            underline: underline,
            strikethrough: strikethrough,
            color: color);

        output[match.start] = thisPdfTextSpan;
        String replacement = "";
        for (int i = 0; i < (match.end - match.start); i++) {
          replacement = "$replacement$_replaceMarker";
        }
        final temp =
            sb.toString().replaceFirst(RegExp(expression), replacement);
        sb.clear();
        sb.write(temp);
      }
    }
    // process non-styled text at the end of the loop
    var sbTwo = StringBuffer();
    int counterStart = 0;
    int counter = 0;
    bool firstSkip = false;
    for (final char in sb.toString().characters) {
      if (char != _replaceMarker) {
        sbTwo.write(char);
        if (firstSkip) {
          firstSkip = false;
          counterStart = counter;
        }
      } else if (!firstSkip) {
        firstSkip = true;
        if (sbTwo.isNotEmpty) {
          output[counterStart] = PdfTextSpan(text: sbTwo.toString());
          sbTwo = StringBuffer();
        }
      }
      counter++;
    }

    if (numMatches == 0) {
      output[0] = PdfTextSpan(text: text);
    } else if (sbTwo.isNotEmpty) {
      output[counterStart] = PdfTextSpan(text: sbTwo.toString());
    }

    return output;
  }

  static String _removeSyntaxMarkers(
      {required String input, required String regExp}) {
    switch (regExp) {
      case r"(?<!\S)(\*{1})[^*]+\1(?!\S)":
      case r"(?<!\S)(\_{1})[^*]+\1(?!\S)":
        return input.substring(1, input.length - 1);
      case r"(?<!\S)(\*{2})[^*]+\1(?!\S)":
        return input.substring(2, input.length - 2);
      case r"(?<!\S)(\*{3})[^*]+\1(?!\S)":
        return input.substring(3, input.length - 3);
      case r"\B\~{2}[^*]+\~{2}\B":
        return input.substring(2, input.length - 2);
      case r"sub\<.*?\>":
        return input.substring(4, input.length - 1);
      case r"col<([A-Za-z0-9]+( [A-Za-z0-9]+)+) :: [a-zA-Z]+>":
        return input.substring(4, input.indexOf("::")).trim();
      case r"[A-Za-z0-9]+\{[^}]*\}":
        return input.substring(input.indexOf("{") + 1, input.indexOf("}"));

      default:
        return input;
    }
  }
}

class CoRegExpStrings {
  static const String italicBold = r"(?<!\*)\*\*\*[^*]+\*\*\*(?!\*)";
  static const String bold = r"(?<!\*)\*\*[^*]+\*\*(?!\*)";
  static const String italic = r"(?<!\*)\*[^*]+\*(?!\*)";
  static const String strikethrough = r"\s~{2}[ \w&!@#$%\'()\/*\-]+~{2}";
  static const String underline = r"\s\_[a-zA-z0-9 \&\!\@\#\$\%\'\(\)\/\-]+\_";

  static const String rowSplitter = r"\|{2}";
  static const String lineBreak = r"\/{2}";
  static const String heading1 = r"\n\@ .+";
  static const String heading2 = "^\@ .+";
  static const String rowStart = r"\n\-";
}
