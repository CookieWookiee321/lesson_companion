import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:lesson_companion/models/styling/pdf_lexer.dart';
import 'package:pdf/pdf.dart';

part 'style_snippet.g.dart';

//==============================================================================
// StyleSnippet
//==============================================================================
@collection
class StyleSnippet {
  final Id id = Isar.autoIncrement;
  final String marker;
  final List<StyleSnippetSpan> children;

  StyleSnippet(this.marker, this.children);

  // METHODS--------------------------------------------------------------------

  static Future<StyleSnippet?> getSnippet(String marker) async {
    final isar = Isar.getInstance("snippet_db") ??
        await Isar.open([StyleSnippetSchema], name: "snippet_db");
    return isar.styleSnippets.filter().markerEqualTo(marker).findFirst();
  }

  static Future<List<StyleSnippet>> getAllSnippets() async {
    final isar = Isar.getInstance("snippet_db") ??
        await Isar.open([StyleSnippetSchema], name: "snippet_db");
    final x = await isar.styleSnippets.where().findAll();
    return x;
  }

  static Future<void> saveLesson(StyleSnippet snippet) async {
    final isar = Isar.getInstance("snippet_db") ??
        await Isar.open([StyleSnippetSchema], name: "snippet_db");
    await isar.writeTxn(() async {
      await isar.styleSnippets.put(snippet);
    });
  }

  static Future<void> deleteSnippet(int id) async {
    final isar = Isar.getInstance("snippet_db") ??
        await Isar.open([StyleSnippetSchema], name: "snippet_db");

    await isar.writeTxn(() async {
      isar.styleSnippets.delete(id);
    });
  }
}

//==============================================================================
// StyleSnippetSpan
//==============================================================================
///[StyleSnippetSpan]s are used to build StyleSnippets.
@embedded
class StyleSnippetSpan {
  late double size;
  late int colour;
  @enumerated
  late List<StylingOption> styles;

  Map<int, Color> _colourMap = {
    0: Colors.black,
    1: Colors.blue,
    2: Colors.blueGrey,
    3: Colors.green,
    4: Colors.grey,
    5: Colors.orange,
    6: Colors.pink,
    7: Colors.purple,
    8: Colors.red,
    9: Colors.yellow,
  };

  ///Avaliable colour options are: [0: Colors.black], [1: Colors.blue],
  ///[2: Colors.blueGrey], [3: Colors.green], [4: Colors.grey],
  ///[5: Colors.orange], [6: Colors.pink], [7: Colors.purple],
  ///[8: Colors.red], and [9: Colors.yellow]
  void setColour(Color color) {
    if (_colourMap.containsValue(color)) {
      colour = _colourMap.keys
          .where((element) => _colourMap[element] == color)
          .first;
    } else {
      throw Exception("This is not a valid choice of colour.");
    }
  }

  Color? getColour(int colour) {
    return _colourMap[colour];
  }

  PdfColor? getPdfColour() {
    try {
      return PdfColor.fromInt(_colourMap[colour]!.value);
    } on Exception {
      return null;
    }
  }
}
