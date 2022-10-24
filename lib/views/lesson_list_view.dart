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
      appBar: AppBar(
        title: const Text("Lesson List"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
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
                                  Text(
                                    CompanionMethods.getShortDate(
                                        _lessons[index].date),
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_lessons[index].topic,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                      textAlign: TextAlign.start)
                                ],
                              ),
                              subtitle: (_lessons[index].homework != null)
                                  ? Text(_lessons[index].homework!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall)
                                  : null);
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
      bottomNavigationBar: const BottomBar(),
    );
  }
}
