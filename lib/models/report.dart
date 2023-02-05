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

    final map = toMap(text!);

    // transform string vars into the right from to be printed
    final name = map["Name"]!.first.contains("[")
        ? map["Name"]!.first.substring(0, map["Name"]!.first.indexOf("[") - 1)
        : map["Name"]!.first;
    final date = CompanionMethods.getDateString(
        DateTime.parse(map["Date"]!.first.replaceAll("/", "-")));
    final topics = CompanionMethods.convertListToString(map["Topic"]!);
    final homework = map["Homework"] != null
        ? CompanionMethods.convertListToString(map["Homework"]!)
        : null;

    //header
    final _name = PdfText();
    await _name.process(name, PdfSection.h1);
    final _date = PdfText();
    await _date.process(date, PdfSection.h1);
    final _topic = PdfText();
    await _topic.process(topics!, PdfSection.h2);
    PdfText _homework = PdfText();
    if (map["Homework"] != null && map["Homework"]!.first != "") {
      await _homework.process(homework!, PdfSection.h2);
    }

    //body
    final _tables = <PdfTableModel>[];
    for (final t in map.entries.where((element) =>
        element.key != "Name" &&
        element.key != "Date" &&
        element.key != "Topic" &&
        element.key != "Homework")) {
      final thisTable = PdfTableModel();

      final heading = PdfText();
      await heading.process(t.key, PdfSection.h3);
      thisTable.heading = heading;

      final temp = <PdfTableRowModel>[];
      for (final row in t.value) {
        final r = PdfTableRowModel();

        if (row.contains("||")) {
          final cellLhs = PdfText();
          final cellRhs = PdfText();
          final text = row.split("||");

          await cellLhs.process(text[0].trim(), PdfSection.body);
          await cellRhs.process(text[1].trim(), PdfSection.body);

          r.lhs = cellLhs;
          r.rhs = cellRhs;
        } else {
          final cell = PdfText();
          await cell.process(row, PdfSection.body);
          r.lhs = cell;
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
    final output = StringBuffer();
    bool skippingMode = false;

    print("Input contains \"\\n\": ${input.contains("\n")}");

    for (int i = 0; i < input.length; i++) {
      print(input[i]);

      if (skippingMode) {
        if (input[i] == " " ||
            input[i] ==
                """
""") {
          continue;
        } else {
          skippingMode = false;
        }
      }

      if (input[i] == "|" && input[i - 1] == "|") {
        skippingMode = true;
      }

      if (input[i] == "/" && input[i - 1] == "/") {
        skippingMode = true;
      }

      output.write(input[i]);
    }

    // String temp = output.toString().replaceAll("//", "//\n");
    // temp = temp.replaceAll("||", "||\n");
    return output.toString().trim();
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

  Map<String, List<String>> toMap(String text) {
    final headingPrefix = "@";
    final linePrefix = "\n-";
    final output = <String, List<String>>{};

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
      for (final line in tLines) {
        tLines[counter] = _removeSpaces(line).trimLeft();
        counter++;
      }

      output[tHeading] = tLines;
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

class InputException implements Exception {
  String cause;
  InputException(this.cause);
}
