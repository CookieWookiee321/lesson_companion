import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:lesson_companion/controllers/styler.dart';
import 'package:lesson_companion/models/pdf_document/pdf_textspan.dart';
import 'package:lesson_companion/models/style_snippet.dart';
import 'package:pdf/pdf.dart' as p;

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
    // r"\B##\s[A-Za-z0-9]+$": StylingOption.bold,
    // r"\B#\s[A-Za-z0-9]+$": (fontWeight: FontWeight.bold),
    r"(?<!\S)(\*{1})[A-Za-z0-9 ]+\1(?!\S)": StylingOption.italic,
    r"(?<!\S)(\*{2})[A-Za-z0-9 ]+\1(?!\S)": StylingOption.bold,
    r"(?<!\S)(\*{3})[A-Za-z0-9 ]+\1(?!\S)": StylingOption.boldAndItalic,
    r"\B\~{2}[A-Za-z0-9 ]+\~{2}\B": StylingOption.strikethrough,
    r"(?<!\S)(\_{1})[A-Za-z0-9 ]+\1(?!\S)": StylingOption.underline,
    r"sub\<.*?\>": StylingOption.subtext,
    r"col<([A-Za-z0-9]+( [A-Za-z0-9]+)+) :: [a-zA-Z]+>": StylingOption.coloured,
    r"[A-Za-z0-9]+\{[^}]*\}": StylingOption.snippet
    // r"lnk<([A-Za-z0-9]+( [A-Za-z0-9]+)+) :: ([A-Za-z0-9]+(\.[A-Za-z0-9]+)+)>":
    //     StylingOption.link,
  };

  static Future<List<PdfTextSpan>> parseText(
      String text, PdfSection section) async {
    final output = <PdfTextSpan>[];
    //separate
    final tempMap = await _mapSeperateStyles(text, section);
    //order
    if (tempMap.length > 1) {
      // sort the map by index (key)
      final temp = tempMap.entries.toList();
      temp.sort((a, b) => a.key.compareTo(b.key));
      final placementMap = Map.fromEntries(temp);

      // get and order the regular text
      int start = 0;
      for (final index in placementMap.keys) {
        final before = text.substring(start, index);
        output.add(PdfTextSpan(text: before));
        output.add(placementMap[index]!);
        start = index + placementMap[index]!.text.length;
      }
    } else {
      // if no styling present, full text added with default settings
      output.add(tempMap.values.first);
    }

    return output;
  }

  static Future<Map<int, PdfTextSpan>> _mapSeperateStyles(
      String text, PdfSection section) async {
    final _replaceMarker = ".?";

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

      for (final match in matches) {
        final thisPdfTextSpan = PdfTextSpan(
            text: _getTrueText(
                input: match.input.toString().substring(match.start, match.end),
                regExp: expression));
        thisPdfTextSpan.size = baseHeight;

        switch (styles[expression]) {
          case StylingOption.bold:
            thisPdfTextSpan.bold = true;
            break;
          case StylingOption.italic:
            thisPdfTextSpan.italic = true;
            break;
          case StylingOption.boldAndItalic:
            thisPdfTextSpan.bold = true;
            thisPdfTextSpan.italic = true;
            break;
          case StylingOption.coloured:
            thisPdfTextSpan.color = PdfStyler.parseTextColour(match.toString());
            break;
          case StylingOption.subtext:
            thisPdfTextSpan.size = subHeight;
            break;
          case StylingOption.underline:
            thisPdfTextSpan.underline = true;
            break;
          case StylingOption.strikethrough:
            thisPdfTextSpan.strikethrough = true;
            break;
          case StylingOption.link:
            thisPdfTextSpan.underline = true;
            thisPdfTextSpan.color = p.PdfColors.blue;
            break;
          case StylingOption.snippet:
            final snippetName = match.input
                .substring(match.start, match.input.indexOf("{", match.start));
            final snippet = await StyleSnippet.getSnippet(snippetName);
            print("Stop skipping me");

            if (snippet != null) {
              //TODO: currently snippets can only have one style applied
              baseHeight = snippet.children.first.size;

              final colour = snippet.children.first.getPdfColour();
              if (colour != null) thisPdfTextSpan.color = colour;

              for (final style in snippet.children.first.styles) {
                switch (style) {
                  case StylingOption.bold:
                    thisPdfTextSpan.bold = true;
                    break;
                  case StylingOption.italic:
                    thisPdfTextSpan.italic = true;
                    break;
                  case StylingOption.underline:
                    thisPdfTextSpan.underline = true;
                    break;
                  case StylingOption.strikethrough:
                    thisPdfTextSpan.strikethrough = true;
                    break;
                  default:
                    continue;
                }
              }
              break;
            }
        }

        output[match.start] = thisPdfTextSpan;
        String replacement = "";
        for (int i = 0; i < (match.end - match.start); i++) {
          replacement = "$replacement^";
        }
        final temp =
            sb.toString().replaceFirst(RegExp(expression), replacement);
        sb.clear();
        sb.write(temp);
      }
      // process non-snippeted text at the end of the loop
      int index = 0;
      int indexEnd = 0;
      bool skippingMode = false;
      String newText = "";
      for (final c in sb.toString().characters) {
        if (c != "^") {
          if (skippingMode) {
            index = indexEnd;
            skippingMode = false;
          }
          newText = "$newText$c";
          indexEnd++;
        } else {
          if (!skippingMode) {
            //add to ouput[]
            output[index] = PdfTextSpan(text: newText);
            skippingMode = true;
            indexEnd++;
          } else {
            indexEnd++;
            continue;
          }
        }
      }
    }

    if (numMatches == 0) {
      output[0] = PdfTextSpan(text: text, size: baseHeight);
    }

    return output;
  }

  static String _getTrueText({required String input, required String regExp}) {
    switch (regExp) {
      case r"(?<!\S)(\*{1})[A-Za-z0-9 ]+\1(?!\S)":
      case r"(?<!\S)(\_{1})[A-Za-z0-9 ]+\1(?!\S)":
        return input.substring(1, input.length - 1);
      case r"(?<!\S)(\*{2})[A-Za-z0-9 ]+\1(?!\S)":
        return input.substring(2, input.length - 2);
      case r"(?<!\S)(\*{3})[A-Za-z0-9 ]+\1(?!\S)":
        return input.substring(3, input.length - 3);
      case r"\B\~{2}[A-Za-z0-9 ]+\~{2}\B":
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
