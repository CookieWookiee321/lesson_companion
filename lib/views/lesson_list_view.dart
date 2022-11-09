import 'package:flutter/material.dart';
import 'package:lesson_companion/models/data_storage.dart';
import 'package:lesson_companion/models/lesson.dart';

import '../controllers/companion_methods.dart';

//==============================================================================
//Student List View
//==============================================================================
class LessonView extends StatefulWidget {
  const LessonView({super.key});

  @override
  State<LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  var _selectedStudent;
  List<Lesson> _lessons = [];
  int _lessonCount = 0;

  Future<List<DropdownMenuItem<String>>> _getStudents() async {
    final stringsList = await DataStorage.getAllStudentNames();
    final output = stringsList.map<DropdownMenuItem<String>>((e) {
      return DropdownMenuItem(
        value: e,
        child: Text(e),
      );
    }).toList();
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //DROP DOWN LIST FOR NAMES--------------------------------------------
          Card(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: FutureBuilder(
                  future: _getStudents(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return DropdownButton(
                            isExpanded: true,
                            value: _selectedStudent,
                            items: snapshot.data,
                            onChanged: (selection) async {
                              _lessons =
                                  await DataStorage.getAllLessonsOfStudent(
                                      selection.toString());
                              setState(() {
                                _selectedStudent = selection;
                                _lessonCount = _lessons.length;
                              });
                              print("Selected: $_selectedStudent");
                            },
                            hint: const Text("Select student's name"));
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return DropdownButtonFormField(
                          decoration: const InputDecoration(isDense: true),
                          items: [DropdownMenuItem(child: Text("Loading..."))],
                          onChanged: null,
                          hint: const Text("Loading..."));
                    }
                    return CircularProgressIndicator();
                  })),
            ),
          ),
          //LIST VIEW FOR LESSONS-----------------------------------------------
          Expanded(
            child: Card(
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: _selectedStudent != ""
                    ? ListView.builder(
                        itemCount: _lessonCount,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CompanionMethods.styleText(
                                    CompanionMethods.getShortDate(
                                        _lessons[index].date),
                                    context),
                              ],
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CompanionMethods.styleText(
                                    _lessons[index].topic, context)
                              ],
                            ),
                            trailing: Icon(
                              Icons.home_work,
                              color: (_lessons[index].homework != null &&
                                      _lessons[index].homework!.trim().length >
                                          0)
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Colors.grey,
                            ),
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      title: Text("Item Menu"),
                                      content: Column(
                                        children: [
                                          OutlinedButton(
                                            child: Text("Edit Lesson"),
                                            onPressed: () async {
                                              await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return EditDialog(
                                                        studentId:
                                                            _lessons[index]
                                                                .studentId,
                                                        initialDate:
                                                            _lessons[index]
                                                                .date,
                                                        initialTopic:
                                                            _lessons[index]
                                                                .topic,
                                                        initialHomework:
                                                            _lessons[index]
                                                                .homework);
                                                  });
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }));
                            },
                          );
                        })
                    : null,
              ),
            ),
          ),
          //FOOTER--------------------------------------------------------------
          Card(
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Text("Total Lessons: $_lessonCount"),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: null,
          child: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          hoverColor: Theme.of(context).colorScheme.tertiary,
          onPressed: () {
            //TODO: Extend bar to search bar
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("Lesson Details"),
      actions: [
        Row(
          children: [
            Text("Date:"),
            Expanded(
                child: TextFormField(
              maxLines: null,
              onChanged: (value) {
                _selectedDate = DateTime.tryParse(value);
              },
              initialValue: CompanionMethods.getShortDate(widget.initialDate),
            ))
          ],
        ),
        Row(
          children: [
            Text("Topic:"),
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
            final lesson = Lesson(
                studentId: widget.studentId,
                date: _selectedDate ?? widget.initialDate,
                topic: _selectedTopic ?? widget.initialTopic,
                homework: _selectedHomework ?? widget.initialHomework);

            await DataStorage.saveLesson(lesson);
            Navigator.pop(context);
          },
        ))
      ],
    );
  }
}
