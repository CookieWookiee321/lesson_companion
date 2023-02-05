import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

enum TextType { question, base, sub, example, info }

class CompanionMethods {
  static String insertStyleSyntax(
      String marker, TextEditingController controller) {
    final fullText = controller.text;

    final before;
    final middle;
    final after;
    final onBlank;

    final base = controller.selection.baseOffset;
    final extent = controller.selection.extentOffset;
    final indexStart;
    final indexEnd;

    if (base > extent) {
      indexStart = extent;
      indexEnd = base;
    } else if (extent > base) {
      indexStart = base;
      indexEnd = extent;
    } else {
      int counter = base;

      if (counter == fullText.length) {
        counter--;
      }

      if (((fullText[counter] == " ") | (fullText[counter] == "\n")) &&
          fullText[counter - 1] != " ") {
        counter--;
        onBlank = true;
      } else {
        onBlank = false;
      }

      while (fullText[counter] != " " && counter > 0) {
        counter--;
      }

      if (fullText[counter] == " ") {
        indexStart = counter + 1;
      } else {
        indexStart = counter;
      }

      final stopper;
      if (!onBlank) {
        final nextSpace = fullText.indexOf(" ", base);
        final nextLineBreak = fullText.indexOf("\n", base);
        if (nextSpace == -1 || nextLineBreak == -1) {
          if (nextSpace == -1 && nextLineBreak == -1) {
            stopper = max(nextSpace, nextLineBreak);
          } else {
            stopper = min(nextSpace, nextLineBreak);
          }
        } else {
          stopper = (nextSpace == -1) ? nextLineBreak : nextSpace;
        }
      } else {
        stopper = base;
      }

      if (stopper != -1) {
        indexEnd = stopper;
      } else {
        indexEnd = fullText.length;
      }
    }

    before = "${fullText.substring(0, indexStart)}$marker";
    middle = fullText.substring(indexStart, indexEnd);
    after = "$marker${fullText.substring(indexEnd, fullText.length)}";

    return "$before$middle$after";
  }

  static Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();

    //create LC dir
    final dir = Directory('${directory.path}\\Lesson Companion\\');
    if (!await dir.exists()) {
      Directory(dir.path).create();
    }

    return dir.path;
  }

  static bool tryParseToInt(String input) {
    return int.tryParse(input) == null ? false : true;
  }

  static String getShortDate(DateTime dateTime) {
    String dayStr;
    String monthStr;

    dayStr = dateTime.day.toString();
    if (dateTime.day < 10) dayStr = "0$dayStr";

    monthStr = dateTime.month.toString();
    if (dateTime.month < 10) monthStr = "0$monthStr";

    return "${dateTime.year}-$monthStr-$dayStr";
  }

  static String getDateString(DateTime dateTime) {
    String monthStr;
    String dayStr;

    switch (dateTime.month) {
      case 1:
        monthStr = "Jan";
        break;
      case 2:
        monthStr = "Feb";
        break;
      case 3:
        monthStr = "Mar";
        break;
      case 4:
        monthStr = "Apr";
        break;
      case 5:
        monthStr = "May";
        break;
      case 6:
        monthStr = "Jun";
        break;
      case 7:
        monthStr = "Jul";
        break;
      case 8:
        monthStr = "Aug";
        break;
      case 9:
        monthStr = "Sep";
        break;
      case 10:
        monthStr = "Oct";
        break;
      case 11:
        monthStr = "Nov";
        break;
      default:
        monthStr = "Dec";
        break;
    }

    dayStr = dateTime.day.toString();
    if (dateTime.day < 10) dayStr = "0$dayStr";

    return "$dayStr $monthStr ${dateTime.year}";
  }

  static String? convertListToString(List<String>? input) {
    if (input == null || input.isEmpty) return null;

    var output = StringBuffer();

    for (final tLine in input) {
      output.writeln(tLine);
    }

    return output.toString().trim();
  }

  static List<TextPart> _seperateParts(String input) {
    int counter = 0;
    final List<TextPart> output = [];
    var currentType = TextType.base;
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
              final sub = TextPart(counter, sb.toString(), currentType);
              output.add(sub);
              sb.clear();
            }

            switch (marker) {
              case "q":
                currentType = TextType.question;
                break;
              case "i":
                currentType = TextType.info;
                break;
              case "e":
                currentType = TextType.example;
                break;
            }
          } else {
            if (currentType != TextType.base) {
              if (currentType == TextType.sub) {
                sb.write(input[i]);
              } else {
                if (sb.isNotEmpty) {
                  final sub = TextPart(counter, sb.toString(), currentType);
                  output.add(sub);
                  sb.clear();
                }

                currentType = TextType.base;
              }
            }
          }
        } else if (input[i] == "<") {
          // begin new subtext substring
          if (sb.isNotEmpty) {
            final sub = TextPart(counter, sb.toString(), currentType);
            output.add(sub);
            sb.clear();
          }
          currentType = TextType.sub;
        } else if (input[i] == ">") {
          // close subtext substring
          if (sb.isNotEmpty) {
            final sub = TextPart(counter, "(${sb.toString()})", currentType);
            output.add(sub);
            sb.clear();
          }
          currentType = TextType.base;
        }
      }
    }

    final sub = TextPart(counter, sb.toString(), currentType);
    output.add(sub);
    sb.clear();

    return output;
  }

  static SelectableText styleText(String input, BuildContext context) {
    final parts = _seperateParts(input);

    List<InlineSpan> outputComponents = [];

    for (final part in parts) {
      TextStyle thisStyle;

      switch (part.textType) {
        case TextType.base:
          thisStyle = TextStyle(
              fontSize: 13, color: Theme.of(context).colorScheme.onSurface);
          break;
        case TextType.sub:
          thisStyle = TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold);
          break;
        default:
          throw Exception("Unhandled text type");
      }

      outputComponents.add(TextSpan(text: part.text, style: thisStyle));
    }

    return SelectableText.rich(TextSpan(children: outputComponents));
  }

  static String autoInsertBrackets(String char,
      TextEditingController controller, int currentIndex, int selectionEnd) {
    final sb = StringBuffer();

    final startInd;
    final endInd;

    if (currentIndex > selectionEnd) {
      startInd = selectionEnd;
      endInd = currentIndex;
    } else {
      startInd = currentIndex;
      endInd = selectionEnd;
    }

    final start = controller.text.substring(0, startInd);
    final end = controller.text.substring(endInd, controller.text.length);
    final endChar;
    switch (char) {
      case "{":
        endChar = "}";
        break;
      case "(":
        endChar = ")";
        break;
      case "[":
        endChar = "]";
        break;
      default:
        endChar = char;
    }

    if (selectionEnd - currentIndex == 0) {
      sb.write("$start$char$endChar$end");
    } else {
      final middle = controller.text.substring(startInd, endInd);
      sb.write("$start$char$middle$endChar$end");
    }

    return sb.toString();
  }

  static RegExp _isLetterRegExp = RegExp(r'[a-z]', caseSensitive: false);
  static bool isLetter(String letter) => _isLetterRegExp.hasMatch(letter);
}

class TextPart {
  final int index;
  final String text;
  final TextType textType;

  TextPart(this.index, this.text, this.textType);
}
