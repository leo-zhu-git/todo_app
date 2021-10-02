import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/loading.dart';
import 'package:todo_app/screens/taskhome.dart';

class SyncView extends StatefulWidget {
  @override
  _SyncViewState createState() => _SyncViewState();
}

class _SyncViewState extends State<SyncView> {
  GlobalKey<ScaffoldState> _key;

  @override
  void initState() {
    super.initState();
    await mysqlDBhelper.syncTasks();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: new AppBar(
        backgroundColor: Colors.brown[900],
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Sync - never lose your data'),
        ),
      ),
      body: Loading(),
    );
  }
}
