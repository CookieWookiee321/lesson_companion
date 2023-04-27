import 'package:isar/isar.dart';

part 'text_snippet.g.dart';

@collection
class TextSnippet {
  TextSnippet(
      {required this.name, required this.arguments, required this.unpacked});

  Id id = Isar.autoIncrement;
  String name;
  List<String> arguments;
  String unpacked;

  // String unpack() {
  //   return
  // }
}
