import 'package:flutter/material.dart';
import 'package:lesson_companion/views/main_windows/text_input_mode_view.dart';

import '../dialogs/main_menu_dialog.dart';
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
    TextEditorView(),
    LessonHistoryView(),
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
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          TextButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => MenuMainDialog());
              },
              child: const Text("Options"))
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: SizedBox(
        height: 58,
        child: BottomNavigationBar(
          showSelectedLabels: false,
          type: BottomNavigationBarType.shifting,
          selectedIconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.primary),
          selectedItemColor: Theme.of(context).colorScheme.primary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedItemColor: Theme.of(context).colorScheme.onBackground,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.note), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.school), label: "Lessons"),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
