import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'controllers/styler.dart';
import 'views/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final Directory appDocDir = await getApplicationDocumentsDirectory();
  // await Hive.initFlutter(appDocDir.path);

  // Hive.registerAdapter(SettingAdapter());
  // Hive.registerAdapter(StudentAdapter());
  // Hive.registerAdapter(LessonAdapter());
  // Hive.registerAdapter(ReportAdapter());
  // await Hive.openBox<Student>('student_box');
  // await Hive.openBox<Lesson>('lesson_box');
  // await Hive.openBox<Report>('report_box');
  // await Hive.openBox<Setting>('settings_box');

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    DesktopWindow.setMinWindowSize(const Size(500, 700));
    //DesktopWindow.setMaxWindowSize(const Size(1000, 1000));
    DesktopWindow.setWindowSize(const Size(500, 700));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lesson Companion',
      theme:
          ThemeData(useMaterial3: true, colorScheme: Styler.lightColorScheme),
      darkTheme:
          ThemeData(useMaterial3: true, colorScheme: Styler.darkColorScheme),
      //home: StudentListView(),
      home: const HomeView(),
    );
  }
}
