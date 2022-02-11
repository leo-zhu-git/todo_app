import 'dart:async';

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
    syncData();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // DO STUFF
    super.dispose();
  }

  void syncData() async {
    Timer? _timer;
    late double _progress;

    {
      _progress = 0;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
        EasyLoading.showProgress(_progress,
            status: '${(_progress * 100).toStringAsFixed(0)}%');
        _progress += 0.03;

        if (_progress >= 1) {
          _timer?.cancel();
          EasyLoading.dismiss();
        }
      });
    }
    EasyLoading.showProgress(0.3, status: 'Syncing ...');
    await Future.delayed(Duration(seconds: 5), () {});

// wait for leo's code
//    mysqlDBhelper.syncTasks();

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
