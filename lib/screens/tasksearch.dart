import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/screens/taskdetail.dart';
import 'package:todo_app/model/customDropdownItem.dart';
import 'package:todo_app/model/customSettings.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/globals.dart' as globals;

DbHelper helper = DbHelper();
String? _searchText = "";
TextStyle _textStyleControls = TextStyle(fontSize: 17.0, color: Colors.black87);

class TaskSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TaskSearchState();
}

class TaskSearchState extends State {
  DbHelper helper = DbHelper();
  List<CustomDropdownItem> _categories = [];
  List<CustomDropdownItem> _statuses = [];
  List<CustomDropdownItem> _priorities = [];
  List<CustomDropdownItem> _tag1s = [];
  List<Task> tasklist = [];
  int count = 0;
  TextEditingController searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedStatus;
  String? _selectedPriority;
  String? _selectedTag1;
  int? isChecked = 0;
  int? _showIsStar = 0;
  int? _showIsDone = 1;

  @override
  void initState() {
    super.initState();
    _getCustomSettings();
    _loadCategories();
    _loadStatuses();
    _loadPriorities();
    _loadTag1s();
  }

  //##################Drop Down Items Load from DB #################################################################
  _loadCategories() async {
    var categories = await helper.getCategories();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
//    cus.id = null;
    cus.name = "-- All Categories --";
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
//    cus.id = null;
    cus.name = "-- All Statuses --";
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
    cus.name = "-- All Priorities --";
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
    cus.id = null;
    cus.name = "-- All Tags --";
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

//  _loadAction1s() async {
//    var action1s = await helper.getAction1s();
//    CustomDropdownItem cus;
//    cus = new CustomDropdownItem();
//    cus.id = null;
//    cus.name = "-- All Actions --";
//    _action1s.add(cus);
//    action1s.forEach((action1) {
//      setState(() {
//        cus = new CustomDropdownItem();
//        cus.id = action1['id'].toString();
//        String tempAct;
//        if (action1['name'].toString().length > 30)
//          tempAct = action1['name'].toString().substring(0, 30) + "...";
//        else
//          tempAct = action1['name'];

//        cus.name = tempAct;

//        _action1s.add(cus);
//      });
//    });
//  }

//  _loadContext1s() async {
//    var context1s = await helper.getContext1s();
//    CustomDropdownItem cus;
//    cus = new CustomDropdownItem();
//    cus.id = null;
//    cus.name = "-- All Contexts --";
//    _context1s.add(cus);
//    context1s.forEach((context1) {
//      setState(() {
//        cus = new CustomDropdownItem();
//        cus.id = context1['id'].toString();
//        String tempCon;
//        if (context1['name'].toString().length > 30)
//          tempCon = context1['name'].toString().substring(0, 30) + "...";
//        else
//          tempCon = context1['name'];
//        cus.name = tempCon;
//        _context1s.add(cus);
//      });
//    });
//  }

//  _loadLocation1s() async {
//    var location1s = await helper.getLocation1s();
//    CustomDropdownItem cus;
//    cus = new CustomDropdownItem();
//    cus.id = null;
//    cus.name = "-- All Locations --";
//    _location1s.add(cus);
//    location1s.forEach((location1) {
//      setState(() {
//        cus = new CustomDropdownItem();
//        cus.id = location1['id'].toString();
//        String tempLoc;
//        if (location1['name'].toString().length > 30)
//          tempLoc = location1['name'].toString().substring(0, 30) + "...";
//        else
//          tempLoc = location1['name'];

//        cus.name = tempLoc;

//        _location1s.add(cus);
//      });
//    });
//  }

//  _loadGoal1s() async {
//    var goal1s = await helper.getGoal1s();
//    CustomDropdownItem cus;
//    cus = new CustomDropdownItem();
//    cus.id = null;
//    cus.name = "-- All Goals --";
//    _goal1s.add(cus);
//    goal1s.forEach((goal1) {
//      setState(() {
//        cus = new CustomDropdownItem();
//        cus.id = goal1['id'].toString();
//        String tempGoal1;
//        if (goal1['name'].toString().length > 30)
//          tempGoal1 = goal1['name'].toString().substring(0, 30) + "...";
//        else
//          tempGoal1 = goal1['name'];

//        cus.name = tempGoal1;
//        _goal1s.add(cus);
//      });
//    });
//  }

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
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.pink[100]),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TaskHome()));
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        backgroundColor: Colors.teal[800],
        automaticallyImplyLeading: true,
        title: Center(
          child: Container(
            height: 30,
            child: Column(
              children: <Widget>[
                Badge(
                  child: Text('Search     '),
                  shape: BadgeShape.square,
                  stackFit: StackFit.loose,
                  position: BadgePosition.topEnd(),
                  badgeContent: Text(count.toString(),
                      style: TextStyle(color: Colors.black)),
                  badgeColor: Colors.green[100]!,
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: 6.0, left: 4.0, right: 4.0, bottom: 1.0),
            child: TextField(
              style: _textStyleControls,
              controller: searchController,
              onChanged: (value) {
                searchData(
                    value,
                    _selectedCategory,
                    _selectedStatus,
                    _selectedPriority,
                    _selectedTag1,
//                    _selectedAction1,
//                    _selectedContext1,
//                    _selectedLocation1,
//                   _selectedGoal1,
                    _showIsStar,
                    1);
              },
              decoration: InputDecoration(
                fillColor: Colors.green[100],
                border: InputBorder.none,
                filled: true, // dont forget this line
                labelText: "Searching for ...",
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(0.0),
              child: ExpansionTile(
                title: Text(
                  "Advanced Filters",
                  style: _textStyleControls,
                ),

                trailing: Icon(Icons.filter_list_outlined),

                // backgroundColor: Colors.yellow,
                children: [
                  Column(
                    children: [
//####################################Show Completed Task Check box
                      Container(
                        margin:
                            EdgeInsets.only(left: 8.0, right: 8.0, bottom: 1.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Include Completed Tasks:',
                                style: _textStyleControls),
                            Checkbox(
                              value: (_showIsDone == 0) ? false : true,
                              onChanged: (value) {
                                setState(() {
                                  _showIsDone = (value! == false) ? 0 : 1;
                                  searchData(
                                      _searchText,
                                      _selectedCategory,
                                      _selectedStatus,
                                      _selectedPriority,
                                      _selectedTag1,
//                                      _selectedAction1,
//                                      _selectedContext1,
//                                      _selectedLocation1,
//                                      _selectedGoal1,
                                      _showIsStar,
                                      _showIsDone);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
//####################################end of Show completed

//####################################Show Focus Tasks Task Check box
                      Container(
                        margin:
                            EdgeInsets.only(left: 8.0, right: 8.0, bottom: 1.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Focus Tasks Only:',
                                style: _textStyleControls),
                            Checkbox(
                              value: (_showIsStar == 0) ? false : true,
                              onChanged: (value) {
                                setState(() {
                                  _showIsStar = (value! == false) ? 0 : 1;
                                  searchData(
                                      _searchText,
                                      _selectedCategory,
                                      _selectedStatus,
                                      _selectedPriority,
                                      _selectedTag1,
//                                      _selectedAction1,
//                                      _selectedContext1,
//                                      _selectedLocation1,
//                                      _selectedGoal1,
                                      _showIsStar,
                                      _showIsDone);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
//####################################end of Show Focus Tasks

//#################################Category#####################################################
                      Container(
                        margin:
                            EdgeInsets.only(top: 1.0, left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButton<String?>(
                                isExpanded: true,
                                items:
                                    _categories.map((CustomDropdownItem value) {
                                  return DropdownMenuItem<String>(
                                      value: value.id,
                                      child: Text(
                                        value.name!,
                                        overflow: TextOverflow.ellipsis,
                                      ));
                                }).toList(),
                                style: _textStyleControls,
                                value: _selectedCategory,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                    searchData(
                                        _searchText,
                                        _selectedCategory,
                                        _selectedStatus,
                                        _selectedPriority,
                                        _selectedTag1,
//                                        _selectedAction1,
//                                        _selectedContext1,
//                                        _selectedLocation1,
//                                        _selectedGoal1,
                                        _showIsStar,
                                        _showIsDone);
                                  });
                                }),
                          ],
                        ),
                      ),

//#################################Status#####################################################
                      Container(
                        margin:
                            EdgeInsets.only(top: 1.0, left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButton<String?>(
                                isExpanded: true,
                                items:
                                    _statuses.map((CustomDropdownItem value) {
                                  return DropdownMenuItem<String>(
                                      value: value.id,
                                      child: Text(
                                        value.name!,
                                        overflow: TextOverflow.ellipsis,
                                      ));
                                }).toList(),
                                style: _textStyleControls,
                                value: _selectedStatus,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedStatus = newValue;
                                    searchData(
                                        _searchText,
                                        _selectedStatus,
                                        _selectedCategory,
                                        _selectedPriority,
                                        _selectedTag1,
//                                        _selectedAction1,
//                                        _selectedContext1,
//                                        _selectedLocation1,
//                                        _selectedGoal1,
                                        _showIsStar,
                                        _showIsDone);
                                  });
                                }),
                          ],
                        ),
                      ),

//#################################Priority#####################################################
                      Container(
                        margin:
                            EdgeInsets.only(top: 1.0, left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButton<String?>(
                                isExpanded: true,
                                items:
                                    _priorities.map((CustomDropdownItem value) {
                                  return DropdownMenuItem<String>(
                                      value: value.id,
                                      child: Text(
                                        value.name!,
                                        overflow: TextOverflow.ellipsis,
                                      ));
                                }).toList(),
                                style: _textStyleControls,
                                value: _selectedPriority,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedPriority = newValue;
                                    searchData(
                                        _searchText,
                                        _selectedCategory,
                                        _selectedStatus,
                                        _selectedPriority,
                                        _selectedTag1,
//                                        _selectedAction1,
//                                        _selectedContext1,
//                                        _selectedLocation1,
//                                        _selectedGoal1,
                                        _showIsStar,
                                        _showIsDone);
                                  });
                                }),
                          ],
                        ),
                      ),

// //######### Tag  #########
                      Container(
                        margin:
                            EdgeInsets.only(top: 1.0, left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButton<String?>(
                              isExpanded: true,
                              items: _tag1s.map((CustomDropdownItem value) {
                                return DropdownMenuItem<String>(
                                    value: value.id, child: Text(value.name!));
                              }).toList(),
                              style: _textStyleControls,
                              value: _selectedTag1,
                              onChanged: (value) {
                                setState(() {
                                  _selectedTag1 = value;
                                  searchData(
                                      _searchText,
                                      _selectedCategory,
                                      _selectedStatus,
                                      _selectedPriority,
                                      _selectedTag1,
//                                      _selectedAction1,
//                                      _selectedContext1,
//                                      _selectedLocation1,
//                                      _selectedGoal1,
                                      _showIsStar,
                                      _showIsDone);
                                });
                              },
                            )
                          ],
                        ),
                      ),

//########################################### Action  ######### #################################3
//                      Container(
//                        margin:
//                            EdgeInsets.only(top: 1.0, left: 8.0, right: 8.0),
//                        decoration: BoxDecoration(
//                            shape: BoxShape.rectangle, color: Colors.blue[100]),
//                        child: Flexible(
//                          child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: [
//                              DropdownButton<String?>(
//                                items:
//                                    _action1s.map((CustomDropdownItem value) {
//                                  return DropdownMenuItem<String>(
//                                      value: value.id,
//                                      child: Text(value.name!));
//                                }).toList(),
//                                style: _textStyleControls,
//                                value: _selectedAction1,
//                                onChanged: (value) {
//                                  setState(() {
//                                    _selectedAction1 = value;
//                                    searchData(
//                                        _searchText,
//                                        _selectedStatus,
//                                        _selectedPriority,
//                                        _selectedCategory,
//                                        _selectedAction1,
//                                        _selectedContext1,
//                                        _selectedLocation1,
//                                        _selectedTag1,
//                                        _selectedGoal1,
//                                        _showIsStar,
//                                        _showIsDone);
//                                  });
//                                },
//                              )
//                            ],
//                          ),
//                        ),
//                      ),
//######### Context  #########
//                      Container(
//                        margin:
//                            EdgeInsets.only(top: 1.0, left: 8.0, right: 8.0),
//                        decoration: BoxDecoration(
//                            shape: BoxShape.rectangle, color: Colors.blue[100]),
//                        child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: [
//                            DropdownButton<String?>(
//                              items: _context1s.map((CustomDropdownItem value) {
//                                return DropdownMenuItem<String>(
//                                    value: value.id, child: Text(value.name!));
//                              }).toList(),
//                              style: _textStyleControls,
//                              value: _selectedContext1,
//                              onChanged: (value) {
//                                setState(() {
//                                  _selectedContext1 = value;
//                                  searchData(
//                                      _searchText,
//                                      _selectedStatus,
//                                      _selectedPriority,
//                                      _selectedCategory,
//                                      _selectedAction1,
//                                      _selectedContext1,
//                                      _selectedLocation1,
//                                      _selectedTag1,
//                                      _selectedGoal1,
//                                      _showIsStar,
//                                      _showIsDone);
//                                });
//                              },
//                            )
//                          ],
//                        ),
//                      ),
// //######### Location  #########
//                      Container(
//                        margin:
//                            EdgeInsets.only(top: 1.0, left: 8.0, right: 8.0),
//                        decoration: BoxDecoration(
//                            shape: BoxShape.rectangle, color: Colors.blue[100]),
//                        child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: [
//                            DropdownButton<String?>(
//                              items:
//                                  _location1s.map((CustomDropdownItem value) {
//                                return DropdownMenuItem<String>(
//                                    value: value.id, child: Text(value.name!));
//                              }).toList(),
//                              style: _textStyleControls,
//                              value: _selectedLocation1,
//                              onChanged: (value) {
//                                setState(() {
//                                  _selectedLocation1 = value;
//                                  searchData(
//                                     _searchText,
//                                      _selectedStatus,
//                                      _selectedPriority,
//                                      _selectedCategory,
//                                      _selectedAction1,
//                                      _selectedContext1,
//                                      _selectedLocation1,
//                                      _selectedTag1,
//                                      _selectedGoal1,
//                                      _showIsStar,
//                                      _showIsDone);
//                                });
//                              },
//                            )
//                          ],
//                        ),
//                      ),

// //######### Goal  #########
//                      Container(
//                        margin: EdgeInsets.only(
//                            top: 1.0, left: 8.0, right: 8.0, bottom: 1.0),
//                        decoration: BoxDecoration(
//                            shape: BoxShape.rectangle, color: Colors.blue[100]),
//                        child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: [
//                            DropdownButton<String?>(
//                              items: _goal1s.map((CustomDropdownItem value) {
//                                return DropdownMenuItem<String>(
//                                    value: value.id, child: Text(value.name!));
//                              }).toList(),
//                              style: _textStyleControls,
//                              value: _selectedGoal1,
//                              onChanged: (value) {
//                                setState(() {
//                                  _selectedGoal1 = value;
//                                  searchData(
//                                      _searchText,
//                                      _selectedStatus,
//                                      _selectedPriority,
//                                      _selectedCategory,
//                                      _selectedAction1,
//                                      _selectedContext1,
//                                      _selectedLocation1,
//                                      _selectedTag1,
//                                      _selectedGoal1,
//                                      _showIsStar,
//                                      _showIsDone);
//                                });
//                              },
//                            )
//                          ],
//                        ),
//                      ),
                    ],
                  )
                ],
              )),
          Expanded(
            child: Container(child: taskListItems()),
          ),
        ],
      ),

//footer
      //bottomNavigationBar: footerBar,

//      bottomNavigationBar: Container(
//        height: 28.0,
//        child: BottomAppBar(
//          // color: Color.fromRGBO(58, 66, 86, 1.0),
//          color: Colors.teal[800],
//          color: Colors.brown[900],
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              IconButton(
//                icon: Icon(Icons.home, color: Colors.white),
//                tooltip: 'Back to Home',
//                onPressed: () {
//                  // Navigator.pop(context, true);
//                  Navigator.of(context).push(
//                      MaterialPageRoute(builder: (context) => TaskHome()));
//                },
//              ),
//            ],
//          ),
//        ),
//      ),
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
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Item Dismissed"),
                ));
                dbHelper.updateTask(tasklist[position]);
                searchData(
                    _searchText,
                    _selectedStatus,
                    _selectedCategory,
                    _selectedPriority,
                    _selectedTag1,
//                    _selectedAction1,
//                    _selectedContext1,
//                    _selectedLocation1,
//                    _selectedGoal1,
                    _showIsStar,
                    _showIsDone);
              });
            },
            background: Container(
              color: Colors.teal[800],
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(top: 1.0, left: 4.0, right: 4.0, bottom: 1.0),
              child: Card(
                  color: Colors.yellow[200],
                  child: ListTile(
                    visualDensity: VisualDensity(horizontal: -4),
                    leading: Checkbox(
                      checkColor: Colors.white,
                      value: (this.tasklist[position].isDone == 1),
                      onChanged: (value) {
                        setState(() {
                          isChecked = (value! == false) ? 0 : 1;
                          DateTime now = DateTime.now();
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(now);
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
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.lightbulb,
                          color: (this.tasklist[position].isStar == 0)
                              ? Colors.black12
                              : Colors.teal),
                      onPressed: () {
                        setState(() {
                          if (this.tasklist[position].isStar == 1) {
                            this.tasklist[position].isStar = 0;
                            Icon(Icons.lightbulb, color: Colors.black38);
                            dbHelper.updateTask(tasklist[position]);
                          } else {
                            this.tasklist[position].isStar = 1;
                            Icon(Icons.lightbulb, color: Colors.amber[800]);
                            dbHelper.updateTask(tasklist[position]);
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
                                padding: const EdgeInsets.only(right: 1),
                                child: Text(
                                    this.tasklist[position].task == null
                                        ? ""
                                        : this.tasklist[position].task!,
                                    style: _textStyleControls,
                                    overflow: TextOverflow.ellipsis))),
                      ],
                    ),
                    isThreeLine: false,
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    onTap: () {
                      navigateToDetail(this.tasklist[position]);
                    },
//                    value: (this.tasklist[position].isDone == 1),
//                    onChanged: (value) {
//                      setState(() {
//                        DateTime now = DateTime.now();
//                        String formattedDate =
//                            DateFormat('yyyy-mm-dd').format(now);
//                        if (value == true) {
//                          this.tasklist[position].isDone = 1;
//                          this.tasklist[position].dateDone = formattedDate;
//                          dbHelper.updateTask(tasklist[position]);
//                        } else {
//                          this.tasklist[position].isDone = 0;
//                          this.tasklist[position].dateDone = '';
//                          dbHelper.updateTask(tasklist[position]);
//                        }
//                      });
//                    },
//                    activeColor: Colors.brown[900],
//                    checkColor: Colors.white,
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
        globals.filterIsDone != "null" ? globals.filterIsDone : 0;

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
//        globals.filterAction.toString(),
//        globals.filterContext.toString(),
//        globals.filterLocation.toString(),
//        globals.filterGoal.toString(),
        globals.filterIsStar,
        globals.filterIsDone,
      );
      tasksFuture.then((result) {
        List<Task> taskList = [];
        List<DisplayTask> displaytaskList = [];
        count = result.length;
        for (int i = 0; i < count; i++) {
          countDone = countDone + 1;
          taskList.add(Task.fromObject(result[i]));

/////////////////
          /// display main1
////////////////
//          switch (globals.showMain1) {
//            case 0:
//              {
//                taskList[i].main1 = taskList[i].task;
//              }
//              break;
//            case 1:
//              {
//                taskList[i].main1 = taskList[i].note;
//              }
//              break;
//           case 2:
//              {
//                taskList[i].main1 = taskList[i].dateDue;
//              }
//              break;
//            case 3:
//              {
//                taskList[i].main1 = taskList[i].timeDue;
//              }
//              break;
//            case 4:
//              {
//                taskList[i].main1 = taskList[i].statusText;
//              }
//              break;
//            case 5:
//              {
//                taskList[i].main1 = taskList[i].priorityText;
//              }
//              break;
//            case 6:
//              {
//                taskList[i].main1 = taskList[i].categoryText;
//              }
//              break;
//            case 7:
//              {
//                taskList[i].main1 = taskList[i].action1Text;
//              }
//              break;
//            case 8:
//              {
//                taskList[i].main1 = taskList[i].context1Text;
//              }
//              break;
//            case 9:
//              {
//                taskList[i].main1 = taskList[i].location1Text;
//              }
//              break;
//            case 10:
//              {
//                taskList[i].main1 = taskList[i].tag1Text;
//              }
//              break;
//            case 11:
//              {
//                taskList[i].main1 = taskList[i].goal1Text;
//              }
//              break;
//            case 12:
//              {
//                taskList[i].main1 = taskList[i].isStar.toString();
//              }
//              break;
//            default:
//              {
//                taskList[i].main1 = taskList[i].task;
//              }
//              break;
//          }

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
//            case 5:
//              {
//                taskList[i].sec1 = taskList[i].action1Text;
//              }
//              break;
//            case 6:
//              {
//                taskList[i].sec1 = taskList[i].context1Text;
//              }
//              break;
//            case 7:
//              {
//                taskList[i].sec1 = taskList[i].location1Text;
//              }
//              break;
//            case 9:
//              {
//                taskList[i].sec1 = taskList[i].goal1Text;
//              }
//              break;
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
//            case 5:
//              {
//                taskList[i].sec2 = taskList[i].action1Text;
//              }
//              break;
//            case 6:
//              {
//                taskList[i].sec2 = taskList[i].context1Text;
//              }
//              break;
//            case 7:
//              {
//                taskList[i].sec2 = taskList[i].location1Text;
//              }
//              break;
//            case 9:
//              {
//                taskList[i].sec2 = taskList[i].goal1Text;
//              }
//              break;
            case 4:
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
//            case 5:
//              {
//                taskList[i].sec3 = taskList[i].action1Text;
//              }
//              break;
//            case 6:
//              {
//                taskList[i].sec3 = taskList[i].context1Text;
//              }
//              break;
//            case 7:
//              {
//                taskList[i].sec3 = taskList[i].location1Text;
//              }
//              break;
//            case 9:
//              {
//                taskList[i].sec3 = taskList[i].goal1Text;
//              }
//              break;
            case 4:
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

  void searchData(
      String? searchText,
      String? category,
      String? status,
      String? priority,
      String? tag1,
//      String? action1,
//      String? context1,
//      String? location1,
//      String? goal1,
      int? showIsStar,
      int? showIsDone) {
    if (searchText?.trim() != "" || searchText?.trim() == "") {
      final dbFuture = helper.initializeDb();
      dbFuture.then((result) {
        final tasksFuture = helper.searchTasks(
            searchText!,
            category.toString(),
            status.toString(),
            priority.toString(),
            tag1.toString(),
//            action1.toString(),
//            context1.toString(),
//            location1.toString(),
//            goal1.toString(),
            showIsStar!,
            showIsDone!);
        tasksFuture.then((result) {
          List<Task> taskList = [];
          count = result.length;
          for (int i = 0; i < count; i++) {
            taskList.add(Task.fromObject(result[i]));
            debugPrint(taskList[i].note);

/////////////////
            /// display sec1
////////////////
            switch (globals.showSec1) {
              case 0:
                {
                  taskList[i].sec1 = taskList[i].task;
                }
                break;
              case 1:
                {
                  taskList[i].sec1 = taskList[i].note;
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
                  taskList[i].sec1 = taskList[i].status;
                }
                break;
              case 6:
                {
                  taskList[i].sec1 = taskList[i].priority;
                }
                break;
              case 7:
                {
                  taskList[i].sec1 = taskList[i].tag1;
                }
                break;
//              case 7:
//                {
//                  taskList[i].sec1 = taskList[i].action1;
//                }
//                break;
//              case 8:
//                {
//                  taskList[i].sec1 = taskList[i].context1;
//                }
//                break;
//              case 9:
//                {
//                  taskList[i].sec1 = taskList[i].location1;
//                }
//                break;
//              case 11:
//                {
//                  taskList[i].sec1 = taskList[i].goal1;
//                }
//                break;
              case 8:
                {
                  taskList[i].sec1 = taskList[i].isStar.toString();
                }
                break;
              case 9:
                {
                  taskList[i].sec1 = taskList[i].isDone.toString();
                }
                break;
              default:
                {
                  taskList[i].sec1 = taskList[i].task;
                }
                break;
            }

/////////////////
            /// display sec2
////////////////
            switch (globals.showSec2) {
              case 0:
                {
                  taskList[i].sec2 = taskList[i].task;
                }
                break;
              case 1:
                {
                  taskList[i].sec2 = taskList[i].note;
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
                  taskList[i].sec2 = taskList[i].status;
                }
                break;
              case 6:
                {
                  taskList[i].sec2 = taskList[i].priority;
                }
                break;
              case 7:
                {
                  taskList[i].sec2 = taskList[i].tag1;
                }
                break;
//              case 7:
//                {
//                  taskList[i].sec2 = taskList[i].action1;
//                }
//                break;
//              case 8:
//                {
//                  taskList[i].sec2 = taskList[i].context1;
//                }
//                break;
//              case 9:
//                {
//                  taskList[i].sec2 = taskList[i].location1;
//                }
//                break;
//              case 11:
//                {
//                  taskList[i].sec2 = taskList[i].goal1;
//                }
//                break;
              case 8:
                {
                  taskList[i].sec2 = taskList[i].isStar.toString();
                }
                break;
              case 9:
                {
                  taskList[i].sec2 = taskList[i].isDone.toString();
                }
                break;
              default:
                {
                  taskList[i].sec2 = taskList[i].task;
                }
                break;
            }

/////////////////
            /// display sec3
////////////////
            switch (globals.showSec3) {
              case 0:
                {
                  taskList[i].sec3 = taskList[i].task;
                }
                break;
              case 1:
                {
                  taskList[i].sec3 = taskList[i].note;
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
                  taskList[i].sec3 = taskList[i].status;
                }
                break;
              case 6:
                {
                  taskList[i].sec3 = taskList[i].priority;
                }
                break;
              case 7:
                {
                  taskList[i].sec3 = taskList[i].tag1;
                }
                break;
//              case 7:
//                {
//                  taskList[i].sec3 = taskList[i].action1;
//                }
//                break;
//              case 8:
//                {
//                  taskList[i].sec3 = taskList[i].context1;
//                }
//                break;
//              case 9:
//                {
//                  taskList[i].sec3 = taskList[i].location1;
//                }
//                break;
//              case 11:
//                {
//                  taskList[i].sec3 = taskList[i].goal1;
//                }
//                break;
              case 8:
                {
                  taskList[i].sec3 = taskList[i].isStar.toString();
                }
                break;
              case 9:
                {
                  taskList[i].sec3 = taskList[i].isDone.toString();
                }
                break;
              default:
                {
                  taskList[i].sec3 = taskList[i].task;
                }
                break;
            }

            setState(() {
              tasklist = taskList;
              _searchText = searchText;
              count = count;
            });
          }
        });
      });
    } else {
      List<Task> taskList = [];
      count = 0;
      setState(() {
        tasklist = taskList;
        count = count;
      });
    }
  }

  //to get the custom user settings.  this in home now,  but depends on login screen logic we can move this method. KK
  _getCustomSettings() async {
    var _customSetting = await helper.getCustomSettings();
    if (_customSetting.length > 0) {
      customSetting = CustomSettings.fromObject(_customSetting[0]);
      if (customSetting != null && customSetting!.id != null) {
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
//        if (customSetting!.showMain1 != "") {
//          globals.showMain1 = int.parse(customSetting!.showMain1!);
//        }
//        if (customSetting!.showMain2 != "") {
//          globals.showMain2 = int.parse(customSetting!.showMain2!);
//        }
        if (customSetting!.showSec1 != "") {
          globals.showSec1 = int.parse(customSetting!.showSec1!);
        }
        if (customSetting!.showSec2 != "") {
          globals.showSec2 = int.parse(customSetting!.showSec2!);
        }
        if (customSetting!.showSec3 != "") {
          globals.showSec3 = int.parse(customSetting!.showSec3!);
        }
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
//        globals.filterLocation = customSetting!.filterLocation != ""
//            ? int.parse(customSetting!.filterLocation!)
//            : 0;
//        globals.filterGoal = customSetting!.filterGoal != ""
//            ? int.parse(customSetting!.filterGoal!)
//            : 0;
//        globals.filterContext = customSetting!.filterContext != ""
//            ? int.parse(customSetting!.filterContext!)
//            : 0;
//        globals.filterAction = customSetting!.filterAction != ""
//            ? int.parse(customSetting!.filterAction!)
//            : 0;
      }
    }
//    getData();
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
//      case 7:
//        return "action1";
//        break;
//      case 8:
//        return "context1";
//        break;
//      case 9:
//        return "location1";
//        break;
//      case 11:
//        return "goal1";
//        break;
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
