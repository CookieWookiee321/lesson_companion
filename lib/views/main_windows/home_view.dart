import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lesson_companion/views/main_windows/pdf_preview.dart';

import '../../controllers/companion_methods.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/styling/companion_lexer.dart';
import '../../models/database.dart';
import '../../models/lesson.dart';
import '../../models/report.dart';
import '../../models/student.dart';
import '../companion_widgets.dart';

typedef IntCallback = void Function(int row, int column);

//======================================================================
//MAIN FORM VIEW
//======================================================================
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();

  static _HomeViewState of(BuildContext context) =>
      context.findAncestorStateOfType<_HomeViewState>()!;
}

class _HomeViewState extends State<HomeView> {
  String? _name;
  DateTime _date = DateTime.now();
  String? _topic;
  String? _homework;

  int? _currentReportId;

  //TODO:
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

  @override
  void initState() {
    super.initState();
  }

  String _convertTablesToText() {
    if (_name != null && _topic != null) {
      final sb = StringBuffer();

      sb.writeln("=<");
      sb.writeln("# Name\n- $_name\n");
      sb.writeln("# Date\n- ${CompanionMethods.getShortDate(_date)}\n");

      sb.writeln("# Topic");
      _topic!.split("\n").forEach((t) {
        sb.writeln("- ${t}");
      });
      sb.writeln();

      if (_homework != null) {
        sb.writeln("# Homework");
        _homework!.split("\n").forEach((h) {
          sb.writeln("- ${h}");
        });
        sb.writeln();
      }

      for (final table in _tables) {
        sb.writeln("# ${table.title}");
        table.children.forEach((row) {
          if (row.model.lhs != null) {
            sb.write("- ${row.model.lhs}");

            if (row.model.rhs != null) {
              sb.write(" || ${row.model.rhs}");
            }

            sb.writeln();
          }
        });
        sb.writeln();
      }

      return sb.toString();
    } else {
      throw new Exception(
          "You have not filled in the basic information for the class, so it cannot be saved.");
    }
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
    if (!await Database.checkStudentExistsByName(_name!)) {
      //create new entry if not existent
      thisStudent = Student();
      thisStudent.name = _name!;
      thisStudent.active = true;
      await Database.saveStudent(thisStudent);
    }
    thisStudent = await Database.getStudentByName(_name!);

    Lesson thisLesson = Lesson(
        studentId: thisStudent!.id,
        date: _date,
        topic: _topic!,
        homework: _homework);

    //check if student exists
    if (await Database.checkLessonExists(
        thisLesson.studentId, thisLesson.date)) {
      //update details of existing entry
      final id = await Database.getLessonId(_name, thisLesson.date);
      thisLesson.id = id!;
    }
    await Database.saveLesson(thisLesson);

    //counter checks tables are not empty
    final counter = HomeController.areTablesPopulated(_tables);
    if (counter > 0) {
      final dateSplit = _dateController.text.split(" ");

      //build report text
      final sb = StringBuffer();
      sb.writeln("# Name");
      sb.writeln("- $_name");
      sb.writeln("# Date");
      sb.writeln("- $_date");
      sb.writeln("# Topic");
      sb.writeln("- $_topic");
      if (_homework != null) {
        sb.writeln("# Homework");
        sb.writeln("- $_homework");
      }
      for (final table in _tables) {
        sb.writeln("# ${table.title}");
        for (final row in table.children) {
          sb.write("- ${row.model.lhs}");
          if (row.model.rhs != null) {
            sb.write(" || ${row.model.rhs}");
          }
          sb.write("\n");
        }
      }

      final thisReport = Report(sb.toString());

      final pdfDoc = await thisReport.toPdfDoc();
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

  void _resetPage() {
    _nameController.text = "";
    _date = DateTime.now();
    _topicController.text = "";
    _homeworkController.text = "";

    for (final t in _tables) {
      t.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FocusTraversalGroup(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showDetails)
            Card(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            Theme.of(context).colorScheme.secondaryContainer),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
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
                            hint: "Topic",
                            size: 13,
                            controller: _topicController,
                            onTextChanged: (text) {
                              _topic = text;
                              _currentFocus = 3;
                            },
                          )),
                      FocusTraversalOrder(
                          order: NumericFocusOrder(4),
                          child: TextFieldOutlined(
                            hint: "Homework",
                            size: 13,
                            controller: _homeworkController,
                            onTextChanged: (text) {
                              _homework = text;
                              _currentFocus = 4;
                            },
                          )),
                    ],
                  ),
                ),
              ),
            ),
          if (_showDetails)
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
          Padding(
              padding: EdgeInsets.all(5.0),
              child: ElevatedButton(
                child: const Text("Submit"),
                onPressed: () async => _onPressedSubmit(),
              ))
        ],
      )),
      floatingActionButton: SpeedDial(
        icon: Icons.more,
        children: [
          SpeedDialChild(
            label: "Reset Page",
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                        "Are you sure you want to reset the page to the default state?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            _resetPage();
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: Text("Yes")),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("No"))
                    ],
                  );
                },
              );
            },
          ),
          SpeedDialChild(
            label: "Hide/Show Header",
            onTap: () {
              setState(() {
                _showDetails ? _showDetails = false : _showDetails = true;
              });
            },
          ),
          SpeedDialChild(
            label: "Print Report to Console",
            onTap: () {
              try {
                print(_convertTablesToText());
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
          )
        ],
      ),
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

  void clear() {
    children.removeRange(1, children.length);
    children.first.model.lhs = "";
    children.first.model.rhs = "";
  }

  const ReportTable({Key? key, required this.title, required this.children})
      : super(key: key);

  @override
  State<ReportTable> createState() => _ReportTableState();
}

class _ReportTableState extends State<ReportTable> {
  late String _heading;
  final List<int> _cellIndexes = [0, 1];
  var _currentRow = 0;
  final _currentCell = [0, 0];

  void _updateCurrent(int rowIndex, int columnIndex) {
    setState(() {
      _currentRow = rowIndex;
      _currentCell[0] = rowIndex;
      _currentCell[1] = columnIndex;
    });
  }

  void _callbackPlus() {
    setState(() {
      final lhsIndex = _cellIndexes.last + 1;
      final rhsIndex = _cellIndexes.last + 2;
      _cellIndexes.add(lhsIndex);
      _cellIndexes.add(rhsIndex);

      widget.children.add(ReportTableRow(
        cellIndexes: _cellIndexes,
        model: ReportTableRowModel(),
      ));
    });
  }

  void _callbackMinus() {
    if (widget.children.length > 1) {
      setState(() {
        widget.children.removeAt(widget.children.length - 1);
      });
    }
  }

  AlertDialog _titleChangeDialog() {
    return AlertDialog(
      title: Text("Table Header"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFieldOutlined(
            initialText: _heading,
            onTextChanged: (text) {
              setState(() {
                _heading = text;
              });
            },
          ),
          OutlinedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    _heading = widget.title;

    widget.children.add(ReportTableRow(
      model: ReportTableRowModel(),
      cellIndexes: [0, 1],
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        clipBehavior: Clip.antiAlias,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          //HEADING-----------------------------------------------------------
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              child: GestureDetector(
                child: Text(
                  _heading,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                onDoubleTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return _titleChangeDialog();
                    },
                  );
                },
              ),
            ),
            alignment: Alignment.centerLeft,
          ),
          //ROWS--------------------------------------------------------------
          FocusTraversalGroup(
              child: Column(children: [
            ...widget.children.map((e) {
              return e;
            })
          ])),
          //Bottom Row-----------------------------------------------------------
          ReportTableBottomRow(
            cellIndexes: _cellIndexes,
            children: widget.children,
            setStateCallBackPlus: _callbackPlus,
            setStateCallBackMinus: _callbackMinus,
          )
        ]),
      ),
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
  final _controllerRhs = TextEditingController();
  final _controllerLhs = TextEditingController();

  void _saveReportSync() {
    try {
      final text = HomeView.of(context)._convertTablesToText();
      var id = HomeView.of(context)._currentReportId;

      final report;
      if (id != null) {
        report = Report.getReportSync(id);

        if (report == null) {
          final newReport = Report(text);
          Report.saveReportSync(newReport);
          id = newReport.id;
        } else {
          report.text = text;
          Report.saveReportSync(report);
        }
      } else {
        final newReport = Report(text);
        Report.saveReportSync(newReport);
        id = newReport.id;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Report saved")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  KeyEventResult _handleKey(
      RawKeyEvent event, TextEditingController controller) {
    if (event is RawKeyDownEvent) {
      final k = event.logicalKey;

      final baseOffset = controller.selection.baseOffset;
      final extentOffset = controller.selection.extentOffset;

      if (CompanionLexer.markers.contains(k.keyLabel)) {
        final baseOffset = controller.selection.baseOffset;
        final extentOffset = controller.selection.extentOffset;
        final newText = CompanionMethods.autoInsertBrackets(
            k.keyLabel, controller, baseOffset, extentOffset);

        controller.text = newText;
        controller.selection = TextSelection(
            baseOffset: baseOffset + 1, extentOffset: extentOffset + 1);

        return KeyEventResult.handled;
      } else if (event.isControlPressed) {
        switch (k.keyLabel) {
          case "S":
            _saveReportSync();
            break;
          case "B":
            controller.text =
                CompanionMethods.insertStyleSyntax("**", controller);
            controller.selection = TextSelection(
                baseOffset: baseOffset, extentOffset: extentOffset);
            break;
          case "I":
            controller.text =
                CompanionMethods.insertStyleSyntax("*", controller);
            controller.selection = TextSelection(
                baseOffset: baseOffset, extentOffset: extentOffset);
            break;
          case "U":
            controller.text =
                CompanionMethods.insertStyleSyntax("_", controller);
            controller.selection = TextSelection(
                baseOffset: baseOffset, extentOffset: extentOffset);
            break;
          case "Enter":
            final fullText = controller.text;

            final before;
            final middle = "\n";
            final after;
            final newSelectionIndex;

            final indexNextLineEnd =
                fullText.indexOf("\n", controller.selection.baseOffset);

            if (indexNextLineEnd != -1) {
              before = fullText.substring(0, indexNextLineEnd);
              after = fullText.substring(indexNextLineEnd, fullText.length);
              newSelectionIndex = indexNextLineEnd;
            } else {
              before = fullText;
              after = "";
              newSelectionIndex = fullText.length + 1;
            }

            controller.text = "$before$middle$after";
            controller.selection =
                TextSelection.collapsed(offset: newSelectionIndex + 1);

            return KeyEventResult.handled;
          default:
        }
        return KeyEventResult.ignored;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
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
                        child: Focus(
                      child: TextFormField(
                        controller: _controllerLhs,
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
                      ),
                      onKey: (_, event) => _handleKey(event, _controllerLhs),
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
                              child: Focus(
                            child: TextFormField(
                              controller: _controllerRhs,
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
                            ),
                            onKey: (_, event) =>
                                _handleKey(event, _controllerRhs),
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
//Report Table Bottom Row
//======================================================================
class ReportTableBottomRow extends StatefulWidget {
  final List<int> cellIndexes;
  final List<ReportTableRow> children;
  final Function() setStateCallBackPlus;
  final Function() setStateCallBackMinus;

  const ReportTableBottomRow(
      {super.key,
      required this.cellIndexes,
      required this.children,
      required this.setStateCallBackPlus,
      required this.setStateCallBackMinus});

  @override
  State<ReportTableBottomRow> createState() => _ReportTableBottomRowState();
}

class _ReportTableBottomRowState extends State<ReportTableBottomRow> {
  final String _countTemplate = "Count";
  String? _countStr;

  @override
  void initState() {
    _countStr = "$_countTemplate: ${widget.children.length}";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.0,
                ),
                child: Text(
                  _countStr!,
                  style: Theme.of(context).textTheme.bodySmall,
                ))),
        //PLUS BUTTON
        IconButton(
          icon: Icon(
            Icons.plus_one_sharp,
            color: Theme.of(context).colorScheme.secondary,
          ),
          iconSize: 15.0,
          splashRadius: 10.0,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          onPressed: () {
            widget.setStateCallBackPlus();
            setState(() {
              _countStr = "$_countTemplate: ${widget.children.length}";
            });
          },
        ),
        //MINUS BUTTON
        IconButton(
          icon: Icon(
            Icons.exposure_minus_1_sharp,
            color: Theme.of(context).colorScheme.secondary,
          ),
          iconSize: 15.0,
          splashRadius: 10.0,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          onPressed: () {
            widget.setStateCallBackMinus();
            setState(() {
              _countStr = "$_countTemplate: ${widget.children.length}";
            });
          },
        ),
      ],
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

class ReportTableRowModel {
  String? lhs;
  String? rhs;

  ReportTableRowModel({this.lhs, this.rhs});
}
