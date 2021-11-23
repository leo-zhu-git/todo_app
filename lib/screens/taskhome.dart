import 'dart:async';
import 'dart:ffi';

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/action1.dart';
import 'package:todo_app/model/context1.dart';
import 'package:todo_app/model/location1.dart';
import 'package:todo_app/model/tag1.dart';
import 'package:todo_app/model/goal1.dart';
import 'package:todo_app/model/customSettings.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/screens/taskdetail.dart';
import 'package:todo_app/screens/personalizeview.dart';
import 'package:todo_app/screens/swipe.dart';
import 'package:todo_app/screens/tasksearch.dart';
import 'package:todo_app/util/drawer_navigation.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo_app/util/mysql_dbhelper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todo_app/model/globals.dart' as globals;

DateTime currentDate = DateTime.now();
DateFormat formatter = DateFormat('yyyy-mm-dd');
String formattedDate = DateFormat('yyyy-mm-dd').format(currentDate);
var isChecked = false;
var isStar = false;
CustomSettings? customSetting;
MySql_DBHelper mysqlDBhelper = MySql_DBHelper();
TextStyle _textStyleControls = TextStyle(fontSize: 17.0, color: Colors.black87);
TextStyle _textStyleControlsSub = TextStyle(color: Colors.black);
TextStyle _textStyleSnack = TextStyle(
    fontSize: 16.0, color: Colors.pink[100], fontWeight: FontWeight.w600);

class TaskHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TaskHomeState();
}

class TaskHomeState extends State {
  DbHelper helper = DbHelper();
  Timer? _timer;

  List<Task>? tasklist;
  List<DisplayTask>? displaytasklist;
  int count = 0;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    tasklist = [];
    displaytasklist = [];
    _getCustomSettings();
    getData();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('MIT - Most Important Tasks');
  }

  @override
  Widget build(BuildContext context) {
    if (tasklist == null) {

    }

    return Scaffold(
      backgroundColor: Colors.teal[50],
      drawer: DrawerNagivation(),
      appBar: AppBar(
        key: _globalKey,
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
        backgroundColor: Colors.teal[800],
        elevation: 8,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, color: Colors.pink[100]),
            Text(count.toString(), style: TextStyle(color: Colors.pink[100])),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_alt_outlined, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamed('/filterview');
            },
          ),
          IconButton(
              icon: const Icon(Icons.sync, color: Colors.white),
              tooltip: 'Sync',
              onPressed: () {
//                Navigator.of(context).pushNamed('/syncview');
              }),
          IconButton(
            icon: Icon(Icons.find_in_page, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskSearch()),
              );
              getData();
            },
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            tooltip: 'Add Task',
            onPressed: () {
              navigateToDetail(Task(
                  "", "", "", "", "", "", "", "", 0, 0, "", "", "", "", ""));
              getData();
            },
          ),
        ],
      ),
      body: taskListItems(),
//      bottomNavigationBar: (Container(
//        height: 55.0,
//        child: BottomAppBar(
//          // color: Color.fromRGBO(58, 66, 86, 1.0),
//          color: Colors.teal[800],
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              IconButton(
//                icon: Icon(Icons.settings, color: Colors.white),
//                onPressed: () {
//                  Navigator.of(context).pushNamed('/personalizeview');
//                },
//              ),
//              IconButton(
//                icon: Icon(Icons.add, color: Colors.white),
//                onPressed: () {
//                  navigateToDetail(Task("", "", "", "", "", "", "", "", 0, 0,
//                      "", "", "", "", ""));
//                  getData();
//                },
//              ),
//              IconButton(
//                icon: Icon(Icons.find_in_page, color: Colors.white),
//                onPressed: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => TaskSearch()),
//                  );
//                  getData();
//                },
//              ),
//            ],
//          ),
//        ),
//      )),
    );
  }

  ListView taskListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return new Dismissible(
            key: new UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                FlutterAppBadger.updateBadgeCount(1);
                DateTime now = DateTime.now();
                String formattedDate = DateFormat('yyyy-mm-dd').format(now);
                this.tasklist![position].isDone = 1;
                this.tasklist![position].dateDone = formattedDate;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.teal[800],
                  duration: Duration(seconds: 3),
                  content: Text("Task Completed", style: _textStyleSnack),
                ));
                dbHelper.updateTask(tasklist![position]);
                getData();
              });
            },
            background: Container(
              color: Colors.teal[800],
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 2.0, left: 4.0, right: 4.0),
              child: Card(
                  color: Colors.yellow[200],
                  elevation: 8.0,
                  child: ListTile(
                    visualDensity: VisualDensity(horizontal: -4),
                    leading: Checkbox(
                      checkColor: Colors.white,
                      value: (this.tasklist![position].isDone == 1),
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                          DateTime now = DateTime.now();
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(now);
                          if (value == true) {
                            this.tasklist![position].isDone = 1;
                            this.tasklist![position].dateDone = formattedDate;
                            dbHelper.updateTask(tasklist![position]);
                            getData();
                          } else {
                            this.tasklist![position].isDone = 0;
                            this.tasklist![position].dateDone = '';
                            dbHelper.updateTask(tasklist![position]);
                            getData();
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.teal[800],
                            duration: Duration(seconds: 3),
                            content: Text("Task Saved", style: _textStyleSnack),
                          ));
                        });
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.lightbulb,
                          color: (this.tasklist![position].isStar == 0)
                              ? Colors.black12
                              : Colors.teal),
                      onPressed: () {
                        setState(() {
                          if (this.tasklist![position].isStar == 1) {
                            this.tasklist![position].isStar = 0;
                            Icon(Icons.lightbulb, color: Colors.black38);
                            dbHelper.updateTask(tasklist![position]);
                          } else {
                            this.tasklist![position].isStar = 1;
                            Icon(Icons.lightbulb, color: Colors.amber[800]);
                            dbHelper.updateTask(tasklist![position]);
                          }
                          getData();
                        });
                      },
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(
                                  this.tasklist![position].task.toString(),
                                  style: _textStyleControls,
//                                    overflow: TextOverflow.ellipsis)
                                ))),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(
                                  this.tasklist![position].sec1!,
                                  style: _textStyleControlsSub,

//                                    overflow: TextOverflow.ellipsis
                                ))),
                        SizedBox(width: 10),
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(
                                  this.tasklist![position].sec2!,
                                  style: _textStyleControlsSub,
//                                    overflow: TextOverflow.ellipsis
                                ))),
                        SizedBox(width: 10),
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(
                                  this.tasklist![position].sec3!,
                                  style: _textStyleControlsSub,
//                                    overflow: TextOverflow.ellipsis
                                ))),
                      ],
                    ),
                    isThreeLine: false,
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    onTap: () {
                      navigateToDetail(this.tasklist![position]);
                    },
                    autofocus: true,
                  )),
            ));
      },
    );
  }

  void getData() {
    int? _sortField1 = globals.sortField1 != null ? globals.sortField1 : 8;
    int? _sortField2 = globals.sortField2 != null ? globals.sortField2 : 2;
    int? _sortField3 = globals.sortField3 != null ? globals.sortField3 : 3;
    int? _sortField4 = globals.sortField4 != null ? globals.sortField4 : 0;
    int? _sortOrder1 = globals.sortOrder1 != null ? globals.sortOrder1 : 1;
    int? _sortOrder2 = globals.sortOrder2 != null ? globals.sortOrder2 : 0;
    int? _sortOrder3 = globals.sortOrder3 != null ? globals.sortOrder3 : 0;
    int? _sortOrder4 = globals.sortOrder4 != null ? globals.sortOrder4 : 0;

    int? _filterDateDue =
        globals.filterDateDue != 0 ? globals.filterDateDue : 0;
    int? _filterIsStar =
        globals.filterIsStar != "null" ? globals.filterIsStar : 0;
    int? _filterIsDone =
        globals.filterIsDone != "null" ? globals.filterIsDone : 1;

    var countDone = 0;
    final dbFuture = helper.initializeDb();

    dbFuture.then((result) {
      final tasksFuture = helper.getTasksSort(
        getSortColumn(_sortField1!),
        getOrderColumn(_sortOrder1!),
        getSortColumn(_sortField2!),
        getOrderColumn(_sortOrder2!),
        getSortColumn(_sortField3!),
        getOrderColumn(_sortOrder3!),
        getSortColumn(_sortField4!),
        getOrderColumn(_sortOrder4!),
        getDateDueColumn(_filterDateDue!),
        globals.filterCategory.toString(),
        globals.filterStatus.toString(),
        globals.filterPriority.toString(),
        globals.filterTag.toString(),
        globals.filterIsStar,
        globals.filterIsDone,
      );
      tasksFuture.then((result) {
        List<Task> taskList = [];
        List<DisplayTask> displayTaskList = [];
        count = result.length;
        for (int i = 0; i < count; i++) {
          countDone = countDone + 1;
          taskList.add(Task.fromObject(result[i]));

/////////////////
          /// display sec1
////////////////
          switch (globals.showSec1) {
            case 0:
              {
                taskList[i].sec1 = taskList[i].dateDue;
              }
              break;
            case 1:
              {
                taskList[i].sec1 = taskList[i].timeDue;
              }
              break;
            case 2:
              {
                taskList[i].sec1 = taskList[i].categoryText;
              }
              break;
            case 3:
              {
                taskList[i].sec1 = taskList[i].statusText;
              }
              break;
            case 4:
              {
                taskList[i].sec1 = taskList[i].priorityText;
              }
              break;
            case 5:
              {
                taskList[i].sec1 = taskList[i].tag1Text;
              }
              break;
            case 6:
              {
                taskList[i].sec1 = taskList[i].isStar.toString();
              }
              break;
            default:
              {
                taskList[i].sec1 = taskList[i].dateDue;
              }
              break;
          }
/////////////////
          /// display sec2
////////////////
          switch (globals.showSec2) {
            case 0:
              {
                taskList[i].sec2 = taskList[i].dateDue;
              }
              break;
            case 1:
              {
                taskList[i].sec2 = taskList[i].timeDue;
              }
              break;
            case 2:
              {
                taskList[i].sec2 = taskList[i].categoryText;
              }
              break;
            case 3:
              {
                taskList[i].sec2 = taskList[i].statusText;
              }
              break;
            case 4:
              {
                taskList[i].sec2 = taskList[i].priorityText;
              }
              break;
            case 5:
              {
                taskList[i].sec2 = taskList[i].tag1Text;
              }
              break;
            case 6:
              {
                taskList[i].sec2 = taskList[i].isStar.toString();
              }
              break;
            default:
              {
                taskList[i].sec2 = taskList[i].timeDue;
              }
              break;
          }
/////////////////
          /// display sec3
////////////////
          switch (globals.showSec3) {
            case 0:
              {
                taskList[i].sec3 = taskList[i].dateDue;
              }
              break;
            case 1:
              {
                taskList[i].sec3 = taskList[i].timeDue;
              }
              break;
            case 2:
              {
                taskList[i].sec3 = taskList[i].categoryText;
              }
              break;
            case 3:
              {
                taskList[i].sec3 = taskList[i].statusText;
              }
              break;
            case 4:
              {
                taskList[i].sec3 = taskList[i].priorityText;
              }
              break;
            case 5:
              {
                taskList[i].sec3 = taskList[i].tag1Text;
              }
              break;
            case 6:
              {
                taskList[i].sec3 = taskList[i].isStar.toString();
              }
              break;
            default:
              {
                taskList[i].sec3 = taskList[i].categoryText;
              }
              break;
          }
        }
        setState(() {
          tasklist = taskList;
          count = count;
        });
      });
    });
  }

  void navigateToDetail(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetail(task)),
    );
    getData();
  }

  //to get the custom user settings.  this in home now,  but depends on login screen logic we can move this method. KK
  _getCustomSettings() async {
    var _customSetting = await helper.getCustomSettings();
    if (_customSetting.length > 0) {
      customSetting = CustomSettings.fromObject(_customSetting[0]);
      if (customSetting != null && customSetting!.id != "") {
        if (customSetting!.sortField1 != "") {
          globals.sortField1 = int.parse(
              customSetting!.sortField1!); //convert it to session variables
        }
        if (customSetting!.sortField2 != "") {
          globals.sortField2 = int.parse(customSetting!.sortField2!);
        }
        if (customSetting!.sortField3 != "") {
          globals.sortField3 = int.parse(customSetting!.sortField3!);
        }
        if (customSetting!.sortField4 != "") {
          globals.sortField4 = int.parse(customSetting!.sortField4!);
        }
        if (customSetting!.showSec1 != "") {
          globals.showSec1 = int.parse(customSetting!.showSec1!);
        }
        if (customSetting!.showSec2 != "") {
          globals.showSec2 = int.parse(customSetting!.showSec2!);
        }
        if (customSetting!.showSec3 != "") {
          globals.showSec3 = int.parse(customSetting!.showSec3!);
        }
        if (customSetting!.filterDateDue != "") {
          globals.filterDateDue = int.parse(customSetting!.filterDateDue!);
        }
        globals.filterCategory = customSetting!.filterCategory != ""
            ? int.parse(customSetting!.filterCategory!)
            : 0;
        globals.filterStatus = customSetting!.filterStatus != ""
            ? int.parse(customSetting!.filterStatus!)
            : 0;
        globals.filterPriority = customSetting!.filterPriority != ""
            ? int.parse(customSetting!.filterPriority!)
            : 0;
        globals.filterTag = customSetting!.filterTag != ""
            ? int.parse(customSetting!.filterTag!)
            : 0;
        if (customSetting!.filterIsStar == 1) {
          globals.filterIsStar = 1;
        } else {
          globals.filterIsStar = 0;
        }
        if (customSetting!.filterIsDone == 1) {
          globals.filterIsDone = 1;
        } else {
          globals.filterIsDone = 0;
        }
      }
    }
    getData();
    setState(() {
      customSetting = customSetting;
      globals.bootstrap = 1;
    });
  }

//Sort column names are defined here but if there is any changes in column name update here
  String? getSortColumn(int column) {
    switch (column) {
      case 0:
        return "task";
        break;
      case 1:
        return "note";
        break;
      case 2:
        return "dateDue";
        break;
      case 3:
        return "timeDue";
        break;
      case 4:
        return "category";
        break;
      case 5:
        return "status";
        break;
      case 6:
        return "priority";
        break;
      case 7:
        return "tag1";
        break;
      case 8:
        return "isStar";
        break;
      case 9:
        return "isDone";
        break;

      default:
        return "task";
        break;
    }
  }

  //Sort column names are defined here but if there is any changes in column name update here
  String? getDateDueColumn(int column) {
    switch (column) {
      case 0:
        return "All Tasks";
        break;
      case 1:
        return "Today";
        break;
      case 2:
        return "Tomorrow";
        break;
      case 3:
        return "Next 7 days";
        break;
      case 4:
        return "Next 30 days";
        break;
      case 5:
        return "Any Due Date";
        break;
      case 6:
        return "No Due Date";
        break;
      case 7:
        return "Overdues Only";
        break;
      case 8:
        return "Overdues and Today";
        break;
      case 9:
        return "Overdues, Today and Tomorrow";
        break;
      default:
        return "All Tasks";
        break;
    }
  }

  //Sort column names are defined here but if there is any changes in column name update here
  String? getTimeDueColumn(int column) {
    switch (column) {
      case 0:
        return "Today";
        break;
      case 1:
        return "Tomorrow";
        break;
      case 2:
        return "Next 7 days";
        break;
      case 3:
        return "Next 30 days";
        break;
      case 4:
        return "Any Due Date";
        break;
      case 5:
        return "No Due Date";
        break;
      case 6:
        return "Overdues Only";
        break;
      case 7:
        return "All Tasks";
        break;

      default:
        return "All Tasks";
        break;
    }
  }

//Sort column names are defined here but if there is any changes in column name update here
  String? getOrderColumn(int column) {
    switch (column) {
      case 0:
        return "ASC";
        break;
      case 1:
        return "DESC";
        break;

      default:
        return "ASC";
        break;
    }
  }
}
