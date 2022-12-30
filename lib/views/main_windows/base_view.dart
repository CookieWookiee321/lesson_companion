import 'package:flutter/material.dart';
import 'package:lesson_companion/views/main_windows/student_view.dart';
import 'package:lesson_companion/views/main_windows/text_input_mode_view.dart';

import '../dialogs/main_menu_dialog.dart';
import 'home_view.dart';
import 'lesson_view.dart';

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
    StudentsView(),
    LessonHistoryView(),
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
        //backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          TextButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => MenuMainDialog());
              },
              child: Text(
                "Options",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ))
        ],
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
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Theme.of(context).colorScheme.onBackground,
        items: const [
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
