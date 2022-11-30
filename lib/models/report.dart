import 'package:isar/isar.dart';
import 'package:lesson_companion/controllers/companion_methods.dart';
import 'package:lesson_companion/controllers/home_controller.dart';
import 'package:lesson_companion/controllers/styler.dart';
import 'package:lesson_companion/models/database.dart';
import 'package:lesson_companion/models/pdf_document/pdf_doc.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table_row.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';

part 'report.g.dart';

@collection
class Report {
  Id id = Isar.autoIncrement;
  final String text;

  final objectSplitter = "===";
  final headingPrefix = '*';
  final tableSubheading = '#';
  final linePrefix = "-";

  Report(this.text);

  //TODO: syntax highlighting
  //TODO: import old database data

  /// Creates and saves a report PDF based on the parent object.
  Future<PdfDoc> toPdfDoc() async {
    final map = toMap(text);

    // transform string vars into the right from to be printed
    final name = map["Name"]!.first.contains("[")
        ? map["Name"]!.first.substring(0, map["Name"]!.first.indexOf("[") - 1)
        : map["Name"]!.first;
    final date =
        CompanionMethods.getDateString(DateTime.parse(map["Date"]!.first));
    final topics = CompanionMethods.convertListToString(map["Topic"]!);
    final homework = map["Homework"] != null
        ? CompanionMethods.convertListToString(map["Homework"]!)
        : null;

    //header
    final _name = PdfText();
    _name.process(name, PdfSection.h1);
    final _date = PdfText();
    _date.process(date, PdfSection.h1);
    final _topic = PdfText();
    _topic.process(topics, PdfSection.h2);
    PdfText _homework = PdfText();
    if (map["Homework"] != null && map["Homework"]!.first != "") {
      _homework.process(homework!, PdfSection.h2);
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
      heading.process(t.key, PdfSection.h3);
      thisTable.heading = heading;

      final temp = <PdfTableRowModel>[];
      for (final row in t.value) {
        final r = PdfTableRowModel();

        if (row.contains("||")) {
          final cellLhs = PdfText();
          final cellRhs = PdfText();
          final text = row.split("||");
          cellLhs.process(text[0].trim(), PdfSection.body);
          cellRhs.process(text[1].trim(), PdfSection.body);
          r.lhs = cellLhs;
          r.rhs = cellRhs;
        } else {
          final cell = PdfText();
          cell.process(row, PdfSection.body);
          r.lhs = cell;
        }

        temp.add(PdfTableRowModel());
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

  List<PdfTableRowModel> cnvtStringToTableRows(List<String> entries) {
    List<PdfTableRowModel> output = [];

    for (final row in entries) {
      final thisRow = PdfTableRowModel();
      final lhs = PdfText();
      final rhs = PdfText();

      if (row.contains("||")) {
        final split = row.split("||");

        lhs.process(split[0].trim(), PdfSection.body);
        rhs.process(split[1].trim(), PdfSection.body);

        thisRow.lhs = lhs;
        thisRow.rhs = rhs;

        output.add(thisRow);
      } else {
        lhs.process(row.trim(), PdfSection.body);
        thisRow.lhs = lhs;
        output.add(thisRow);
      }
    }

    return output;
  }

  Map<String, List<String>> toMap(String text) {
    String currentHeading = "";
    final headingPrefix = "# ";
    final linePrefix = "- ";
    final commentPrefix = "!@";
    final mappings = <String, List<String>>{};
    var currentEntryList = <String>[];

    //loop through each line in text
    for (var line in text.split("\n")) {
      //don't read blank lines
      if (line.trim().isEmpty || line.trim().length == 0) continue;
      if (line.trim().substring(0, 2) == commentPrefix) continue;
      if (line.trim() == "=<" || line.trim() == ">=") continue;

      //check if the line contains a heading or not
      if (line.substring(0, 2) != headingPrefix) {
        if (line.substring(0, 2) == linePrefix) {
          final temp = line.substring(1).trim();
          //add the line to the housing List obj
          currentEntryList.add(temp);
        }
      } else {
        //add the list of entries for the heading which was just processed
        if (currentEntryList.isNotEmpty) {
          mappings[currentHeading] = currentEntryList;
          currentEntryList = [];
        }

        //if a new heading is detected
        final currentHeadingUnchecked = line.substring(1).trim();
        //determine if the heading is pre-defined + update the currentHeading var
        switch (currentHeadingUnchecked.toUpperCase()) {
          case "NAME":
            currentHeading = "Name";
            break;
          case "DATE":
            currentHeading = "Date";
            break;
          case "TOPIC":
            currentHeading = "Topic";
            break;
          case "HOMEWORK":
            currentHeading = "Homework";
            break;
          default:
            currentHeading = currentHeadingUnchecked;
            break;
        }
      }
    }
    if (currentEntryList.isNotEmpty) {
      mappings[currentHeading] = currentEntryList;
    }

    return mappings;
  }
}

class InputException implements Exception {
  String cause;
  InputException(this.cause);
}
