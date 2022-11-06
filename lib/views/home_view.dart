import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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

  bool _inFocus = false;
  int? _currentFocus = null;

  bool _showDetails = true;
  final _nameController = TextEditingController();
  final _dateController = TextEditingController(
      text: CompanionMethods.getDateString(DateTime.now()));
  final _topicController = TextEditingController();
  final _homeworkController = TextEditingController();

  void _autoInsert(TextEditingController controller) {
    final indexNow = controller.selection.base.offset;
    final character = controller.text[indexNow - 1];
    controller.text =
        CompanionMethods.autoInsert(character, controller, indexNow);
  }

  @override
  void initState() {
    window.onKeyData = (keyData) {
      switch (_currentFocus) {
        case 1:
          _autoInsert(_nameController);
          return true;
        case 3:
          _autoInsert(_topicController);
          return true;
        case 4:
          _autoInsert(_homeworkController);
          return true;
        default:
          return false;
      }
    };

    super.initState();
  }

  void _onSwitched(bool isOn) {
    setState(() {
      _showDetails = isOn;
    });
  }

  void _onPressedSubmit() async {
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
      final id = await DataStorage.getLessonId(_name, thisLesson.date);
      thisLesson.id = id!;
    }
    await DataStorage.saveLesson(thisLesson);

    //TODO: Reports current do not generate from this view
    // Report thisReport =

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Lesson submitted successfully")));
  }

  Future<void> _onTapDateField() async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000, 01, 01),
        lastDate: DateTime(2100, 01, 01));

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
        _dateController.text = CompanionMethods.getDateString(_date);
        _currentFocus = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Scaffold(
        body: FocusTraversalGroup(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_showDetails)
              Card(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: FocusTraversalOrder(
                                  order: NumericFocusOrder(1),
                                  child: TFOutlined(
                                    name: "tName",
                                    hint: "Name",
                                    size: 13.0,
                                    controller: _nameController,
                                    onTextChanged: (text) {
                                      _name = text;
                                      _currentFocus = 1;
                                    },
                                  ))),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(2.0, 6.0, 2.0, 0.0),
                              child: FocusTraversalOrder(
                                  order: NumericFocusOrder(2),
                                  child: HomeTextField(
                                      controller: _dateController,
                                      hintText: "Date",
                                      alignment: TextAlign.center,
                                      edittable: false,
                                      onTap: () async {
                                        await _onTapDateField();
                                      })),
                            ),
                          )
                        ],
                      ),
                      FocusTraversalOrder(
                          order: NumericFocusOrder(3),
                          child: TFOutlined(
                            name: "tTopic",
                            hint: "Topic",
                            size: 13,
                            onTextChanged: (text) {
                              _topic = text;
                              _currentFocus = 3;
                            },
                          )),
                      FocusTraversalOrder(
                          order: NumericFocusOrder(4),
                          child: TFOutlined(
                            name: "tHomework",
                            hint: "Homework",
                            size: 13,
                            onTextChanged: (text) {
                              _homework = text;
                              _currentFocus = 4;
                            },
                          )),
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
              child: ListView(
                children: [
                  FocusTraversalOrder(
                      order: NumericFocusOrder(5),
                      child: ReportTable(title: "New Language")),
                  FocusTraversalOrder(
                      order: NumericFocusOrder(6),
                      child: ReportTable(title: "Pronunciation")),
                  FocusTraversalOrder(
                      order: NumericFocusOrder(7),
                      child: ReportTable(title: "Corrections"))
                ],
              ),
            ),
            ElevatedButton(
              child: const Text("Submit"),
              onPressed: () async => _onPressedSubmit(),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton.small(
            heroTag: null, child: Icon(Icons.more), onPressed: null),
      ),
      onFocusChange: (value) {
        setState(() {
          _inFocus = value;
        });
      },
    );
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
  final List<int> _cellIndexes = [0, 1];
  final _children = <ReportTableRow>[
    ReportTableRow(
      cellIndexes: [0, 1],
    )
  ];
  var _currentColumn = 0;
  var _currentRow = 0;
  final _currentCell = [0, 0];
  bool _inFocus = false;

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
      child: Card(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.tertiary),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
          margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
          clipBehavior: Clip.antiAlias,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                      final lhsIndex = _cellIndexes.last + 1;
                      final rhsIndex = _cellIndexes.last + 2;
                      _cellIndexes.add(lhsIndex);
                      _cellIndexes.add(rhsIndex);

                      _children.add(ReportTableRow(
                        cellIndexes: _cellIndexes,
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
                    if (_children.length > 1) {
                      setState(() {
                        _children.removeAt(_currentRow);
                      });
                    }
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
            FocusTraversalGroup(
                child: Column(children: [
              ..._children.map((e) {
                return e;
              })
            ])),
          ]),
        ),
      ),
      onFocusChange: (hasFocus) {
        setState(() {
          _inFocus = hasFocus;
        });
      },
    );
  }
}

//======================================================================
//REPORT INPUT TABLE ROW
//======================================================================
class ReportTableRow extends StatefulWidget {
  final IntCallback? onFocus;
  final List<int> cellIndexes;

  const ReportTableRow({Key? key, required this.cellIndexes, this.onFocus})
      : super(key: key);

  @override
  State<ReportTableRow> createState() => _ReportTableRowState();
}

class _ReportTableRowState extends State<ReportTableRow> {
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
                child: FocusTraversalOrder(
              order: NumericFocusOrder(widget.cellIndexes.last - 1),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      ),
                      style: const TextStyle(fontSize: 11),
                      maxLines: null,
                    ))
                  ],
                ),
              ),
            )),
            const Padding(
              padding: EdgeInsets.all(3.0),
            ),
            Expanded(
                child: FocusTraversalOrder(
                    order:
                        NumericFocusOrder(widget.cellIndexes.last.toDouble()),
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
                    ))),
          ],
        ),
      ),
    );
  }
}

class AdjustableScrollController extends ScrollController {
  AdjustableScrollController([int extraScrollSpeed = 40]) {
    super.addListener(() {
      ScrollDirection scrollDirection = super.position.userScrollDirection;
      if (scrollDirection != ScrollDirection.idle) {
        double scrollEnd = super.offset +
            (scrollDirection == ScrollDirection.reverse
                ? extraScrollSpeed
                : -extraScrollSpeed);
        scrollEnd = min(super.position.maxScrollExtent,
            max(super.position.minScrollExtent, scrollEnd));
        jumpTo(scrollEnd);
      }
    });
  }
}
