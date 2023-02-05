import 'package:flutter/material.dart';
import 'package:lesson_companion/models/database.dart';
import 'package:lesson_companion/models/student.dart';

import '../companion_widgets.dart';

//==============================================================================
//Student View
//==============================================================================
class StudentsView extends StatefulWidget {
  const StudentsView({Key? key}) : super(key: key);

  @override
  State<StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends State<StudentsView> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: StudentsListView(),
    );
  }
}

//==============================================================================
//Student List View
//==============================================================================
class StudentsListView extends StatefulWidget {
  const StudentsListView({Key? key}) : super(key: key);

  @override
  State<StudentsListView> createState() => _StudentsListViewState();
}

class _StudentsListViewState extends State<StudentsListView> {
  List<Student>? _students;
  Map<String, int>? _namesAndCountMap;
  Map<String, bool>? _namesAndActiveMap;

  final _scrollController = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    _namesAndActiveMap = {};

    super.initState();
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
          if (_students == null || _students!.isEmpty) {
            return Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                margin: const EdgeInsets.fromLTRB(13.0, 6, 13, 0),
                padding: const EdgeInsets.all(6),
                child: Text("Error. Failed to load students"));
          }
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
                    trailing: _namesAndActiveMap!.keys.elementAt(index) == true
                        ? Icon(
                            Icons.star,
                            color: Theme.of(context).colorScheme.tertiary,
                          )
                        : Icon(
                            Icons.star,
                            color: Theme.of(context).colorScheme.background,
                          ),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return StudentsViewMenu(
                            student: _students!
                                .where((element) =>
                                    element.name ==
                                    _namesAndCountMap!.keys.elementAt(index))
                                .first,
                            map: _namesAndActiveMap!,
                          );
                        },
                      );
                    },
                  );
                }),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  // METHODS--------------------------------------------------------------------

  Future<void> _getStudentDetails() async {
    _students = await Student.getAllStudents();

    final Map<String, int> temp = {};
    for (final s in _students!) {
      temp[s.name!] = await Student.getLessonCountOfStudent(s.id);
      _namesAndActiveMap![s.name!] = s.active!;
    }
    _namesAndCountMap = Map.fromEntries(
        temp.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }
}

class StudentsViewMenu extends StatefulWidget {
  const StudentsViewMenu({super.key, required this.student, required this.map});

  final Student student;
  final Map<String, bool> map;

  @override
  State<StudentsViewMenu> createState() => _StudentsViewMenuState();
}

class _StudentsViewMenuState extends State<StudentsViewMenu> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Student Menu"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // OutlinedButton(
          //     child: Text("Edit"),
          //     onPressed: () async {
          //       await showDialog(
          //               context: context,
          //               builder: (context) => _editDialog(widget.index))
          //           .then((value) => Navigator.pop(context));
          //     }),
          // Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          // OutlinedButton(
          //     child: Text("Delete"),
          //     onPressed: () async {
          //       await showDialog(
          //               context: context,
          //               builder: (context) => _deleteDialog(widget.index))
          //           .then((value) => Navigator.pop(context));
          //     }),
          //      Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          Row(
            children: [
              Expanded(child: Text("Student active")),
              Expanded(
                  child: Switch(
                      value: widget.student.active!,
                      onChanged: (state) {
                        Student.saveStudent(Student.known(
                            id: widget.student.id,
                            name: widget.student.name,
                            active: state));
                      }))
            ],
          )
        ],
      ),
    );
  }

  // AlertDialog _editDialog(Student student) {
  // final __initialName = student.name;
  // String __name = __initialName!;

  // return AlertDialog(
  //     content: Column(mainAxisSize: MainAxisSize.min, children: [
  //   Row(children: [
  //     Expanded(child: Text("Name:")),
  //     Expanded(
  //         flex: 2,
  //         child: TextFieldOutlined(
  //           initialText: __name,
  //           onTextChanged: (text) => __name = text,
  //         ))
  //   ]),
  //   Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       TextButton(
  //           onPressed: () => Navigator.pop(context), child: Text("Close")),
  //       TextButton(
  //         child: Text("Save"),
  //         onPressed: () async {
  //           //check if name is not already taken
  //           if (!_namesAndCountMap!.keys.contains(__name)) {
  //             final student = _students!
  //                 .where((element) => element.name == __initialName)
  //                 .first;
  //             student.name = __name;
  //             await Database.saveStudent(student);
  //           }

  //           setState(() {});

  //           //Return
  //           Navigator.pop(context);
  //         },
  //       )
  //     ],
  //   )
  // ])
  // );
  // }

  // AlertDialog _deleteDialog(int index) {
  //   return AlertDialog(
  //     content: Text(
  //       "Are you sure you want to delete this student?\n(All lessons for this student will be deleted too)",
  //       style: Theme.of(context).textTheme.labelSmall,
  //     ),
  //     actions: [
  //       TextButton(
  //           child: Text("Yes"),
  //           onPressed: () async {
  //             final s = _students!
  //                 .where((element) =>
  //                     element.name == _namesAndCountMap!.keys.elementAt(index))
  //                 .first;

  //             await Database.deleteStudent(s.id).then((value) {
  //               setState(() {});
  //               Navigator.pop(context);
  //             });
  //           }),
  //       TextButton(
  //           child: Text("No"),
  //           onPressed: () {
  //             Navigator.pop(context);
  //           })
  //     ],
  //   );
}
