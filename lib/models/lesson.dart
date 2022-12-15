import 'package:isar/isar.dart';

part 'lesson.g.dart';

@collection
class Lesson {
  Id id;
  late int studentId;
  late DateTime date;
  late String topic;
  String? homework;

  Lesson(
      {this.id = Isar.autoIncrement,
      required this.studentId,
      required this.date,
      required this.topic,
      required this.homework});
}
