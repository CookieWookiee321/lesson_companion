import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lesson_companion/controllers/companion_methods.dart';
import 'package:lesson_companion/controllers/home_controller.dart';
import 'package:lesson_companion/models/data_storage.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/report.dart';
import 'package:lesson_companion/models/student.dart';
import 'package:lesson_companion/models/views/home_view_models.dart';
import 'package:lesson_companion/views/pdf_preview.dart';

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
  double _traversalCap = 5;

  bool _showDetails = true;
  final _nameController = TextEditingController();
  final _dateController = TextEditingController(
      text: CompanionMethods.getDateString(DateTime.now()));
  final _topicController = TextEditingController();
  final _homeworkController = TextEditingController();

  List<ReportTable> _tables = [
    ReportTable(title: "New Language", children: []),
    ReportTable(title: "Pronunciation", children: []),
    ReportTable(title: "Corrections", children: [])
  ];

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

    final counter = HomeController.areTablesPopulated(_tables);
    if (counter > 0) {
      final dateSplit = _dateController.text.split(" ");

      final thisReport = Report();
      thisReport.studentId = thisStudent.id;
      thisReport.lessonId = thisLesson.id;
      thisReport.date = HomeController.convertStringToDateTime(
          dateSplit[0], dateSplit[1], dateSplit[2]);
      thisReport.topic = _topicController.text.split("\n").toList();
      thisReport.homework = _topicController.text.split("\n").toList();

      switch (counter) {
        case 3:
          thisReport.tableOneName = _tables[0].title;
          thisReport.tableOneItems = HomeController.modelTableData(_tables[0]);

          thisReport.tableTwoName = _tables[1].title;
          thisReport.tableTwoItems = HomeController.modelTableData(_tables[1]);

          thisReport.tableThreeName = _tables[2].title;
          thisReport.tableThreeItems =
              HomeController.modelTableData(_tables[2]);
          break;
        case 2:
          thisReport.tableOneName = _tables[0].title;
          thisReport.tableOneItems = HomeController.modelTableData(_tables[0]);

          thisReport.tableTwoName = _tables[1].title;
          thisReport.tableTwoItems = HomeController.modelTableData(_tables[1]);
          break;
        default:
          thisReport.tableOneName = _tables[0].title;
          thisReport.tableOneItems = HomeController.modelTableData(_tables[0]);
          break;
      }

      final pdfDoc = await thisReport.create();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PdfPreviewPage(pdfDocument: pdfDoc);
      }));
    }

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
                                  child: TextFieldOutlined(
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
                          child: TextFieldOutlined(
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
                          child: TextFieldOutlined(
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
                  ..._tables.map((e) {
                    return FocusTraversalOrder(
                        order: NumericFocusOrder(_traversalCap++), child: e);
                  })
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

//======================================================================
//Home TextField
//======================================================================
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
//Report Table
//======================================================================
class ReportTable extends StatefulWidget {
  final String title;
  final List<ReportTableRow> children;

  const ReportTable({Key? key, required this.title, required this.children})
      : super(key: key);

  @override
  State<ReportTable> createState() => _ReportTableState();
}

class _ReportTableState extends State<ReportTable> {
  final List<int> _cellIndexes = [0, 1];
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
  void initState() {
    widget.children.add(ReportTableRow(
      model: ReportTableRowModel(),
      cellIndexes: [0, 1],
    ));
    super.initState();
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
                      final lhsIndex = _cellIndexes.last + 1;
                      final rhsIndex = _cellIndexes.last + 2;
                      _cellIndexes.add(lhsIndex);
                      _cellIndexes.add(rhsIndex);

                      widget.children.add(ReportTableRow(
                        cellIndexes: _cellIndexes,
                        onFocus: (row, column) {
                          _updateCurrent(row, column);
                        },
                        model: ReportTableRowModel(),
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
                    if (widget.children.length > 1) {
                      setState(() {
                        widget.children.removeAt(_currentRow);
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
              ...widget.children.map((e) {
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
//Report Table Row
//======================================================================
class ReportTableRow extends StatefulWidget {
  final ReportTableRowModel model;
  final IntCallback? onFocus;
  final List<int> cellIndexes;

  const ReportTableRow({
    Key? key,
    required this.model,
    required this.cellIndexes,
    this.onFocus,
  }) : super(key: key);

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
                      onChanged: (value) {
                        widget.model.lhs = value;
                      },
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
                            onChanged: (value) {
                              widget.model.rhs = value;
                            },
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

//======================================================================
//Adjustable Scroll Controller
//======================================================================
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
