import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todo_app/screens/loading.dart';
import 'package:todo_app/screens/taskhome.dart';

class SyncView extends StatefulWidget {
  @override
  _SyncViewState createState() => _SyncViewState();
}

class _SyncViewState extends State<SyncView> {
  late GlobalKey<ScaffoldState> _key;
  TextStyle _textStyleSnack = TextStyle(
      fontSize: 16.0, color: Colors.pink[100], fontWeight: FontWeight.w600);

  @override
  void initState() {
    super.initState();
    getData();
    Navigator.pop(context);
  }

  void getData() async {

    EasyLoading.showProgress(0.3, status: 'Downloading ...');
    
// wait for leo's code
//    mysqlDBhelper.syncTasks();
    await Future.delayed(Duration(seconds: 5), () {});

    await EasyLoading.showSuccess('Sync completed successfully');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: new AppBar(
        backgroundColor: Colors.teal[800],
        automaticallyImplyLeading: false,
        title: Center(
          child: Icon(Icons.sync, color: Colors.white),
        ),
      ),
    );
  }
}
