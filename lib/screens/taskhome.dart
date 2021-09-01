import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/customSettings.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/screens/customizeview.dart';
import 'package:todo_app/screens/swipe.dart';
import 'package:todo_app/screens/tasksearch.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/screens/taskdetail.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/util/drawer_navigation.dart';
import 'package:todo_app/model/globals.dart' as globals;
import 'package:todo_app/util/mysql_dbhelper.dart';

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

  @override
  Widget build(BuildContext context) {
    if (tasklist == null) {
      // tasklist = List<Task>();
      // displaytasklist = List<DisplayTask>();
      //  getData();  // get data moved inside getcustom settings.

    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: DrawerNagivation(),
      appBar: AppBar(
        backgroundColor: Colors.brown[900],
        elevation: 8,
        title: Center(child: Text('View (' + count.toString() + ')')),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.sync, color: Colors.white),
              tooltip: 'Sync',
// LZ's code for sync
              onPressed: () {
                mysqlDBhelper.syncTasks();
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
              //             IconButton(
              //               icon: Icon(Icons.list, color: Colors.white),
              //               onPressed: () {},
              //             ),
              IconButton(
                icon: Icon(Icons.dashboard_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushNamed('/customizeview');
                },
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  navigateToDetail(Task("", "", "", "", "", "", "", "", 0, "",
                      "", "", 0, "", "", "", "", "", "", "", ""));
                  getData();
//                  mysqlDBhelper.syncTaskDataFromMySql();
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
                this.tasklist.removeAt(position);
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Item Dismissed"),
                ));
              });
            },
            background: Container(
              color: Colors.red,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                  color: Colors.yellow[200],
                  elevation: 8.0,
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Flexible(
                        //     child: Padding(
                        //         padding: const EdgeInsets.only(right: 2),
                        //         child: Row(
                        //           children: [
                        //             Text(this.tasklist[position].main1,
                        //                 overflow: TextOverflow.ellipsis),

                        //           ],
                        //         ))),

                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(this.tasklist[position].main1,
                                    overflow: TextOverflow.ellipsis))),

//                        Flexible(
//                            child: Padding(
//                                padding: const EdgeInsets.only(right: 2),
//                                child: Text(this.tasklist[position].main2,
//                                    overflow: TextOverflow.ellipsis))),
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

                        // SizedBox(width: 5.0),
                        // Text(this.tasklist[position].sec2),
//                        Flexible(
//                            child: Padding(
//                                padding: const EdgeInsets.only(right: 2),
//                                child: Text(this.tasklist[position].sec2,
//                                    overflow: TextOverflow.ellipsis))),

                        //   SizedBox(width: 5.0),
                        // Text(this.tasklist[position].sec3),
//                        Flexible(
//                            child: Padding(
//                                padding: const EdgeInsets.only(right: 2),
//                                child: Text(this.tasklist[position].sec3,
//                                    overflow: TextOverflow.ellipsis))),
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
          getDueDateColumn(_filterDateDue),
          globals.filterIsDone);
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
                taskList[i].main1 = taskList[i].title;
              }
              break;
            case 1:
              {
                taskList[i].main1 = taskList[i].description;
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
                taskList[i].main1 = taskList[i].categoryText;
              }
              break;
            case 5:
              {
                taskList[i].main1 = taskList[i].action1Text;
              }
              break;
            case 6:
              {
                taskList[i].main1 = taskList[i].context1Text;
              }
              break;
            case 7:
              {
                taskList[i].main1 = taskList[i].location1Text;
              }
              break;
            case 8:
              {
                taskList[i].main1 = taskList[i].tag1Text;
              }
              break;
            default:
              {
                taskList[i].main1 = taskList[i].title;
              }
              break;
          }

/////////////////
          /// display main2
////////////////
          switch (globals.showMain2) {
            case 0:
              {
                taskList[i].main2 = taskList[i].title;
              }
              break;
            case 1:
              {
                taskList[i].main2 = taskList[i].description;
              }
              break;
            case 2:
              {
                taskList[i].main2 = taskList[i].dateDue;
              }
              break;
            case 3:
              {
                taskList[i].main2 = taskList[i].timeDue;
              }
              break;
            case 4:
              {
                taskList[i].main2 = taskList[i].categoryText;
              }
              break;
            case 5:
              {
                taskList[i].main2 = taskList[i].action1Text;
              }
              break;
            case 6:
              {
                taskList[i].main2 = taskList[i].context1Text;
              }
              break;
            case 7:
              {
                taskList[i].main2 = taskList[i].location1Text;
              }
              break;
            case 8:
              {
                taskList[i].main2 = taskList[i].tag1Text;
              }
              break;
            default:
              {
                taskList[i].main2 = taskList[i].title;
              }
              break;
          }

/////////////////
          /// display sec1
////////////////
          switch (globals.showSec1) {
            case 0:
              {
                taskList[i].sec1 = taskList[i].title;
              }
              break;
            case 1:
              {
                taskList[i].sec1 = taskList[i].description;
              }
              break;
            case 2:
              {
                taskList[i].sec1 = taskList[i].dateDue;
              }
              break;
            case 3:
              {
                taskList[i].sec1 = taskList[i].timeDue;
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
                taskList[i].sec2 = taskList[i].title;
              }
              break;
            case 1:
              {
                taskList[i].sec2 = taskList[i].description;
              }
              break;
            case 2:
              {
                taskList[i].sec2 = taskList[i].dateDue;
              }
              break;
            case 3:
              {
                taskList[i].sec2 = taskList[i].timeDue;
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
                taskList[i].sec3 = taskList[i].title;
              }
              break;
            case 1:
              {
                taskList[i].sec3 = taskList[i].description;
              }
              break;
            case 2:
              {
                taskList[i].sec3 = taskList[i].dateDue;
              }
              break;
            case 3:
              {
                taskList[i].sec3 = taskList[i].timeDue;
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
      }
    }
    getData();
    setState(() {
      customSetting = customSetting;
    });
  }

//Sort column names are defined here but if there is any changes in column name update here
  String getSortColumn(int column) {
    switch (column) {
      case 0:
        return "title";
        break;
      case 1:
        return "description";
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

      default:
        return "title";
        break;
    }
  }

  //Sort column names are defined here but if there is any changes in column name update here
  String getDueDateColumn(int column) {
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
