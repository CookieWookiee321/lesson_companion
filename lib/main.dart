//TODO: message on look up no results
//TODO: style functions
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
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

  final fontSize = await db.Database.getSetting(SharedPrefOption.fontSize);
  if (fontSize == null) {
    await db.Database.saveSetting(SharedPrefOption.fontSize, 11.0);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  /// 1) our themeMode "state" field
  ThemeMode _themeMode = ThemeMode.system;

  /// 3) Call this to change theme from any context using "of" accessor
  /// e.g.:
  /// MyApp.of(context).changeTheme(ThemeMode.dark);
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  void initState() {
    Database.getSetting(SharedPrefOption.darkMode)!.then((value) {
      if (value) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lesson Companion',
      theme:
          ThemeData(useMaterial3: true, colorScheme: Styler.lightColorScheme),
      darkTheme:
          ThemeData(useMaterial3: true, colorScheme: Styler.darkColorScheme),
      themeMode: _themeMode,
      home: const BaseView(),

      // home: FutureBuilder(
      //     future: FreeDictionary.fetchJson(
      //         "https://api.dictionaryapi.dev/api/v2/entries/en/purple"),
      //     builder: ((context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.done) {
      //         return LookUpCard(details: LookUp(snapshot.data!));
      //       }
      //       return CircularProgressIndicator();
      //     }))
    );
  }
}
