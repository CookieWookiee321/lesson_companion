import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:lesson_companion/models/database.dart';
import 'package:lesson_companion/views/main_windows/base_view.dart';
import 'package:lesson_companion/views/dialogs/main_menu_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/styler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    DesktopWindow.setMinWindowSize(const Size(500, 700));
    //DesktopWindow.setMaxWindowSize(const Size(1000, 1000));
    DesktopWindow.setWindowSize(const Size(500, 700));
  }

  await initialSettings();

  runApp(const MyApp());
}

Future<void> initialSettings() async {
  final checker = await Database.getSetting(SharedPrefOption.darkMode);

  if (checker != null) {
    return;
  } else {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "footer", "Customise your footer in the options menu!");
    await prefs.setBool("darkMode", false);
  }
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
      // home: FutureBuilder(
      //     future: FreeDictionary.fetchJson(
      //         "https://api.dictionaryapi.dev/api/v2/entries/en/purple"),
      //     builder: ((context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.done) {
      //         return LookUpCard(details: LookUp(snapshot.data!));
      //       }
      //       return CircularProgressIndicator();
      //     }))
      home: BaseView(),
    );
  }
}
