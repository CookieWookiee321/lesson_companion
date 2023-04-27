import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TextModeMethods extends ChangeNotifier {
  static Future<FilePickerResult?> pickFile() async {
    return await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["txt", "lc"]);
  }
}
