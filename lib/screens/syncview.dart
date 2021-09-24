import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SyncView extends StatefulWidget {
  @override
  _SyncViewState createState() => _SyncViewState();
}

class _SyncViewState extends State<SyncView> {
  GlobalKey<ScaffoldState> _key;

  @override
  void initState() {
    super.initState();
    mysqlDBhelper.syncTasks();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        body: Center(
          child: SpinKitFoldingCube(
            color: Colors.yellow[200],
            size: 100,
          ),
        ));
  }
}
