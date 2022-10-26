import 'package:flutter/material.dart';
import 'package:lesson_companion/models/data_storage.dart';

import 'companion_widgets.dart';

class StudentView extends StatefulWidget {
  const StudentView({Key? key}) : super(key: key);

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Student List"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: StudentListRow(),
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
            return Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                margin: const EdgeInsets.fromLTRB(13.0, 6, 13, 0),
                padding: const EdgeInsets.all(6),
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.person_2_rounded),
                        title: Text(snapshot.data![index]),
                      );
                    }));
          } else {
            Center(
              child: Text("Failed to load students"),
            );
          }
        }
        //TODO: handle error connection state
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
      future: DataStorage.getAllStudentNames(),
    );
  }
}
