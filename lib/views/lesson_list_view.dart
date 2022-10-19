import 'package:flutter/material.dart';
import 'package:lesson_companion/models/data_storage.dart';
import 'package:lesson_companion/models/lesson.dart';

import '../controllers/companion_methods.dart';

import 'companion_widgets.dart';

class LessonListView extends StatefulWidget {
  const LessonListView({super.key});

  @override
  State<LessonListView> createState() => _LessonListViewState();
}

class _LessonListViewState extends State<LessonListView> {
  final List<DropdownMenuItem<String>> _studentNames = [
    const DropdownMenuItem(
      value: "Loading...",
      child: Text("Loading..."),
    )
  ];
  var _selectedStudent = "";
  final List<TableRow> _lessonRows = [];

  Future<List<DropdownMenuItem<String>>> _getStudents() async {
    final stringsList = await DataStorage.getAllStudentNames();
    final List<DropdownMenuItem<String>> output = [];

    for (final s in stringsList) {
      output.add(DropdownMenuItem(
        value: s,
        child: Text(s),
      ));
    }

    return output;
  }

  @override
  void initState() async {
    super.initState();
    _studentNames.addAll(await _getStudents());
    _studentNames.removeAt(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lesson List"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
              child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(isDense: true),
              items: _studentNames,
              onChanged: (selection) {
                setState(() {
                  _selectedStudent = selection.toString();
                });
              },
              hint: const Text("Enter student's name"),
            ),
          )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: _selectedStudent != ""
                    ? LessonTable(studentName: _selectedStudent)
                    : null,
              ),
            ),
          ))
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

class LessonTable extends StatefulWidget {
  final String _studentName;

  const LessonTable({super.key, required String studentName})
      : _studentName = studentName;

  @override
  State<LessonTable> createState() => _LessonTableState();
}

class _LessonTableState extends State<LessonTable> {
  // final List<LessonHive> _lessons = DataStorage.getAllLessons(widget.studentName);
  final List<Lesson> _lessons = [];

  void _loadLessons() async {
    _lessons
        .addAll(await DataStorage.getAllLessonsOfStudent(widget._studentName));
  }

  @override
  void initState() {
    _loadLessons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        ..._lessons.map((e) {
          return TableRow(children: [
            Text(CompanionMethods.getShortDate(e.date)),
            Text(e.topic),
            if (e.homework != null) Text(e.homework!)
          ]);
        })
      ],
    );
  }
}
