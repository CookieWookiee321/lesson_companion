// import 'dart:math';
// import 'dart:ui';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:lesson_companion/controllers/companion_methods.dart';
// import 'package:lesson_companion/controllers/text_mode_input_controller.dart';
// import 'package:lesson_companion/models/database.dart';
// import 'package:lesson_companion/models/dictionary/look_up.dart';
// import 'package:lesson_companion/models/lesson.dart';
// import 'package:lesson_companion/models/report.dart';
// import 'package:lesson_companion/models/report_template.dart';
// import 'package:lesson_companion/models/student.dart';
// import 'package:lesson_companion/views/companion_widgets.dart';
// import 'package:lesson_companion/views/dialogs/lookups/new_language_look_up.dart';
// import 'package:lesson_companion/views/main_windows/pdf_preview.dart';
// import 'package:rich_text_controller/rich_text_controller.dart';

// import '../../controllers/styling/companion_lexer.dart';

// final _nonAutoRowStartKeys = [
//   "Backspace",
//   "Delete",
//   "-",
//   "@",
//   "Arrow Left",
//   "Arrow Right",
//   "Arrow Up",
//   "Arrow Down",
//   "Alt Right",
//   "Alt Left",
//   "Shift Left",
//   "Shift Right",
//   "Control Left",
//   "Control Right",
// ];

// //==============================================================================
// // Text Input Mode View
// //==============================================================================
// class TextEditorView extends StatefulWidget {
//   const TextEditorView({Key? key}) : super(key: key);

//   @override
//   State<TextEditorView> createState() => _TextEditorViewState();
// }

// class _TextEditorViewState extends State<TextEditorView> {
//   final _lookUpReturns = <LookUpReturn>[];

//   late RichTextController _textController;
//   final _textNode = FocusNode();

//   double _fontSize = 13.0;

//   String? _name;
//   DateTime _date = DateTime.now();
//   List<String>? _topics;
//   List<String>? _homework;

//   late TextEditingController _nameController;
//   late TextEditingController _dateController;
//   late TextEditingController _topicController;
//   late TextEditingController _homeController;

//   //MAIN------------------------------------------------------------------------

//   @override
//   initState() {
//     _textController = RichTextController(
//         patternMatchMap: CompanionLexer.highlighter,
//         onMatch: (_) {},
//         deleteOnBack: false);
//     _textController.text = _template;

//     _nameController = RichTextController(
//         patternMatchMap: CompanionLexer.highlighter,
//         onMatch: (_) {},
//         deleteOnBack: false);
//     _dateController = RichTextController(
//         patternMatchMap: CompanionLexer.highlighter,
//         onMatch: (_) {},
//         deleteOnBack: false);
//     _dateController.text = CompanionMethods.getDateString(_date);
//     _topicController = RichTextController(
//         patternMatchMap: CompanionLexer.highlighter,
//         onMatch: (_) {},
//         deleteOnBack: false);
//     _homeController = RichTextController(
//         patternMatchMap: CompanionLexer.highlighter,
//         onMatch: (_) {},
//         deleteOnBack: false);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     Database.saveSetting(SharedPrefOption.fontSize, _fontSize);

//     window.onKeyData = null;
//     _textController.dispose();
//     super.dispose();
//   }

//   Widget _templateListView(AsyncSnapshot snapshot) {
//     return ListView.builder(
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(
//             snapshot.data![index].text!,
//             softWrap: true,
//           ),
//           onTap: () async {
//             await showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: Text("Load Template"),
//                   content: Text(
//                       "Are you sure you want to load this template to the editor?\nThis will remove all current text"),
//                   actions: [
//                     OutlinedButton(
//                         onPressed: () {
//                           _textController.text = snapshot.data![index].text!;
//                           Navigator.pop(context);
//                           setState(() {});
//                         },
//                         child: Text("Yes")),
//                     OutlinedButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text("No"))
//                   ],
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _newTemplateDialog() {
//     String? _templateBody;

//     return AlertDialog(
//       content: TextFieldBorderless(
//         onTextChanged: (p0) {
//           _templateBody = p0;
//         },
//       ),
//       actions: [
//         TextButton(
//             onPressed: () async {
//               if (_templateBody != null && _templateBody!.isNotEmpty) {
//                 await ReportTemplate.save(ReportTemplate(text: _templateBody));
//                 Navigator.pop(context);
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text("Please enter a body for the template.")));
//               }
//             },
//             child: Text("OK"))
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: FocusScope(
//           autofocus: true,
//           canRequestFocus: true,
//           onKey: (node, event) {
//             return _handleKey(event);
//           },
//           child: Focus(
//             child: Column(
//               children: [
//                 //tool bar
//                 Card(
//                     child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                             //NAME
//                             flex: 2,
//                             child: TextFieldOutlined(
//                               hint: "Name",
//                               size: _fontSize,
//                               controller: _nameController,
//                               onTextChanged: (text) {
//                                 _name = text;
//                               },
//                             )),
//                         Expanded(
//                             flex: 1,
//                             child: TextFormField(
//                               readOnly: true,
//                               onTap: () async {
//                                 await showDatePicker(
//                                         context: context,
//                                         initialDate: _date,
//                                         firstDate: DateTime(2000),
//                                         lastDate: DateTime(2099))
//                                     .then((selectedDate) {
//                                   setState(() {
//                                     _date = selectedDate!;
//                                     _dateController.text =
//                                         CompanionMethods.getShortDate(_date);
//                                   });
//                                 });
//                               },
//                               textInputAction: TextInputAction.next,
//                               controller: _dateController,
//                               textAlign: TextAlign.center,
//                               decoration: InputDecoration(
//                                 border: const OutlineInputBorder(),
//                                 isDense: true,
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 13, vertical: 9),
//                               ),
//                               style: TextStyle(fontSize: _fontSize),
//                               maxLines: null,
//                             ))
//                       ],
//                     ),
//                     TextFieldOutlined(
//                       hint: "Topic",
//                       controller: _topicController,
//                       size: _fontSize,
//                     )
//                   ],
//                 )),
//                 // main text field
//                 Expanded(
//                     child: Card(
//                   child: Padding(
//                     padding: EdgeInsets.all(0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                             child: RawKeyboardListener(
//                           focusNode: _textNode,
//                           autofocus: true,
//                           child: TextField(
//                             controller: _textController,
//                             onSubmitted: ((value) {
//                               _textController.selection =
//                                   TextSelection.collapsed(offset: 0);
//                             }),
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10.0))),
//                               contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 13, vertical: 9),
//                             ),
//                             style: TextStyle(
//                                 fontSize: _fontSize, fontFamily: "Roboto"),
//                             maxLines: null,
//                             expands: true,
//                           ),
//                           onKey: null,
//                         )),
//                       ],
//                     ),
//                   ),
//                 )),
//                 Padding(
//                     padding: const EdgeInsets.all(5),
//                     child: ElevatedButton(
//                         onPressed: _onPressedSubmit,
//                         child: const Text("Submit")))
//               ],
//             ),
//           ),
//         ),
//         floatingActionButton: SpeedDial(
//           animatedIcon: AnimatedIcons.menu_close,
//           animatedIconTheme: IconThemeData(size: 22.0),
//           visible: true,
//           curve: Curves.bounceIn,
//           children: [
//             SpeedDialChild(
//               label: "Load Template...",
//               onTap: () async {
//                 final _template = await showDialog(
//                   context: context,
//                   builder: (context) {
//                     return FutureBuilder(
//                       future: ReportTemplate.getAll(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.done) {
//                           if (snapshot.hasData) {
//                             if (snapshot.data!.length > 0) {
//                               return _templateListView(snapshot);
//                             } else {
//                               return Center(
//                                 child: Text("No templates have been saved."),
//                               );
//                             }
//                           } else if (snapshot.hasError) {
//                             return Center(
//                               child: Text(
//                                   "Error retrieving templates from database."),
//                             );
//                           } else {
//                             return Center(
//                               child: Text("No templates have been saved"),
//                             );
//                           }
//                         } else {
//                           return Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                       },
//                     );
//                   },
//                 );
//                 if (_template != null) {
//                   _textController.text = _template;
//                 }
//               },
//             ),
//             // SpeedDialChild(
//             //   label: "Unformat",
//             //   onTap: () {
//             //     setState(() {
//             //       _textController.text = _unformat();
//             //     });
//             //   },
//             // ),
//             // SpeedDialChild(
//             //   label: "Format",
//             //   onTap: () {
//             //     setState(() {
//             //       _textController.text = _format(_textController.text);
//             //     });
//             //   },
//             // ),
//           ],
//         ));
//   }

//   //FORMATTING------------------------------------------------------------------

//   String _unformat() {
//     String temp = _textController.text;
//     temp = temp.replaceAll("\n  ", "");
//     temp = temp.replaceAll("\n    ", "");
//     return temp;
//   }

//   String _format(String input) {
//     final sb = StringBuffer();
//     final whitespacePostSplit = "    ";
//     final whitespacePreSplit = "  ";

//     bool afterSplit = false;

//     for (int i = 0; i < input.length; i++) {
//       switch (input[i]) {
//         case "@":
//           sb.write("\n\n${input[i]}");
//           break;
//         case "|":
//           if (input[i - 1] == "|") {
//             if (!afterSplit) {
//               if (input.substring(i + 1, i + 6) != "\n    ") {
//                 sb.write("${input[i]}\n$whitespacePostSplit");
//               } else {
//                 sb.write("${input[i]}\n");
//               }
//               afterSplit = true;
//             } else {
//               //only one splitter is allowed per row
//               sb.write(input[i]);
//             }
//           } else {
//             sb.write(input[i]);
//           }
//           break;
//         case "/":
//           if (input[i - 1] == "/") {
//             if (afterSplit) {
//               if (input.substring(i + 1, i + 6) != "\n    ") {
//                 sb.write("${input[i]}\n$whitespacePostSplit");
//               } else {
//                 sb.write("${input[i]}\n");
//               }
//             } else {
//               if (input.substring(i + 1, i + 4) != "\n  ") {
//                 sb.write("${input[i]}\n$whitespacePreSplit");
//               } else {
//                 sb.write("${input[i]}\n");
//               }
//             }
//           } else {
//             sb.write(input[i]);
//           }
//           break;
//         case "-":
//           if (input[i - 1] == "\n") {
//             if (input[1 + 1] != " ") {
//               sb.write("\n${input[i]} ");
//             } else {
//               sb.write("\n${input[i]}");
//             }
//             afterSplit = false;
//           } else {
//             sb.write(input[i]);
//           }
//           break;
//         case ">":
//           if (input[i - 1] == "\n" && input[i + 1] == "=") {
//             sb.write("\n\n${input[i]}");
//           } else {
//             sb.write(input[i]);
//           }
//           break;
//         case "\t":
//           //skip tabs
//           break;
//         case "\n":
//           //skip line breaks
//           break;
//         default:
//           sb.write(input[i]);
//       }
//     }
//     return sb.toString();
//   }

//   String _autoStartRow(String keyLabel, int minOffset) {
//     final sb = StringBuffer();
//     sb.write(_textController.text);

//     final strA = sb.toString().substring(0, minOffset);
//     final strB = sb.toString().substring(minOffset, sb.toString().length);

//     return "$strA- $strB";
//   }

//   String _autoCellBreak(int caretIndex) {
//     final sb = StringBuffer();
//     sb.write(_textController.text);

//     final strA = sb.toString().substring(0, caretIndex);
//     final strB = sb.toString().substring(caretIndex, sb.toString().length);

//     return "$strA|\n    $strB";
//   }

//   String _autoLineBreak(int caretIndex, bool afterSplitter) {
//     final sb = StringBuffer();
//     sb.write(_textController.text);

//     final strA = sb.toString().substring(0, caretIndex);
//     final strB = sb.toString().substring(caretIndex, sb.toString().length);

//     if (afterSplitter) {
//       return "$strA/\n    $strB";
//     } else {
//       return "$strA/\n  $strB";
//     }
//   }

//   //LOOK UP---------------------------------------------------------------------

//   Future<bool> _lookUpWords() async {
//     List<String> temp = [];

//     final connection = await Connectivity().checkConnectivity();
//     if (connection == ConnectivityResult.none) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: const Text(
//             "No Internet connection detected. Please make sure you are connected to use this feature."),
//         clipBehavior: Clip.antiAlias,
//         showCloseIcon: true,
//       ));
//       return false;
//     }

//     _textController.text = _format(_textController.text);
//     final indexStart = _textController.text.indexOf("@ New Language");
//     final indexEnd = (_textController.text.indexOf("@", indexStart + 1) != -1)
//         ? _textController.text.indexOf("@", indexStart + 1)
//         : _textController.text.indexOf(">=");
//     final chunk = _textController.text.substring(indexStart, indexEnd);
//     final terms = chunk.split("\n-");

//     //skip the first term as it is just the heading
//     for (int i = 1; i < terms.length; i++) {
//       if (terms[i].trim().length == 0) continue;

//       final String thisTerm;

//       if (terms[i].contains("||")) {
//         thisTerm = terms[i].trim().substring(0, terms[i].trim().indexOf("||"));
//       } else {
//         thisTerm = terms[i].trim();
//       }

//       if (thisTerm.isNotEmpty && thisTerm != "-") {
//         temp.add(thisTerm);
//       }
//     }

//     if (temp.isNotEmpty) {
//       _lookUpReturns.addAll(await showDialog(
//           context: context,
//           builder: ((context) {
//             return NewLanguageLookUpDialog(
//                 lookUpQueries: temp, controller: _textController);
//           })));
//       return true;
//     }
//     return false;
//   }

//   //OTHER-----------------------------------------------------------------------

//   Future<void> _saveStudent(String name) async {
//     final student = Student();
//     student.name = name;
//     student.active = true;
//     await Student.save(student);
//   }

//   void _onPressedSubmit() async {
//     String text = _unformat();
//     if (TextModeMethods.checkNeededHeadings(text)) {
//       try {
//         while (text.contains("=<") && text.contains(">=")) {
//           final start = text.indexOf("=<");
//           final stop = text.indexOf(">=");
//           final singleEntry = text.substring(start + 2, stop);
//           text = text.substring(stop + 2, text.length);

//           // divide reports into data by section
//           final report = Report.fromText(text);
//           final reportData = report.toDataObj(singleEntry);

//           //check if Student exists
//           var student = await Student.getByName(reportData.name);
//           if (student == null) {
//             await _saveStudent(reportData.name);
//             student = await Student.getByName(reportData.name);
//           }

//           //format TOPIC
//           String topic =
//               CompanionMethods.convertListToString(reportData.topic)!;
//           //format HOMEWORK
//           String? homework;
//           if (reportData.homework != null) {
//             homework =
//                 CompanionMethods.convertListToString(reportData.homework);
//           } else {
//             homework = null;
//           }

//           var lesson = await Lesson.getLesson(reportData.name, reportData.date);
//           if (lesson != null) {
//             lesson.topic = topic;
//             lesson.homework = homework;
//           } else {
//             lesson = Lesson(
//                 studentId: student!.id,
//                 date: reportData.date,
//                 topic: topic,
//                 homework: homework);
//           }
//           await Lesson.saveLesson(lesson);

//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text("Lesson saved: ${reportData.name}"),
//             clipBehavior: Clip.antiAlias,
//             showCloseIcon: true,
//           ));

//           if (reportData.tables.length > 0) {
//             try {
//               final pdfDoc = await report.toPdfDoc();
//               Navigator.push(context, MaterialPageRoute(
//                 builder: (context) {
//                   return PdfPreviewPage(pdfDocument: pdfDoc);
//                 },
//               ));
//             } catch (e) {
//               print(e.toString());
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text(
//                       "Report could not be made.\nYou may have made a mistake with you notation markers.\nPlease check them again")));
//             }
//           }
//         }
//       } on InputException {
//         final we = InputException("Name, Date, and Topic are required fields");
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(we.cause)));
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text(
//             "Error:\nPlease ensure the basic headings \"@ Name\", \"@ Date\", and \"@ Topic\" are present before continuing."),
//         clipBehavior: Clip.antiAlias,
//         showCloseIcon: true,
//       ));
//     }
//   }

//   String _shiftRow(String keyLabel) {
//     final text = _textController.text;

//     int counterStart = _textController.selection.baseOffset;
//     while (true) {
//       if (text.substring(counterStart, counterStart + 2) == "\n-" ||
//           text.substring(counterStart, counterStart + 2) == "\n@") {
//         counterStart++;
//         break;
//       }
//       counterStart--;
//     }

//     String tMarker = "-";
//     int counterEnd = text.indexOf(tMarker, counterStart + 1);
//     if (counterEnd == -1) {
//       tMarker = "@";
//       counterEnd = text.indexOf(tMarker, counterStart + 1);
//     }
//     while (true) {
//       if (text[counterEnd - 1] == "\n") {
//         break;
//       }
//       counterEnd = text.indexOf(tMarker, counterStart + 1);
//     }

//     final chunkAct = text.substring(counterStart, counterEnd);

//     if (keyLabel == "Arrow Up") {
//       //shift up
//       return "";
//     } else {
//       //shift down
//       final counterOldEnd = counterEnd;
//       counterEnd = counterStart;
//       counterStart = counterStart - 2;

//       while (true) {
//         final substring = text.substring(counterStart, counterStart + 2);
//         if (substring == "\n-" || substring == "\n@") {
//           counterStart++;
//           break;
//         }
//         counterStart--;
//       }

//       final chunkReact = text.substring(counterStart, counterEnd);

//       return text.substring(0, counterStart) +
//           chunkAct.trim() +
//           "\n" +
//           chunkReact.trim() +
//           "\n" +
//           text.substring(counterOldEnd, text.length);
//     }
//   }

//   KeyEventResult _handleKey(RawKeyEvent value) {
//     final k = value.logicalKey;

//     // this character is used to format the final report
//     if (k.keyLabel == "^") {
//       return KeyEventResult.handled;
//     }

//     if (value is RawKeyDownEvent) {
//       // print(k.keyLabel);

//       final List<int> caretIndex = [
//         _textController.selection.baseOffset,
//         _textController.selection.extentOffset
//       ];

//       if (CompanionLexer.markers.contains(k.keyLabel)) {
//         final newText = CompanionMethods.autoInsertBrackets(
//             k.keyLabel, _textController, caretIndex[0], caretIndex[1]);

//         _textController.text = newText;
//         _textController.selection = TextSelection(
//             baseOffset: caretIndex[0] + 1, extentOffset: caretIndex[1] + 1);

//         return KeyEventResult.handled;
//       } else if (value.isControlPressed) {
//         switch (k.keyLabel) {
//           case "Arrow Up":
//           case "Arrow Down":
//             _textController.text = _shiftRow(k.keyLabel);
//             _textController.selection = TextSelection(
//                 baseOffset: caretIndex[0], extentOffset: caretIndex[1]);
//             break;
//           case "S":
//             //_saveReportSync();
//             break;
//           case "B":
//             _textController.text =
//                 CompanionMethods.insertStyleSyntax("**", _textController);
//             _textController.selection = TextSelection(
//                 baseOffset: caretIndex[0] + 2, extentOffset: caretIndex[1] + 2);
//             break;
//           case "I":
//             _textController.text =
//                 CompanionMethods.insertStyleSyntax("*", _textController);
//             _textController.selection = TextSelection(
//                 baseOffset: caretIndex[0] + 1, extentOffset: caretIndex[1] + 1);
//             break;
//           case "U":
//             _textController.text =
//                 CompanionMethods.insertStyleSyntax("_", _textController);
//             _textController.selection = TextSelection(
//                 baseOffset: caretIndex[0] + 1, extentOffset: caretIndex[1] + 1);
//             break;
//           case "Enter":
//             final fullText = _textController.text;

//             final before;
//             final middle = "\n";
//             final after;
//             final newSelectionIndex;

//             final indexNextLineEnd =
//                 fullText.indexOf("\n", _textController.selection.baseOffset);

//             if (indexNextLineEnd != -1) {
//               before = fullText.substring(0, indexNextLineEnd);
//               after = fullText.substring(indexNextLineEnd, fullText.length);
//               newSelectionIndex = indexNextLineEnd;
//             } else {
//               before = fullText;
//               after = "";
//               newSelectionIndex = fullText.length + 1;
//             }

//             _textController.text = "$before$middle$after";
//             _textController.selection =
//                 TextSelection.collapsed(offset: newSelectionIndex + 1);

//             return KeyEventResult.handled;
//           case "Numpad Add":
//             //increase font size
//             setState(() {
//               _fontSize++;
//             });
//             break;
//           case "Numpad Subtract":
//             //decrease font size
//             setState(() {
//               _fontSize--;
//             });
//             break;
//           //TODO: this is just a copy from "Enter"'s body
//           case "V":
//             final fullText = _textController.text;

//             final startInd = min(caretIndex[0], caretIndex[1]);
//             final endInd = max(caretIndex[0], caretIndex[1]);

//             // final before;
//             // final after;
//             // final newSelectionIndex;

//             // final indexNextLineEnd =
//             //     fullText.indexOf("\n", _textController.selection.baseOffset);

//             // if (indexNextLineEnd != -1) {
//             //   before = fullText.substring(0, indexNextLineEnd);
//             //   after = fullText.substring(indexNextLineEnd, fullText.length);
//             //   newSelectionIndex = indexNextLineEnd;
//             // } else {
//             //   before = fullText;
//             //   after = "";
//             //   newSelectionIndex = fullText.length + 1;
//             // }

//             // _textController.text = "$before- $after";
//             // _textController.selection =
//             //     TextSelection.collapsed(offset: newSelectionIndex + 1);

//             return KeyEventResult.ignored;
//           default:
//         }
//         return KeyEventResult.ignored;
//       } else {
//         if (!_nonAutoRowStartKeys.contains(k.keyLabel) && //auto-start row
//             _textController.text[caretIndex[0] - 1] == "\n") {
//           final indexMin =
//               (caretIndex[0] < caretIndex[1]) ? caretIndex[0] : caretIndex[1];

//           _textController.text = _autoStartRow(k.keyLabel, indexMin);
//           _textController.selection = TextSelection(
//               baseOffset: caretIndex[0] + 2, extentOffset: caretIndex[1] + 2);
//         } else if (k.keyLabel == "|" && //auto-go to new line for RHS cell entry
//             (_textController.text[caretIndex[0] - 1] == "|")) {
//           _textController.text = _autoCellBreak(caretIndex[0]);
//           _textController.selection = TextSelection(
//               baseOffset: caretIndex[0] + 6, extentOffset: caretIndex[1] + 6);
//           return KeyEventResult.handled;
//         } else if (k.keyLabel == "/" && //auto-make line break in cell
//             (_textController.text[caretIndex[0] - 1] == "/")) {
//           int lineStartIndex = 0;
//           int thisIndex;

//           if (_textController.text.contains("\n-")) {
//             thisIndex = _textController.text.indexOf("\n-");

//             while (thisIndex < caretIndex[0]) {
//               lineStartIndex = thisIndex;
//               thisIndex =
//                   _textController.text.indexOf("\n-", lineStartIndex + 1);

//               if (thisIndex == -1) {
//                 lineStartIndex = _textController.text.indexOf("\n-");
//                 break;
//               }
//             }
//           } else {
//             thisIndex = _textController.text.indexOf("\n");
//           }

//           final start = lineStartIndex;
//           final end = caretIndex[0];

//           final line = _textController.text.substring(start, end);
//           if (line.contains("||") && (line.indexOf("||") < caretIndex[0])) {
//             _textController.text = _autoLineBreak(caretIndex[0], true);
//             _textController.selection = TextSelection(
//                 baseOffset: caretIndex[0] + 6, extentOffset: caretIndex[1] + 6);
//           } else {
//             _textController.text = _autoLineBreak(caretIndex[0], false);
//             _textController.selection = TextSelection(
//                 baseOffset: caretIndex[0] + 4, extentOffset: caretIndex[1] + 4);
//           }
//           return KeyEventResult.handled;
//         }
//       }
//     }
//     return KeyEventResult.ignored;
//   }

//   void _duplicateCorrections() {
//     _textController.text = _format(_textController.text);

//     final fullText = _textController.text;
//     final StringBuffer sb = StringBuffer();

//     // get the full "Corrections" text chunk
//     final indexStart = fullText.indexOf("@ Corrections") + 14;
//     final indexEnd;
//     if (fullText.indexOf("@", indexStart) != -1) {
//       indexEnd = fullText.indexOf("@", indexStart);
//     } else {
//       indexEnd = fullText.indexOf(">=");
//     }

//     final nl = fullText.substring(indexStart, indexEnd).split("\n");

//     for (final line in nl) {
//       if (line.isEmpty || line.trim().length == 0) continue;
//       if (line.endsWith(" ??")) {
//         sb.writeln(line.substring(0, line.length - 3));
//         continue;
//       }

//       if (!line.contains("||")) {
//         sb.writeln("${line.trim()} || ${line.substring(2)}");
//       } else {
//         sb.writeln(line);
//       }
//     }

//     final before = fullText.substring(0, indexStart);
//     final middle = sb.toString().trim();
//     final after = fullText.substring(indexEnd, fullText.length);

//     _textController.text = "$before\n$middle\n\n$after";
//   }
// }

// // The storage area-------------------------------------------------------------

// final _template = """@ New Language


// @ Pronunciation


// @ Corrections

// ===""";
