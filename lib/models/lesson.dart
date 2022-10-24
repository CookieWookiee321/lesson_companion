import 'package:isar/isar.dart';

part 'lesson.g.dart';

@collection
class Lesson {
  Id id;
  final int studentId;
  final DateTime date;
  final String topic;
  final String? homework;

  Lesson(
      {this.id = Isar.autoIncrement,
      required this.studentId,
      required this.date,
      required this.topic,
      required this.homework});
}
