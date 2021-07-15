import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/screens/taskdetail.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/globals.dart' as globals;

DbHelper helper = DbHelper();
final _priorities = ["", "Low", "Medium", "High", "Top"];
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
  List<String> _categories = [""];  
  List<String> _action1s = [""];
  List<String> _context1s = [""];
  List<String> _location1s = [""];
  List<String> _tag1s = [""];
  List<Task> tasklist;
  int count = 0;
  TextEditingController searchController = TextEditingController();
  var _selectedCategory = "";
  var _selectedAction1 = "";
  var _selectedContext1 = "";
  var _selectedLocation1 = "";
  var _selectedTag1 = "";
//  var _selectedGoal1 = "";

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadAction1s();
    _loadContext1s();
    _loadLocation1s();
    _loadTag1s();
//    _loadGoal1s();
  }

  //##################Drop Down Items Load from DB #################################################################
  _loadCategories() async {
    var categories = await helper.getCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(category['name']);
      });
    });
  }

  _loadAction1s() async {
    var action1s = await helper.getActions();
    action1s.forEach((action1) {
      setState(() {
        _action1s.add(action1['name']);
      });
    });
  }

  _loadContext1s() async {
    var context1s = await helper.getContexts();
    context1s.forEach((context1) {
      setState(() {
        _context1s.add(context1['name']);
      });
    });
  }

  _loadLocation1s() async {
    var location1s = await helper.getLocations();
    location1s.forEach((location1) {
      setState(() {
        _location1s.add(location1['name']);
      });
    });
  }

  _loadTag1s() async {
    var tag1s = await helper.getTags();
    tag1s.forEach((tag1) {
      setState(() {
        _tag1s.add(tag1['name']);
      });
    });
  }

//  _loadGoal1s() async {
//    var goal1s = await helper.getGoals();
//    goal1s.forEach((goal1) {
//      setState(() {
//        _goal1s.add(goal1['name']);
//      });
//    });
//  }

//##########################################end of Dropdown #################################################################

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[900],
        automaticallyImplyLeading: false,
        title: Center(child: Text('Task Search')),
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: TextField(
              controller: searchController,
              style: textStyle,
              onChanged: (value) {
//                          searchData(value, _selectedpriority, _selectedCategory, _selectedAction1, _selectedContext1, _selectedLocation1, _selectedTag1, _selectedGoal1);
                searchData(value, _selectedCategory, _selectedAction1,
                    _selectedContext1, _selectedLocation1, _selectedTag1);
              },
              decoration: InputDecoration(
                  labelStyle: textStyle,
                  labelText: "Enter a search term",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(2.0),
              child: ExpansionTile(
                title: Text("Advanced Filters"),

                trailing: Icon(Icons.filter_list_outlined),

                // backgroundColor: Colors.yellow,
                children: [
                  Column(
                    children: [
//                Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: [
//                    Text("  Priority: ", style: _textStyleControls),
//                    Spacer(),
//                            DropdownButton<String>(
//
//                              items: _priorities.map((String value) {
//                                return DropdownMenuItem<String>(
//                                    value: value, child: Text(value));
//                              }).toList(),
//                              style: _textStyleControls,
//                              value: _selectedpriority,
//                              onChanged: (String newValue) {
//        setState(() {
//          _selectedpriority = newValue;
//          searchData(_searchText, _selectedpriority, _selectedCategory, _selectedAction1, _selectedContext1, _selectedLocation1, _selectedTag1, _selectedGoal1);
//          searchData(_searchText, _selectedCategory, _selectedAction1, _selectedContext1, _selectedLocation1, _selectedTag1);
//        });}
//                            ),
//
//           ],),
//#################################Category#####################################################
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("  Catogory: ", style: _textStyleControls),
                          Spacer(),
                          DropdownButton<String>(
                              items: _categories.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
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
                                      _selectedTag1);
                                });
                              }),
                        ],
                      ),
//########################################### Action  ######### #################################3
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "  Action: ",
                            style: _textStyleControls,
                          ),
                          Spacer(),
                          DropdownButton<String>(
                            items: _action1s.map((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                            style: _textStyleControls,
                            value: _selectedAction1,
                            onChanged: (value) {
                              setState(() {
                                _selectedAction1 = value;
//                    searchData(_searchText, _selectedpriority, _selectedCategory, _selectedAction1, _selectedContext1, _selectedLocation1, _selectedTag1, _selectedGoal1);
                                searchData(
                                    _searchText,
                                    _selectedCategory,
                                    _selectedAction1,
                                    _selectedContext1,
                                    _selectedLocation1,
                                    _selectedTag1);
                              });
                            },
                          )
                        ],
                      ),
//######### Context  #########
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "  Context: ",
                            style: _textStyleControls,
                          ),
                          Spacer(),
                          DropdownButton<String>(
                            items: _context1s.map((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
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
                                    _selectedTag1);
                              });
                            },
                          )
                        ],
                      ),
// //######### Location  #########
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "  Location: ",
                            style: _textStyleControls,
                          ),
                          Spacer(),
                          DropdownButton<String>(
                            items: _location1s.map((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
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
                                    _selectedTag1);
                              });
                            },
                          )
                        ],
                      ),
// //######### Tag  #########
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "  Tag: ",
                            style: _textStyleControls,
                          ),
                          Spacer(),
                          DropdownButton<String>(
                            items: _tag1s.map((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
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
                                    _selectedTag1);
                              });
                            },
                          )
                        ],
                      ),
// //######### Goal  #########
//    Row(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: [
//        Text("  Goal: ", style: _textStyleControls,),
//        Spacer(),
//        DropdownButton<String>(
//                              items: _goal1s.map((String value) {
//                                return DropdownMenuItem<String>(
//                                    value: value, child: Text(value));
//                              }).toList(),
//                              style: _textStyleControls,
//                              value: _selectedGoal1,
//                onChanged: (value) {
//                  setState(() {
//                    _selectedGoal1 = value;
//                  searchData(_searchText, _selectedCategory, _selectedAction1, _selectedContext1, _selectedLocation1, _selectedTag1);
//                  });
//               },
//              )
//               ],)
                    ],
                  )
                ],
              )),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(count.toString() + " Results found.."))),
          
          

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

  // ListView taskListItems() {
  //   return ListView.builder(
  //     itemCount: count,
  //     itemBuilder: (BuildContext context, int position) {
  //       return Card(
  //         color: Colors.yellow[200],
  //         elevation: 2.0,
  //         // // child: ListTile(
  //         // //   leading: Icon(Icons.add_alert),
  //         // //   title: Text(this.tasklist[position].title),
  //         // //   subtitle: Text(this.tasklist[position].description +
  //         // //       " " +
  //         // //       this.tasklist[position].prioritytext),
  //         // //   trailing: Icon(Icons.keyboard_arrow_right),
  //         // //   onTap: () {
  //         // //      navigateToDetail(this.tasklist[position]);
  //         // //   },
  //         // // ),
  //         //Commented now or revmove the child

  //         child: Padding(
  //             padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
  //             child: Card(
  //                 color: Colors.yellow[200],
  //                 elevation: 8.0,
  //                 child: CheckboxListTile(
  //                   controlAffinity: ListTileControlAffinity.leading,
  //                   title: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                   Flexible(
  //                           child: Padding(
  //                               padding: const EdgeInsets.only(right: 2),
  //                               child: Text(this.tasklist[position].main1,
  //                                       overflow: TextOverflow.ellipsis))),
  //                                Flexible(
  //                           child: Padding(
  //                               padding: const EdgeInsets.only(right: 2),
  //                               child: Text(this.tasklist[position].main2,
  //                                       overflow: TextOverflow.ellipsis))),
  //                     ],
                   
  //                   ),
  //                   subtitle: Row(
  //                     children: [
  //                      // Text(this.tasklist[position].sec1),
  //                       Flexible(
  //                           child: Padding(
  //                               padding: const EdgeInsets.only(right: 2),
  //                               child: Text(this.tasklist[position].sec1,
  //                                       overflow: TextOverflow.ellipsis))),
                      
  //                      // SizedBox(width: 5.0),
  //                      // Text(this.tasklist[position].sec2),
  //                       Flexible(
  //                           child: Padding(
  //                               padding: const EdgeInsets.only(right: 2),
  //                               child: Text(this.tasklist[position].sec2,
  //                                       overflow: TextOverflow.ellipsis))),
                      
  //                    //   SizedBox(width: 5.0),
  //                      // Text(this.tasklist[position].sec3),
  //                      Flexible(
  //                           child: Padding(
  //                               padding: const EdgeInsets.only(right: 2),
  //                               child: Text(this.tasklist[position].sec3,
  //                                       overflow: TextOverflow.ellipsis))),
                  
  //                     ],
  //                   ),
  //                   isThreeLine: false,
  //                   secondary: IconButton(
  //                     icon: Icon(Icons.more_vert),
  //                     onPressed: () {
  //                       navigateToDetail(this.tasklist[position]);
  //                     },
  //                   ),
  //                   dense: true,
  //                   value: (this.tasklist[position].isDone == 1),
  //                   onChanged: (value) {
  //                     setState(() {
  //                       DateTime now = DateTime.now();
  //                       String formattedDate =
  //                           DateFormat('yyyy-mm-dd').format(now);
  //                       if (value == true) {
  //                         this.tasklist[position].isDone = 1;
  //                         this.tasklist[position].dateDone = formattedDate;
  //                         dbHelper.updateTask(tasklist[position]);
  //                       } else {
  //                         this.tasklist[position].isDone = 0;
  //                         this.tasklist[position].dateDone = '';
  //                         dbHelper.updateTask(tasklist[position]);
  //                       }
  //                     });
  //                   },
  //                   activeColor: Colors.brown[900],
  //                   checkColor: Colors.white,
  //                   autofocus: true,
  //                 )),
  //           )
  //       );
  //     },
  //   );
  // }

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

                    Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(this.tasklist[position].main1 == null ? "" : this.tasklist[position].main1,
                                        overflow: TextOverflow.ellipsis))),

                                 Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(this.tasklist[position].main2 == null ? "" : this.tasklist[position].main2,
                                        overflow: TextOverflow.ellipsis))),
                      ],
                   
                    ),
                    subtitle: Row(
                      children: [
                       
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(this.tasklist[position].sec1 == null ? "" : this.tasklist[position].sec1,
                                        overflow: TextOverflow.ellipsis))),
                      
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(this.tasklist[position].sec2 == null ? "" : this.tasklist[position].sec2,
                                        overflow: TextOverflow.ellipsis))),

                       Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(this.tasklist[position].sec3 == null ? "" : this.tasklist[position].sec3,
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
    // if (result == true) {
    //   getData();
    // }
  }

  void searchData(String searchText, String category, String action1,
      String context1, String location1, String tag1) {
    if (searchText.trim() != "" || searchText.trim() == "") {
      final dbFuture = helper.initializeDb();
      dbFuture.then((result) {
//      final tasksFuture = helper.searchTasks(searchText, priority, category, action1, context1, location1, tag1, goal1);
        final tasksFuture = helper.searchTasks(
            searchText, category, action1, context1, location1, tag1);
        tasksFuture.then((result) {
          List<Task> taskList = List<Task>();
          count = result.length;
          for (int i = 0; i < count; i++) {
            taskList.add(Task.fromObject(result[i]));
            debugPrint(taskList[i].description);

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
            _searchText = searchText;
//          _selectedpriority = priority;
            count = count;
          });
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