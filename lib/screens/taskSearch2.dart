import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/model/globals.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/screens/taskdetail.dart';
import 'package:todo_app/model/customDropdownItem.dart';
import 'package:todo_app/model/customSettings.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/globals.dart' as globals;

class TaskSearch2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TaskSearch2State();
}

class TaskSearch2State extends State {
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

//##########################################end of Dropdown #################################################################

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.black38],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            TextField(
              autofocus: true,
            ),
            TextField(
            ),
            TextField(
              focusNode: myFocusNode,
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => FocusScope.of(context).requestFocus(myFocusNode)
        ),
    );
  }
}

