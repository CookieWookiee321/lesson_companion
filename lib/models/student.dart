import 'package:isar/isar.dart';
import 'package:lesson_companion/models/lesson.dart';

part 'student.g.dart';

@collection
class Student {
  Id id = Isar.autoIncrement;

  String? _name;

  String? get name => _name;

  set name(String? value) {
    _name = value;
  }

  bool? _active;

  bool? get active => _active;

  set active(bool? value) {
    _active = value;
  }

  Student();

  Student.known(
      {required this.id, required String? name, required bool? active})
      : _active = active,
        _name = name;

  Student.newStudent(
      {int id = Isar.autoIncrement, required String? name, bool? active = true})
      : _active = active,
        _name = name;

  // DATABASE-------------------------------------------------------------------
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

  static Future<void> saveStudent(Student student) async {
    final isar = Isar.getInstance("student_db") ??
        await Isar.open([StudentSchema], name: "student_db");
    await isar.writeTxn(() async {
      await isar.students.put(student);
    });
  }
}
