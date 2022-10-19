import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TextInputModeMethods extends ChangeNotifier {
  static bool checkNeededHeadings(String text) {
    if (text.isEmpty) return false;
    if (text == "") return false;

    bool hasName = false;
    bool hasDate = false;
    bool hasTopic = false;

    for (var line in text.split("\n")) {
      if (hasName & hasDate & hasTopic) return true;
      if (line[0] != '*') continue;

      final lineConvert = line.toUpperCase().trim();

      switch (lineConvert) {
        case "* NAME":
          hasName = true;
          break;
        case "* DATE":
          hasDate = true;
          break;
        case "* TOPIC":
          hasTopic = true;
          break;
      }
    }
    return false;
  }

  static Future<FilePickerResult?> pickFile() async {
    return await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["txt", "lc"]);
  }
}
