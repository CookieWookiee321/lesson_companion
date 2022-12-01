import 'package:isar/isar.dart';
import 'package:lesson_companion/models/styling/pdf_lexer.dart';

part 'style_snippet.g.dart';

@collection
class StyleSnippet {
  final Id id = Isar.autoIncrement;
  final String marker;
  final List<StyleSnippetSpan> children;

  StyleSnippet(this.marker, this.children);

  // static Future<Student?> getStudentById(int id) async {
  //   final isar = Isar.getInstance("student_db") ??
  //       await Isar.open([StudentSchema], name: "student_db");
  //   final student = isar.students.filter().idEqualTo(id).findFirst();
  //   return student;
  // }

  // static Future<bool> checkLessonExists(int studentId, DateTime date) async {
  //   final bool exists;
  //   if (await getLessonId(await getStudentName(studentId), date) != null) {
  //     exists = true;
  //   } else {
  //     exists = false;
  //   }
  //   return exists;
  // }

  // static Future<void> saveLesson(Lesson lesson) async {
  //   final isar = Isar.getInstance("lesson_db") ??
  //       await Isar.open([LessonSchema], name: "lesson_db");
  //   await isar.writeTxn(() async {
  //     await isar.lessons.put(lesson);
  //   });
  // }

  // static Future<void> deleteStudent(int id) async {
  //   final isar = Isar.getInstance("student_db") ??
  //       await Isar.open([StudentSchema], name: "student_db");

  //   await isar.writeTxn(() async {
  //     isar.students.delete(id);
  //   });
  // }
}

@embedded
class StyleSnippetSpan {
  late String text;
  @enumerated
  late List<StylingOption> styles;
}
