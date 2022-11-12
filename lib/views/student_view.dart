import 'package:flutter/material.dart';
import 'package:lesson_companion/models/data_storage.dart';
import 'package:lesson_companion/models/student.dart';

//==============================================================================
//Student View
//==============================================================================
class StudentView extends StatefulWidget {
  const StudentView({Key? key}) : super(key: key);

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: StudentListView(),
    );
  }
}

//==============================================================================
//Student List View
//==============================================================================
class StudentListView extends StatefulWidget {
  const StudentListView({Key? key}) : super(key: key);

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  List<Student>? _students;
  Map<String, int>? _namesAndCountMap;

  final _scrollController = ScrollController(keepScrollOffset: true);

  Future<void> _getStudentDetails() async {
    _students = await DataStorage.getAllStudents();

    if (_namesAndCountMap == null) {
      _namesAndCountMap = {};
    }

    for (final s in _students!) {
      _namesAndCountMap![s.name!] =
          await DataStorage.getLessonCountOfStudent(s.id);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getStudentDetails(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            margin: const EdgeInsets.fromLTRB(13.0, 6, 13, 0),
            padding: const EdgeInsets.all(6),
            child: ListView.builder(
                controller: _scrollController,
                itemCount: _namesAndCountMap!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_namesAndCountMap!.keys.elementAt(index)),
                    subtitle: Text(
                        "Total Lessons: ${_namesAndCountMap!.values.elementAt(index)}"),
                    onLongPress: () {
                      //TODO: add menu
                    },
                  );
                }),
          );
        }
        //TODO: handle error connection state
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
