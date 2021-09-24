import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/screens/taskdetail.dart';
import 'package:todo_app/model/customDropdownItem.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/globals.dart' as globals;

DbHelper helper = DbHelper();
String _selectedpriority = "";
String _searchText = "";
TextStyle _textStyleControls =
    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800, color: Colors.black);

class TaskSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TaskSearchState();
}

class TaskSearchState extends State {
  DbHelper helper = DbHelper();
  List<CustomDropdownItem> _categories = [];
  List<CustomDropdownItem> _action1s = [];
  List<CustomDropdownItem> _context1s = [];
  List<CustomDropdownItem> _location1s = [];
  List<CustomDropdownItem> _tag1s = [];
  List<CustomDropdownItem> _goal1s = [];
  List<Task> tasklist;
  int count = 0;
  TextEditingController searchController = TextEditingController();
  var _selectedCategory = null;
  var _selectedAction1 = null;
  var _selectedContext1 = null;
  var _selectedLocation1 = null;
  var _selectedTag1 = null;
  var _selectedGoal1 = null;

//  var _selectedGoal1 = "";

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadAction1s();
    _loadContext1s();
    _loadLocation1s();
    _loadTag1s();
    _loadGoal1s();
//    _loadGoal1s();
  }

  //##################Drop Down Items Load from DB #################################################################
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
    var action1s = await helper.getActions();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "--Select Action--             ";
    _action1s.add(cus);
    action1s.forEach((action1) {
      setState(() {
        cus = new CustomDropdownItem();
        cus.id = action1['id'].toString();
        String tempAct;
        if (action1['name'].toString().length > 30)
          tempAct = action1['name'].toString().substring(0, 30) + "...";
        else
          tempAct = action1['name'];

        cus.name = tempAct;

        _action1s.add(cus);
      });
    });
  }

  _loadContext1s() async {
    var context1s = await helper.getContexts();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "--Select Context--            ";
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
    var location1s = await helper.getLocations();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "--Select Location--           ";
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
    var tag1s = await helper.getTags();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "--Select Tag--                ";
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
    var goal1s = await helper.getGoals();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "--Select Goal --                ";
    _goal1s.add(cus);
    goal1s.forEach((goal1) {
      setState(() {
        cus = new CustomDropdownItem();
        cus.id = goal1['id'].toString();
        String tempGoal1;
        if (goal1['name'].toString().length > 30)
          tempGoal1 = goal1['name'].toString().substring(0, 30) + "...";
        else
          tempGoal1 = goal1['name'];

        cus.name = tempGoal1;
        _goal1s.add(cus);
      });
    });
  }

//##########################################end of Dropdown #################################################################

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[900],
        automaticallyImplyLeading: false,
//        title: Center(child: Text('Search')),
        title: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Badge(
                  child: Text('Search  '),
                  badgeContent: Text(count.toString(), style: TextStyle(color: Colors.white)),
                  badgeColor: Colors.red,
                ),
              ],
            ),
          ),
        ),      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.0, left:8.0, right:8.0, bottom:6.0),
            child: TextField(
              controller: searchController,
              style: textStyle,
              onChanged: (value) {
                searchData(
                    value,
                    _selectedCategory,
                    _selectedAction1,
                    _selectedContext1,
                    _selectedLocation1,
                    _selectedTag1,
                    _selectedGoal1);
              },
              decoration: InputDecoration(
                labelStyle: textStyle,
                fillColor: Colors.green[100],
                border: InputBorder.none,
                filled: true, // dont forget this line
                labelText: "Enter a search term",
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
//#################################Category#####################################################
                      Container(
                        margin:
                            EdgeInsets.only(left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                                items:
                                    _categories.map((CustomDropdownItem value) {
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
                                    searchData(
                                        _searchText,
                                        _selectedCategory,
                                        _selectedAction1,
                                        _selectedContext1,
                                        _selectedLocation1,
                                        _selectedTag1,
                                        _selectedGoal1);
                                  });
                                }),
                          ],
                        ),
                      ),

//########################################### Action  ######### #################################3
                      Container(
                        margin: EdgeInsets.only(
                            top: 4.0, left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DropdownButton<String>(
                                items:
                                    _action1s.map((CustomDropdownItem value) {
                                  return DropdownMenuItem<String>(
                                      value: value.id, child: Text(value.name));
                                }).toList(),
                                style: _textStyleControls,
                                value: _selectedAction1,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAction1 = value;
                                    searchData(
                                        _searchText,
                                        _selectedCategory,
                                        _selectedAction1,
                                        _selectedContext1,
                                        _selectedLocation1,
                                        _selectedTag1,
                                        _selectedGoal1);
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
//######### Context  #########
                      Container(
                        margin: EdgeInsets.only(
                            top: 4.0, left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              items: _context1s.map((CustomDropdownItem value) {
                                return DropdownMenuItem<String>(
                                    value: value.id, child: Text(value.name));
                              }).toList(),
                              style: _textStyleControls,
                              value: _selectedContext1,
                              onChanged: (value) {
                                setState(() {
                                  _selectedContext1 = value;
                                  searchData(
                                      _searchText,
                                      _selectedCategory,
                                      _selectedAction1,
                                      _selectedContext1,
                                      _selectedLocation1,
                                      _selectedTag1,
                                      _selectedGoal1);
                                });
                              },
                            )
                          ],
                        ),
                      ),
// //######### Location  #########
                      Container(
                        margin: EdgeInsets.only(
                            top: 4.0, left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              items:
                                  _location1s.map((CustomDropdownItem value) {
                                return DropdownMenuItem<String>(
                                    value: value.id, child: Text(value.name));
                              }).toList(),
                              style: _textStyleControls,
                              value: _selectedLocation1,
                              onChanged: (value) {
                                setState(() {
                                  _selectedLocation1 = value;
                                  searchData(
                                      _searchText,
                                      _selectedCategory,
                                      _selectedAction1,
                                      _selectedContext1,
                                      _selectedLocation1,
                                      _selectedTag1,
                                      _selectedGoal1);
                                });
                              },
                            )
                          ],
                        ),
                      ),
// //######### Tag  #########
                      Container(
                        margin:
                            EdgeInsets.only(top:4.0, left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              items: _tag1s.map((CustomDropdownItem value) {
                                return DropdownMenuItem<String>(
                                    value: value.id, child: Text(value.name));
                              }).toList(),
                              style: _textStyleControls,
                              value: _selectedTag1,
                              onChanged: (value) {
                                setState(() {
                                  _selectedTag1 = value;
                                  searchData(
                                      _searchText,
                                      _selectedCategory,
                                      _selectedAction1,
                                      _selectedContext1,
                                      _selectedLocation1,
                                      _selectedTag1,
                                      _selectedGoal1);
                                });
                              },
                            )
                          ],
                        ),
                      ),
// //######### Goal  #########
                      Container(
                        margin:
                            EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              items: _goal1s.map((CustomDropdownItem value) {
                                return DropdownMenuItem<String>(
                                    value: value.id, child: Text(value.name));
                              }).toList(),
                              style: _textStyleControls,
                              value: _selectedGoal1,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGoal1 = value;
                                  searchData(
                                      _searchText,
                                      _selectedCategory,
                                      _selectedAction1,
                                      _selectedContext1,
                                      _selectedLocation1,
                                      _selectedTag1,
                                      _selectedGoal1);
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )),
//          Padding(
//              padding: EdgeInsets.all(8.0),
//              child: Align(
//                  alignment: Alignment.topLeft,
//                  child: Text(count.toString() + " Results found..",
//                      style: _textStyleControls))),
          Expanded(
            child: Container(child: taskListItems()),
          ),
        ],
      ),

//footer
      //bottomNavigationBar: footerBar,

      bottomNavigationBar: Container(
        height: 55.0,
        child: BottomAppBar(
          // color: Color.fromRGBO(58, 66, 86, 1.0),
          color: Colors.brown[900],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                tooltip: 'Back to Home',
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        ),
      ),
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
              padding:
                  EdgeInsets.only(top: 1.0, left: 4.0, right: 4.0, bottom: 1.0),
              child: Card(
                  color: Colors.yellow[200],
//                  elevation: 8.0,
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 1),
                                child: Text(
                                    this.tasklist[position].main1 == null
                                        ? ""
                                        : this.tasklist[position].main1,
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

  void navigateToDetail(Task task) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetail(task)),
    );
  }

  void searchData(String searchText, String category, String action1,
      String context1, String location1, String tag1, String goal1) {
    if (searchText.trim() != "" || searchText.trim() == "") {
      final dbFuture = helper.initializeDb();
      dbFuture.then((result) {
//      final tasksFuture = helper.searchTasks(searchText, priority, category, action1, context1, location1, tag1, goal1);
        final tasksFuture = helper.searchTasks(
            searchText, category, action1, context1, location1, tag1, goal1);
        tasksFuture.then((result) {
          List<Task> taskList = List<Task>();
          count = result.length;
          for (int i = 0; i < count; i++) {
            taskList.add(Task.fromObject(result[i]));
            debugPrint(taskList[i].note);

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
                  taskList[i].main1 = taskList[i].status;
                }
                break;
              case 5:
                {
                  taskList[i].main1 = taskList[i].priority;
                }
                break;
              case 6:
                {
                  taskList[i].main1 = taskList[i].star;
                }
                break;
              case 7:
                {
                  taskList[i].main1 = taskList[i].category;
                }
                break;
              case 8:
                {
                  taskList[i].main1 = taskList[i].action1;
                }
                break;
              case 9:
                {
                  taskList[i].main1 = taskList[i].context1;
                }
                break;
              case 10:
                {
                  taskList[i].main1 = taskList[i].location1;
                }
                break;
              case 11:
                {
                  taskList[i].main1 = taskList[i].tag1;
                }
                break;
              case 12:
                {
                  taskList[i].main1 = taskList[i].goal1;
                }
                break;
              default:
                {
                  taskList[i].main1 = taskList[i].task;
                }
                break;
            }

/////////////////
            /// display main2
////////////////
            switch (globals.showMain2) {
              case 0:
                {
                  taskList[i].main2 = taskList[i].task;
                }
                break;
              case 1:
                {
                  taskList[i].main2 = taskList[i].note;
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
                  taskList[i].main2 = taskList[i].status;
                }
                break;
              case 5:
                {
                  taskList[i].main2 = taskList[i].priority;
                }
                break;
              case 6:
                {
                  taskList[i].main2 = taskList[i].star;
                }
                break;
              case 7:
                {
                  taskList[i].main2 = taskList[i].category;
                }
                break;
              case 8:
                {
                  taskList[i].main2 = taskList[i].action1;
                }
                break;
              case 9:
                {
                  taskList[i].main2 = taskList[i].context1;
                }
                break;
              case 10:
                {
                  taskList[i].main2 = taskList[i].location1;
                }
                break;
              case 11:
                {
                  taskList[i].main2 = taskList[i].tag1;
                }
                break;
              case 12:
                {
                  taskList[i].main2 = taskList[i].goal1;
                }
                break;
              default:
                {
                  taskList[i].main2 = taskList[i].task;
                }
                break;
            }

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
                  taskList[i].sec1 = taskList[i].status;
                }
                break;
              case 5:
                {
                  taskList[i].sec1 = taskList[i].priority;
                }
                break;
              case 6:
                {
                  taskList[i].sec1 = taskList[i].star;
                }
                break;
              case 7:
                {
                  taskList[i].sec1 = taskList[i].category;
                }
                break;
              case 8:
                {
                  taskList[i].sec1 = taskList[i].action1;
                }
                break;
              case 9:
                {
                  taskList[i].sec1 = taskList[i].context1;
                }
                break;
              case 10:
                {
                  taskList[i].sec1 = taskList[i].location1;
                }
                break;
              case 11:
                {
                  taskList[i].sec1 = taskList[i].tag1;
                }
                break;
              case 12:
                {
                  taskList[i].sec1 = taskList[i].goal1;
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
                  taskList[i].sec2 = taskList[i].status;
                }
                break;
              case 5:
                {
                  taskList[i].sec2 = taskList[i].priority;
                }
                break;
              case 6:
                {
                  taskList[i].sec2 = taskList[i].star;
                }
                break;
              case 7:
                {
                  taskList[i].sec2 = taskList[i].category;
                }
                break;
              case 8:
                {
                  taskList[i].sec2 = taskList[i].action1;
                }
                break;
              case 9:
                {
                  taskList[i].sec2 = taskList[i].context1;
                }
                break;
              case 10:
                {
                  taskList[i].sec2 = taskList[i].location1;
                }
                break;
              case 11:
                {
                  taskList[i].sec2 = taskList[i].tag1;
                }
                break;
              case 12:
                {
                  taskList[i].sec2 = taskList[i].goal1;
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
                  taskList[i].sec3 = taskList[i].status;
                }
                break;
              case 5:
                {
                  taskList[i].sec3 = taskList[i].priority;
                }
                break;
              case 6:
                {
                  taskList[i].sec3 = taskList[i].star;
                }
                break;
              case 7:
                {
                  taskList[i].sec3 = taskList[i].category;
                }
                break;
              case 8:
                {
                  taskList[i].sec3 = taskList[i].action1;
                }
                break;
              case 9:
                {
                  taskList[i].sec3 = taskList[i].context1;
                }
                break;
              case 10:
                {
                  taskList[i].sec3 = taskList[i].location1;
                }
                break;
              case 11:
                {
                  taskList[i].sec3 = taskList[i].tag1;
                }
                break;
              case 12:
                {
                  taskList[i].sec3 = taskList[i].goal1;
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
      List<Task> taskList = List<Task>();
      count = 0;
      setState(() {
        tasklist = taskList;
        count = count;
      });
    }
  }
}
