import 'package:flutter/material.dart';
import 'package:lesson_companion/models/data_storage.dart';
import 'package:lesson_companion/models/lesson.dart';
import 'package:lesson_companion/models/student.dart';

import '../controllers/home_controller.dart';

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
  String? name;
  String? day;
  String? month;
  String? year;
  DateTime? date;
  String? topic;
  String? homework;

  bool _showDetails = true;

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
                child: Column(
                  children: [
                    TFOutlined(
                      name: "tName",
                      text: "Name",
                      onTextChanged: (text) {
                        name = text;
                      },
                    ),
                    Focus(
                      child: Row(
                        children: [
                          Expanded(
                              child: TFOutlined(
                            name: "tDateDay",
                            text: "Day",
                            size: 13,
                            onTextChanged: (text) {
                              day = text;

                              if (day != null &&
                                  month != null &&
                                  year != null) {
                                date = HomeController.convertStringToDateTime(
                                    text, month!, year!);
                              }
                            },
                          )),
                          Expanded(
                              child: TFOutlined(
                            name: "tDateMonth",
                            text: "Month",
                            size: 13,
                            onTextChanged: (text) {
                              month = text;

                              if (day != null &&
                                  month != null &&
                                  year != null) {
                                date = HomeController.convertStringToDateTime(
                                    day!, text, year!);
                              }
                            },
                          )),
                          Expanded(
                              child: TFOutlined(
                            name: "tDateYear",
                            text: "Year",
                            size: 13,
                            onTextChanged: (text) {
                              year = text;

                              if (day != null &&
                                  month != null &&
                                  year != null) {
                                date = HomeController.convertStringToDateTime(
                                    day!, month!, text);
                              }
                            },
                          )),
                        ],
                      ),
                    ),
                    TFOutlined(
                      name: "tTopic",
                      text: "Topic",
                      size: 13,
                      onTextChanged: (text) {
                        topic = text;
                      },
                    ),
                    TFOutlined(
                      name: "tHomework",
                      text: "Homework",
                      size: 13,
                      onTextChanged: (text) {
                        homework = text;
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Divider(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                  ],
                ),
              ),
            Expanded(
                child: Container(
              child: Column(children: const [
                Expanded(child: ReportTable(title: "New Language")),
                Expanded(child: ReportTable(title: "Pronunciation")),
                Expanded(child: ReportTable(title: "Corrections"))
              ]),
            )),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                child: ElevatedButton(
                    onPressed: () {
                      if (name == null || topic == null || date == null) return;

                      Student thisStudent =
                          DataStorage.getStudentByName(name!) as Student;
                      Lesson thisLesson = Lesson(
                          studentId: thisStudent.id,
                          date: date!,
                          topic: topic!,
                          homework: homework == null ? "" : homework!);
                      //TODO: Report thisReport =

                      HomeController.submitLesson(
                          thisStudent, thisLesson, null);

                      //TODO: Toast message on result
                    },
                    child: const Text("Submit")))
          ],
        ),
        bottomNavigationBar: const BottomBar());
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

  void _onRowFocus(int row, int column) {
    _currentRow = row;
    _currentColumn = column;
    _currentCell[0] = _currentRow;
    _currentCell[1] = _currentColumn;
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

  void _updateCurrent(int rowIndex, int columnIndex) {
    setState(() {
      _currentRow = rowIndex;
      _currentColumn = columnIndex;
      _currentCell[0] = rowIndex;
      _currentCell[1] = columnIndex;
    });
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
