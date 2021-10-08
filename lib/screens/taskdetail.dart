import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/model/customDropdownItem.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/screens/notificationPlugin.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'tasksearch.dart';

DbHelper dbHelper = DbHelper();

DateTime currentDate = DateTime.now();
String formattedDate = DateFormat('yyyymmdd').format(currentDate);
String _searchText = "";
TextStyle _textStyleControls =
    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800, color: Colors.black);

final List<String> choices = const <String>[
  'Save Task & Back',
  'Delete Task & Back',
  'Back to List'
];

const mnuSave = 'Save Task & Back';
const mnuDelete = 'Delete Task & Back';
const mnuBack = "Back to List";

class TaskDetail extends StatefulWidget {
  final Task task;
  TaskDetail(this.task);

  @override
  State<StatefulWidget> createState() => TaskDetailState(task);

  // TaskDetailState createState() => TaskDetailState(task);
}

class TaskDetailState extends State //<TaskDetail>
{
  Task task;

  TaskDetailState(this.task);
  List<String> _cat = List<String>();

  var _todoTaskController = TextEditingController();
  var _todoNoteController = TextEditingController();
  var _todoDateController = TextEditingController();
  var _todoTimeController = TextEditingController();
//  var _todoStatusController = TextEditingController();
//  var _todoPriorityController = TextEditingController();
  var _selectedIsStar;
  var _selectedStatus;
  var _selectedPriority;
  var _selectedCategory;
  var _selectedAction1;
  var _selectedContext1;
  var _selectedLocation1;
  var _selectedTag1;
  var _selectedGoal1;
  var _nTitle; 

  List<CustomDropdownItem> _statuses = [];
  List<CustomDropdownItem> _priorities = [];
  List<CustomDropdownItem> _categories = [];
  List<CustomDropdownItem> _action1s = [];
  List<CustomDropdownItem> _context1s = [];
  List<CustomDropdownItem> _location1s = [];
  List<CustomDropdownItem> _tag1s = [];
  List<CustomDropdownItem> _goal1s = [];

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

//  String formattedDate = '';

  @override
  void initState() {
    super.initState();

    _loadStatuses();
    _loadPriorities();
    _loadCategories();
    _loadAction1s();
    _loadContext1s();
    _loadLocation1s();
    _loadTag1s();
    _loadGoal1s();
  }

//##################Drop Down Items Load from DB #################################################################
  _loadStatuses() async {
    var statuses = await helper.getStatuses();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "-- Select Status --";
    _statuses.add(cus);
    statuses.forEach((status) {
      setState(() {
        cus = new CustomDropdownItem();
        cus.id = status['id'].toString();
        String tempStatus;
        if (status['name'].toString().length > 30)
          tempStatus = status['name'].toString().substring(0, 30) + "...";
        else
          tempStatus = status['name'];

        cus.name = tempStatus;

        _statuses.add(cus);
      });
    });
  }

  _loadPriorities() async {
    var priorities = await helper.getPriorities();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "-- Select Priority --";
    _priorities.add(cus);
    priorities.forEach((priority) {
      setState(() {
        cus = new CustomDropdownItem();
        cus.id = priority['id'].toString();
        String tempPriority;
        if (priority['name'].toString().length > 30)
          tempPriority = priority['name'].toString().substring(0, 30) + "...";
        else
          tempPriority = priority['name'];

        cus.name = tempPriority;

        _priorities.add(cus);
      });
    });
  }

  _loadCategories() async {
    var categories = await helper.getCategories();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "-- Select Category --";
    _categories.add(cus);
    categories.forEach((category) {
      setState(() {
        cus = new CustomDropdownItem();
        cus.id = category['id'].toString();
        String tempCat;
        if (category['name'].toString().length > 30)
          tempCat = category['name'].toString().substring(0, 30) + "...";
        else
          tempCat = category['name'];

        cus.name = tempCat;

        _categories.add(cus);
      });
    });
  }

  _loadAction1s() async {
    var action1s = await helper.getAction1s();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "-- Select Action --";
    _action1s.add(cus);
    action1s.forEach((action1) {
      setState(() {
        cus = new CustomDropdownItem();
        cus.id = action1['id'].toString();
        String tempAct;
        if (action1['name'].toString().length > 20)
          tempAct = action1['name'].toString().substring(0, 20) + "...";
        else
          tempAct = action1['name'];

        cus.name = tempAct;
        _action1s.add(cus);
      });
    });
  }

  _loadContext1s() async {
    var context1s = await helper.getContext1s();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "-- Select Context --";
    _context1s.add(cus);
    context1s.forEach((context1) {
      setState(() {
        cus = new CustomDropdownItem();
        cus.id = context1['id'].toString();
        String tempCon;
        if (context1['name'].toString().length > 30)
          tempCon = context1['name'].toString().substring(0, 30) + "...";
        else
          tempCon = context1['name'];

        cus.name = tempCon;

        _context1s.add(cus);
      });
    });
  }

  _loadLocation1s() async {
    var location1s = await helper.getLocation1s();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "-- Select Location --";
    _location1s.add(cus);
    location1s.forEach((location1) {
      setState(() {
        cus = new CustomDropdownItem();
        cus.id = location1['id'].toString();
        String tempLoc;
        if (location1['name'].toString().length > 30)
          tempLoc = location1['name'].toString().substring(0, 30) + "...";
        else
          tempLoc = location1['name'];

        cus.name = tempLoc;

        _location1s.add(cus);
      });
    });
  }

  _loadTag1s() async {
    var tag1s = await helper.getTag1s();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "-- Select Tag --";
    _tag1s.add(cus);
    tag1s.forEach((tag1) {
      setState(() {
        cus = new CustomDropdownItem();
        cus.id = tag1['id'].toString();
        String tempTag;
        if (tag1['name'].toString().length > 30)
          tempTag = tag1['name'].toString().substring(0, 30) + "...";
        else
          tempTag = tag1['name'];

        cus.name = tempTag;
        _tag1s.add(cus);
      });
    });
  }

  _loadGoal1s() async {
    var goal1s = await helper.getGoal1s();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "-- Select Goal --";
    _goal1s.add(cus);
    goal1s.forEach((goal1) {
      setState(() {
        cus = new CustomDropdownItem();
        cus.id = goal1['id'].toString();
        String tempGoal;
        if (goal1['name'].toString().length > 30)
          tempGoal = goal1['name'].toString().substring(0, 30) + "...";
        else
          tempGoal = goal1['name'];

        cus.name = tempGoal;
        _goal1s.add(cus);
      });
    });
  }

  DateTime _dateDue;
  _selectedTodoDate(BuildContext context) async {
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateDue == null ? DateTime.now() : _dateDue,
        firstDate: new DateTime(DateTime.now().year - 3),
        lastDate: new DateTime(DateTime.now().year + 3));

    if (pickedDate != null) {
      setState(() {
        _dateDue = pickedDate;
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(_dateDue);
        _todoDateController.text = formatter.format(_dateDue);
      });
    }
  }

  String _pickedTime = '';
  TimeOfDay _timeDue;
  DateTime _todoTimeDue;
  String _savedTime;
  Future<void> _openTimePicker(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _todoTimeController == null ? TimeOfDay.now() : _timeDue,
    );

    if (pickedTime != null) {
      setState(() {
        _timeDue = pickedTime;
        _pickedTime = pickedTime.format(context);
        _todoTimeController.text = _pickedTime;
      });
    }
  }

  TimeOfDay timeConvert(String s) {
    int hour;
    int minute;
    TimeOfDay _startTime = TimeOfDay(hour:int.parse(s.split(":")[0]),minute: int.parse(s.split(":")[1]));
//    String ampm = normTime.substring(normTime.length - 2);
//    String result = normTime.substring(0, normTime.indexOf(' '));
//    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
//      hour = int.parse(result.split(':')[0]);
//      if (hour == 12) hour = 0;
//      minute = int.parse(result.split(":")[1]);
//    } else {
//      hour = int.parse(result.split(':')[0]) - 12;
//      if (hour <= 0) {
//        hour = 24 + hour;
//      }
//      minute = int.parse(result.split(":")[1]);
//    }
    return TimeOfDay(hour: hour, minute: minute);
  }

//##################End of Drop Down Items Load from DB #################################################################

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    _todoNoteController.text = task.note;
    task.status != "" ? _selectedStatus = task.status : _selectedStatus = null;
    task.priority != ""
        ? _selectedPriority = task.priority
        : _selectedPriority = null;
    task.category != ""
        ? _selectedCategory = task.category
        : _selectedCategory = null;
    task.action1 != ""
        ? _selectedAction1 = task.action1
        : _selectedAction1 = null;
    task.context1 != ""
        ? _selectedContext1 = task.context1
        : _selectedContext1 = null;
    task.location1 != ""
        ? _selectedLocation1 = task.location1
        : _selectedLocation1 = null;
    task.tag1 != "" ? _selectedTag1 = task.tag1 : _selectedTag1 = null;
    task.goal1 != "" ? _selectedGoal1 = task.goal1 : _selectedGoal1 = null;
    _todoTaskController.text = task.task;
    task.dateDue != ""
        ? {
            if (_dateDue == null)
              {
                _todoDateController.text = task.dateDue,
                _dateDue = DateFormat('yyyy-M-d').parse(task.dateDue),
              },
          }
        : {
            _todoDateController.text = null,
            _dateDue = DateTime.now(),
          };
    task.timeDue != ""
        ? {
            if (_timeDue == null)
              {
                _todoTimeController.text = task.timeDue,
                _savedTime = task.timeDue,
                _timeDue = timeConvert(_savedTime),
                print(_timeDue),
              }
          }
        : {
            _todoTimeController.text = null,
            _timeDue = TimeOfDay.now(),
          };
    print(_todoTimeController.text);
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      key: _globalKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.brown[900],
        automaticallyImplyLeading: false,
        title: Center(child: Text('Todo Detail')),
      ),
      body: SingleChildScrollView(
        // this will make your body scrollable
        child: Column(
          children: <Widget>[
///////////////////////////
//  WHAT - Task
///////////////////////////
            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 2.0),
              decoration: new BoxDecoration(
                color: Colors.yellow[200],
              ),
              child: TextField(
                style: _textStyleControls,
                controller: _todoTaskController,
                onChanged: (value) {
                  task.task = value;
                },
                decoration: InputDecoration(
                  labelText: ' Task',
                  hintText: ' Write Todo Task',
                ),
              ),
            ),
///////////////////////////
//  WHAT - NOTE
///////////////////////////
            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: new BoxDecoration(
                color: Colors.yellow[200],
              ),
              child: TextField(
                style: _textStyleControls,
                controller: _todoNoteController,
                onChanged: (value) {
                  task.note = value;
                },
                minLines: 4,
                maxLines: 30,
                decoration: InputDecoration(
                  labelText: ' Note',
                  hintText: ' Write Todo Note',
                ),
              ),
            ),
///////////////////////////
//  WHEN - DATE DUE
///////////////////////////
            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.blue[100],
              ),
              child: TextField(
                controller: _todoDateController,
                style: _textStyleControls,
                decoration: InputDecoration(
                  labelText: ' Due Date',
                  hintText: ' Pick a Date',
                  prefixIcon: InkWell(
                    onTap: () {
                      _selectedTodoDate(context);
                    },
                    child: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),

///////////////////////////
//  WHEN - TIME DUE
///////////////////////////
            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.blue[100],
              ),
              child: TextField(
                controller: _todoTimeController,
                style: _textStyleControls,
                decoration: InputDecoration(
                  labelText: ' Due Time',
                  hintText: ' Pick a Time',
                  prefixIcon: InkWell(
                    onTap: () {
                      _openTimePicker(context);
                    },
                    child: Icon(Icons.access_time),
                  ),
                ),
              ),
            ),
///////////////////////////
//  STATUS
///////////////////////////

            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.blue[100]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                      items: _statuses.map((CustomDropdownItem value) {
                        return DropdownMenuItem<String>(
                            value: value.id,
                            child: Text(
                              value.name,
                              overflow: TextOverflow.ellipsis,
                            ));
                      }).toList(),
                      style: _textStyleControls,
                      value: _selectedStatus,
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedStatus = newValue;
                          task.status = newValue;
                        });
                      }),
                ],
              ),
            ),

///////////////////////////
//  PRIORITY
///////////////////////////

            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.blue[100]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                      items: _priorities.map((CustomDropdownItem value) {
                        return DropdownMenuItem<String>(
                            value: value.id,
                            child: Text(
                              value.name,
                              overflow: TextOverflow.ellipsis,
                            ));
                      }).toList(),
                      style: _textStyleControls,
                      value: _selectedPriority,
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedPriority = newValue;
                          task.priority = newValue;
                        });
                      }),
                ],
              ),
            ),

///////////////////////////
//  CATEGORY
///////////////////////////

            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.blue[100]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                      items: _categories.map((CustomDropdownItem value) {
                        return DropdownMenuItem<String>(
                            value: value.id,
                            child: Text(
                              value.name,
                              overflow: TextOverflow.ellipsis,
                            ));
                      }).toList(),
                      style: _textStyleControls,
                      value: _selectedCategory,
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                          task.category = newValue;
                        });
                      }),
                ],
              ),
            ),

///////////////////////////
//  ACTION
///////////////////////////

            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.blue[100]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                      items: _action1s.map((CustomDropdownItem value) {
                        return DropdownMenuItem<String>(
                            value: value.id,
                            child: Text(
                              value.name,
                              overflow: TextOverflow.ellipsis,
                            ));
                      }).toList(),
                      style: _textStyleControls,
                      value: _selectedAction1,
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedAction1 = newValue;
                          task.action1 = newValue;
                        });
                      }),
                ],
              ),
            ),

///////////////////////////
//  CONTEXT
///////////////////////////
            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.blue[100]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                      items: _context1s.map((CustomDropdownItem value) {
                        return DropdownMenuItem<String>(
                            value: value.id,
                            child: Text(
                              value.name,
                              overflow: TextOverflow.ellipsis,
                            ));
                      }).toList(),
                      style: _textStyleControls,
                      value: _selectedContext1,
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedContext1 = newValue;
                          task.context1 = newValue;
                        });
                      }),
                ],
              ),
            ),
///////////////////////////
//  LOCATION
///////////////////////////
            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.blue[100]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                      items: _location1s.map((CustomDropdownItem value) {
                        return DropdownMenuItem<String>(
                            value: value.id,
                            child: Text(
                              value.name,
                              overflow: TextOverflow.ellipsis,
                            ));
                      }).toList(),
                      style: _textStyleControls,
                      value: _selectedLocation1,
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedLocation1 = newValue;
                          task.location1 = newValue;
                        });
                      }),
                ],
              ),
            ),
///////////////////////////
//  TAG
///////////////////////////
            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.blue[100]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                      items: _tag1s.map((CustomDropdownItem value) {
                        return DropdownMenuItem<String>(
                            value: value.id,
                            child: Text(
                              value.name,
                              overflow: TextOverflow.ellipsis,
                            ));
                      }).toList(),
                      style: _textStyleControls,
                      value: _selectedTag1,
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedTag1 = newValue;
                          task.tag1 = newValue;
                        });
                      }),
                ],
              ),
            ),

///////////////////////////
//  GOAL
///////////////////////////
            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.blue[100]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                      items: _goal1s.map((CustomDropdownItem value) {
                        return DropdownMenuItem<String>(
                            value: value.id,
                            child: Text(
                              value.name,
                              overflow: TextOverflow.ellipsis,
                            ));
                      }).toList(),
                      style: _textStyleControls,
                      value: _selectedGoal1,
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedGoal1 = newValue;
                          task.goal1 = newValue;
                        });
                      }),
                ],
              ),
            ), //KK     // SizedBox(
///////////////////////////
//  Star
///////////////////////////
//            Container(
//                margin: EdgeInsets.only(
//                    left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
//                decoration: BoxDecoration(
//                    shape: BoxShape.rectangle, color: Colors.blue[100]),
//                child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: [
//                      IconButton(
//                          icon: Icon(Icons.lightbulb,
//                          color: (task.isStar == 0)
//                          ? Colors.black38
//                          : Colors.green),
//                          onPressed: () {
//                              if (task.isStar == 1) {
//                                this.task.isStar = 0;
//                              } else {
//                                this.task.isStar = 1;
//                              }
//                          })
//                    ])),

            /// form - save or cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[100],
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.brown[900]),
                    )),
                SizedBox(width: 5),
                ElevatedButton(
                    onPressed: () async {
                      task.task = _todoTaskController.text;
                      task.note = _todoNoteController.text;
                      task.status = _selectedStatus == null
                          ? ""
                          : _selectedStatus.toString();
                      task.priority = _selectedPriority == null
                          ? ""
                          : _selectedPriority.toString();
                      task.category = _selectedCategory == null
                          ? ""
                          : _selectedCategory.toString();
                      task.action1 = _selectedAction1 == null
                          ? ""
                          : _selectedAction1.toString();
                      task.context1 = _selectedContext1 == null
                          ? ""
                          : _selectedContext1.toString();
                      task.tag1 =
                          _selectedTag1 == null ? "" : _selectedTag1.toString();
                      task.goal1 = _selectedGoal1 == null
                          ? ""
                          : _selectedGoal1.toString();
                      task.dateDue = _todoDateController.text;
                      task.timeDue = _todoTimeController.text;
                      task.timeDue != ""
                          ? {
//                              _nTitle = task.timeDue.toString() + ' reminder: ' + task.task,
//                              await notificationPlugin.scheduleNotification(
//                                  _nTitle, task.note, task.timeDue)
                            }
                          : task.isDone = 0;
//                      if (task.isDone == 0) {
//                        task.status = "Open";
//                      } else {
//                        task.status = "Completed";
//                      }
                      //task.lastModified = DateTime.parse(
                      //DateFormat("yyyy-MM-dd HH:mm:ss")
                      //.format(DateTime.now()));

                      task.lastModified = DateFormat("yyyy-MM-dd HH:mm:ss")
                          .format(DateTime.now());

                      var result;
//<<<<<<< HEAD
//                      mysqlDBhelper.syncTaskDataToMySql();
//=======
//  >>>>>>> bbd660f62817a657ab9f13b93c3fb21d3c8f28aa

                      print(task.id);
                      if (task.id != null) {
                        result = dbHelper.updateTask(task);
                      } else {
                        result = dbHelper.insertTask(task);
                      }

                      _showSuccessSnackBar(
                        Container(
                          color: Colors.tealAccent[100],
                          //KK height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (Icon(
                                Icons.thumb_up,
                                color: Colors.black,
                              )),
                              Text(
                                ' Successfully Saved ',
                                style: (TextStyle(color: Colors.black)),
                              )
                            ],
                          ),
                        ),
                      );
                      await Future.delayed(
                          const Duration(milliseconds: 500), () {});
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.brown[900],
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
