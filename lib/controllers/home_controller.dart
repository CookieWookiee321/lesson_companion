import 'package:flutter/cupertino.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table_row.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';
import 'package:lesson_companion/models/report.dart';
import 'package:lesson_companion/views/home_view.dart';

import 'package:intl/intl.dart';

import 'companion_methods.dart';

class HomeController extends ChangeNotifier {
  static final Map _monthsMap = {
    "Jan": 1,
    "Feb": 2,
    "Mar": 3,
    "Apr": 4,
    "May": 5,
    "Jun": 6,
    "Jul": 7,
    "Aug": 8,
    "Sep": 9,
    "Oct": 10,
    "Nov": 11,
    "Dec": 12
  };

  static DateTime? convertStringToDateTime(
      String day, String month, String year) {
    if (!CompanionMethods.tryParseToInt(day) ||
        !CompanionMethods.tryParseToInt(year)) return null;
    if (!_monthsMap.keys.contains(month)) return null;

    int yearNum = int.parse(year);

    if (yearNum > DateTime.now().year || yearNum < 2000) return null;

    int dayNum = int.parse(day);
    int monthNum = _monthsMap[month];

    return DateFormat("yyyy-MM-dd").parse("$yearNum-$monthNum-$dayNum");
  }

  static bool isTablePopulated(ReportTable table) {
    for (final row in table.children) {
      if (row.model.lhs != null) return true;
    }

    return false;
  }

  static int areTablesPopulated(List<ReportTable> tables) {
    int counter = 0;

    for (final table in tables) {
      for (final row in table.children) {
        if (row.model.lhs != null) {
          counter++;
          continue;
        }
      }
    }
    return counter;
  }

  static List<PdfTableRowModel> modelTableData(ReportTable table) {
    final List<PdfTableRowModel> output = [];

    for (final row in table.children) {
      final thisRow = PdfTableRowModel();

      if (row.model.lhs != null) {
        final thisLhs = PdfText();
        thisLhs.input(row.model.lhs!);
        thisRow.lhs = thisLhs;

        if (row.model.rhs != null) {
          final thisRhs = PdfText();
          thisRhs.input(row.model.rhs!);
          thisRow.rhs = thisRhs;
        }

        output.add(thisRow);
      } else {
        continue;
      }
    }

    return output;
  }
}
