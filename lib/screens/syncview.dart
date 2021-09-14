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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: Center(
          child: SpinKitRotatingCircle(
            color: Colors.white,
            size: 50,
          ),
        ));
  }
}
