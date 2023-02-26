import 'package:isar/isar.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LCObjectType { student, lesson, report }

enum SharedPrefOption { darkMode, footer, dictionary, fontSize }

class Database {
  //============================================================================
  //SELECT----------------------------------------------------------------------
  //============================================================================

  static Future<dynamic>? getSetting(SharedPrefOption option) async {
    final prefs = await SharedPreferences.getInstance();

    switch (option) {
      case SharedPrefOption.darkMode:
        return prefs.getBool("darkMode");
      case SharedPrefOption.footer:
        return prefs.getString("footer");
      case SharedPrefOption.dictionary:
        return prefs.getStringList("dictionary");
      case SharedPrefOption.fontSize:
        return prefs.getDouble("fontSize");
    }
  }

  static Future<Map<String, dynamic>> getAllSettings() async {
    final Map<String, dynamic> output = {};
    final prefs = await SharedPreferences.getInstance();

    for (final key in prefs.getKeys()) {
      output[key] = prefs.get(key);
    }

    return output;
  }

  //============================================================================
  //SAVE----------------------------------------------------------------------
  //============================================================================

  static Future<void> saveSetting(SharedPrefOption key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    final proper;
    switch (key) {
      case SharedPrefOption.darkMode:
        proper = value as bool;
        await prefs.setBool("darkMode", proper);
        break;
      case SharedPrefOption.footer:
        proper = value as String;
        await prefs.setString("footer", proper);
        break;
      case SharedPrefOption.dictionary:
        proper = value as List<String>;
        await prefs.setString("dictionary", proper);
        break;
      case SharedPrefOption.fontSize:
        proper = value as double;
        await prefs.setDouble("fontSize", proper);
    }
  }

  //============================================================================
  //CHECK----------------------------------------------------------------------
  //============================================================================
  static Future<bool> checkStudentExistsByName(String name) async {
    final isar = Isar.getInstance("student_db") ??
        await Isar.open([StudentSchema], name: "student_db");
    final students = isar.students;
    final bool exists =
        await students.filter().nameEqualTo(name).findFirst() != null
            ? true
            : false;
    return exists;
  }

  static Future<bool> checkStudentExistsById(int id) async {
    final isar = Isar.getInstance("student_db") ??
        await Isar.open([StudentSchema], name: "student_db");
    final students = isar.students;
    final bool exists =
        await students.filter().idEqualTo(id).findFirst() != null
            ? true
            : false;
    return exists;
  }

  static Future<bool> checkLessonExists(int studentId, DateTime date) async {
    final bool exists;
    if (await Lesson.getLessonId(
            await Student.getStudentName(studentId), date) !=
        null) {
      exists = true;
    } else {
      exists = false;
    }
    return exists;
  }

  //============================================================================
  //UPDATE----------------------------------------------------------------------
  //============================================================================

  //============================================================================
  //Delete----------------------------------------------------------------------
  //============================================================================
  static Future<void> deleteChildlessStudents() async {
    final isarLessons = Isar.getInstance("lesson_db") ??
        await Isar.open([LessonSchema], name: "lesson_db");
    final isarStudents = Isar.getInstance("student_db") ??
        await Isar.open([StudentSchema], name: "student_db");

    //delete students with 0 lessons
    final allStudent = await isarStudents.students.where().findAll();
    final allIds = allStudent.map((e) => e.id).toList();
    for (final id in allIds) {
      final lessonsById =
          await isarLessons.lessons.filter().studentIdEqualTo(id).findAll();

      if (lessonsById.isEmpty) {
        await isarStudents.writeTxn(() async {
          isarStudents.students.delete(id);
        });
      }
    }
  }

  static Future<void> deleteStudent(int id) async {
    final isar = Isar.getInstance("student_db") ??
        await Isar.open([StudentSchema], name: "student_db");

    await isar.writeTxn(() async {
      isar.students.delete(id);
    });
  }

  static Future<void> deleteLessonById(int lessonId) async {
    final isar = Isar.getInstance("lesson_db") ??
        await Isar.open([LessonSchema], name: "lesson_db");
    await isar.writeTxn(() async {
      await isar.lessons.delete(lessonId);
    });

    //delete students with 0 lessons
    deleteChildlessStudents();
  }

  static Future<void> deleteLessonByDetails(
      int studentId, DateTime date) async {
    final isar = Isar.getInstance("lesson_db") ??
        await Isar.open([LessonSchema], name: "lesson_db");
    final lesson = await isar.lessons
        .filter()
        .dateEqualTo(date)
        .and()
        .studentIdEqualTo(studentId)
        .findFirst();
    await deleteLessonById(lesson!.id);
  }
}
