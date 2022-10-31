import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lesson_companion/views/companion_widgets.dart';
import 'package:lesson_companion/views/home_view.dart';
import 'package:lesson_companion/views/lesson_list/lesson_list_view.dart';
import 'package:lesson_companion/views/student_list_view.dart';
import 'package:lesson_companion/views/text_input_mode_view.dart';

class BaseView extends StatefulWidget {
  const BaseView({super.key});

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = [
    HomeView(),
    TextInputModeView(),
    StudentView(),
    LessonView(),
    HomeView()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lesson Companion"),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedIconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.primary),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Theme.of(context).colorScheme.onBackground,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Text Mode"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Students"),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "Lessons"),
          BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner), label: "Reports")
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
