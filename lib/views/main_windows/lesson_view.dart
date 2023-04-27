import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:lesson_companion/models/database.dart';
import 'package:lesson_companion/models/lesson.dart';

import '../../controllers/companion_methods.dart';
import '../../models/student.dart';

//==============================================================================
//Lesson History View
//==============================================================================
class LessonHistoryView extends StatefulWidget {
  const LessonHistoryView({super.key});

  @override
  State<LessonHistoryView> createState() => _LessonHistoryViewState();
}

class _LessonHistoryViewState extends State<LessonHistoryView> {
  List<Student>? _students;
  List<String>? _names;
  bool? _onlyActive = false;
  String? _selectedStudent;
  List<Lesson>? _lessons;

  final _scrollControllerAlphabet = ScrollController();
  double _scrollPositionAlphabet = 0.0;
  final _scrollControllerNames = ScrollController();
  double _scrollPositionNames = 0.0;

  @override
  void initState() {
    super.initState();

    // _scrollControllerAlphabet.addListener(() {
    //   _scrollPositionAlphabet = _scrollControllerAlphabet.position.pixels;
    // });

    // _scrollControllerNames.addListener(() {
    //   _scrollPositionNames = _scrollControllerNames.position.pixels;
    // });
  }

  Future<void> _getLessons() async {
    if (_selectedStudent != null) {
      _lessons = await Lesson.getAllLessonsOfStudent(_selectedStudent!);
    }
  }

  Future<void> _getNames(bool onlyActive) async {
    _students = await Student.getAll();

    if (onlyActive) {
      final filtered = _students!
          .where(
              (student) => (student.active == true) && (student.name != null))
          .toList();
      _names = filtered.map((student) => student.name!).toList();
    } else {
      _names = _students!.map((student) => student.name!).toList();
    }
  }

  Widget _nameListView() {
    return FutureBuilder(
        future: _getNames(_onlyActive!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AlphabetScrollView(
              itemBuilder: (context, index, value) {
                return ListTile(
                  leading: Text(" "),
                  title: Text(value),
                  onTap: () {
                    setState(() {
                      _selectedStudent = value;
                    });
                  },
                  onLongPress: () async {
                    if (_selectedStudent != null) {
                      final id = await Student.getId(value);
                      await Database.deleteStudent(id);
                      setState(() {});
                    }
                  },
                );
              },
              alignment: LetterAlignment.left,
              list: _names!.map((e) => AlphaModel(e)).toList(),
              selectedTextStyle: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(fontSize: 16),
              unselectedTextStyle: Theme.of(context).textTheme.labelSmall!,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _lessonListView() {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: FutureBuilder(
        future: _getLessons(),
        builder: (context, snapshot) {
          return (_lessons != null)
              ? ListView.builder(
                  itemCount: _lessons!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading:
                          Text(CoMethods.getShortDate(_lessons![index].date)),
                      title:
                          Text(_lessons![index].topic.replaceAll("//", "\n")),
                      onTap: () async {
                        final id = _students!
                            .where((s) => s.name! == _selectedStudent!)
                            .first
                            .id;
                        final date = _lessons![index].date;
                        final topic = _lessons![index].topic;
                        final homework = _lessons![index].homework;

                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EditDialog(
                                studentId: id,
                                initialDate: date,
                                initialTopic: topic,
                                initialHomework: homework,
                              );
                            });
                        setState(() {});
                        _scrollControllerNames.jumpTo(_scrollPositionNames);
                      },
                      onLongPress: () async {
                        final id = _students!
                            .where((s) => s.name! == _selectedStudent!)
                            .first
                            .id;
                        final date = _lessons![index].date;

                        await Database.deleteLessonByDetails(id, date);
                        setState(() {});
                      },
                    );
                  },
                )
              : Icon(Icons.more_horiz);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //NAME LIST
          Expanded(
            child: _nameListView(),
          ),
          // LIST OF LESSONS
          Expanded(child: _lessonListView())
        ],
      ),
    );
  }
}

//==============================================================================
//Edit Dialog (private)
//==============================================================================
class EditDialog extends StatefulWidget {
  final int studentId;
  final DateTime initialDate;
  final String initialTopic;
  final String? initialHomework;

  const EditDialog(
      {super.key,
      required this.studentId,
      required this.initialDate,
      required this.initialTopic,
      required this.initialHomework});

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  DateTime? _selectedDate;
  String? _selectedTopic;
  String? _selectedHomework;

  AlertDialog _editMenu() {
    return AlertDialog(
      scrollable: true,
      title: Text("Lesson Details"),
      actions: [
        Row(
          children: [
            Text("Date:"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
            ),
            Expanded(
                child: TextFormField(
              maxLines: null,
              onChanged: (value) {
                _selectedDate = DateTime.tryParse(value);
              },
              initialValue: CoMethods.getShortDate(widget.initialDate),
            ))
          ],
        ),
        Row(
          children: [
            Text("Topic:"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
            ),
            Expanded(
                child: TextFormField(
              maxLines: null,
              onChanged: (value) {
                _selectedTopic = value;
              },
              initialValue: widget.initialTopic,
            ))
          ],
        ),
        Row(
          children: [
            Text("Homework:"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
            ),
            Expanded(
                child: TextFormField(
              maxLines: null,
              onChanged: (value) {
                _selectedTopic = value;
              },
              initialValue: widget.initialHomework,
            ))
          ],
        ),
        Center(
            child: OutlinedButton(
          child: Text("Submit"),
          onPressed: () async {
            final stuName = await Student.getName(widget.studentId);
            var lesson = await Lesson.getLesson(
                stuName, _selectedDate ?? widget.initialDate);

            if (lesson != null) {
              lesson.date = _selectedDate ?? widget.initialDate;
              lesson.topic = _selectedTopic ?? widget.initialTopic;
              lesson.homework = _selectedHomework ?? widget.initialHomework;
            } else {
              lesson = Lesson(
                  studentId: widget.studentId,
                  date: _selectedDate ?? widget.initialDate,
                  topic: _selectedTopic ?? widget.initialTopic,
                  homework: _selectedHomework ?? widget.initialHomework);
            }

            await Lesson.saveLesson(lesson);
            Navigator.pop(context);
          },
        ))
      ],
    );
  }

  AlertDialog _confirmMenu() {
    return AlertDialog(
      scrollable: true,
      content: Text("Are you sure you want to delete this lesson?"),
      actions: [
        TextButton(
            onPressed: () async {
              final lesson = Lesson(
                  studentId: widget.studentId,
                  date: _selectedDate ?? widget.initialDate,
                  topic: _selectedTopic ?? widget.initialTopic,
                  homework: _selectedHomework ?? widget.initialHomework);

              await Database.deleteLessonByDetails(
                  lesson.studentId, lesson.date);
              Navigator.pop(context);
            },
            child: Text("Yes")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No"))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
              onPressed: () {
                //get all lesson details
                //switch back to other tab
                //load details into other tab
              },
              child: Text("Load into Editor")),
          Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          OutlinedButton(
            child: Text("Edit"),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return _editMenu();
                },
              ).then((value) => Navigator.pop(context));
            },
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          OutlinedButton(
            child: Text("Delete"),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return _confirmMenu();
                },
              ).then((value) => Navigator.pop(context));
            },
          )
        ],
      ),
    );
  }
}
