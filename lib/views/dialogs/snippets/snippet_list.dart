import 'package:flutter/material.dart';
import 'package:lesson_companion/models/style_snippet.dart';
import 'package:lesson_companion/views/dialogs/snippets/snippet_builder.dart';

class SnippetList extends StatefulWidget {
  const SnippetList({super.key});

  @override
  State<SnippetList> createState() => SnippetListState();
}

class SnippetListState extends State<SnippetList> {
  AlertDialog _snippetEditMenu(StyleSnippet snippet) {
    return AlertDialog(
      title: Text("Style Snippet Menu"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        OutlinedButton(
            onPressed: () async {
              Navigator.pop(context);
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SnippetBuilder(marker: snippet),
                  ));
            },
            child: Text("Edit")),
        Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
        OutlinedButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return _confirmMenu(snippet.marker);
                },
              ).then((value) => Navigator.pop(context));
              setState(() {});
            },
            child: Text("Delete"))
      ]),
    );
  }

  AlertDialog _confirmMenu(String marker) {
    return AlertDialog(
      scrollable: true,
      content: Text("Are you sure you want to delete this snippet?"),
      actions: [
        TextButton(
          child: Text("Yes"),
          onPressed: () async {
            await StyleSnippet.deleteSnippet(marker);
            Navigator.pop(context);
          },
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No"))
      ],
    );
  }

  ListView _snippetListView(List<StyleSnippet> list) {
    return ListView(
      shrinkWrap: true,
      children: [
        ...list.map((e) {
          return ListTile(
            leading: Text(e.marker),
            title: RichText(text: TextSpan(text: "hello")),
            onTap: () async {
              await showDialog(
                      context: context,
                      builder: (context) => _snippetEditMenu(e))
                  .then((value) => setState(() {}));
            },
          );
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Style Snippet Menu"),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
                icon: Icon(Icons.exposure_plus_1),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => SnippetBuilder(),
                  );
                  setState() {}
                  ;
                }),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiaryContainer)),
                    child: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: FutureBuilder(
                          future: StyleSnippet.getAllSnippets(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                return _snippetListView(snapshot.data!);
                              }
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
