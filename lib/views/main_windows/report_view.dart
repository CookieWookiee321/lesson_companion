import 'package:flutter/material.dart';
import 'package:lesson_companion/models/report.dart';
import 'package:lesson_companion/models/report_details.dart';

//==============================================================================
//Report View
//==============================================================================
class ReportsView extends StatefulWidget {
  const ReportsView({Key? key}) : super(key: key);

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ReportsListView(),
    );
  }
}

//==============================================================================
//Report List View
//==============================================================================
class ReportsListView extends StatefulWidget {
  const ReportsListView({Key? key}) : super(key: key);

  @override
  State<ReportsListView> createState() => _ReportsListViewState();
}

class _ReportsListViewState extends State<ReportsListView> {
  List<Report>? _reports;

  final _scrollController = ScrollController(keepScrollOffset: true);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Map<Report, ReportDetails>> _getReportDetails() async {
    final output = <Report, ReportDetails>{};
    final reports = await Report.getAllReports();
    for (final r in reports) {
      final map = r.toMap(r.text!);
      output[r] = ReportDetails(
          map["Name"]!.first,
          map["Date"]!.first,
          map["Topic"]!.first,
          (map["Homework"] != null) ? map["Homework"]!.first : "");
    }
    return output;
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getReportDetails(),
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
                  controller: _scrollController,
                  itemCount: _reports!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.values.elementAt(index).name),
                      subtitle: Text(
                          "Date: ${snapshot.data!.values.elementAt(index).date}"),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return _menuDialog(index);
                          },
                        );
                      },
                    );
                  }),
            );
          } else {
            return Center(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  margin: const EdgeInsets.fromLTRB(13.0, 6, 13, 0),
                  padding: const EdgeInsets.all(6),
                  child: Text("Error. Failed to load database.")),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  AlertDialog _menuDialog(int index) {
    return AlertDialog(
        // title: Text("Report Menu"),
        // content: Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     OutlinedButton(
        //         child: Text("Edit"),
        //         onPressed: () async {
        //           await showDialog(
        //                   context: context,
        //                   builder: (context) => _editDialog(index))
        //               .then((value) => Navigator.pop(context));
        //         }),
        //     Padding(padding: EdgeInsets.symmetric(vertical: 4)),
        //     OutlinedButton(
        //         child: Text("Delete"),
        //         onPressed: () async {
        //           await showDialog(
        //                   context: context,
        //                   builder: (context) => _deleteDialog(index))
        //               .then((value) => Navigator.pop(context));
        //         })
        //   ],
        // ),
        );
  }

  AlertDialog _deleteDialog(int index) {
    return AlertDialog(
        // content: Text(
        //   "Are you sure you want to delete this report?\n(All lessons for this report will be deleted too)",
        //   style: Theme.of(context).textTheme.labelSmall,
        // ),
        // actions: [
        //   TextButton(
        //       child: Text("Yes"),
        //       onPressed: () async {
        //         final s = _reports!
        //             .where((element) =>
        //                 element.name == _namesAndCountMap!.keys.elementAt(index))
        //             .first;

        //         await Database.deleteReport(s.id).then((value) {
        //           setState(() {});
        //           Navigator.pop(context);
        //         });
        //       }),
        //   TextButton(
        //       child: Text("No"),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       })
        // ],
        );
  }
}
