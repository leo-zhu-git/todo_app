import 'package:flutter/material.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/screens/LocalNotification_screen.dart';
import 'package:todo_app/screens/loading.dart';
import 'package:todo_app/screens/signUp.dart';
import 'package:todo_app/screens/signin.dart';
import 'package:todo_app/screens/personalizeview.dart';
import 'package:todo_app/screens/syncview.dart';
import 'package:todo_app/screens/swipe.dart';
import 'package:todo_app/screens/taskdetail.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter/services.dart';

import 'package:flutter_login/flutter_login.dart';

import 'screens/entry.dart';
import 'screens/confirm.dart';
import 'screens/confirm_reset.dart';

//import 'package:todo_app/screens/ExpandApp.dart';

void main() {
//  runApp(MyApp());
  // runApp(new TileApp1());
  //runApp(Swipe());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

    initPlatformState() async {
    String appBadgeSupported;
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        appBadgeSupported = 'Supported';
      } else {
        appBadgeSupported = 'Not supported';
      }
    } on PlatformException {
      appBadgeSupported = 'Failed to get badge support.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
//    if (!mounted) return;

//    setState(() {
//      _appBadgeSupported = appBadgeSupported;
//    });
  }

    void _addBadge() {
    FlutterAppBadger.updateBadgeCount(1);
  }

  void _removeBadge() {
    FlutterAppBadger.removeBadge();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      
      onGenerateRoute: (settings) {
        if (settings.name == '/confirm') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ConfirmScreen(data: settings.arguments as LoginData),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        if (settings.name == '/confirm-reset') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ConfirmResetScreen(data: settings.arguments as LoginData),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        if (settings.name == '/dashboard') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => TaskHome(),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }
        if (settings.name == '/personalizeview') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => PersonalizeView(),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        if (settings.name == '/syncview') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => SyncView(),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        if (settings.name == '/loading') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => Loading(),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        FlutterAppBadger.updateBadgeCount(2); 

        return MaterialPageRoute(builder: (_) => EntryScreen());
      },
    );
  }
}

