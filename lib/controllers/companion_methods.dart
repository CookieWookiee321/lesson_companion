import 'dart:io';

import 'package:path_provider/path_provider.dart';

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
}
