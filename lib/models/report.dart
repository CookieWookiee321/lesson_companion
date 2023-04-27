import 'package:isar/isar.dart';
import 'package:lesson_companion/controllers/co_methods.dart';
import 'package:lesson_companion/controllers/styler.dart';
import 'package:lesson_companion/models/pdf_document/pdf_doc.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table_row.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';

part 'report.g.dart';

@collection
class Report {
  Report(
      {required this.studentId,
      required this.lessonId,
      required this.date,
      required this.topic,
      this.homework,
      required this.body}) {}

  Id id = Isar.autoIncrement;
  int studentId;
  int lessonId;
  DateTime date;
  String topic;
  String? homework;
  String body;

  /// Creates and saves a report PDF based on the parent object.
  Future<PdfDoc> toPdfDoc() async {
    final dataObj = this.toDataObj();

    // transform string vars into the right from to be printed
    final topics = CoMethods.convertListToString(dataObj.topic);
    final homework = dataObj.homework != null
        ? CoMethods.convertListToString(dataObj.homework)
        : null;

    //header
    final _name = PdfText();
    await _name.process(dataObj.name, PdfSection.h1);
    final _date = PdfText();
    await _date.process(CoMethods.getDateString(dataObj.date), PdfSection.h1);
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
      name: _name,
      date: _date,
      topic: _topic,
      homework: _homework,
      tables: _tables,
    );
    return pdf;
  }

  /// Maps [body] of this [Report] object according to the user's entered data.
  /// Headings are stored as keys and all the lines that fall under the heading
  /// are placed into a [List] which is stored as the key to the key. Lines are
  /// stored in the same order in which they are written.
  Map<String, List<String>> mapBody() {
    Map<String, List<String>> mOutput = {};
    String? heading;
    // get all sections and loop through
    final lSections = this.body.split("@");
    for (int i = 0; i < lSections.length; i++) {
      // get all lines + heading for each section
      final lLines = lSections[i].split("\n-");
      for (int j = 0; j < lLines.length; j++) {
        if (j == 0) {
          heading = lLines[j].trim();
          mOutput[heading] = [];
          continue;
        }
        mOutput[heading!]!.add(lLines[j]);
      }
    }
    return mOutput;
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

  /// Converts this [Report] into a [ReportData] object.
  ReportData toDataObj() {
    String text = this.body;
    final headingPrefix = "@";
    final linePrefix = "\n-";

    final tables = <ReportTableData>[];
    final output = ReportData.late(null, tables);

    int iStart; // starting index of text chunk
    int iEnd; // ending index of text chunk
    String tChunk; // full body of text being processed
    List<String> tLines; // container for lines under heading after processing
    String tHeading; // heading of the current chunk

    // processed text gets deleted from [text] String.
    // loops until all headings have been processed
    while (text.contains(headingPrefix)) {
      tLines = [];
      iStart = text.indexOf(headingPrefix);
      iEnd = text.indexOf(headingPrefix, iStart + 1);
      if (iEnd == -1) {
        iEnd = text.length;
      }
      tChunk = text.substring(iStart, iEnd).trim();

      if (!tChunk.contains("\n")) {
        text = text.substring(0, text.indexOf(tChunk)) +
            text.substring(text.indexOf(tChunk) + tChunk.length, text.length);
        continue;
      }

      tHeading = tChunk
          .substring(0, tChunk.indexOf("\n"))
          .replaceFirst(headingPrefix, "")
          .trim();

      final tempList = tChunk.split(linePrefix);
      tempList.removeAt(0);
      tLines.addAll(tempList);

      if (tLines.isEmpty) {
        continue;
      }

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

      // set [text], remove newly processed text data for next loop
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
