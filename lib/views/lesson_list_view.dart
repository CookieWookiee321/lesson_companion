import 'package:flutter/material.dart';
import 'package:lesson_companion/models/data_storage.dart';
import 'package:lesson_companion/models/lesson.dart';

import '../../controllers/companion_methods.dart';

import '../companion_widgets.dart';

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
                            subtitle: (_lessons[index].homework != null &&
                                    _lessons[index].homework!.trim().length > 0)
                                ? CompanionMethods.styleText(
                                    _lessons[index].homework!, context)
                                : null,
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: ((context) {
                                    final _selectedId = _lessons[index].id;
                                    DateTime? _selectedDate =
                                        _lessons[index].date;
                                    String _selectedTopic =
                                        _lessons[index].topic;
                                    String? _selectedHomework =
                                        _lessons[index].homework;

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
                                                _selectedDate =
                                                    DateTime.tryParse(value);
                                              },
                                              initialValue: _lessons[index]
                                                  .date
                                                  .toString(),
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
                                              initialValue:
                                                  _lessons[index].topic,
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
                                              initialValue:
                                                  _lessons[index].homework,
                                            ))
                                          ],
                                        ),
                                        Center(
                                          child: OutlinedButton(
                                              onPressed: () async {
                                                final lesson = Lesson(
                                                    date: _selectedDate!,
                                                    homework: _selectedHomework,
                                                    studentId: _selectedId,
                                                    topic: _selectedTopic);

                                                await DataStorage.saveLesson(
                                                    lesson);
                                                Navigator.pop(context);
                                              },
                                              child: Text("Submit")),
                                        )
                                      ],
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
