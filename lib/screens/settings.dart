import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SettingsForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsFormState();
}

class SettingsFormState extends State {
  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Capture It!'),
        ),
      ),
      body: Text('hi'),
    );
  }
}
