import 'package:flutter/material.dart';
import 'package:lesson_companion/models/data_storage.dart';

import 'companion_widgets.dart';

class StudentListView extends StatefulWidget {
  const StudentListView({Key? key}) : super(key: key);

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Student List"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: Column(
          children: const [StudentListRow()],
        ),
        bottomNavigationBar: const BottomBar());
  }
}

//==============================================================================
//COMPONENTS
//==============================================================================

class StudentListRow extends StatefulWidget {
  const StudentListRow({Key? key}) : super(key: key);

  @override
  State<StudentListRow> createState() => _StudentListRowState();
}

class _StudentListRowState extends State<StudentListRow> {
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final data = snapshot.data as String;

            return Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                margin: const EdgeInsets.fromLTRB(13.0, 6, 13, 0),
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Text(
                      data,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ));
          }
        }
        //TODO: handle error connection state
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
      future: DataStorage.getStudentName(0),
    );
  }
}
