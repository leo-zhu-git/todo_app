import 'package:flutter/material.dart';

class NotifyScreen extends StatefulWidget {
  @override
  _NotifyScreenState createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Notification')),
      body: Center(
        child: FlatButton(
          onPressed: (){

          },
          child: Text('Send Notification'),
        )
      ),
    );
  }
}
