import 'package:flutter/material.dart';
import 'package:todo_app/screens/taskhome.dart';

import '../widgets/login.dart';

import 'package:todo_app/model/todouser.dart';
import 'package:todo_app/util/dbhelper.dart';

class EntryScreen extends StatefulWidget {
  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  var _todoUser = todoUser();
  var _dbHelper = DbHelper();
  bool userexist = true;

  @override
  void initState() {
    super.initState();
    gettodoUser();
  }

  @override
  void dispose() {
    // DO STUFF
    super.dispose();
  }

  gettodoUser() async {
    var todousers = await _dbHelper.getUser();
    if (todousers.length > 0) {
      userexist = true;
      // Navigator.of(context).pushNamed('/dashboard');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskHome(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      body: Center(
        child: Login(),
      ),
    );
  }
}
