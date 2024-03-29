import 'package:flutter/services.dart';
import 'package:lesson_companion/controllers/styler.dart';
import 'package:lesson_companion/models/database.dart';
import 'package:lesson_companion/models/pdf_document/pdf_table.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfDoc {
  PdfText name;
  PdfText date;
  PdfText topic;
  PdfText? homework;
  List<PdfTableModel>? tables;

  PdfDoc(
      {required this.name,
      required this.date,
      required this.topic,
      this.homework,
      this.tables});

  /// Creates and saves a report PDF based on the parent object.
  Future<Uint8List> create() async {
    final footer = PdfText();
    footer.process(
        await Database.getSetting(SharedPrefOption.footer), PdfSection.footer);

    // model the sections of the PDF to get styled objects
    // final _name = await PdfStyler.parseTextSpanList(pdfText: name);

    final _name = name.toRichText();
    final _date = date.toRichText();
    final _topicHeader = Text("Topic:",
        style: TextStyle(
            color: PdfColors.blueGrey700,
            fontSize: 13.0,
            font: Font.ttf(await rootBundle
                .load("lib/assets/IBMPlexSansKR-SemiBold.ttf"))));
    final _topic = topic.toRichText();
    final _homeworkHeader = Text("Homework:",
        style: TextStyle(
            color: PdfColors.blueGrey700,
            fontSize: 13.0,
            font: Font.ttf(await rootBundle
                .load("lib/assets/IBMPlexSansKR-SemiBold.ttf"))));
    final _homework = homework != null ? homework!.toRichText() : null;

    final List<Widget> _tables = [];
    if (tables != null && tables!.length > 0) {
      for (int i = 0; i < tables!.length; i++) {
        await _newTable(table: tables![i]).then((value) => _tables.add(value));
      }
    }

    final _footer = Text(footer.toString(),
        style: TextStyle(
            color: PdfColors.blueGrey700,
            fontSize: 10.0,
            fontStyle: FontStyle.italic,
            font: Font.ttf(await rootBundle
                .load("lib/assets/IBMPlexSansKR-SemiBold.ttf"))));

    //initial set up

    final pdf = Document();
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: ((context) {
          return [
            // H1-------------------------------------------------------------------
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(children: [
                  Expanded(child: _name),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerRight, child: _date))
                ])),
            // H2-------------------------------------------------------------------
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: _topicHeader),
                  Expanded(child: _topic)
                ])),
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
              return Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10), child: e);
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
  ///Takes a heading and a map of LHS and RHS values to build a table with them
  Future<Widget> _newTable({required PdfTableModel table}) async {
    final _heading = table.heading!.toRichText();
    final _rows = await _styleTableRows(table);

    final Map<String, int> _flexAmounts = {
      "New Language": 2,
      "Pronunciation": 3,
      "Corrections": 1
    };

    return Column(children: [
      Container(
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: PdfColors.black, width: 2.0))),
        child: Row(children: [
          Expanded(child: _heading),
          if (table.heading.toString() == "Pronunciation")
            Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 2.0),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8.0),
                    color: PdfColors.grey300),
                child: UrlLink(
                  destination:
                      "https://www.englishclub.com/images/pronunciation/Phonemic-Chart.jpg",
                  child: Text("IPA Reference",
                      style: TextStyle(
                          color: PdfColors.blueGrey700,
                          fontSize: 10.0,
                          fontStyle: FontStyle.italic,
                          font: Font.ttf(await rootBundle
                              .load("lib/assets/IBMPlexSansKR-SemiBold.ttf")))),
                ))
        ]),
      ),
      Table(children: [
        ..._rows.map((row) {
          return TableRow(
              verticalAlignment: TableCellVerticalAlignment.middle,
              decoration: const BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: PdfColors.blueGrey))),
              children: [
                // LHS
                table.heading.toString() == "Pronunciation"
                    ? UrlLink(
                        child: Expanded(
                            child: Padding(
                                padding: EdgeInsets.all(3.0), child: row[0])),
                        destination: _getForvoLink(
                            row[0].text.toPlainText().toLowerCase()))
                    : Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(3.0), child: row[0])),

                // Separator
                if (row.length == 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),

                // RHS
                if (row.length == 2)
                  Expanded(
                      child:
                          Padding(padding: EdgeInsets.all(3.0), child: row[1]),
                      flex: _flexAmounts[table.heading.toString()] ?? 1)
              ]);
        }),
        TableRow(children: [
          Padding(padding: const EdgeInsets.symmetric(vertical: 4.0))
        ])
      ])
    ]);
  }

  Future<List<List<RichText>>> _styleTableRows(PdfTableModel table) async {
    final List<List<RichText>> output = [];

    for (final row in table.rows!) {
      final lhs;
      final rhs;

      lhs = row.lhs!.toRichText();

      if (row.rhs != null) {
        rhs = row.rhs!.toRichText();
        output.add([lhs, rhs]);
      } else {
        output.add([lhs]);
      }
    }

    return output;
  }

  String _getForvoLink(String term) {
    return "https://forvo.com/word/$term";
  }
}
