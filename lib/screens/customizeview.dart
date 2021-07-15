import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/model/customSettings.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/globals.dart' as globals;

class CustomizeView extends StatefulWidget {
  @override
  _CustomizeViewState createState() => _CustomizeViewState();
}

class SortItem {
  int id;
  String name;

  SortItem(this.id, this.name);
  static List<SortItem> getSort() {
    return <SortItem>[
      SortItem(0, 'Title'),
      SortItem(1, 'Description'),
      SortItem(2, 'Due Date'),
      SortItem(3, 'Due Time'),
      SortItem(4, 'Category'),
      SortItem(5, 'Action'),
      SortItem(6, 'Context'),
      SortItem(7, 'Location'),
      SortItem(8, 'Tag'),
    ];
  }
}

class CompletedItem {
  int id;
  String name;

  CompletedItem(this.id, this.name);
  static List<CompletedItem> getCompleted() {
    return <CompletedItem>[
      CompletedItem(0, 'Hide'),
      CompletedItem(1, 'Show'),
    ];
  }
}

class DueDateItem {
  int id;
  String name;

  DueDateItem(this.id, this.name);
  static List<DueDateItem> getDueDate() {
    return <DueDateItem>[
      DueDateItem(0, 'Today'),
      DueDateItem(1, 'Tomorrow'),
      DueDateItem(2, 'Next 7 days'),
      DueDateItem(3, 'Next 30 days'),
      DueDateItem(4, 'Any Due Date'),
      DueDateItem(5, 'No Due Date'),
      DueDateItem(6, 'Overdue'),
      DueDateItem(7, 'All'),
    ];
  }
}

class SortOrder {
  int id;
  String name;

  SortOrder(this.id, this.name);
  static List<SortOrder> getOrder() {
    return <SortOrder>[
      SortOrder(0, 'a -> Z'),
      SortOrder(1, 'Z -> a'),
    ];
  }
}

class _CustomizeViewState extends State //State<CustomizeView>
{
  List<SortItem> _sort = SortItem.getSort();
  List<SortOrder> _order = SortOrder.getOrder();
  List<CompletedItem> _completed = CompletedItem.getCompleted();
  List<DueDateItem> _dueDate = DueDateItem.getDueDate(); 
  List<DropdownMenuItem<CompletedItem>> _dropdownCompletedItems;
  List<DropdownMenuItem<SortItem>> _dropdownMenuItemsSort;
  List<DropdownMenuItem<DueDateItem>> _dropdownDueDateItems; 
  List<DropdownMenuItem<SortOrder>> _dropdownMenuSortOrder;
  CompletedItem _selectedShowCompleted;
  DueDateItem _selectedShowDueDate; 
  SortItem _selectedSort1;
  SortOrder _selectedOrder1;
  SortItem _selectedSort2;
  SortOrder _selectedOrder2;
  SortItem _selectedSort3;
  SortOrder _selectedOrder3; 
  SortItem _selectedMain1;
  SortItem _selectedMain2;
  SortItem _selectedSec1;
  SortItem _selectedSec2;
  SortItem _selectedSec3;
  DbHelper helper = DbHelper();
  CustomSettings customSetting;

  //
  @override
  void initState() {
    _dropdownMenuItemsSort = buildDropdownMenuItems(_sort);
    _dropdownMenuSortOrder  = buildDropdownMenuOrder(_order);
    _dropdownCompletedItems = buildDropdownCompletedItems(_completed);
    _dropdownDueDateItems = buildDropdownDueDateItems(_dueDate);

    ////////////////////////////
    /// show - due date
    ////////////////////////////
    if (globals.showDueDate == null) {
      _selectedShowDueDate = _dropdownDueDateItems[0].value;
      globals.showDueDate = 0;
    } else
      _selectedShowDueDate =
          _dropdownDueDateItems[globals.showDueDate].value;

    ////////////////////////////
    /// show - completed
    ////////////////////////////
    if (globals.showCompleted == null) {
      _selectedShowCompleted = _dropdownCompletedItems[0].value;
      globals.showCompleted = 0;
    } else
      _selectedShowCompleted =
          _dropdownCompletedItems[globals.showCompleted].value;
    ////////////////////////////

    ////////////////////////////
    //Sort
    ////////////////////////////
    if (globals.sort1 == null) {
      _selectedSort1 = _dropdownMenuItemsSort[2].value;
      globals.sort1 = 2;
    } else
      _selectedSort1 = _dropdownMenuItemsSort[globals.sort1].value;

    if (globals.order1 == null) {
      _selectedOrder1 = _dropdownMenuSortOrder[0].value;
      globals.order1 = 0;
    } else
      _selectedOrder1 =
          _dropdownMenuSortOrder[globals.order1].value;


    if (globals.sort2 == null) {
      _selectedSort2 = _dropdownMenuItemsSort[3].value;
      globals.sort2 = 3;
    } else
      _selectedSort2 = _dropdownMenuItemsSort[globals.sort2].value;
    if (globals.order2 == null) {
      _selectedOrder2 = _dropdownMenuSortOrder[0].value;
      globals.order2 = 0;
    } else
      _selectedOrder2 =
          _dropdownMenuSortOrder[globals.order2].value;


    if (globals.sort3 == null) {
      _selectedSort3 = _dropdownMenuItemsSort[0].value;
      globals.sort3 = 0;
    } else
      _selectedSort3 = _dropdownMenuItemsSort[globals.sort3].value;
    if (globals.order3 == null) {
      _selectedOrder3 = _dropdownMenuSortOrder[0].value;
      globals.order3 = 0;
    } else
      _selectedOrder3 =
          _dropdownMenuSortOrder[globals.order3].value;

    ////////////////////////////
    /// show
    ////////////////////////////
    if (globals.showMain1 == null) {
      _selectedMain1 = _dropdownMenuItemsSort[2].value;
      globals.showMain1 = 2;
    } else
      _selectedMain1 = _dropdownMenuItemsSort[globals.showMain1].value;
    if (globals.showMain2 == null) {
      _selectedMain2 = _dropdownMenuItemsSort[2].value;
      globals.showMain2 = 2;
    } else
      _selectedMain2 = _dropdownMenuItemsSort[globals.showMain2].value;
    if (globals.showSec1 == null) {
      _selectedSec1 = _dropdownMenuItemsSort[2].value;
      globals.showSec1 = 2;
    } else
      _selectedSec1 = _dropdownMenuItemsSort[globals.showSec1].value;
    if (globals.showSec2 == null) {
      _selectedSec2 = _dropdownMenuItemsSort[2].value;
      globals.showSec2 = 2;
    } else
      _selectedSec2 = _dropdownMenuItemsSort[globals.showSec2].value;
    if (globals.showSec3 == null) {
      _selectedSec3 = _dropdownMenuItemsSort[2].value;
      globals.showSec3 = 2;
    } else
      _selectedSec3 = _dropdownMenuItemsSort[globals.showSec3].value;

    _getCustomSettings();

    super.initState();
  }

  List<DropdownMenuItem<SortItem>> buildDropdownMenuItems(List sortItems) {
    List<DropdownMenuItem<SortItem>> items = List();
    for (SortItem sortItem in sortItems) {
      items.add(
        DropdownMenuItem(
          value: sortItem,
          child: Text(sortItem.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<SortOrder>> buildDropdownMenuOrder(List orderItems) {
    List<DropdownMenuItem<SortOrder>> order = List();
    for (SortOrder sortOrder in orderItems) {
      order.add(
        DropdownMenuItem(
          value: sortOrder,
          child: Text(sortOrder.name),
        ),
      );
    }
    return order;
  }

    List<DropdownMenuItem<CompletedItem>> buildDropdownCompletedItems(
      List completedItems) {
    List<DropdownMenuItem<CompletedItem>> items = List();
    for (CompletedItem completedItem in completedItems) {
      items.add(
        DropdownMenuItem(
          value: completedItem,
          child: Text(completedItem.name),
        ),
      );
    }
    return items;
  }


  List<DropdownMenuItem<DueDateItem>> buildDropdownDueDateItems(
      List dueDateItems) {
    List<DropdownMenuItem<DueDateItem>> items = List();
    for (DueDateItem dueDateItem in dueDateItems) {
      items.add(
        DropdownMenuItem(
          value: dueDateItem,
          child: Text(dueDateItem.name),
        ),
      );
    }
    return items;
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      key: _globalKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: new AppBar(
        backgroundColor: Colors.brown[900],
        automaticallyImplyLeading: false,
        title: Center(child: Text('View - Filter, Sort, Show')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
///////////////////////////
//  Filter Due Date
///////////////////////////
              Text("Filter - Due Date"),

              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: DropdownButtonFormField(
                  items: _dropdownDueDateItems,
                  hint: Text('Filter by Due Date'),
                  value: _selectedShowDueDate,
                  onChanged: (selectedDueDateItems) {
                    setState(() {
                      _selectedShowDueDate = selectedDueDateItems;
                    });
                  },
                ),
              ),

///////////////////////////
//  Filter Completed
///////////////////////////
              Text("Filter - Completed Tasks"),

              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: DropdownButtonFormField(
                  items: _dropdownCompletedItems,
                  hint: Text('Filter by Completed Tasks'),
                  value: _selectedShowCompleted,
                  onChanged: (selectedCompletedItems) {
                    setState(() {
                      _selectedShowCompleted = selectedCompletedItems;
                    });
                  },
                ),
              ),

              SizedBox(
                height: 20,
              ),

///////////////////////////
//  SORT ORDER 1
///////////////////////////
              Text("Sort 1"),
///////////////////////////
//  SORT ORDER 1
///////////////////////////
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.pink[100]),
                child: DropdownButtonFormField(
                  value: _selectedSort1,
                  items: _dropdownMenuItemsSort,
                  hint: Text('Sort Order 1'),
                  onChanged: (selectedSort) {
                    setState(() {
                      _selectedSort1 = selectedSort;
                    });
                  },
                ),
              ),
///////////////////////////
//  SORT ORDER 1 ASC/DESC
///////////////////////////
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.pink[100]),
                child: DropdownButtonFormField(
                  value: _selectedOrder1,
                  items: _dropdownMenuSortOrder,
                  hint: Text('Sort 1 Ascending/Descending'),
                  onChanged: (selectedOrder) {
                    setState(() {
                      _selectedOrder1 = selectedOrder;
                    });
                  },
                ),
              ),
///////////////////////////
//  SORT ORDER 2
///////////////////////////
              Text("Sort 2"),
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.pink[100]),
                child: DropdownButtonFormField(
                  items: _dropdownMenuItemsSort,
                  hint: Text('Sort 2'),
                  value: _selectedSort2,
                  onChanged: (selectedSort) {
                    setState(() {
                      _selectedSort2 = selectedSort;
                    });
                  },
                ),
              ),
///////////////////////////
//  SORT ORDER 2 ASC/DESC
///////////////////////////
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.pink[100]),
                child: DropdownButtonFormField(
                  value: _selectedOrder2,
                  items: _dropdownMenuSortOrder,
                  hint: Text('Sort 2 Ascending/Descending'),
                  onChanged: (selectedOrder) {
                    setState(() {
                      _selectedOrder2 = selectedOrder;
                    });
                  },
                ),
              ),
///////////////////////////
//  SORT ORDER 3
///////////////////////////
              Text("Sort 3"),
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.pink[100]),
                child: DropdownButtonFormField(
                  items: _dropdownMenuItemsSort,
                  hint: Text('Sort 3'),
                  value: _selectedSort3,
                  onChanged: (selectedSort) {
                    setState(() {
                      _selectedSort3 = selectedSort;
                    });
                  },
                ),
              ),
///////////////////////////
//  SORT ORDER 3 ASC/DESC
///////////////////////////
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.pink[100]),
                child: DropdownButtonFormField(
                  value: _selectedOrder3,
                  items: _dropdownMenuSortOrder,
                  hint: Text('Sort Order 3 Ascending/Descending'),
                  onChanged: (selectedOrder) {
                    setState(() {
                      _selectedOrder3 = selectedOrder;
                    });
                  },
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Text("Show - Main line"),
///////////////////////////
//  Show Main 1
///////////////////////////
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.green[100]),
                child: DropdownButtonFormField(
                  items: _dropdownMenuItemsSort,
                  hint: Text('Display Main1'),
                  value: _selectedMain1,
                  onChanged: (selectedShow) {
                    setState(() {
                      _selectedMain1 = selectedShow;
                    });
                  },
                ),
              ),
///////////////////////////
//  Show Main 2
///////////////////////////
//              new Container(
//                margin: const EdgeInsets.all(2.0),
//                decoration: BoxDecoration(
//                    shape: BoxShape.rectangle, color: Colors.green[100]),
//                child: DropdownButtonFormField(
//                  items: _dropdownMenuItemsSort,
//                  hint: Text('Display Main2'),
//                  value: _selectedMain2,
//                  onChanged: (selectedShow) {
//                    setState(() {
//                      _selectedMain2 = selectedShow;
//                    });
//                  },
//                ),
//              ),
///////////////////////////
//  Show Secondary 1
///////////////////////////
              Text("Show - Second Line"),
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.green[100]),
                child: DropdownButtonFormField(
                  items: _dropdownMenuItemsSort,
                  hint: Text('Display Secondary1'),
                  value: _selectedSec1,
                  onChanged: (selectedShow) {
                    setState(() {
                      _selectedSec1 = selectedShow;
                    });
                  },
                ),
              ),
///////////////////////////
//  Show Secondary 2
///////////////////////////
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.green[100]),
                child: DropdownButtonFormField(
                  items: _dropdownMenuItemsSort,
                  hint: Text('Display Secondary2'),
                  value: _selectedSec2,
                  onChanged: (selectedShow) {
                    setState(() {
                      _selectedSec2 = selectedShow;
                    });
                  },
                ),
              ),
///////////////////////////
//  Show Secondary 3
///////////////////////////
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.green[100]),
                child: DropdownButtonFormField(
                  items: _dropdownMenuItemsSort,
                  hint: Text('Display Secondary3'),
                  value: _selectedSec3,
                  onChanged: (selectedShow) {
                    setState(() {
                      _selectedSec3 = selectedShow;
                    });
                  },
                ),
              ),

              SizedBox(
                height: 20,
              ),


              /// form - save or cancel
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.brown[900]),
                      )),
                  SizedBox(width: 10),
                  RaisedButton(
                      onPressed: () {
                        setState(() {
                          if (_selectedSort1 != null)
                            globals.sort1 = _selectedSort1.id;
                          if (_selectedOrder1 != null)
                            globals.order1 = _selectedOrder1.id;
                          if (_selectedSort2 != null)
                            globals.sort2 = _selectedSort2.id;
                          if (_selectedOrder2 != null)
                            globals.order2 = _selectedOrder2.id;
                          if (_selectedSort3 != null)
                            globals.sort3 = _selectedSort3.id;
                          if (_selectedOrder3 != null)
                            globals.order3 = _selectedOrder3.id;
                          if (_selectedMain1 != null)
                            globals.showMain1 = _selectedMain1.id;
                          print(globals.showMain1);
                          if (_selectedMain2 != null)
                            globals.showMain2 = _selectedMain2.id;
                          print(globals.showMain2);
                          if (_selectedSec1 != null)
                            globals.showSec1 = _selectedSec1.id;
                          print(globals.showSec1);
                          if (_selectedSec2 != null)
                            globals.showSec2 = _selectedSec2.id;
                          print(globals.showSec2);
                          if (_selectedSec3 != null)
                            globals.showSec3 = _selectedSec3.id;
                          print(globals.showSec3);
                          if (_selectedShowCompleted != null)
                            globals.showCompleted = _selectedShowCompleted.id;
                          if (_selectedShowDueDate != null)
                            globals.showDueDate = _selectedShowDueDate.id;

//Save
                          if (customSetting == null) {
                            customSetting = new CustomSettings(
                                '', '', '', '','','','', '', '', '', '', false,'');
                          }

                          customSetting.sort1 = _selectedSort1 == null
                              ? ""
                              : _selectedSort1.id.toString();
                          customSetting.order1 = _selectedOrder1 == null
                              ? ""
                              : _selectedOrder1.id.toString();
                          customSetting.sort2 = _selectedSort2 == null
                              ? ""
                              : _selectedSort2.id.toString();
                          customSetting.order2 = _selectedOrder2 == null
                              ? ""
                              : _selectedOrder2.id.toString();
                          customSetting.sort3 = _selectedSort3 == null
                              ? ""
                              : _selectedSort3.id.toString();
                          customSetting.order3 = _selectedOrder3 == null
                              ? ""
                              : _selectedOrder3.id.toString();
                          customSetting.fieldToDisplay1 = _selectedMain1 == null
                              ? ""
                              : _selectedMain1.id.toString();
                          customSetting.fieldToDisplay2 = _selectedMain2 == null
                              ? ""
                              : _selectedMain2.id.toString();
                          customSetting.fieldToDisplay3 = _selectedSec1 == null
                              ? ""
                              : _selectedSec1.id.toString();
                          customSetting.fieldToDisplay4 = _selectedSec2 == null
                              ? ""
                              : _selectedSec2.id.toString();
                          customSetting.fieldToDisplay5 = _selectedSec3 == null
                              ? ""
                              : _selectedSec3.id.toString();
                          customSetting.showDueDateTask = _selectedShowDueDate == null
                              ? ""
                              : _selectedShowDueDate.id.toString();
                          if (_selectedShowCompleted == null) {
                            customSetting.showCompletedTask = false;
                          } else {
                            if (_selectedShowCompleted.id == 0) {
                              customSetting.showCompletedTask = false;
                            } else {
                              customSetting.showCompletedTask = true;
                            }
                          }

                          var result;

                          if (customSetting.id != null) {
                            result = helper.updateCustomSettings(customSetting);
                          } else {
                            result = helper.insertCustomSettings(customSetting);
                          }

//end of save
                          print('showCompleted');
                          print(globals.showCompleted);
                        });
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
      ),
    );
  }

  _getCustomSettings() async {
    var _customSetting = await helper.getCustomSettings();
    if (_customSetting.length > 0) {
      customSetting = CustomSettings.fromObject(_customSetting[0]);

      if (customSetting != null && customSetting.id != null) {
        if (customSetting.sort1 != "") {
          _selectedSort1 =
              _dropdownMenuItemsSort[int.parse(customSetting.sort1)].value;
          globals.sort1 =
              int.parse(customSetting.sort1); //convert it to session variables
        }
        if (customSetting.order1 != "") {
          _selectedOrder1 =
              _dropdownMenuSortOrder[int.parse(customSetting.order1)].value;
          globals.sort1 =
              int.parse(customSetting.order1); //convert it to session variables
        }
        if (customSetting.sort2 != "") {
          _selectedSort2 =
              _dropdownMenuItemsSort[int.parse(customSetting.sort2)].value;
          globals.sort2 = int.parse(customSetting.sort2);
        }
        if (customSetting.order2 != "") {
          _selectedOrder2 =
              _dropdownMenuSortOrder[int.parse(customSetting.order2)].value;
          globals.sort2 =
              int.parse(customSetting.order2); //convert it to session variables
        }
        if (customSetting.sort3 != "") {
          _selectedSort3 =
              _dropdownMenuItemsSort[int.parse(customSetting.sort3)].value;
          globals.sort3 = int.parse(customSetting.sort3);
        }
        if (customSetting.order3 != "") {
          _selectedOrder3 =
              _dropdownMenuSortOrder[int.parse(customSetting.order3)].value;
          globals.sort3 =
              int.parse(customSetting.order3); //convert it to session variables
        }
        if (customSetting.fieldToDisplay1 != "") {
          _selectedMain1 =
              _dropdownMenuItemsSort[int.parse(customSetting.fieldToDisplay1)]
                  .value;
          globals.showMain1 = int.parse(customSetting.fieldToDisplay1);
        }
        if (customSetting.fieldToDisplay2 != "") {
          _selectedMain2 =
              _dropdownMenuItemsSort[int.parse(customSetting.fieldToDisplay2)]
                  .value;
          globals.showMain2 = int.parse(customSetting.fieldToDisplay2);
        }
        if (customSetting.fieldToDisplay3 != "") {
          _selectedSec1 =
              _dropdownMenuItemsSort[int.parse(customSetting.fieldToDisplay3)]
                  .value;
          globals.showSec1 = int.parse(customSetting.fieldToDisplay3);
        }
        if (customSetting.fieldToDisplay4 != "") {
          _selectedSec2 =
              _dropdownMenuItemsSort[int.parse(customSetting.fieldToDisplay4)]
                  .value;
          globals.showSec2 = int.parse(customSetting.fieldToDisplay4);
        }
        if (customSetting.fieldToDisplay5 != "") {
          _selectedSec3 =
              _dropdownMenuItemsSort[int.parse(customSetting.fieldToDisplay5)]
                  .value;
          globals.showSec3 = int.parse(customSetting.fieldToDisplay5);
        }
        if (customSetting.showCompletedTask == true) {
          _selectedShowCompleted = _dropdownCompletedItems[1].value;
          globals.showCompleted = 1;
        } else
          _selectedShowCompleted = _dropdownCompletedItems[0].value;
      }
        if (customSetting.showDueDateTask == true) {
          _selectedShowDueDate = _dropdownDueDateItems[0].value;
          globals.showDueDate = 0;
        } else
          _selectedShowDueDate = _dropdownDueDateItems[0].value;
      }
    setState(() {
      customSetting = customSetting;
    });
  }
}
