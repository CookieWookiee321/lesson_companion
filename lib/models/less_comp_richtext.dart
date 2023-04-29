import 'package:flutter/widgets.dart';

import '../controllers/styling/companion_lexer.dart';

enum ColorOption { purple, orange, green, regular, silver }

class LessCompText {
  late List<TextSpan> components = [];

  LessCompText(String text) {
    text = text.replaceAll("//", "\n");
    components = this.toPdfTextSpanList(text);
  }

  ///Returns a plain text version of the substrings which make up the PdfText object
  @override
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
      case "Jan":
        monthNum = "01";
        break;
      case "Feb":
        monthNum = "02";
        break;
      case "Mar":
        monthNum = "03";
        break;
      case "Apr":
        monthNum = "04";
        break;
      case "May":
        monthNum = "05";
        break;
      case "Jun":
        monthNum = "06";
        break;
      case "Jul":
        monthNum = "07";
        break;
      case "Aug":
        monthNum = "08";
        break;
      case "Sep":
        monthNum = "09";
        break;
      case "Oct":
        monthNum = "10";
        break;
      case "Nov":
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

  RichText toRichText() {
    final textSpans = <TextSpan>[];

    for (final pdfTextSpan in components) {
      textSpans.add(TextSpan(text: pdfTextSpan.text, style: pdfTextSpan.style));
    }

    return RichText(text: TextSpan(children: textSpans));
  }

  List<TextSpan> toPdfTextSpanList(String text) {
    // SEPERATE
    final unorderedStyleMap = _mapPositionToStyle(text);
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

  Map<int, TextSpan> _mapPositionToStyle(String text) {
    final _replaceMarker = "^";

    var output = <int, TextSpan>{};
    final sb = StringBuffer();
    sb.write(text);

    //find all matching substrings and organise them into a map
    int numMatches = 0;
    for (final expression in CompanionLexer.styles.keys) {
      if (!RegExp(expression).hasMatch(text)) continue;
      numMatches++;
      final matches = RegExp(expression).allMatches(text);

      for (final match in matches) {
        final thisPdfTextSpan = TextSpan(
            text: _removeSyntaxMarkers(
                input: match.input.toString().substring(match.start, match.end),
                regExp: expression),
            style: CompanionLexer.styles[expression]!);

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
          output[counterStart] = TextSpan(text: sbTwo.toString());
          sbTwo = StringBuffer();
        }
      }
      counter++;
    }

    if (numMatches == 0) {
      output[0] = TextSpan(text: text);
    } else if (sbTwo.isNotEmpty) {
      output[counterStart] = TextSpan(text: sbTwo.toString());
    }

    return output;
  }

  String _removeSyntaxMarkers({required String input, required String regExp}) {
    switch (regExp) {
      case r"(?<!\*)\*\*[^*]+\*\*(?!\*)":
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
