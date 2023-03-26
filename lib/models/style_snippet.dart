import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:pdf/pdf.dart';

part 'style_snippet.g.dart';

@collection
class StyleSnippet {
  StyleSnippet(this.id, this.marker, this.size, this.colour, this.styles);

  Id? id;
  String marker;
  double size;
  int colour;
  List<int> styles;

  static const int bold = 1;
  static const int italic = 2;
  static const int underline = 3;
  static const int strikethough = 4;

  static Map<int, Color> colourMap = {
    0: Colors.black,
    1: Color(0xFF0066B3),
    2: Colors.blueGrey,
    3: Color(0xFF00992B),
    4: Colors.grey[600]!,
    5: Color(0xFF980095),
    6: Color(0xFF995B00),
    7: Color(0xFF5E09B3),
    8: Color(0xFFCC1714),
    9: Color(0xFF988F01),
  };

  Color? getColour() {
    return colourMap[colour];
  }

  PdfColor? getPdfColour() {
    try {
      return PdfColor.fromInt(colourMap[colour]!.value);
    } on Exception {
      return PdfColors.black;
    }
  }

  // METHODS--------------------------------------------------------------------

  static Future<int> getNewId() async {
    final isar = Isar.getInstance("snippet_db") ??
        await Isar.open([StyleSnippetSchema], name: "snippet_db");
    final x = await isar.styleSnippets.where().findAll();
    final y = x.toList();
    return y.length + 1;
  }

  static Future<StyleSnippet?> getSnippet(int id) async {
    final isar = Isar.getInstance("snippet_db") ??
        await Isar.open([StyleSnippetSchema], name: "snippet_db");

    return isar.styleSnippets.get(id);
  }

  static Future<StyleSnippet?> getSnippetByName(String marker) async {
    final isar = Isar.getInstance("snippet_db") ??
        await Isar.open([StyleSnippetSchema], name: "snippet_db");
    final styleSnippets = isar.styleSnippets;
    final output = styleSnippets.filter().markerEqualTo(marker).findFirst();
    return output;
  }

  static Future<List<StyleSnippet>> getAllSnippets() async {
    final isar = Isar.getInstance("snippet_db") ??
        await Isar.open([StyleSnippetSchema], name: "snippet_db");
    final x = await isar.styleSnippets.where().findAll();
    return x;
  }

  static Future<void> saveSnippet(StyleSnippet snippet) async {
    final isar = Isar.getInstance("snippet_db") ??
        await Isar.open([StyleSnippetSchema], name: "snippet_db");
    await isar.writeTxn(() async {
      await isar.styleSnippets.put(snippet);
    });
  }

  static Future<void> deleteSnippet(String marker) async {
    final isar = Isar.getInstance("snippet_db") ??
        await Isar.open([StyleSnippetSchema], name: "snippet_db");

    await isar.writeTxn(() async {
      final snippet =
          await isar.styleSnippets.filter().markerEqualTo(marker).findFirst();
      await isar.styleSnippets.delete(snippet!.id!);
    });
  }
}
