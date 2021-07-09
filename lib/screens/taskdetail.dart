import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper dbHelper = DbHelper();

DateTime currentDate = DateTime.now();
String formattedDate = DateFormat('yyyymmdd').format(currentDate);

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
  final _priorities = ["Low", "Medium", "High", "Top"];
  List<String> _cat = List<String>();

  var _todoTitleController = TextEditingController();
  var _todoDescriptionController = TextEditingController();
  var _todoDateController = TextEditingController();
  var _todoTimeController = TextEditingController();

  var _selectedCategory;
  var _selectedAction1;
  var _selectedContext1;
  var _selectedLocation1;
  var _selectedTag1;
  var _selectedGoal1;
  var _selectedPriorityText;
  int _selectedPriorityValue;

  var _categories = List<DropdownMenuItem>();
  var _action1s = List<DropdownMenuItem>();
  var _context1s = List<DropdownMenuItem>();
  var _location1s = List<DropdownMenuItem>();
  var _tag1s = List<DropdownMenuItem>();
  var _goal1s = List<DropdownMenuItem>();
  TextEditingController prioritytextController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

//  String formattedDate = '';

  @override
  void initState() {
    super.initState();

    _loadCategories();
    _loadAction1s();
    _loadContext1s();
    _loadLocation1s();
    _loadTag1s();
    _loadGoal1s();
  }

//##################Drop Down Items Load from DB #################################################################
  _loadCategories() async {
    var categories = await dbHelper.getCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  _loadAction1s() async {
    var action1s = await dbHelper.getActions();
    action1s.forEach((action1) {
      setState(() {
        _action1s.add(DropdownMenuItem(
          child: Text(action1['name']),
          value: action1['name'],
        ));
      });
    });
  }

  _loadContext1s() async {
    var context1s = await dbHelper.getContexts();
    context1s.forEach((context1) {
      setState(() {
        _context1s.add(DropdownMenuItem(
          child: Text(context1['name']),
          value: context1['name'],
        ));
      });
    });
  }

  _loadLocation1s() async {
    var location1s = await dbHelper.getLocations();
    location1s.forEach((location1) {
      setState(() {
        _location1s.add(DropdownMenuItem(
          child: Text(location1['name']),
          value: location1['name'],
        ));
      });
    });
  }

  _loadTag1s() async {
    var tag1s = await dbHelper.getTags();
    tag1s.forEach((tag1) {
      setState(() {
        _tag1s.add(DropdownMenuItem(
          child: Text(tag1['name']),
          value: tag1['name'],
        ));
      });
    });
  }

  _loadGoal1s() async {
    var goal1s = await dbHelper.getGoals();
    goal1s.forEach((goal1) {
      setState(() {
        _goal1s.add(DropdownMenuItem(
          child: Text(goal1['name']),
          value: goal1['name'],
        ));
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

  TimeOfDay timeConvert(String normTime) {
    int hour;
    int minute;
    String ampm = normTime.substring(normTime.length - 2);
    String result = normTime.substring(0, normTime.indexOf(' '));
    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
      hour = int.parse(result.split(':')[0]);
      if (hour == 12) hour = 0;
      minute = int.parse(result.split(":")[1]);
    } else {
      hour = int.parse(result.split(':')[0]) - 12;
      if (hour <= 0) {
        hour = 24 + hour;
      }
      minute = int.parse(result.split(":")[1]);
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

//##################End of Drop Down Items Load from DB #################################################################

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    _todoDescriptionController.text = task.description;
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
        : _selectedContext1 = null;
    task.tag1 != "" ? _selectedTag1 = task.tag1 : _selectedTag1 = null;
    task.goal1 != "" ? _selectedGoal1 = task.goal1 : _selectedGoal1 = null;
    _todoTitleController.text = task.title;
    _selectedPriorityText = task.prioritytext;
    task.prioritytext != ""
        ? _selectedPriorityValue = task.priorityvalue
        : _selectedPriorityValue = null;
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[900],
        automaticallyImplyLeading: false,
        title: Center(child: Text('Todo Detail')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
///////////////////////////
//  WHAT - TITLE
///////////////////////////
            Container(
              margin: const EdgeInsets.all(2.0),
              decoration: new BoxDecoration(
                color: Colors.green[100],
              ),
              child: TextField(
                controller: _todoTitleController,
                onChanged: (value) {
                  task.title = value;
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Write Todo title',
                ),
              ),
            ),
///////////////////////////
//  WHAT - DESCRIPTION
///////////////////////////
            Container(
              margin: const EdgeInsets.all(2.0),
              decoration: new BoxDecoration(
                color: Colors.green[100],
              ),
              child: TextField(
                controller: _todoDescriptionController,
                onChanged: (value) {
                  task.description = value;
                },
                minLines: 2,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Write Todo Description',
                ),
              ),
            ),
///////////////////////////
//  WHEN - DATE DUE
///////////////////////////
            Container(
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.blue[200],
              ),
              child: TextField(
                controller: _todoDateController,
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  hintText: 'Pick a Date',
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
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.blue[200],
              ),
              child: TextField(
                controller: _todoTimeController,
                decoration: InputDecoration(
                  labelText: 'Due Time',
                  hintText: 'Pick a Time',
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
//  CATEGORY
///////////////////////////
            Container(
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.pink[100]),
              child: DropdownButtonFormField(
                items: _categories,
                hint: Text('Category'),
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    task.category = value;
                    _selectedCategory = value;
                  });
                },
              ),
            ),
///////////////////////////
//  PRIORITY
///////////////////////////
//            Container(
//              margin: const EdgeInsets.all(2.0),
//              decoration: BoxDecoration(
//                  shape: BoxShape.rectangle, color: Colors.pink[100]),
//              child: DropdownButtonFormField(
//              //  value: _selectedPriorityValue,
//               items: _priorities.map((String value){
//
//                 return DropdownMenuItem<String> (
//                 value:value,
//                 child: Text (value)
//               );
//              }).toList(),
//                hint: Text('Priority'),
//                 value: retrievePriority(_selectedPriorityValue),
//                 onChanged: (value)=> updatePriority(value),
//              ),
//            ),
///////////////////////////
//  ACTION
///////////////////////////
            Container(
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.pink[100]),
              child: DropdownButtonFormField(
                value: _selectedAction1,
                items: _action1s,
                hint: Text('Action'),
                onChanged: (value) {
                  setState(() {
                    _selectedAction1 = value;
                    task.action1 = value;
                  });
                },
              ),
            ),
///////////////////////////
//  CONTEXT
///////////////////////////
            Container(
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.pink[100]),
              child: DropdownButtonFormField(
                value: _selectedContext1,
                items: _context1s,
                hint: Text('Context'),
                onChanged: (value) {
                  setState(() {
                    _selectedContext1 = value;
                    task.context1 = value;
                  });
                },
              ),
            ),
///////////////////////////
//  LOCATION
///////////////////////////
            Container(
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.pink[100]),
              child: DropdownButtonFormField(
                value: _selectedLocation1,
                items: _location1s,
                hint: Text('Location'),
                onChanged: (value) {
                  setState(() {
                    _selectedLocation1 = value;
                    task.location1 = value;
                  });
                },
              ),
            ),
///////////////////////////
//  TAG
///////////////////////////
            Container(
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.pink[100]),
              child: DropdownButtonFormField(
                value: _selectedTag1,
                items: _tag1s,
                hint: Text('Tag'),
                onChanged: (value) {
                  setState(() {
                    _selectedTag1 = value;
                    task.tag1 = value;
                  });
                },
              ),
            ),
///////////////////////////
//  GOAL
///////////////////////////
//            Container(
//              margin: const EdgeInsets.all(2.0),
//              decoration: BoxDecoration(
//                  shape: BoxShape.rectangle, color: Colors.pink[100]),
//              child: DropdownButtonFormField(
//                value: _selectedGoal1,
//               items: _goal1s,
//                hint: Text('Goal'),
//                onChanged: (value) {
//                  setState(() {
//                    _selectedGoal1 = value;
//                    task.goal1 = value;
//                  });
//                },
//              ),
//            ),

            SizedBox(
              height: 20,
            ),

            /// form - save or cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                    onPressed: () {
                      //  Navigator.pop(context);
                      Navigator.of(context).pushNamed('/dashboard');
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.brown[900]),
                    )),
                SizedBox(width: 10),
                RaisedButton(
                    onPressed: () async {
                      task.title = _todoTitleController.text;
                      task.description = _todoDescriptionController.text;
//                      task.prioritytext = _selectedPriorityText == null
//                          ? ""
//                          : _selectedPriorityText;
//                      task.priorityvalue = _selectedPriorityValue == null
//                          ? ""
//                          : _selectedPriorityValue;
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
//                      task.goal1 = _selectedGoal1 == null
//                          ? ""
//                          : _selectedGoal1.toString();
                      task.dateDue = _todoDateController.text;
                      task.timeDue = _todoTimeController.text;
                      task.isDone = 0;
                      if (task.isDone == 0) {
                        task.status = "Open";
                      } else {
                        task.status = "Completed";
                      }
                      //task.lastModified = DateTime.parse(
                      //DateFormat("yyyy-MM-dd HH:mm:ss")
                      //.format(DateTime.now()));

                      task.lastModified = DateFormat("yyyy-MM-dd HH:mm:ss")
                          .format(DateTime.now());

                      var result;
//<<<<<<< HEAD
//                      mysqlDBhelper.syncTaskDataToMySql();
//=======
//>>>>>>> bbd660f62817a657ab9f13b93c3fb21d3c8f28aa

                      print(task.id);
                      if (task.id != null) {
                        result = dbHelper.updateTask(task);
                      } else {
                        result = dbHelper.insertTask(task);
                      }

                      _showSuccessSnackBar(
                        Container(
                          color: Colors.tealAccent[100],
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (Icon(
                                Icons.thumb_up,
                                color: Colors.black,
                              )),
                              Text(
                                ' Added ',
                                style: (TextStyle(color: Colors.black)),
                              )
                            ],
                          ),
                        ),
                      );

                      Navigator.of(context).pushNamed('/dashboard');
                    },
                    color: Colors.brown[900],
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

// Future<void> _selectWhen(BuildContext context) async {
//   final DateTime pickedDate = await showDatePicker(
//     context: context,
//     initialDate: currentDate,
//     firstDate: DateTime(2020),
//     lastDate: DateTime(2050),
//     builder: (BuildContext context, Widget child) {
//       return Theme(
//         data: ThemeData.light().copyWith(
//           colorScheme: ColorScheme.fromSwatch(
//             primarySwatch: Colors.teal,
//             primaryColorDark: Colors.teal,
//             accentColor: Colors.teal,
//           ),
//           dialogBackgroundColor: Colors.white,
//         ),
//         child: child,
//       );
//     },
//   );
//   if (pickedDate != null && pickedDate != currentDate)
//     setState(() {
//       currentDate = pickedDate;
//       formattedDate = DateFormat('yyyymmdd').format(currentDate);
//     });
// }

//  String retrievePriority(int value) {
//    if (value == null)
//    {
//      return null;
//    }else
//    {
//    return _priorities[value];
//    }
//  }

//  void updatePriority(String value) {
//    switch (value) {
//      case "Top":
//        task.priorityvalue = 3;
//        task.prioritytext = "Top";
//        _selectedPriorityValue = 3;
//        _selectedPriorityText = "Top";
//        break;
//      case "High":
//        task.priorityvalue = 2;
//        task.prioritytext = "High";
//         _selectedPriorityValue = 2;
//        _selectedPriorityText = "High";
//        break;
//      case "Medium":
//        task.priorityvalue = 1;
//        task.prioritytext = "Medium";
//         _selectedPriorityValue = 1;
//       _selectedPriorityText = "Medium";
//        break;
//      case "Low":
//        task.priorityvalue = 0;
//        task.prioritytext = "Low";
//         _selectedPriorityValue = 0;
//        _selectedPriorityText = "Low";
//        break;

//      default:
//        task.priorityvalue = null;
//        task.prioritytext = null;
//         _selectedPriorityValue = null;
//        _selectedPriorityText = null;
//    }
//    setState(() {
//        task.prioritytext = value;
//        task.priorityvalue = _selectedPriorityValue;
//    });
//  }

//}
