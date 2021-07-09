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
        title: Center(child: Text('Home')),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help, color: Colors.white),
            tooltip: 'Help',
            onPressed: () {},
          ),
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
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(this.tasklist[position].sec2,
                                    overflow: TextOverflow.ellipsis))),

                        //   SizedBox(width: 5.0),
                        // Text(this.tasklist[position].sec3),
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(this.tasklist[position].sec3,
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
                            DateFormat('yyyy-mm-dd').format(now);
                        if (value == true) {
                          this.tasklist[position].isDone = 1;
                          this.tasklist[position].dateDone = formattedDate;
                          dbHelper.updateTask(tasklist[position]);
                        } else {
                          this.tasklist[position].isDone = 0;
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
    int _sort1 = globals.sort1 != null ? globals.sort1 : 0;
    int _sort2 = globals.sort2 != null ? globals.sort2 : 1;
    int _sort3 = globals.sort3 != null ? globals.sort3 : 2;
    int _order1 = globals.order1 != null ? globals.order1 : 0;
    int _order2 = globals.order2 != null ? globals.order2 : 0;
    int _order3 = globals.order3 != null ? globals.order3 : 0;

    var countDone = 0;
    final dbFuture = helper.initializeDb();

    dbFuture.then((result) {
      final tasksFuture = helper.getTasksSort(
          getSortColumn(_sort1),
          getOrderColumn(_order1),
          getSortColumn(_sort2),
          getOrderColumn(_order2),
          getSortColumn(_sort3),
          getOrderColumn(_order3),
          globals.showCompleted);
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
                taskList[i].main1 = taskList[i].category;
              }
              break;
            case 5:
              {
                taskList[i].main1 = taskList[i].action1;
              }
              break;
            case 6:
              {
                taskList[i].main1 = taskList[i].context1;
              }
              break;
            case 7:
              {
                taskList[i].main1 = taskList[i].location1;
              }
              break;
            case 8:
              {
                taskList[i].main1 = taskList[i].tag1;
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
                taskList[i].main2 = taskList[i].category;
              }
              break;
            case 5:
              {
                taskList[i].main2 = taskList[i].action1;
              }
              break;
            case 6:
              {
                taskList[i].main2 = taskList[i].context1;
              }
              break;
            case 7:
              {
                taskList[i].main2 = taskList[i].location1;
              }
              break;
            case 8:
              {
                taskList[i].main2 = taskList[i].tag1;
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
                taskList[i].sec1 = taskList[i].category;
              }
              break;
            case 5:
              {
                taskList[i].sec1 = taskList[i].action1;
              }
              break;
            case 6:
              {
                taskList[i].sec1 = taskList[i].context1;
              }
              break;
            case 7:
              {
                taskList[i].sec1 = taskList[i].location1;
              }
              break;
            case 8:
              {
                taskList[i].sec1 = taskList[i].tag1;
              }
              break;
            default:
              {
                taskList[i].sec1 = taskList[i].title;
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
                taskList[i].sec2 = taskList[i].category;
              }
              break;
            case 5:
              {
                taskList[i].sec2 = taskList[i].action1;
              }
              break;
            case 6:
              {
                taskList[i].sec2 = taskList[i].context1;
              }
              break;
            case 7:
              {
                taskList[i].sec2 = taskList[i].location1;
              }
              break;
            case 8:
              {
                taskList[i].sec2 = taskList[i].tag1;
              }
              break;
            default:
              {
                taskList[i].sec2 = taskList[i].title;
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
                taskList[i].sec3 = taskList[i].category;
              }
              break;
            case 5:
              {
                taskList[i].sec3 = taskList[i].action1;
              }
              break;
            case 6:
              {
                taskList[i].sec3 = taskList[i].context1;
              }
              break;
            case 7:
              {
                taskList[i].sec3 = taskList[i].location1;
              }
              break;
            case 8:
              {
                taskList[i].sec3 = taskList[i].tag1;
              }
              break;
            default:
              {
                taskList[i].sec3 = taskList[i].title;
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
    if (result == true) {
      getData();
    }
  }

  //to get the custom user settings.  this in home now,  but depends on login screen logic we can move this method. KK
  _getCustomSettings() async {
    var _customSetting = await helper.getCustomSettings();
    if (_customSetting.length > 0) {
      customSetting = CustomSettings.fromObject(_customSetting[0]);
      if (customSetting != null && customSetting.id != null) {
        if (customSetting.sort1 != "") {
          globals.sort1 =
              int.parse(customSetting.sort1); //convert it to session variables
        }
        if (customSetting.sort2 != "") {
          globals.sort2 = int.parse(customSetting.sort2);
        }
        if (customSetting.sort3 != "") {
          globals.sort3 = int.parse(customSetting.sort3);
        }
        if (customSetting.fieldToDisplay1 != "") {
          globals.showMain1 = int.parse(customSetting.fieldToDisplay1);
        }
        if (customSetting.fieldToDisplay2 != "") {
          globals.showMain2 = int.parse(customSetting.fieldToDisplay2);
        }
        if (customSetting.fieldToDisplay3 != "") {
          globals.showSec1 = int.parse(customSetting.fieldToDisplay3);
        }
        if (customSetting.fieldToDisplay4 != "") {
          globals.showSec2 = int.parse(customSetting.fieldToDisplay4);
        }
        if (customSetting.fieldToDisplay5 != "") {
          globals.showSec3 = int.parse(customSetting.fieldToDisplay5);
        }
        if (customSetting.showCompletedTask == true) {
          globals.showCompleted = 1;
        }
      }
      getData();
    }
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
