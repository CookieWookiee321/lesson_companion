import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

enum TextType { question, base, sub, example, info }

class CompanionMethods {
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
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }

  static String getDateString(DateTime dateTime) {
    String dayStr;

    switch (dateTime.month) {
      case 1:
        dayStr = "January";
        break;
      case 2:
        dayStr = "February";
        break;
      case 3:
        dayStr = "March";
        break;
      case 4:
        dayStr = "April";
        break;
      case 5:
        dayStr = "May";
        break;
      case 6:
        dayStr = "June";
        break;
      case 7:
        dayStr = "July";
        break;
      case 8:
        dayStr = "August";
        break;
      case 9:
        dayStr = "September";
        break;
      case 10:
        dayStr = "October";
        break;
      case 11:
        dayStr = "November";
        break;
      default:
        dayStr = "December";
        break;
    }

    return "${dateTime.day} $dayStr ${dateTime.year}";
  }

  static String convertListToString(List<String> input) {
    var output = StringBuffer();

    int counter = 0;
    for (var t in input) {
      output.write(t);
      if (counter != (input.length - 1)) {
        output.write("//");
      }
    }

    return output.toString();
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
            final sub = TextPart(counter, "[${sb.toString()}]", currentType);
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
}

class TextPart {
  final int index;
  final String text;
  final TextType textType;

  TextPart(this.index, this.text, this.textType);
}
