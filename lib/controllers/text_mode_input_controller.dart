import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TextInputModeMethods extends ChangeNotifier {
  static bool checkNeededHeadings(String text) {
    if (text.isEmpty) return false;
    if (text == "") return false;

    bool hasName = false;
    bool hasDate = false;
    bool hasTopic = false;

    Map<int, List<bool>> results = {};
    int counter = 0;

    for (var line in text.split("\n")) {
      if (line.trim() == "===") {
        results[counter] = [hasName, hasDate, hasTopic];

        counter++;
        hasName = false;
        hasDate = false;
        hasTopic = false;
      }
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

    bool output = true;
    for (final index in results.keys) {
      if (results[index]!.contains(false)) {
        print("There is a problem with entry number ${index + 1}");
        output = false;
      }
    }
    return output;
  }

  static Future<FilePickerResult?> pickFile() async {
    return await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["txt", "lc"]);
  }
}
