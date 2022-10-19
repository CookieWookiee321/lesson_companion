import 'package:flutter/cupertino.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/report.dart';
import 'package:lesson_companion/models/student.dart';

import 'companion_methods.dart';

class HomeController extends ChangeNotifier {
  static final Map _monthsMap = {
    "January": 1,
    "February": 2,
    "March": 3,
    "April": 4,
    "May": 5,
    "June": 6,
    "July": 7,
    "August": 8,
    "September": 9,
    "October": 10,
    "November": 11,
    "December": 12
  };

  static bool submitLesson(Student student, Lesson lesson, Report? report) {
    //TODO: validate

    int affectedRows = 0;

    //check if Report is needed
    if (report != null) {
      //TODO: generate and print the report
      //TODO: insert Lesson and Report as a transaction
    } else {
      //Otherwise, just insert the lesson
      //TODO: affectedRows = HiveMethods.insertLesson(lesson) as int;
    }

    //return true if the transaction is successful, and false if not
    return affectedRows > 0 ? true : false;
  }

  static DateTime? convertStringToDateTime(
      String day, String month, String year) {
    if (!CompanionMethods.tryParseToInt(day) ||
        !CompanionMethods.tryParseToInt(year)) return null;
    if (!_monthsMap.keys.contains(month)) return null;

    int yearNum = int.parse(year);

    if (yearNum > DateTime.now().year || yearNum < 2000) return null;

    int dayNum = int.parse(day);
    int monthNum = _monthsMap[month];

    return DateTime.parse("$yearNum-$monthNum-$dayNum");
  }
}
