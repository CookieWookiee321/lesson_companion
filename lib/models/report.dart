import 'package:isar/isar.dart';
import 'package:lesson_companion/controllers/companion_methods.dart';
import 'package:lesson_companion/controllers/styler.dart';
import 'package:lesson_companion/models/pdf_document/pdf_doc.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table_row.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';

part 'report.g.dart';

@collection
class Report {
  Report(this.text);

  Id id = Isar.autoIncrement;
  String? text;

  final objectSplitter = "===";
  final headingPrefix = '*';
  final tableSubheading = '#';
  final linePrefix = "-";

  /// Creates and saves a report PDF based on the parent object.
  Future<PdfDoc> toPdfDoc() async {
    assert(text != null,
        "The Report object's 'text' field has not been initialized");

    final dataObj = toDataObj(text!);

    // transform string vars into the right from to be printed
    final topics = CompanionMethods.convertListToString(dataObj.topic);
    final homework = dataObj.homework != null
        ? CompanionMethods.convertListToString(dataObj.homework)
        : null;

    //header
    final _name = PdfText();
    await _name.process(dataObj.name, PdfSection.h1);
    final _date = PdfText();
    await _date.process(
        CompanionMethods.getDateString(dataObj.date), PdfSection.h1);
    final _topic = PdfText();
    await _topic.process(topics!, PdfSection.h2);
    PdfText _homework = PdfText();
    if (homework != null && homework != "") {
      await _homework.process(homework, PdfSection.h2);
    }

    //body
    final _tables = <PdfTableModel>[];
    for (final t in dataObj.tables) {
      final thisTable = PdfTableModel();

      final heading = PdfText();
      await heading.process(t.heading, PdfSection.h3);
      thisTable.heading = heading;

      final temp = <PdfTableRowModel>[];
      for (final row in t.rows) {
        final r = PdfTableRowModel();
        final cellLhs = PdfText();
        await cellLhs.process(row.lhs, PdfSection.body);
        r.lhs = cellLhs;

        if (row.rhs != null) {
          final cellRhs = PdfText();
          await cellRhs.process(row.rhs!, PdfSection.body);
          r.rhs = cellRhs;
        }

        temp.add(r);
      }
      thisTable.rows = temp;
      _tables.add(thisTable);
    }

    final pdf = PdfDoc(
      _name,
      _date,
      _topic,
      _homework,
      _tables,
    );
    return pdf;
  }

  //============================================================================
  //METHODS---------------------------------------------------------------------
  //============================================================================

  String _removeSpaces(String input) {
    var marker = "//";
    var regExp = RegExp(r'\s*(\/\/)\s*');
    input = input.replaceAll(regExp, marker);
    marker = "||";
    regExp = RegExp(r'\s*(\|\|)\s*');
    input = input.replaceAll(regExp, marker);
    return input;
  }

  Future<List<PdfTableRowModel>> convertToTableRows(
      List<String> entries) async {
    List<PdfTableRowModel> output = [];

    for (final row in entries) {
      final thisRow = PdfTableRowModel();
      final lhs = PdfText();
      final rhs = PdfText();

      if (row.contains("||")) {
        final split = row.split("||");

        await lhs.process(split[0].trim(), PdfSection.body);
        await rhs.process(split[1].trim(), PdfSection.body);

        thisRow.lhs = lhs;
        thisRow.rhs = rhs;

        output.add(thisRow);
      } else {
        await lhs.process(row.trim(), PdfSection.body);
        thisRow.lhs = lhs;
        output.add(thisRow);
      }
    }

    return output;
  }

  ReportData toDataObj(String text) {
    final headingPrefix = "@";
    final linePrefix = "\n-";

    final tables = <ReportTableData>[];
    final output = ReportData.late(null, tables);

    int iStart;
    int iEnd;
    String tChunk;
    List<String> tLines;
    String tHeading;

    while (text.contains(headingPrefix)) {
      tLines = [];
      iStart = text.indexOf(headingPrefix);
      iEnd = text.indexOf(headingPrefix, iStart + 1);
      if (iEnd == -1) {
        iEnd = text.length;
      }
      tChunk = text.substring(iStart, iEnd).trim();
      tHeading = tChunk
          .substring(0, tChunk.indexOf("\n"))
          .replaceFirst(headingPrefix, "")
          .trim();

      final tempList = tChunk.split(linePrefix);
      tempList.removeAt(0);
      tLines.addAll(tempList);

      int counter = 0;
      for (var line in tLines) {
        line = _removeSpaces(line).trimLeft();
        if (line.endsWith(" ??")) {
          // remove skip markers from text
          line = line.substring(0, tLines[counter].length - 3);
        }
        tLines[counter] = line;
        counter++;
      }

      switch (tHeading.toUpperCase()) {
        case "NAME":
          output.name = tLines.first;
          break;
        case "DATE":
          //format the DATE string
          if (tLines.first.toString().contains('/')) {
            tLines.first = tLines.first.replaceAll('/', '-');
          }
          if (tLines.first.toString().split('-')[2].length == 1) {
            final tempList = tLines.first.toString().split('-');
            final tempDay = "0${tempList[2]}";
            tLines.first = "${tempList[0]}-${tempList[1]}-$tempDay";
          }
          output.date = DateTime.parse(tLines.first);
          break;
        case "TOPIC":
          output.topic = tLines;
          break;
        case "HOMEWORK":
          output.homework = tLines;
          break;
        default:
          final List<ReportTableRowData> rows = [];

          tLines.forEach((line) {
            if (line.contains("||")) {
              final arr = line.split("||");
              rows.add(ReportTableRowData(arr[0].trim(), arr[1].trim()));
            } else {
              rows.add(ReportTableRowData(line, null));
            }
          });

          output.tables.add(ReportTableData(tHeading, rows));
          break;
      }

      //remove the processed text from the input string
      text = text.substring(iEnd, text.length);
    }

    return output;
  }

  //DATABASE
  static Future<Report?> getReport(int id) async {
    final isar = Isar.getInstance("report_db") ??
        await Isar.open([ReportSchema], name: "report_db");

    final report = isar.reports.filter().idEqualTo(id).findFirst();

    return report;
  }

  static Future<List<Report>> getAllReports() async {
    final isar = Isar.getInstance("report_db") ??
        await Isar.open([ReportSchema], name: "report_db");

    final results = await isar.reports.where().findAll();

    return results.toList();
  }

  static Report? getReportSync(int id) {
    final isar = Isar.getInstance("report_db") ??
        Isar.openSync([ReportSchema], name: "report_db");

    final report = isar.reports.filter().idEqualTo(id).findFirstSync();

    return report;
  }

  static Future<void> saveReport(Report report) async {
    final isar = Isar.getInstance("report_db") ??
        await Isar.open([ReportSchema], name: "report_db");

    await isar.writeTxn(() async {
      await isar.reports.put(report);
    });
  }

  static void saveReportSync(Report report) {
    final isar = Isar.getInstance("report_db") ??
        Isar.openSync([ReportSchema], name: "report_db");

    isar.writeTxnSync(() => isar.reports.putSync(report));
  }

  static Future<void> deleteReport(int id) async {
    final isar = Isar.getInstance("report_db") ??
        await Isar.open([ReportSchema], name: "report_db");

    await isar.writeTxn(() async {
      isar.reports.delete(id);
    });
  }
}

class ReportData {
  late String name;
  late DateTime date;
  late List<String> topic;
  List<String>? homework;
  List<ReportTableData> tables;

  ReportData.late(this.homework, this.tables);
  ReportData(this.name, this.date, this.topic, this.homework, this.tables);
}

class ReportTableData {
  String heading;
  List<ReportTableRowData> rows;

  ReportTableData(this.heading, this.rows);
}

class ReportTableRowData {
  final String lhs;
  final String? rhs;

  ReportTableRowData(this.lhs, this.rhs);
}

class InputException implements Exception {
  String cause;
  InputException(this.cause);
}
