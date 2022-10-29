import 'package:isar/isar.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LCObjectType { student, lesson, report }

class DataStorage {
  //============================================================================
  //SELECT----------------------------------------------------------------------
  //============================================================================

  static Future<Student?> getStudentById(int id) async {
    final isar = Isar.getInstance("student_db") ??
        await Isar.open([StudentSchema], name: "student_db");
    final student = isar.students.filter().idEqualTo(id).findFirst();
    return student;
  }

  static Future<Student?> getStudentByName(String name) async {
    final isar = Isar.getInstance("student_db") ??
        await Isar.open([StudentSchema], name: "student_db");
    return await isar.students.filter().nameEqualTo(name).findFirst();
  }

  static Future<String?> getStudentName(int id) async {
    final isar = Isar.getInstance("student_db") ??
        await Isar.open([StudentSchema], name: "student_db");
    final student = await isar.students.filter().idEqualTo(id).findFirst();
    return student != null ? student.name : "[student name not found]";
  }

  static Future<List<Student>> getAllStudents() async {
    final isar = Isar.getInstance("student_db") ??
        await Isar.open([StudentSchema], name: "student_db");

    final ret = await isar.students.where().findAll();
    return ret;
  }

  static Future<List<String>> getAllStudentNames() async {
    List<String> output = [];

    final students = await getAllStudents();

    for (final s in students) {
      output.add(s.name!);
    }
    output.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });

    return output;
  }

  /// Attempts to retrieve the Student ID from a name.
  ///
  /// Returns either the correct Student ID, or -1 in the event that no result is found
  static Future<int> getStudentId(String name) async {
    final isar = Isar.getInstance("student_db") ??
        await Isar.open([StudentSchema], name: "student_db");
    final students = await isar.students.where().findAll();
    return students.where((element) => element.name == name).first.id;
  }

  /// Attempts to retrieve the Lesson ID from a name and date.
  ///
  /// Returns either the correct Lesson ID, or -1 in the event that no result is found
  static Future<int?> getLessonId(String? name, DateTime date) async {
    final isar = Isar.getInstance("lesson_db") ??
        await Isar.open([LessonSchema], name: "lesson_db");
    final studentId = await getStudentId(name!);
    final lesson = await isar.lessons
        .filter()
        .idEqualTo(studentId)
        .and()
        .dateBetween(DateTime(date.year, date.month, date.day, 0, 0, 1),
            DateTime(date.year, date.month, date.day, 23, 59, 59))
        .findFirst();
    return lesson != null ? lesson.id : null;
  }

  static Future<String> getSetting(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "[Setting not found]";
  }

  static Future<List<Lesson>> getAllLessonsOfStudent(String name) async {
    final isar = Isar.getInstance("lesson_db") ??
        await Isar.open([LessonSchema], name: "lesson_db");
    final allLessons = await isar.lessons.where().findAll();
    final studentId = await getStudentId(name);
    final lessonsByStudent =
        allLessons.where((element) => element.studentId == studentId).toList();
    lessonsByStudent.sort((a, b) {
      return a.date.compareTo(b.date);
    });
    return lessonsByStudent.reversed.toList();
  }

  //============================================================================
  //SAVE----------------------------------------------------------------------
  //============================================================================
  static Future<void> saveStudent(Student student) async {
    final isar = Isar.getInstance("student_db") ??
        await Isar.open([StudentSchema], name: "student_db");
    await isar.writeTxn(() async {
      await isar.students.put(student);
    });
  }

  static Future<void> saveLesson(Lesson lesson) async {
    final isar = Isar.getInstance("lesson_db") ??
        await Isar.open([LessonSchema], name: "lesson_db");
    await isar.writeTxn(() async {
      await isar.lessons.put(lesson);
    });
  }

  static void saveSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
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
    if (await getLessonId(await getStudentName(studentId), date) != null) {
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
}
