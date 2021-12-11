import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/customDropdownItem.dart';
import 'package:todo_app/model/priority.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/screens/notificationPlugin.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'tasksearch.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

DbHelper dbHelper = DbHelper();

DateTime currentDate = DateTime.now();
String formattedDate = DateFormat('yyyymmdd').format(currentDate);
String _searchText = "";
TextStyle _textStyleControls = TextStyle(
    fontSize: 18.0, color: Colors.black87, fontWeight: FontWeight.w600);
TextStyle _textStyleSnack = TextStyle(
    fontSize: 16.0, color: Colors.pink[100], fontWeight: FontWeight.w600);

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
  List<String> _cat = [];

  var _todoTaskController = TextEditingController();
  var _todoNoteController = TextEditingController();
  var _todoDateController = TextEditingController();
  var _todoTimeController = TextEditingController();
  bool _selectedIsStar = false;
  bool _selectedIsDone = false;
  var _nTitle;

  List<CustomDropdownItem> _categories = [];
  List<CustomDropdownItem> _statuses = [];
  List<CustomDropdownItem> _priorities = [];
  List<CustomDropdownItem> _tag1s = [];
  var _selectedCategory = null;
  var _selectedStatus = null;
  var _selectedPriority = null;
  var _selectedTag1 = null;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

//  String formattedDate = '';

  int index = 0;

  @override
  void initState() {
    super.initState();

    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _loadCategories();
    _loadStatuses();
    _loadPriorities();
    _loadTag1s();
    _initFields();
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
    _initFields();

//    scrollController = FixedExtentScrollController(initialItem: index);
  }

//  @override
//  void dispose() {
//    scrollController.dispose();
//    super.dispose();
//  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}

  onNotificationClick(String payload) {
    print('Payload $payload');
  }

  _initFields() {
    _todoTaskController.text = task.task!;
    _todoNoteController.text = task.note!;
    if (task.dateDue != "") {
      _todoDateController.text = task.dateDue!;
      _dateDue = DateFormat('yyyy-M-d').parse(task.dateDue!);
    } else {}
    ;
    if (task.timeDue != "") {
      _todoTimeController.text = task.timeDue!;
      _savedTime = task.timeDue!;
      _timeDue = timeConvert(_savedTime!);
    } else {}
    ;
    task.category != ""
        ? {
            _selectedCategory = task.category,
          }
        : _selectedCategory = null;
    task.status != ""
        ? {
            _selectedStatus = task.status,
          }
        : _selectedStatus = null;
    task.priority != ""
        ? {
            _selectedPriority = task.priority,
          }
        : _selectedPriority = null;
    task.tag1 != ""
        ? {
            _selectedTag1 = task.tag1,
          }
        : _selectedTag1 = null;
    task.isStar == 0
        ? {
            _selectedIsStar = false,
          }
        : _selectedIsStar = true;
    task.isDone == 0
        ? {
            _selectedIsDone = false,
          }
        : _selectedIsDone = true;
  }

  void navigateToDetail(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetail(task)),
    );
  }

//##################Drop Down Items Load from DB #################################################################
  _loadCategories() async {
    var categories = await helper.getCategories();
    CustomDropdownItem cus;
//    cus = new CustomDropdownItem();
//    cus.id = 'CAT9';
//    cus.name = "[ Any Category ]";
//    _categories.add(cus);
    cus = new CustomDropdownItem();
    cus.name = "[ No Category ]";
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

  _loadStatuses() async {
    var statuses = await helper.getStatuses();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.name = "[ No Status ]";
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
    cus.name = "[ No Priority ]";
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

  _loadTag1s() async {
    var tag1s = await helper.getTag1s();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
//    cus.id = null;
    cus.name = "[ No Tag ]";
    _tag1s.add(cus);
    tag1s.forEach((tag1) {
      setState(() {
        cus = new CustomDropdownItem();
        cus.id = tag1['id'].toString();
        String tempTag1;
        if (tag1['name'].toString().length > 30)
          tempTag1 = tag1['name'].toString().substring(0, 30) + "...";
        else
          tempTag1 = tag1['name'];

        cus.name = tempTag1;

        _tag1s.add(cus);
      });
    });
  }

//##########################################end of Dropdown #################################################################

  DateTime? _dateDue;
  void _showCupertinoDatePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 400,
                    child: CupertinoDatePicker(
                        initialDateTime:
                            (_dateDue == null) ? DateTime.now() : _dateDue,
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (val) {
                          setState(() {
                            _dateDue = val;
                            final DateFormat formatter =
                                DateFormat('yyyy-MM-dd');
                            final String formatted =
                                formatter.format(_dateDue!);
                            _todoDateController.text =
                                formatter.format(_dateDue!);
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ),
            ));
  }

  _selectedTodoDate(BuildContext context) async {
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateDue == null ? DateTime.now() : _dateDue!,
        firstDate: new DateTime(DateTime.now().year - 3),
        lastDate: new DateTime(DateTime.now().year + 3));

    if (pickedDate != null) {
      setState(() {
        _dateDue = pickedDate;
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(_dateDue!);
        if (DateTime.tryParse(formatted) != null) {
          DateTime date = DateTime.parse(formatted);
        }
        _todoDateController.text = formatter.format(_dateDue!);
      });
    }
  }

  String? _pickedTime = '';
  TimeOfDay? _timeDue;
  DateTime? _todoTimeDue;
  String? _savedTime;

  Future<void> _openTimePicker(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: (_timeDue == null) ? TimeOfDay.now() : _timeDue!,
    );

    if (pickedTime != null && pickedTime != _savedTime) {
      setState(() {
        _timeDue = pickedTime;
        _pickedTime = pickedTime.format(context);
        _todoTimeController.text = _pickedTime!;
      });
    }
  }

  void _showCupertinoDateTimePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 400,
                    child: CupertinoDatePicker(
                        initialDateTime: (_dateDue == null)
                            ? DateTime.now()
                            : DateTime(
                                _dateDue!.year,
                                _dateDue!.month,
                                _dateDue!.day,
                                _timeDue!.hour,
                                _timeDue!.minute),
//                            : (_dateDue!.add(Duration(
//                                hours: (_timeDue == null)
//                                    ? DateTime.now().hour
//                                    : _timeDue!.hour,
//                                minutes: (_timeDue == null)
//                                    ? DateTime.now().minute
//                                    : _timeDue!.minute))),
                        mode: CupertinoDatePickerMode.dateAndTime,
                        onDateTimeChanged: (val) {
                          setState(() {
                            _dateDue = val;
                            final DateFormat formatter =
                                DateFormat('yyyy-MM-dd');
                            final String formatted =
                                formatter.format(_dateDue!);
                            _todoDateController.text =
                                formatter.format(_dateDue!);

                            _timeDue = TimeOfDay.fromDateTime(val);
                            _todoTimeController.text =
                                _timeDue!.format(context);
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ),
            ));
  }

  TimeOfDay timeConvert(String s) {
    String ampm = s.substring(s.length - 2);
    int hour;
    int minute;
    if (ampm == "AM" || ampm == "PM") {
      String result = s.substring(0, s.indexOf(' '));
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
    } else {
      TimeOfDay _time = TimeOfDay(
          hour: int.parse(s.split(":")[0]), minute: int.parse(s.split(":")[1]));
      return _time;
    }
  }

//  TimeOfDay timeConvert(String s) {
//    TimeOfDay _time = TimeOfDay(
//        hour: int.parse(s.split(":")[0]), minute: int.parse(s.split(":")[1]));
//    return _time;
//  }

//TimeOfDay timeConvert(String normTime) {
//   int hour;
//    int minute;
//  String ampm = normTime.substring(normTime.length - 2);
//    String result = normTime.substring(0, normTime.indexOf(' '));
//    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
//      hour = int.parse(result.split(':')[0]);
//      if (hour == 12) hour = 0;
//      minute = int.parse(result.split(":")[1]);
//    } else {
//      hour = int.parse(result.split(':')[0]) - 12;
//      if (hour <= 0) {
//       hour = 24 + hour;
//      }
//      minute = int.parse(result.split(":")[1]);
//    }
//    return TimeOfDay(hour: hour, minute: minute);
//  }

//##################End of Drop Down Items Load from DB #################################################################

  @override
  Widget build(BuildContext context) {
//    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
      key: _globalKey,
      resizeToAvoidBottomInset: false,
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
        backgroundColor: Colors.teal[800],
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.content_copy, color: Colors.white),
              tooltip: 'Clone',
              onPressed: () {
                setState(() {
                  dbHelper.insertTaskClone(task);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.teal[800],
                    duration: Duration(seconds: 3),
                    content: Text("Task Cloned", style: _textStyleSnack),
                  ));
                });
              }),
          IconButton(
              icon: Icon(Icons.save, color: Colors.white),
//              icon: Icon(Icons.savings_outlined, color: Colors.white),
              tooltip: 'Save',
              onPressed: () {
                setState(() {
                  task.task = _todoTaskController.text;
                  task.note = _todoNoteController.text;
                  (_selectedCategory == null)
                      ? {
                          task.category = "",
                        }
                      : {
                          task.category = _selectedCategory.toString(),
                        };
                  (_selectedStatus == null)
                      ? {
                          task.status = "",
                        }
                      : {
                          task.status = _selectedStatus.toString(),
                        };
                  (_selectedPriority == null)
                      ? {
                          task.priority = "",
                        }
                      : {
                          task.priority = _selectedPriority.toString(),
                        };
                  (_selectedTag1 == null)
                      ? {
                          task.tag1 = "",
                        }
                      : {
                          task.tag1 = _selectedTag1.toString(),
                        };

                  if (_selectedIsStar == false) {
                    task.isStar = 0;
                  } else {
                    task.isStar = 1;
                  }

                  if (_selectedIsDone == false) {
                    task.isDone = 0;
                    task.dateDone = null;
                  } else {
                    task.isDone = 1;
                    DateTime now = DateTime.now();
                    String formattedDate = DateFormat('yyyy-mm-dd').format(now);
                    task.dateDone = formattedDate;
                  }

                  task.dateDue = _todoDateController.text;
                  task.timeDue = _todoTimeController.text;

                  task.timeDue != ""
                      ? {
                          _nTitle = task.timeDue.toString() +
                              ' reminder: ' +
                              task.task!,
                          notificationPlugin.scheduleNotification(
                              _nTitle, task.note!, task.dateDue!, task.timeDue!)
                        }
                      : {};

//                  task.isDone = 0;
                  task.lastModified =
                      DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

                  var result;

                  if (task.id != null) {
                    result = dbHelper.updateTask(task);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.teal[800],
                      duration: Duration(seconds: 3),
                      content: Text("Task Updated", style: _textStyleSnack),
                    ));
                  } else {
                    result = dbHelper.insertTask(task);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.teal[800],
                      duration: Duration(seconds: 3),
                      content: Text("Task Saved", style: _textStyleSnack),
                    ));
                  }

                  Navigator.pop(context);

//////////////
                });
              }),
        ],
        title: Center(
          child: Icon(Icons.add, color: Colors.yellow[100]),
        ),
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
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0, bottom: 2.0),
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
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: ' Note',
                  hintText: ' Write Todo Note',
                ),
              ),
            ),

///////////////////////////
//  WHEN - DATE DUE
///////////////////////////
//            Container(
//              margin:
//                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
//              decoration: BoxDecoration(
//                shape: BoxShape.rectangle,
//                color: Colors.blue[100],
//              ),
//              child: Column(
//                children: [
//                  TextField(
//                    readOnly: true,
//                    controller: _todoDateController,
//                    style: _textStyleControls,
//                    decoration: InputDecoration(
//                      labelText: ' Due Date',
//                      hintText: ' Pick a Date',
//                      prefixIcon: InkWell(
//                        onTap: () {
//                          _selectedTodoDate(context);
//                        },
//                        child: Icon(Icons.calendar_today),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),

///////////////////////////
//  WHEN - TIME DUE
///////////////////////////
//            Container(
//              margin:
//                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
//              decoration: BoxDecoration(
//                shape: BoxShape.rectangle,
//                color: Colors.blue[100],
//              ),
//              child: TextField(
//                readOnly: true,
//                controller: _todoTimeController,
//                style: _textStyleControls,
//                decoration: InputDecoration(
//                  labelText: ' Due Time',
//                  hintText: ' Pick a Time',
//                  prefixIcon: InkWell(
//                    onTap: () {
////                      _showCupertinoDateTimePicker(context);
//                      DatePicker.showDateTimePicker(context,
//                         showTitleActions: true,
//                          minTime: DateTime(2020, 5, 5, 20, 50),
//                          maxTime: DateTime(2020, 6, 7, 05, 09),
//                          onChanged: (date) {
//                        print('change $date in time zone ' +
//                            date.timeZoneOffset.inHours.toString());
//                      }, onConfirm: (date) {
//                        _dateDue = date;
//                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
//                        final String formatted = formatter.format(_dateDue!);
//                        _todoDateController.text = formatter.format(_dateDue!);
//
//                        _timeDue = TimeOfDay.fromDateTime(date);
//                        _todoTimeController.text = _timeDue!.format(context);
//
//                        print('confirm $date');
////                      }, locale: LocaleType.zh);
//                      },
//                          currentTime: (_dateDue == null)
//                              ? DateTime.now()
//                              : DateTime(
//                                  _dateDue!.year,
//                                  _dateDue!.month,
//                                  _dateDue!.day,
//                                  _timeDue!.hour,
//                                  _timeDue!.minute));
//                    },
//                    child: Icon(Icons.access_time),
//                  ),
//                ),
//              ),
//            ),

///////////////////////////
//  Date Time Combined
///////////////////////////
            Container(
                margin: EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.blue[100],
                ),
//                padding: const EdgeInsets.all(15),
                child: Flexible(
                  child: Row(children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: _todoDateController,
                        style: _textStyleControls,
                        decoration: InputDecoration(
                          labelText: ' Date Due',
                          hintText: ' Pick a Date',
                          border: InputBorder.none,
                          prefixIcon: InkWell(
                            onTap: () {
                              _selectedTodoDate(context);
                            },
                            child: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: _todoTimeController,
                        style: _textStyleControls,
                        decoration: InputDecoration(
                          labelText: ' Time Due',
                          hintText: ' Pick a Time',
                          border: InputBorder.none,
                          prefixIcon: InkWell(
                            onTap: () {
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(2020, 5, 5, 20, 50),
                                  maxTime: DateTime(2020, 6, 7, 05, 09),
                                  onChanged: (date) {
                                print('change $date in time zone ' +
                                    date.timeZoneOffset.inHours.toString());
                              }, onConfirm: (date) {
                                _dateDue = date;

                                final DateFormat formatter =
                                    DateFormat('yyyy-MM-dd');

                                final String formatted =
                                    formatter.format(_dateDue!);

                                _todoDateController.text =
                                    formatter.format(_dateDue!);

                                _timeDue = TimeOfDay.fromDateTime(date);

                                _todoTimeController.text =
                                    _timeDue!.format(context);

                                print('confirm $date');
                              },
                                  currentTime: (_dateDue == null)
                                      ? DateTime.now()
                                      : DateTime(
                                          _dateDue!.year,
                                          _dateDue!.month,
                                          _dateDue!.day,
                                          _timeDue!.hour,
                                          _timeDue!.minute));
                            },
                            child: Icon(Icons.access_time),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed:() {
// clear date due
      _todoDateController.text = "";
      _dateDue = null;
// clear time due
      _todoTimeController.text = "";
      _savedTime = null;
      _timeDue = null;
                      },
                      ),
                    SizedBox(
                      width: 5,
                    ),
                  ]),
                )),

///////////////////////////
//  FOCUS
///////////////////////////
            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.blue[100],
              ),
              child: TextField(
                readOnly: true,
                style: _textStyleControls,
                decoration: InputDecoration(
                  labelText: ' Focus',
                  hintText: '',
                  prefixIcon: InkWell(
                    onTap: () {
                      setState(() {
//                        if (task.isStar == 1) {
//                          task.isStar = 0;
//                          Icon(Icons.lightbulb, color: Colors.black38);
//                          dbHelper.updateTask(task);
//                        } else {
//                          task.isStar = 1;
//                          Icon(Icons.lightbulb, color: Colors.amber[800]);
//                          dbHelper.updateTask(task);
//                        }
                        (_selectedIsStar == true)
                            ? {
                                _selectedIsStar = false,
                                Icon(Icons.lightbulb, color: Colors.black38),
                              }
                            : {
                                _selectedIsStar = true,
                                Icon(Icons.lightbulb, color: Colors.amber[800]),
                              };
                      });
                    },
                    child: Icon(Icons.lightbulb,
                        color: (_selectedIsStar == false)
                            ? Colors.black12
                            : Colors.teal),
                  ),
                ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(canvasColor: Colors.lime[100]),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          isExpanded: true,
                          style: _textStyleControls,
                          items: _categories.map((CustomDropdownItem value) {
                            return DropdownMenuItem<String>(
                                value: value.id,
                                child: Text(
                                  value.name!,
                                  overflow: TextOverflow.ellipsis,
                                ));
                          }).toList(),
                          value: _selectedCategory,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          }),
                    ),
                  ),
                ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(canvasColor: Colors.lime[100]),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          isExpanded: true,
                          style: _textStyleControls,
                          items: _statuses.map((CustomDropdownItem value) {
                            return DropdownMenuItem<String>(
                                value: value.id,
                                child: Text(
                                  value.name!,
                                  overflow: TextOverflow.ellipsis,
                                ));
                          }).toList(),
                          value: _selectedStatus,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedStatus = newValue;
                            });
                          }),
                    ),
                  ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(canvasColor: Colors.lime[100]),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          isExpanded: true,
                          style: _textStyleControls,
                          items: _priorities.map((CustomDropdownItem value) {
                            return DropdownMenuItem<String>(
                                value: value.id,
                                child: Text(
                                  value.name!,
                                  overflow: TextOverflow.ellipsis,
                                ));
                          }).toList(),
                          value: _selectedPriority,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedPriority = newValue;
                            });
                          }),
                    ),
                  ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(canvasColor: Colors.lime[100]),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          isExpanded: true,
                          style: _textStyleControls,
                          items: _tag1s.map((CustomDropdownItem value) {
                            return DropdownMenuItem<String>(
                                value: value.id,
                                child: Text(
                                  value.name!,
                                  overflow: TextOverflow.ellipsis,
                                ));
                          }).toList(),
                          value: _selectedTag1,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedTag1 = newValue;
                            });
                          }),
                    ),
                  ),
                ],
              ),
            ),
///////////////////////////
//  IS COMPLETED
///////////////////////////
            Container(
              margin:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.blue[100]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
//                    value: (task.isDone == 0) ? false : true,
                    value: _selectedIsDone ? true : false,
                    onChanged: (value) {
                      setState(() {
                        _selectedIsDone = (value == true) ? true : false;
//                        if (value == false) {
//                          task.isDone = 0;
//                          task.dateDone = null;
//                          dbHelper.updateTask(task);
//                        } else {
//                          task.isDone = 1;
//                          DateTime now = DateTime.now();
//                          String formattedDate =
//                              DateFormat('yyyy-mm-dd').format(now);
//                          task.dateDone = formattedDate;
//                          dbHelper.updateTask(task);
//                       }
                      });
                    },
                  ),
                  Text('Completed', style: _textStyleControls),
                ],
              ),
            ),
///////////////////////////
          ],
        ),
      ),
    );
  }
}
