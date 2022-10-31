import 'package:flutter/material.dart';
import 'package:lesson_companion/models/data_storage.dart';

import 'companion_widgets.dart';

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
      body: StudentListRow(),
    );
  }
}

//==============================================================================
//COMPONENTS
//==============================================================================

class StudentListRow extends StatefulWidget {
  const StudentListRow({Key? key}) : super(key: key);

  @override
  State<StudentListRow> createState() => _StudentListRowState();
}

class _StudentListRowState extends State<StudentListRow> {
  Map<String, bool> _studentMap = {};
  final _scrollController = ScrollController(keepScrollOffset: true);

  Future<void> _getStudentDetails() async {
    final students = await DataStorage.getAllStudents();

    if (_studentMap.isNotEmpty) _studentMap.clear();

    for (final s in students) {
      _studentMap[s.name!] = s.active!;
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
            child: GestureDetector(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _studentMap.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      value: _studentMap.values.elementAt(index) ? true : false,
                      title: Text(_studentMap.keys.elementAt(index)),
                      onChanged: (isChecked) async {
                        final name = _studentMap.keys.elementAt(index);
                        final student =
                            await DataStorage.getStudentByName(name);
                        student!.active = isChecked;
                        await DataStorage.saveStudent(student);

                        setState(() {
                          _studentMap[name] == isChecked;
                        });
                      },
                    );
                  }),
              onLongPress: () {
                //TODO: add menu
              },
            ),
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
