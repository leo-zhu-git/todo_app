import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
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
// import 'package:todo_app/screens/personalizeview.dart';
import 'package:todo_app/screens/swipe.dart';
import 'package:todo_app/screens/tasksearch.dart';
import 'package:todo_app/util/drawer_navigation.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo_app/util/mysql_dbhelper.dart';
import 'package:todo_app/model/globals.dart' as globals;

DateTime currentDate = DateTime.now();
DateFormat formatter = DateFormat('yyyy-mm-dd');
String formattedDate = DateFormat('yyyy-mm-dd').format(currentDate);
var isChecked = false;
CustomSettings customSetting;
MySql_DBHelper mysqlDBhelper = MySql_DBHelper();

class TaskHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TaskHomeState();
}

class TaskHomeState extends State {
  DbHelper helper = DbHelper();

  List<Task> tasklist;
  List<DisplayTask> displaytasklist;
  int count = 0;
  @override
  void initState() {
    super.initState();
    tasklist = List<Task>();
    displaytasklist = List<DisplayTask>();
    _getCustomSettings();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    if (tasklist == null) {
      // tasklist = List<Task>();
      // displaytasklist = List<DisplayTask>();
      //  getData();  // get data moved inside getcustom settings.

    }

    return Scaffold(
      backgroundColor: Colors.teal[50],
      drawer: DrawerNagivation(),
      appBar: AppBar(
        key: _globalKey,
        backgroundColor: Colors.brown[900],
        elevation: 8,
        title: Center(
//          child: Container(
//            child: Row(
//              children: [
//                Text('View '),
//                Container(
//                  decoration: BoxDecoration(
//                  shape: BoxShape.rectangle, color: Colors.blue[100]),
//                  child: Padding(
//                  padding: const EdgeInsets.all(2.0),
//                  child: Text(
//                    count.toString(),
//                    style: TextStyle(backgroundColor: Colors.green[100], color: Colors.black)),
//                  ),
//                ),
//              ]
//            )
//          ),
//        ),

          child: Column(
            children: <Widget>[
              Badge(
                child: Text('View          '),
                shape: BadgeShape.square,
                position: BadgePosition.topEnd(),
                badgeContent: Text(count.toString(),
                    style: TextStyle(color: Colors.black)),
                badgeColor: Colors.yellow[200],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.sync, color: Colors.white),
              tooltip: 'Sync',
              onPressed: () {
                Navigator.of(context).pushNamed('/syncview');
// rt: comment out temporarily to test loader/ spinkit --> code in syncview
              }),
        ],
      ),
      body: taskListItems(),
      bottomNavigationBar: (Container(
        height: 55.0,
        child: BottomAppBar(
          // color: Color.fromRGBO(58, 66, 86, 1.0),
          color: Colors.brown[900],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.dashboard_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushNamed('/personalizeview');
                },
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  navigateToDetail(Task("", "", "", "", "", "", "", "", "", "",
                      "", "", 0, 0, "", "", "", "", "", "", ""));
                  getData();
                },
              ),
              IconButton(
                icon: Icon(Icons.find_in_page, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskSearch()),
                  );
                },
              ),
            ],
          ),
        ),
      )),
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
                DateTime now = DateTime.now();
                String formattedDate = DateFormat('yyyy-mm-dd').format(now);
                this.tasklist[position].isDone = 1;
                this.tasklist[position].status = "Completed";
                this.tasklist[position].dateDone = formattedDate;
                dbHelper.updateTask(tasklist[position]);
                //this.tasklist.removeAt(position);
                getData();
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Item Dismissed"),
                ));
              });
            },
            background: Container(
              color: Colors.brown,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
              child: Card(
                  color: Colors.yellow[200],
                  elevation: 8.0,
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(this.tasklist[position].main1,
                                    overflow: TextOverflow.ellipsis))),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        // Text(this.tasklist[position].sec1),
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(this.tasklist[position].sec1,
                                    overflow: TextOverflow.ellipsis))),
                      ],
                    ),
                    isThreeLine: false,
                    secondary: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        navigateToDetail(this.tasklist[position]);
                      },
                    ),
                    dense: true,
                    value: (this.tasklist[position].isDone == 1),
                    onChanged: (value) {
                      setState(() {
                        DateTime now = DateTime.now();
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(now);
                        if (value == true) {
                          this.tasklist[position].isDone = 1;
                          this.tasklist[position].status = "Completed";
                          this.tasklist[position].dateDone = formattedDate;
                          dbHelper.updateTask(tasklist[position]);
//                          _showSuccessSnackBar(Container(
//                            color: Colors.tealAccent[100],
//                            height: 40,
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: [
//                                (Icon(
//                                  Icons.thumb_up,
//                                  color: Colors.black,
//                                )),
//                                Text(
//                                  ' Task Completed - Satisfaction... ',
//                                  style: (TextStyle(color: Colors.black)),
//                                )
//                              ],
//                            ),
//                          ));
                        } else {
                          this.tasklist[position].isDone = 0;
                          this.tasklist[position].status = "Open";
                          this.tasklist[position].dateDone = '';
                          dbHelper.updateTask(tasklist[position]);
                        }
                      });
                    },
                    activeColor: Colors.brown[900],
                    checkColor: Colors.white,
                    autofocus: true,
                  )),
            ));
      },
    );
  }

  void getData() {
    int _sortField1 = globals.sortField1 != null ? globals.sortField1 : 2;
    int _sortField2 = globals.sortField2 != null ? globals.sortField2 : 4;
    int _sortField3 = globals.sortField3 != null ? globals.sortField3 : 0;
    int _sortOrder1 = globals.sortOrder1 != null ? globals.sortOrder1 : 0;
    int _sortOrder2 = globals.sortOrder2 != null ? globals.sortOrder2 : 0;
    int _sortOrder3 = globals.sortOrder3 != null ? globals.sortOrder3 : 0;

    int _filterDateDue =
        globals.filterDateDue != null ? globals.filterDateDue : 7;
    int _filterIsDone = globals.filterIsDone != null ? globals.filterIsDone : 0;

    var countDone = 0;
    final dbFuture = helper.initializeDb();

    dbFuture.then((result) {
      final tasksFuture = helper.getTasksSort(
        getSortColumn(_sortField1),
        getOrderColumn(_sortOrder1),
        getSortColumn(_sortField2),
        getOrderColumn(_sortOrder2),
        getSortColumn(_sortField3),
        getOrderColumn(_sortOrder3),
        getDateDueColumn(_filterDateDue),
//          getDateDueColumn(_filterTimeDue),
        globals.filterStatus.toString(),
        globals.filterPriority.toString(),
        globals.filterCategory.toString(),
        globals.filterAction.toString(),
        globals.filterContext.toString(),
        globals.filterLocation.toString(),
        globals.filterTag.toString(),
        globals.filterGoal.toString(),
        globals.filterIsStar,
        globals.filterIsDone,
      );
      // final tasksFuture = helper.getTasksFromLastFewDays();
      tasksFuture.then((result) {
        List<Task> taskList = List<Task>();
        List<DisplayTask> displaytaskList = List<DisplayTask>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          countDone = countDone + 1;
          taskList.add(Task.fromObject(result[i]));

/////////////////
          /// display main1
////////////////
          switch (globals.showMain1) {
            case 0:
              {
                taskList[i].main1 = taskList[i].task;
              }
              break;
            case 1:
              {
                taskList[i].main1 = taskList[i].note;
              }
              break;
            case 2:
              {
                taskList[i].main1 = taskList[i].dateDue;
              }
              break;
            case 3:
              {
                taskList[i].main1 = taskList[i].timeDue;
              }
              break;
            case 4:
              {
                taskList[i].main1 = taskList[i].isStar.toString();
              }
              break;
            case 5:
              {
                taskList[i].main1 = taskList[i].statusText;
              }
              break;
            case 6:
              {
                taskList[i].main1 = taskList[i].priorityText;
              }
              break;
            case 7:
              {
                taskList[i].main1 = taskList[i].categoryText;
              }
              break;
            case 8:
              {
                taskList[i].main1 = taskList[i].action1Text;
              }
              break;
            case 9:
              {
                taskList[i].main1 = taskList[i].context1Text;
              }
              break;
            case 10:
              {
                taskList[i].main1 = taskList[i].location1Text;
              }
              break;
            case 11:
              {
                taskList[i].main1 = taskList[i].tag1Text;
              }
              break;
            case 12:
              {
                taskList[i].main1 = taskList[i].goal1Text;
              }
              break;
            default:
              {
                taskList[i].main1 = taskList[i].task;
              }
              break;
          }

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
                taskList[i].sec1 = taskList[i].statusText;
              }
              break;
            case 3:
              {
                taskList[i].sec1 = taskList[i].priorityText;
              }
              break;
            case 4:
              {
                taskList[i].sec1 = taskList[i].categoryText;
              }
              break;
            case 5:
              {
                taskList[i].sec1 = taskList[i].action1Text;
              }
              break;
            case 6:
              {
                taskList[i].sec1 = taskList[i].context1Text;
              }
              break;
            case 7:
              {
                taskList[i].sec1 = taskList[i].location1Text;
              }
              break;
            case 8:
              {
                taskList[i].sec1 = taskList[i].tag1Text;
              }
              break;
            case 9:
              {
                taskList[i].sec1 = taskList[i].goal1Text;
              }
              break;
            case 10:
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
                taskList[i].sec2 = taskList[i].statusText;
              }
              break;
            case 3:
              {
                taskList[i].sec2 = taskList[i].priorityText;
              }
              break;
            case 4:
              {
                taskList[i].sec2 = taskList[i].categoryText;
              }
              break;
            case 5:
              {
                taskList[i].sec2 = taskList[i].action1Text;
              }
              break;
            case 6:
              {
                taskList[i].sec2 = taskList[i].context1Text;
              }
              break;
            case 7:
              {
                taskList[i].sec2 = taskList[i].location1Text;
              }
              break;
            case 8:
              {
                taskList[i].sec2 = taskList[i].tag1Text;
              }
              break;
            case 9:
              {
                taskList[i].sec2 = taskList[i].goal1Text;
              }
              break;
            case 10:
              {
                taskList[i].sec2 = taskList[i].isStar.toString();
              }
              break;

            default:
              {
                taskList[i].sec2 = taskList[i].priorityText;
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
                taskList[i].sec3 = taskList[i].statusText;
              }
              break;
            case 3:
              {
                taskList[i].sec3 = taskList[i].priorityText;
              }
              break;
            case 4:
              {
                taskList[i].sec3 = taskList[i].categoryText;
              }
              break;
            case 5:
              {
                taskList[i].sec3 = taskList[i].action1Text;
              }
              break;
            case 6:
              {
                taskList[i].sec3 = taskList[i].context1Text;
              }
              break;
            case 7:
              {
                taskList[i].sec3 = taskList[i].location1Text;
              }
              break;
            case 8:
              {
                taskList[i].sec3 = taskList[i].tag1Text;
              }
              break;
            case 9:
              {
                taskList[i].sec3 = taskList[i].goal1Text;
              }
              break;
            case 10:
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
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetail(task)),
    );
//    if (result == true) {
    getData();
//    }
  }

  //to get the custom user settings.  this in home now,  but depends on login screen logic we can move this method. KK
  _getCustomSettings() async {
    var _customSetting = await helper.getCustomSettings();
    if (_customSetting.length > 0) {
      customSetting = CustomSettings.fromObject(_customSetting[0]);
      if (customSetting != null && customSetting.id != null) {
        if (customSetting.sortField1 != "") {
          globals.sortField1 = int.parse(
              customSetting.sortField1); //convert it to session variables
        }
        if (customSetting.sortField2 != "") {
          globals.sortField2 = int.parse(customSetting.sortField2);
        }
        if (customSetting.sortField3 != "") {
          globals.sortField3 = int.parse(customSetting.sortField3);
        }
        if (customSetting.showMain1 != "") {
          globals.showMain1 = int.parse(customSetting.showMain1);
        }
        if (customSetting.showMain2 != "") {
          globals.showMain2 = int.parse(customSetting.showMain2);
        }
        if (customSetting.showSec1 != "") {
          globals.showSec1 = int.parse(customSetting.showSec1);
        }
        if (customSetting.showSec2 != "") {
          globals.showSec2 = int.parse(customSetting.showSec2);
        }
        if (customSetting.showSec3 != "") {
          globals.showSec3 = int.parse(customSetting.showSec3);
        }
        if (customSetting.filterIsDone == true) {
          globals.filterIsDone = 1;
        }
        if (customSetting.filterDateDue != "") {
          globals.filterDateDue = int.parse(customSetting.filterDateDue);
        }
        globals.filterStatus = customSetting.filterStatus != ""
            ? int.parse(customSetting.filterStatus)
            : 0;
        globals.filterPriority = customSetting.filterPriority != ""
            ? int.parse(customSetting.filterPriority)
            : 0;
        globals.filterCategory = customSetting.filterCategory != ""
            ? int.parse(customSetting.filterCategory)
            : 0;
        globals.filterLocation = customSetting.filterLocation != ""
            ? int.parse(customSetting.filterLocation)
            : 0;
        globals.filterTag = customSetting.filterTag != ""
            ? int.parse(customSetting.filterTag)
            : 0;
        globals.filterGoal = customSetting.filterGoal != ""
            ? int.parse(customSetting.filterGoal)
            : 0;
        globals.filterContext = customSetting.filterContext != ""
            ? int.parse(customSetting.filterContext)
            : 0;
        globals.filterAction = customSetting.filterAction != ""
            ? int.parse(customSetting.filterAction)
            : 0;
      }
    }
    getData();
    setState(() {
      customSetting = customSetting;
      globals.bootstrap = 1;
    });
  }

//Sort column names are defined here but if there is any changes in column name update here
  String getSortColumn(int column) {
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
        return "status";
        break;
      case 5:
        return "priority";
        break;
      case 6:
        return "category";
        break;
      case 7:
        return "action1";
        break;
      case 8:
        return "context1";
        break;
      case 9:
        return "location1";
        break;
      case 10:
        return "tag1";
        break;
      case 11:
        return "goal1";
        break;
      case 12:
        return "star";
        break;

      default:
        return "task";
        break;
    }
  }

  //Sort column names are defined here but if there is any changes in column name update here
  String getShowColumn(int column) {
    switch (column) {
      case 0:
        return "dateDue";
        break;
      case 1:
        return "timeDue";
        break;
      case 2:
        return "status";
        break;
      case 3:
        return "priority";
        break;
      case 4:
        return "category";
        break;
      case 5:
        return "action1";
        break;
      case 6:
        return "context1";
        break;
      case 7:
        return "location1";
        break;
      case 8:
        return "tag1";
        break;
      case 9:
        return "goal1";
        break;
      case 10:
        return "star";
        break;

      default:
        return "dateDue";
        break;
    }
  }

  //Sort column names are defined here but if there is any changes in column name update here
  String getDateDueColumn(int column) {
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

      default:
        return "All Tasks";
        break;
    }
  }

  //Sort column names are defined here but if there is any changes in column name update here
  String getTimeDueColumn(int column) {
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
  String getOrderColumn(int column) {
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
