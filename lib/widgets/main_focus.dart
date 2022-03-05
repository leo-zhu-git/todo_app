
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override 

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: TaskSearch2(),
    );
  }
}

class TaskSearch2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TaskSearch2State();
}

class TaskSearch2State extends State {
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.black38],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            TextField(
            ),
            TextField(
              autofocus: true,
            ),
            TextField(
              focusNode: myFocusNode,
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => FocusScope.of(context).requestFocus(myFocusNode)
        ),
    );
  }
}
