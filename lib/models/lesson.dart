import 'package:isar/isar.dart';
import 'package:lesson_companion/models/student.dart';

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

  // DATABASE---------------------------------------------------------------
  /// Attempts to retrieve the Lesson ID from a name and date.
  ///
  /// Returns either the correct Lesson ID, or -1 in the event that no result is found
  static Future<int?> getLessonId(String? name, DateTime date) async {
    final isar = Isar.getInstance("lesson_db") ??
        await Isar.open([LessonSchema], name: "lesson_db");
    final studentId = await Student.getId(name!);
    final lesson = await isar.lessons
        .filter()
        .idEqualTo(studentId)
        .and()
        .dateBetween(DateTime(date.year, date.month, date.day, 0, 0, 1),
            DateTime(date.year, date.month, date.day, 23, 59, 59))
        .findFirst();
    return lesson != null ? lesson.id : null;
  }

  /// Attempts to retrieve the Lesson ID from a name and date.
  ///
  /// Returns either the correct Lesson ID, or -1 in the event that no result is found
  static Future<Lesson?> getLesson(String? name, DateTime date) async {
    final isar = Isar.getInstance("lesson_db") ??
        await Isar.open([LessonSchema], name: "lesson_db");
    final studentId = await Student.getId(name!);
    final lesson = await isar.lessons
        .filter()
        .studentIdEqualTo(studentId)
        .and()
        .dateEqualTo(date)
        .findFirst();
    return lesson;
  }

  static Future<List<Lesson>> getAllLessonsOfStudent(String name) async {
    final isar = Isar.getInstance("lesson_db") ??
        await Isar.open([LessonSchema], name: "lesson_db");
    final allLessons = await isar.lessons.where().findAll();
    final studentId = await Student.getId(name);
    final lessonsByStudent =
        allLessons.where((element) => element.studentId == studentId).toList();
    lessonsByStudent.sort((a, b) {
      return a.date.compareTo(b.date);
    });
    return lessonsByStudent.reversed.toList();
  }

  static Future<void> saveLesson(Lesson lesson) async {
    final isar = Isar.getInstance("lesson_db") ??
        await Isar.open([LessonSchema], name: "lesson_db");
    await isar.writeTxn(() async {
      await isar.lessons.put(lesson);
    });
  }
}
