import 'package:isar/isar.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/report.dart';
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

  static Future<List<String>> getAllStudentNames() async {
    List<String> output = [];

    final isar = Isar.getInstance("student_db") ??
        await Isar.open([StudentSchema], name: "student_db");
    final students = await isar.students.where().findAll();

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
        .dateEqualTo(date)
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
  //Delete----------------------------------------------------------------------
  //============================================================================

// //OLD METHODS
// // static Future<List<Student>> selectAllStudents() async {
// //   Database db = await DBHelper.instance.database;

// //   var results = await db.rawQuery("SELECT * FROM Student;");

// //   return List.generate(results.length, (i) {
// //     return Student.knownId(
// //         id: int.parse(results[i]["studentId"].toString()),
// //         name: results[i]["name"].toString(),
// //         active:
// //             int.parse(results[i]["active"].toString()) == 1 ? true : false);
// //   });
// // }

// // static Future<List<String>> selectAllStudentNames() async {
// //   final db = await DBHelper.instance.database;

// //   final results = await db.rawQuery("SELECT name FROM Student;");

// //   return List.generate(results.length, (index) {
// //     return results[index]["name"].toString();
// //   });
// // }

// // static Future<int> selectStudentID(String studentName) async {
// //   Database db = await DBHelper.instance.database;

// //   var results = await db.rawQuery(
// //       "SELECT studentId FROM Student WHERE name = ?;", [studentName]);

// //   if (results.isNotEmpty) {
// //     return int.parse(results[0][0].toString());
// //   }

// //   return createStudentId();
// // }

// // static Future<List<String>> selectStudentActiveNames() async {
// //   Database db = await DBHelper.instance.database;

// //   var results =
// //       await db.rawQuery("SELECT name FROM Student WHERE active = 1;");

// //   return List.generate(results.length, (i) {
// //     return results[i]["name"].toString();
// //   });
// // }

// // // static Future<Report> selectLesson(int id) async {
// // //   final db = await DBHelper.instance.database;

// // //   final resultBase =
// // //       await db.rawQuery("SELECT * FROM Report WHERE reportId = ?", [id]);

// // //   final resultsEntry = await db
// // //       .rawQuery("SELECT * FROM Report_Entry WHERE reportId = ?", [id]);

// // //   final repId = id;
// // //   final stuId = int.parse(resultBase[0][1].toString());
// // //   final lessId = int.parse(resultBase[0][2].toString());
// // //   final date = DateTime.parse(resultBase[0][3].toString());
// // //   final topic = resultBase[0][4].toString();
// // //   final homework = resultBase[0][5].toString();
// // //   final tableOneName = resultBase[0][6].toString();
// // //   final tableTwoName = resultBase[0][7].toString();
// // //   final tableThreeName = resultBase[0][8].toString();

// // //   var tableOneItems = {};
// // //   var tableTwoItems = {};
// // //   var tableThreeItems = {};

// // //   //sort entries into maps
// // //   for (var entry in resultsEntry) {
// // //     if (entry["tableName"].toString() == tableOneName) {
// // //       tableOneItems[entry["lhs"].toString()] = entry["rhs"].toString();
// // //     } else if (entry["tableName"].toString() == tableTwoName) {
// // //       tableTwoItems[entry["lhs"].toString()] = entry["rhs"];
// // //     } else {
// // //       tableThreeItems[entry["lhs"].toString()] = entry["rhs"].toString();
// // //     }
// // //   }

// // //   return Report(
// // //       repId,
// // //       stuId,
// // //       lessId,
// // //       date,
// // //       topic,
// // //       homework,
// // //       tableOneName,
// // //       tableOneItems,
// // //       tableTwoName,
// // //       tableTwoItems,
// // //       tableThreeName,
// // //       tableThreeItems);
// // // }

// // static Future<int> selectLessonId(String studentName, DateTime date) async {
// //   Database db = await DBHelper.instance.database;

// //   var results = await db.rawQuery(
// //       "SELECT lessonId FROM Lesson WHERE name = ? AND date = ?;",
// //       [studentName, date]);

// //   if (results.isNotEmpty) {
// //     return int.parse(results[0][0].toString());
// //   }

// //   return 0;
// // }

// // static Future<Report> selectReport(int id) async {
// //   final db = await DBHelper.instance.database;

// //   final resultBase =
// //       await db.rawQuery("SELECT * FROM Report WHERE reportId = ?", [id]);

// //   final resultsEntry = await db
// //       .rawQuery("SELECT * FROM Report_Entry WHERE reportId = ?", [id]);

// //   final repId = id;
// //   final stuId = int.parse(resultBase[0][1].toString());
// //   final lessId = int.parse(resultBase[0][2].toString());
// //   final date = DateTime.parse(resultBase[0][3].toString());
// //   final topic = resultBase[0][4].toString();
// //   final homework = resultBase[0][5].toString();
// //   final tableOneName = resultBase[0][6].toString();
// //   final tableTwoName = resultBase[0][7].toString();
// //   final tableThreeName = resultBase[0][8].toString();

// //   var tableOneItems = {};
// //   var tableTwoItems = {};
// //   var tableThreeItems = {};

// //   //sort entries into maps
// //   for (var entry in resultsEntry) {
// //     if (entry["tableName"].toString() == tableOneName) {
// //       tableOneItems[entry["lhs"].toString()] = entry["rhs"].toString();
// //     } else if (entry["tableName"].toString() == tableTwoName) {
// //       tableTwoItems[entry["lhs"].toString()] = entry["rhs"];
// //     } else {
// //       tableThreeItems[entry["lhs"].toString()] = entry["rhs"].toString();
// //     }
// //   }

// //   return Report(
// //       repId,
// //       stuId,
// //       lessId,
// //       date,
// //       topic,
// //       homework,
// //       tableOneName,
// //       tableOneItems,
// //       tableTwoName,
// //       tableTwoItems,
// //       tableThreeName,
// //       tableThreeItems);
// // }

// //     public static int FindReportID(string studentName, DateTime lessDate)
// //     public static string[][] FindLessonsByStudent(string name)
// //     public static string[] FindStudentNamesRecent()
// //     public static string[] FindStudentNamesAll(bool isOrdered)
// //     public static string[] FindReportsBasicInfo()
// //     public static string[] FindReportsDetailedInfo(DateTime date, string name)
}
