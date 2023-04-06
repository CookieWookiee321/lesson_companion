import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lesson_companion/controllers/companion_methods.dart';
import 'package:printing/printing.dart';

import '../../models/pdf_document/pdf_doc.dart';
import '../../models/student.dart';

class PdfPreviewPage extends StatelessWidget {
  final PdfDoc _pdfDocument;

  PdfPreviewPage({super.key, required PdfDoc pdfDocument})
      : _pdfDocument = pdfDocument;

  @override
  Widget build(BuildContext context) {
    Uint8List? _pdf;

    return Scaffold(
        appBar: AppBar(
          title: Text("Pdf Preview"),
        ),
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          Expanded(
              child: FutureBuilder(
            future: _pdfDocument.create(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  _pdf = snapshot.data!;

                  return PdfPreview(build: (_) {
                    return snapshot.data!;
                  });
                } else {
                  return Center(
                    child: Text(
                        "Failed to load preview.\nSaving the file may still work, however."),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
              // PdfPreview(build: (format) async {
              //   return;
              // })
              ),
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
                    if (_pdf != null) {
                      final saveDest =
                          "${await CompanionMethods.getLocalPath()}${_pdfDocument.name.toString()} (ID ${await Student.getId(_pdfDocument.name.toString())}) (${CompanionMethods.getShortDate(_pdfDocument.date.parseToDateTime())}).pdf";
                      final file = File(saveDest);
                      await file.writeAsBytes(_pdf!);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Report PDF file saved successfully"),
                        clipBehavior: Clip.antiAlias,
                        showCloseIcon: true,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("There was a problem saving this PDF file."),
                        clipBehavior: Clip.antiAlias,
                        showCloseIcon: true,
                      ));
                    }
                  },
                )
              ],
            ),
          )
        ]));
  }
}
