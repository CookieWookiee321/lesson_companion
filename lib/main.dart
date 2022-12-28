//TODO: "cntrl + __" shortcuts
//TODO: message on look up no results
//TODO: style functions
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:lesson_companion/models/database.dart' as db;
import 'package:lesson_companion/models/database.dart';
import 'package:lesson_companion/views/main_windows/base_view.dart';
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
  final checker = await db.Database.getSetting(SharedPrefOption.darkMode);
  final prefs = await SharedPreferences.getInstance();

  if (checker == null) {
    await prefs.setString(
        "footer", "Customise your footer in the options menu!");
    await prefs.setBool("darkMode", false);
  }

  final dictionaryCompiled =
      await db.Database.getSetting(SharedPrefOption.dictionary);
  if (dictionaryCompiled == null) {
    final response = await http
        .get(Uri.parse("http://www.mieliestronk.com/corncob_lowercase.txt"));
    final fullText = utf8.decode(response.bodyBytes);
    await prefs.setStringList("dictionary", fullText.split("\r\n"));
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
      home: const BaseView(),
    );
  }
}
