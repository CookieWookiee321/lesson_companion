import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:lesson_companion/controllers/styler.dart';
import 'package:lesson_companion/models/data_storage.dart';
import 'package:lesson_companion/models/pdf_document/pdf_substring.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table_row.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

part 'pdf_document.g.dart';

@collection
class PdfDoc {
  final Id id = Isar.autoIncrement;
  final PdfText name;
  final PdfText date;
  final PdfText topic;
  final PdfText? homework;
  final List<PdfTableModel>? tables;

  PdfDoc(this.name, this.date, this.topic, this.homework, this.tables);

  /// Creates and saves a report PDF based on the parent object.
  Future<Uint8List> create() async {
    final footer = PdfText();
    //TODO:footer.input(await DataStorage.getSetting(SharedPrefOption.footer));

    // model the sections of the PDF to get styled objects
    final _name = await _newText(name, PdfSection.h1);
    final _date = await _newText(date, PdfSection.h1);
    final _topicHeader = Text("Topic:",
        style: TextStyle(
            color: PdfColors.blueGrey700,
            fontSize: 13.0,
            font: Font.ttf(await rootBundle
                .load("lib/assets/IBMPlexSansKR-SemiBold.ttf"))));
    final _topic = await _newText(topic, PdfSection.h2);
    final _homeworkHeader = Text("Homework:",
        style: TextStyle(
            color: PdfColors.blueGrey700,
            fontSize: 13.0,
            font: Font.ttf(await rootBundle
                .load("lib/assets/IBMPlexSansKR-SemiBold.ttf"))));
    final _homework =
        homework != null ? await _newText(homework!, PdfSection.h2) : null;

    final List<Table> _tables = [];
    if (tables != null && tables!.length > 0) {
      for (int i = 0; i < tables!.length; i++) {
        await newTable(table: tables![i]).then((value) => _tables.add(value));
      }
    }
    final _footer = await _newText(footer, PdfSection.footer);

    //initial set up

    final pdf = Document();
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: ((context) {
          return [
            // H1-------------------------------------------------------------------
            Row(children: [
              Expanded(child: _name),
              Expanded(
                  child:
                      Container(alignment: Alignment.centerRight, child: _date))
            ]),
            // H2-------------------------------------------------------------------
            Row(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: _topicHeader),
              Expanded(child: _topic)
            ]),
            if (homework!.components.isNotEmpty)
              Row(children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: _homeworkHeader),
                Expanded(child: _homework!)
              ]),
            Padding(padding: const EdgeInsets.symmetric(vertical: 4.0)),
            // BODY-----------------------------------------------------------------
            ..._tables.map((e) {
              return e;
            }),
            // FOOTER---------------------------------------------------------------
            _footer
          ];
        })));

    return await pdf.save();
  }

  //============================================================================
  //COMPONENTS------------------------------------------------------------------
  //============================================================================
  ///Takes a heading and a map of LHS and RHS values to build a table with
  Future<Table> newTable({required PdfTableModel table}) async {
    final _heading = await _newText(table.heading!, PdfSection.h3);
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

  Future<List<List<RichText>>> styleTableRows(PdfTableModel table) async {
    final List<List<RichText>> output = [];

    for (final row in table.rows!) {
      final lhs = await _newText(row.lhs!, PdfSection.body);
      if (row.rhs != null) {
        final rhs = await _newText(row.rhs!, PdfSection.body);
        output.add([lhs, rhs]);
      } else {
        output.add([lhs]);
      }
    }

    return output;
  }

  Future<RichText> _newText(PdfText pdfText, PdfSection pdfSection) async {
    List<TextSpan> outputComponents = [];
//TODO
    // for (final substring in pdfText.components) {
    //   outputComponents.add(TextSpan(
    //       text: substring.setText,
    //       style: await StylerMethods.getTextStyle(
    //           pdfSection, substring.setTextType)));
    // }

    return RichText(text: TextSpan(children: outputComponents), softWrap: true);
  }
}
