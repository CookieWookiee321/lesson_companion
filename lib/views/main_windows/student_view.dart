import 'package:flutter/material.dart';
import 'package:lesson_companion/models/database.dart';
import 'package:lesson_companion/models/student.dart';
import 'package:lesson_companion/views/companion_widgets.dart';

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

  final _scrollController = ScrollController(keepScrollOffset: true);

  Future<void> _getStudentDetails() async {
    _students = await Database.getAllStudents();

    final Map<String, int> temp = {};
    for (final s in _students!) {
      temp[s.name!] = await Database.getLessonCountOfStudent(s.id);
    }
    _namesAndCountMap = Map.fromEntries(
        temp.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
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
                    onLongPress: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return _menuDialog(index);
                        },
                      );
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

  AlertDialog _menuDialog(int index) {
    return AlertDialog(
      title: Text("Student Menu"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
              child: Text("Edit"),
              onPressed: () async {
                await showDialog(
                        context: context,
                        builder: (context) => _editDialog(index))
                    .then((value) => Navigator.pop(context));
              }),
          Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          OutlinedButton(
              child: Text("Delete"),
              onPressed: () async {
                await showDialog(
                        context: context,
                        builder: (context) => _deleteDialog(index))
                    .then((value) => Navigator.pop(context));
              })
        ],
      ),
    );
  }

  AlertDialog _editDialog(int index) {
    final __initialName = _namesAndCountMap!.keys.elementAt(index);
    String __name = __initialName;

    return AlertDialog(
        content: Column(mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Expanded(child: Text("Name:")),
        Expanded(
            flex: 2,
            child: TextFieldOutlined(
              initialText: __name,
              onTextChanged: (text) => __name = text,
            ))
      ]),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Close")),
          TextButton(
            child: Text("Save"),
            onPressed: () async {
              //check if name is not already taken
              if (!_namesAndCountMap!.keys.contains(__name)) {
                final student = _students!
                    .where((element) => element.name == __initialName)
                    .first;
                student.name = __name;
                await Database.saveStudent(student);
              } else {
                //if name is taken
                //TODO: merge the two profiles?
              }

              setState(() {});

              //Return
              Navigator.pop(context);
            },
          )
        ],
      )
    ]));
  }

  AlertDialog _deleteDialog(int index) {
    return AlertDialog(
      content: Text(
        "Are you sure you want to delete this student?\n(All lessons for this student will be deleted too)",
        style: Theme.of(context).textTheme.labelSmall,
      ),
      actions: [
        TextButton(
            child: Text("Yes"),
            onPressed: () async {
              final s = _students!
                  .where((element) =>
                      element.name == _namesAndCountMap!.keys.elementAt(index))
                  .first;

              await Database.deleteStudent(s.id).then((value) {
                setState(() {});
                Navigator.pop(context);
              });
            }),
        TextButton(
            child: Text("No"),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}