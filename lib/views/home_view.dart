import 'package:flutter/material.dart';
import 'package:lesson_companion/controllers/companion_methods.dart';
import 'package:lesson_companion/models/data_storage.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/student.dart';

import 'companion_widgets.dart';

typedef IntCallback = void Function(int row, int column);

//======================================================================
//MAIN FORM VIEW
//======================================================================
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? _name;
  DateTime _date = DateTime.now();
  String? _topic;
  String? _homework;

  bool _showDetails = true;
  final _dateController = TextEditingController(
      text: CompanionMethods.getDateString(DateTime.now()));

  @override
  void initState() {
    super.initState();
  }

  void _onSwitched(bool isOn) {
    setState(() {
      !isOn ? _showDetails = false : _showDetails = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lesson Companion"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        const Expanded(child: Text("Show details")),
                        Switch(
                            value: _showDetails,
                            onChanged: (state) => _onSwitched(state))
                      ],
                    ),
                  ),
                ];
              },
            )
          ],
        ),
        body: Column(
          children: [
            if (_showDetails)
              Card(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5.0),
                  child: Column(
                    children: [
                      Focus(
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: TFOutlined(
                                  name: "tName",
                                  hint: "Name",
                                  onTextChanged: (text) {
                                    _name = text;
                                  },
                                )),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    2.0, 6.0, 12.0, 0.0),
                                child: HomeTextField(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                        context: context,
                                        initialDate: _date,
                                        firstDate: DateTime(2000, 01, 01),
                                        lastDate: DateTime(2100, 01, 01));

                                    if (picked != null && picked != _date) {
                                      setState(() {
                                        _date = picked;
                                        _dateController.text =
                                            CompanionMethods.getDateString(
                                                _date);
                                      });
                                    }
                                  },
                                  controller: _dateController,
                                  hintText: "Date",
                                  alignment: TextAlign.center,
                                  edittable: false,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      TFOutlined(
                        name: "tTopic",
                        hint: "Topic",
                        size: 13,
                        onTextChanged: (text) {
                          _topic = text;
                        },
                      ),
                      TFOutlined(
                        name: "tHomework",
                        hint: "Homework",
                        size: 13,
                        onTextChanged: (text) {
                          _homework = text;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  color: Theme.of(context).colorScheme.primary,
                )),
            Expanded(
              child: Column(children: const [
                Expanded(child: ReportTable(title: "New Language")),
                Expanded(child: ReportTable(title: "Pronunciation")),
                Expanded(child: ReportTable(title: "Corrections"))
              ]),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                child: ElevatedButton(
                    onPressed: () async {
                      if (_name == null || _topic == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                                "A name and topic are required at least to submit a lesson")));
                        return;
                      }

                      Student? thisStudent;

                      //check if student exists
                      if (!await DataStorage.checkStudentExistsByName(_name!)) {
                        //create new entry if not existant
                        thisStudent = Student();
                        thisStudent.name = _name!;
                        thisStudent.active = true;
                        await DataStorage.saveStudent(thisStudent);
                      }
                      thisStudent = await DataStorage.getStudentByName(_name!);

                      Lesson thisLesson = Lesson(
                          studentId: thisStudent!.id,
                          date: _date,
                          topic: _topic!,
                          homework: _homework);

                      //check if student exists
                      if (await DataStorage.checkLessonExists(
                          thisLesson.studentId, thisLesson.date)) {
                        //update details of existing entry
                        final id = await DataStorage.getLessonId(
                            _name, thisLesson.date);
                        thisLesson.id = id!;
                      }
                      await DataStorage.saveLesson(thisLesson);

                      //TODO: Reports current do not generate from this view
                      // Report thisReport =

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Lesson submitted successfully")));
                    },
                    child: const Text("Submit")))
          ],
        ),
        bottomNavigationBar: const BottomBar());
  }
}

class HomeTextField extends StatefulWidget {
  final String? hintText;
  final TextAlign alignment;
  final TextEditingController controller;
  final Function()? onTap;
  final bool edittable;

  const HomeTextField(
      {super.key,
      this.hintText,
      this.alignment = TextAlign.start,
      required this.controller,
      this.onTap = null,
      this.edittable = true});

  @override
  State<HomeTextField> createState() => _HomeTextFieldState();
}

class _HomeTextFieldState extends State<HomeTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: !widget.edittable,
      onTap: widget.onTap,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      textAlign: widget.alignment,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: widget.hintText,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      ),
      style: TextStyle(fontSize: 13),
      maxLines: null,
    );
  }
}

//======================================================================
//REPORT INPUT TABLE
//======================================================================
class ReportTable extends StatefulWidget {
  const ReportTable({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ReportTable> createState() => _ReportTableState();
}

class _ReportTableState extends State<ReportTable> {
  final _children = <ReportTableRow>[
    const ReportTableRow(rowIndex: 0),
    const ReportTableRow(rowIndex: 1),
    const ReportTableRow(rowIndex: 2)
  ];
  var _currentColumn = 0;
  var _currentRow = 0;
  final _currentCell = [0, 0];
  var _inFocus = false;

  void _updateCurrent(int rowIndex, int columnIndex) {
    setState(() {
      _currentRow = rowIndex;
      _currentColumn = columnIndex;
      _currentCell[0] = rowIndex;
      _currentCell[1] = columnIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
        margin: const EdgeInsets.fromLTRB(13, 2, 13, 2),
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),

              //PLUS BUTTON
              IconButton(
                onPressed: () {
                  setState(() {
                    // updating the state
                    _children.add(ReportTableRow(
                      rowIndex: _children.isNotEmpty ? _children.length - 1 : 0,
                      onFocus: (row, column) {
                        _updateCurrent(row, column);
                      },
                    ));
                  });
                },
                icon: Icon(
                  Icons.plus_one_sharp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                iconSize: 15.0,
                splashRadius: 10.0,
                padding: const EdgeInsets.all(4.0),
              ),
              //MINUS BUTTON
              IconButton(
                onPressed: () {
                  setState(() {
                    // updating the state
                    if (_inFocus && _children.isNotEmpty) {
                      _children.removeAt(_currentRow);
                    }
                  });
                },
                icon: Icon(
                  Icons.exposure_minus_1_sharp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                iconSize: 15.0,
                splashRadius: 10.0,
                padding: const EdgeInsets.all(4.0),
              ),

              //PLUS BUTTON
            ],
          ),
          Expanded(
              child: ListView(
            controller: ScrollController(),
            children: _children,
          )),
        ]),
      ),
      onFocusChange: (hasFocus) {
        _inFocus = hasFocus ? true : false;
      },
    );
  }
}

//======================================================================
//REPORT INPUT TABLE ROW
//======================================================================
class ReportTableRow extends StatefulWidget {
  const ReportTableRow({Key? key, required this.rowIndex, this.onFocus})
      : super(key: key);

  final IntCallback? onFocus;
  final int rowIndex;

  @override
  State<ReportTableRow> createState() => _ReportTableRowState();
}

class _ReportTableRowState extends State<ReportTableRow> {
  int _columnIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.secondaryContainer),
            borderRadius: const BorderRadius.all(Radius.circular(4.0))),
        child: Row(
          children: [
            Expanded(
              child: Focus(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                          ),
                          style: const TextStyle(fontSize: 11),
                          maxLines: null,
                        ))
                      ],
                    ),
                  ),
                  onFocusChange: (hasFocus) {
                    if (hasFocus) _columnIndex = 0;
                  }),
            ),
            const Padding(
              padding: EdgeInsets.all(3.0),
            ),
            Expanded(
              child: Focus(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                          ),
                          style: const TextStyle(fontSize: 11),
                          maxLines: null,
                        ))
                      ],
                    ),
                  ),
                  onFocusChange: (hasFocus) {
                    if (hasFocus) _columnIndex = 1;
                  }),
            ),
          ],
        ),
      ),
      onFocusChange: (hasFocus) {
        widget.onFocus != null
            ? widget.onFocus!(widget.rowIndex, _columnIndex)
            : null;
      },
    );
  }
}
