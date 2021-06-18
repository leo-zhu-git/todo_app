import 'package:flutter/material.dart';

class Swipe extends StatelessWidget {
  final List<String> items =
      new List<String>.generate(30, (i) => "Items ${i + 1}");
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      appBar: AppBar(
        title: Text('Swipe to dismiss'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, int index) {
          return new Dismissible(
            key: new Key(items[index]),
            onDismissed: (direction) {
              items.removeAt(index);
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text("Item Dismissed"),
              ));
            },
            background: Container(
              color: Colors.red,
            ),
            child: ListTile(
              title: Text("${items[index]}"),
            ),
          );
        },
      ),
    ));
  }
}
