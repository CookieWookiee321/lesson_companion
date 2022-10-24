import 'package:isar/isar.dart';

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
}
