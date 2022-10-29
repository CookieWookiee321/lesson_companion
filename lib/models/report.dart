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
  String? tableOneName;
  List<PdfTableRow>? tableOneItems;
  String? tableTwoName;
  List<PdfTableRow>? tableTwoItems;
  String? tableThreeName;
  List<PdfTableRow>? tableThreeItems;

  final objectSplitter = "===";
  final headingPrefix = '*';
  final linePrefix = "-";

  Report();

  Future<void> fromMap(Map<String, List<String>> mappings) async {
    await _initReport(mappings);
  }

  Future<void> _initReport(Map<String, List<String>> mappings) async {
    studentId = await DataStorage.getStudentId(mappings["Name"]!.first);
    studentName = mappings["Name"]!.first;
    date = DateTime.parse(mappings["Date"]!.first);
    topic = mappings["Topic"];
    homework = mappings["Homework"];

    // Skip over pre-defined heading keywords.
    var counter = 1;
    if (mappings.length > 3) {
      for (var key in mappings.keys) {
        if (key == "Name" ||
            key == "Date" ||
            key == "Topic" ||
            key == "Homework") {
          continue;
        }

        // Process only user-defined headings.
        switch (counter) {
          case 1:
            tableOneName = key;
            tableOneItems = cnvtStringToTableRows(mappings[key]!);
            break;
          case 2:
            tableTwoName = key;
            tableTwoItems = cnvtStringToTableRows(mappings[key]!);
            break;
          case 3:
            tableThreeName = key;
            tableThreeItems = cnvtStringToTableRows(mappings[key]!);
            break;
        }

        counter++;
      }
    }
  }

  //TODO: syntax highlighting
  //TODO: import old database data

  /// Creates and saves a report PDF based on the parent object.
  Future<void> create() async {
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
    _name.input(strName);
    final _date = PdfText();
    _date.input(strDate);
    final _topic = PdfText();
    _topic.input(strTopics);
    PdfText _homework = PdfText();
    if (homework != null) {
      _homework.input(strHomework!);
    }
    //tables
    final _tableName1 = PdfText();
    _tableName1.input(tableOneName!);
    final _table1 = PdfTable();
    _table1.heading = _tableName1;
    _table1.rows = tableOneItems!;

    PdfText _tableName2 = PdfText();
    PdfTable _table2 = PdfTable();
    if (tableTwoName != null) {
      _tableName2.input(tableTwoName!);

      _table2.heading = _tableName2;
      _table2.rows = tableTwoItems!;
    }

    PdfText _tableName3 = PdfText();
    PdfTable _table3 = PdfTable();
    if (tableThreeName != null) {
      _tableName3.input(tableThreeName!);

      _table3.heading = _tableName3;
      _table3.rows = tableThreeItems!;
    }

    final pdf = PdfDoc(
      _name,
      _date,
      _topic,
      _homework,
      _table1,
      _table2,
      _table3,
    );
    pdf.create();
  }

  //============================================================================
  //METHODS---------------------------------------------------------------------
  //============================================================================

  List<PdfTableRow> cnvtStringToTableRows(List<String> entries) {
    List<PdfTableRow> output = [];

    for (final row in entries) {
      final thisRow = PdfTableRow();
      final lhs = PdfText();
      final rhs = PdfText();

      if (row.contains("||")) {
        final split = row.split("||");

        lhs.input(split[0].trim());
        rhs.input(split[1].trim());

        thisRow.lhs = lhs;
        thisRow.rhs = rhs;

        output.add(thisRow);
      } else {
        lhs.input(row.trim());
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

  Map<String, dynamic> fromObjToMap() {
    return {
      "reportId": id,
      "studentId": studentId,
      "lessonId": lessonId,
      "date": date,
      "topic": topic,
      "homework": homework,
      "tableOneName": tableOneName,
      "tableOneItems": tableOneItems,
      "tableTwoName": tableTwoName,
      "tableTwoItems": tableTwoItems,
      "tableThreeName": tableThreeName,
      "tableThreeItems": tableThreeItems
    };
  }
}

class InputException implements Exception {
  String cause;
  InputException(this.cause);
}
