import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/loading.dart';
import 'package:todo_app/screens/taskhome.dart';

class SyncView extends StatefulWidget {
  @override
  _SyncViewState createState() => _SyncViewState();
}

class _SyncViewState extends State<SyncView> {
  late GlobalKey<ScaffoldState> _key;

  @override
  void initState() {
    super.initState();
    mysqlDBhelper.syncTasks();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: new AppBar(
        backgroundColor: Colors.teal[800],
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Sync - never lose your data'),
        ),
      ),
//      body: LoadingView(),
    );
  }
}
