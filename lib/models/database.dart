import 'package:isar/isar.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LCObjectType { student, lesson, report }

enum SharedPrefOption { darkMode, footer, dictionary }

class Database {
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

  static Future<int> getLessonCountOfStudent(int studentId) async {
    final isar = Isar.getInstance("lesson_db") ??
        await Isar.open([LessonSchema], name: "lesson_db");
    final lessons =
        await isar.lessons.filter().studentIdEqualTo(studentId).findAll();
    return lessons.length;
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

  /// Attempts to retrieve the Lesson ID from a name and date.
  ///
  /// Returns either the correct Lesson ID, or -1 in the event that no result is found
  static Future<Lesson?> getLesson(String? name, DateTime date) async {
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
    return lesson;
  }

  static Future<dynamic>? getSetting(SharedPrefOption option) async {
    final prefs = await SharedPreferences.getInstance();

    switch (option) {
      case SharedPrefOption.darkMode:
        return prefs.getBool("darkMode");
      case SharedPrefOption.footer:
        return prefs.getString("footer");
      case SharedPrefOption.dictionary:
        return prefs.getStringList("dictionary");
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
