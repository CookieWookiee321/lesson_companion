import 'package:isar/isar.dart';
import 'package:lesson_companion/controllers/companion_methods.dart';
import 'package:lesson_companion/models/data_storage.dart';
import 'package:lesson_companion/models/pdf_document/pdf_document.dart';
import 'package:lesson_companion/models/pdf_document/pdf_substring.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table_row.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';

part 'report.g.dart';

@collection
class Report {
  Id id = Isar.autoIncrement;
  int? studentId;
  String? studentName;
  int? lessonId;
  DateTime? date;
  List<String>? topic;
  List<String>? homework;
  List<PdfTableModel>? tables;

  final objectSplitter = "===";
  final headingPrefix = '*';
  final tableSubheading = '#';
  final linePrefix = "-";

  Report();

  Future<void> fromMap(Map<String, List<String>> mappings) async {
    studentId = await DataStorage.getStudentId(mappings["Name"]!.first);
    studentName = mappings["Name"]!.first;
    date = DateTime.parse(mappings["Date"]!.first);
    topic = mappings["Topic"];
    homework = mappings["Homework"];
    tables = [];

    // Skip over pre-defined heading keywords.
    if (mappings.length > 3) {
      for (var key in mappings.keys) {
        if (key == "Name" ||
            key == "Date" ||
            key == "Topic" ||
            key == "Homework") {
          continue;
        }

        // Process the user-defined headings
        final name = PdfText();
        name.process(key);

        final items = cnvtStringToTableRows(mappings[key]!);

        final thisTable = PdfTableModel();
        thisTable.heading = name;
        thisTable.rows = items;

        tables!.add(thisTable);
      }
    }
  }

  //TODO: syntax highlighting
  //TODO: import old database data

  /// Creates and saves a report PDF based on the parent object.
  Future<PdfDoc> createPdf() async {
    // transform string vars into the right from to be printed
    final tempName = await DataStorage.getStudentName(studentId!);
    final strName = tempName!.contains("(")
        ? tempName.substring(0, tempName.indexOf("(") - 1)
        : tempName;
    final strDate = CompanionMethods.getDateString(date!);
    final strTopics = CompanionMethods.convertListToString(topic!);
    final strHomework = homework != null
        ? CompanionMethods.convertListToString(homework!)
        : null;

    //header
    final _name = PdfText();
    _name.process(strName);
    final _date = PdfText();
    _date.process(strDate);
    final _topic = PdfText();
    _topic.process(strTopics);
    PdfText _homework = PdfText();
    if (homework != null && homework!.first != "") {
      _homework.process(strHomework!);
    }

    final pdf = PdfDoc(
      _name,
      _date,
      _topic,
      _homework,
      tables,
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

        lhs.process(split[0].trim());
        rhs.process(split[1].trim());

        thisRow.lhs = lhs;
        thisRow.rhs = rhs;

        output.add(thisRow);
      } else {
        lhs.process(row.trim());
        thisRow.lhs = lhs;
        output.add(thisRow);
      }
    }

    return output;
  }

  Map<String, List<String>> mapTextInput(String text) {
    String currentHeading = "";
    Map<String, List<String>> mappings = {};
    List<String> currentEntryList = [];

    //loop through each line in text
    for (var line in text.split("\n")) {
      //don't read blank lines
      if (line.trim().isEmpty || line.trim() == "-") continue;
      if (line.trim() == objectSplitter) continue;

      //check if the line contains a heading or not
      if (line[0] != headingPrefix) {
        if (line[0] == linePrefix) {
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
