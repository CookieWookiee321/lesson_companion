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
    3: Color(0xFF4AD24E),
    4: Colors.grey[600]!,
    5: Color(0xFFFF9900),
    6: Color(0xFFD90BCD),
    7: Color(0xFF5E09B3),
    8: Color(0xFFCC1714),
    9: Color(0xFFCCCC29),
  };

  ///Avaliable colour options are: [0: Colors.black], [1: Colors.blue],
  ///[2: Colors.blueGrey], [3: Colors.green], [4: Colors.grey],
  ///[5: Colors.orange], [6: Colors.pink], [7: Colors.purple],
  ///[8: Colors.red], and [9: Colors.yellow]
  // void setColour(Color color) {
  //   if (_colourMap.containsValue(color)) {
  //     colour = _colourMap.keys
  //         .where((element) => _colourMap[element] == color)
  //         .first;
  //   } else {
  //     throw Exception("This is not a valid choice of colour.");
  //   }
  // }

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

  static Future<StyleSnippet?> getSnippet(String marker) async {
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
