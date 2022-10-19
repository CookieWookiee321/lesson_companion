import 'dart:io';

import 'package:isar/isar.dart';
import 'package:lesson_companion/controllers/companion_methods.dart';
import 'package:lesson_companion/controllers/styler.dart';
import 'package:lesson_companion/models/data_storage.dart';
import 'package:lesson_companion/models/pdf_document/pdf_substring.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table_row.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

part 'pdf_document.g.dart';

enum PdfTextType { question, base, sub, example, info }

@collection
class PdfDoc {
  final Id id = Isar.autoIncrement;
  final PdfText name;
  final PdfText date;
  final PdfText topic;
  final PdfText? homework;
  final PdfTable table1;
  final PdfTable? table2;
  final PdfTable? table3;

  PdfDoc(this.name, this.date, this.topic, this.homework, this.table1,
      this.table2, this.table3);

  /// Creates and saves a report PDF based on the parent object.
  void create() async {
    final footer = PdfText();
    footer.input(DataStorage.getSetting("footer").toString());

    // model the sections of the PDF to get styled objects
    final _name = await _newText(name, PdfSection.h1);
    final _date = await _newText(date, PdfSection.h1);
    final _topicHeader = Text("Topic:",
        style:
            await StylerMethods.getTextStyle(PdfSection.h2, PdfTextType.base));
    final _topic = await _newText(topic, PdfSection.h2);
    final _homeworkHeader = Text("Homework:",
        style:
            await StylerMethods.getTextStyle(PdfSection.h2, PdfTextType.base));
    final _homework =
        homework == null ? await _newText(homework!, PdfSection.h2) : null;
    final _table1 = await newTable(table: table1);
    final _table2 = table2 != null ? await newTable(table: table2!) : null;
    final _table3 = table3 != null ? await newTable(table: table3!) : null;
    final _footer = await _newText(footer, PdfSection.footer);

    //initial set up
    var saveDest =
        "${await CompanionMethods.getLocalPath()}\\${name.toString()} | ID ${DataStorage.getStudentId(name.toString())} | ${CompanionMethods.getShortDate(DateTime.parse(date.toString()))}.pdf";

    final pdf = Document();
    pdf.addPage(Page(build: ((context) {
      return Column(children: [
        // H1
        Row(children: [
          Expanded(child: _name),
          Expanded(
              child: Container(alignment: Alignment.centerRight, child: _date))
        ]),
        // H2
        Row(children: [
          _topicHeader,
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0)),
          Expanded(child: _topic)
        ]),
        if (homework != null)
          Row(children: [_homeworkHeader, Expanded(child: _homework!)]),
        Padding(padding: const EdgeInsets.symmetric(vertical: 4.0)),
        // BODY
        _table1,
        if (table2 != null) _table2!,
        if (table3 != null) _table3!,
        // FOOTER
        _footer
      ]);
    })));
    try {
      final file = File(saveDest);
      final x = await pdf.save();
      await file.writeAsBytes(x);
      print("${DateTime.now()} - PDF saved to $saveDest");
    } on FileSystemException {
      print("Report is currently being used by another process.");
    }
  }

  //============================================================================
  //COMPONENTS------------------------------------------------------------------
  //============================================================================
  ///Takes a heading and a map of LHS and RHS values to build a table with
  Future<Table> newTable({required PdfTable table}) async {
    final _heading = await _newText(table.heading, PdfSection.h3);
    final _rows = await styleTableRows(table);

    return Table(children: [
      TableRow(
          children: [Expanded(child: _heading)],
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: PdfColors.black,
                      width:
                          2.0)))), //TableBorder.symmetric(inside: const BorderSide(color: PdfColors.blueGrey700), outside: const BorderSide()
      ..._rows.map((row) {
        return TableRow(
            verticalAlignment: TableCellVerticalAlignment.middle,
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: PdfColors.blueGrey))),
            children: [
              // LHS
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200, minWidth: 100),
                child: row[0],
              ),

              // Separator
              if (row.length == 2)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),

              // RHS
              if (row.length == 2) Expanded(child: row[1])
            ]);
      }),
      TableRow(children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 4.0))
      ])
    ]);
  }

  Future<List<List<RichText>>> styleTableRows(PdfTable table) async {
    final List<List<RichText>> output = [];

    for (final row in table.rows) {
      List<RichText> thisRow = [];
      thisRow.add(await _newText(row.lhs, PdfSection.body));
      if (row.rhs != null) {
        thisRow.add(await _newText(row.rhs!, PdfSection.body));
      }

      output.add(thisRow);
    }

    return output;
  }

  Future<RichText> _newText(PdfText pdfText, PdfSection pdfSection) async {
    List<TextSpan> outputComponents = [];

    for (final substring in pdfText.components) {
      outputComponents.add(TextSpan(
          text: substring.setText,
          style: await StylerMethods.getTextStyle(
              pdfSection, substring.setTextType)));
    }

    return RichText(text: TextSpan(children: outputComponents), softWrap: true);
  }
}
