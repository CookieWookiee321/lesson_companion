import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lesson_companion/controllers/companion_methods.dart';
import 'package:lesson_companion/models/database.dart';
import 'package:printing/printing.dart';

import '../models/pdf_document/pdf_doc.dart';

class PdfPreviewPage extends StatelessWidget {
  final PdfDoc _pdfDocument;
  late Uint8List _bytes;

  PdfPreviewPage({super.key, required PdfDoc pdfDocument})
      : _pdfDocument = pdfDocument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pdf Preview"),
        ),
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          Expanded(child: PdfPreview(build: (format) async {
            _bytes = await _pdfDocument.create();
            return _bytes;
          })),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("Close"),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
                ElevatedButton(
                  child: Text("Save"),
                  onPressed: () async {
                    final saveDest =
                        "${await CompanionMethods.getLocalPath()}${_pdfDocument.name.toString()} (ID ${await Database.getStudentId(_pdfDocument.name.toString())}) (${CompanionMethods.getShortDate(_pdfDocument.date.parseToDateTime())}).pdf";
                    final file = File(saveDest);
                    await file.writeAsBytes(_bytes);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Report PDF file saved successfully")));
                  },
                )
              ],
            ),
          )
        ]));
  }
}
