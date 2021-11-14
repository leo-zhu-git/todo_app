import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/model/customDropdownItem.dart';
import 'package:todo_app/model/customSettings.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/screens/action1s_screen.dart';
import 'package:todo_app/screens/categories_screen.dart';
import 'package:todo_app/screens/context1s_screen.dart';
import 'package:todo_app/screens/goal1s_screen.dart';
import 'package:todo_app/screens/location1s_screen.dart';
import 'package:todo_app/screens/priorities_screen.dart';
import 'package:todo_app/screens/statuses_screen.dart';
import 'package:todo_app/screens/tag1s_screen.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/globals.dart' as globals;

TextStyle _textStyleControls = TextStyle(fontSize: 17.0, color: Colors.black87);

class PersonalizeView extends StatefulWidget {
  @override
  _PersonalizeViewState createState() => _PersonalizeViewState();
}

class SortItem {
  int id;
  String name;

  SortItem(this.id, this.name);
  static List<SortItem> getSort() {
    return <SortItem>[
      SortItem(0, 'Task'),
      SortItem(1, 'Note'),
      SortItem(2, 'Due Date'),
      SortItem(3, 'Due Time'),
      SortItem(4, 'Category'),
      SortItem(5, 'Status'),
      SortItem(6, 'Priority'),
      SortItem(7, 'Tag'),
//      SortItem(7, 'Action'),
//      SortItem(8, 'Context'),
//      SortItem(9, 'Location'),
//      SortItem(11, 'Goal'),
      SortItem(8, 'Focus'),
      SortItem(9, 'Done'),
    ];
  }
}

class ShowItem {
  int id;
  String name;

  ShowItem(this.id, this.name);
  static List<ShowItem> getShow() {
    return <ShowItem>[
      ShowItem(0, 'Due Date'),
      ShowItem(1, 'Due Time'),
      ShowItem(2, 'Category'),
      ShowItem(3, 'Status'),
      ShowItem(4, 'Priority'),
      ShowItem(5, 'Tag'),
//      ShowItem(5, 'Action'),
//      ShowItem(6, 'Context'),
//      ShowItem(7, 'Location'),
//      ShowItem(9, 'Goal'),
      ShowItem(6, 'Focus'),
    ];
  }
}

class FilterIsStar {
  int id;
  String name;

  FilterIsStar(this.id, this.name);
  static List<FilterIsStar> getIsStar() {
    return <FilterIsStar>[
      FilterIsStar(0, '-- Focus & All Tasks --'),
      FilterIsStar(1, 'Focus Tasks Only'),
    ];
  }
}

class FilterIsDone {
  int id;
  String name;

  FilterIsDone(this.id, this.name);
  static List<FilterIsDone> getIsDone() {
    return <FilterIsDone>[
      FilterIsDone(0, '-- Include Completed Tasks --'),
      FilterIsDone(1, 'Hide Completed Tasks'),
    ];
  }
}

class FilterDateDue {
  int id;
  String name;

  FilterDateDue(this.id, this.name);
  static List<FilterDateDue> getDateDue() {
    return <FilterDateDue>[
      FilterDateDue(0, '-- All Due Dates --'),
      FilterDateDue(1, 'Today'),
      FilterDateDue(2, 'Tomorrow'),
      FilterDateDue(3, 'Next 7 days'),
      FilterDateDue(4, 'Next 30 days'),
      FilterDateDue(5, 'Any Due Date'),
      FilterDateDue(6, 'No Due Date'),
      FilterDateDue(7, 'Overdues Only'),
      FilterDateDue(8, 'Today and Overdues'),
    ];
  }
}

class SortOrder {
  int id;
  String name;

  SortOrder(this.id, this.name);
  static List<SortOrder> getOrder() {
    return <SortOrder>[
      SortOrder(0, 'Ascending'),
      SortOrder(1, 'Descending'),
    ];
  }
}

class _PersonalizeViewState extends State //State<PersonalizeView>
{
  List<ShowItem> _show = ShowItem.getShow();
  List<SortItem> _sort = SortItem.getSort();
  List<SortOrder> _order = SortOrder.getOrder();
  List<FilterIsStar> _filterIsStar = FilterIsStar.getIsStar();
  List<FilterIsDone> _filterIsDone = FilterIsDone.getIsDone();
  List<FilterDateDue> _filterDateDue = FilterDateDue.getDateDue();
  late List<DropdownMenuItem<ShowItem>> _dropdownMenuItemsShow;
  late List<DropdownMenuItem<SortItem>> _dropdownMenuItemsSort;
  late List<DropdownMenuItem<SortOrder>> _dropdownMenuSortOrder;
  late List<DropdownMenuItem<FilterIsStar>> _dropdownFilterIsStar;
  late List<DropdownMenuItem<FilterIsDone>> _dropdownFilterIsDone;
  late List<DropdownMenuItem<FilterDateDue>> _dropdownFilterDateDue;
  FilterIsStar? _selectedFilterIsStar;
  FilterIsDone? _selectedFilterIsDone;
  FilterDateDue? _selectedFilterDateDue;
  SortItem? _selectedSortField1;
  SortOrder? _selectedSortOrder1;
  SortItem? _selectedSortField2;
  SortItem? selectedSort;
  SortOrder? _selectedSortOrder2;
  SortItem? _selectedSortField3;
  SortOrder? _selectedSortOrder3;
  SortItem? _selectedSortField4;
  SortOrder? _selectedSortOrder4;
  ShowItem? _selectedShowSec1;
  ShowItem? _selectedShowSec2;
  ShowItem? _selectedShowSec3;
  DbHelper helper = DbHelper();
  CustomSettings? customSetting;
  List<CustomDropdownItem> _categories = [];
  List<CustomDropdownItem> _statuses = [];
  List<CustomDropdownItem> _priorities = [];
  List<CustomDropdownItem> _tag1s = [];
//  List<CustomDropdownItem> _action1s = [];
//  List<CustomDropdownItem> _context1s = [];
//  List<CustomDropdownItem> _location1s = [];
//  List<CustomDropdownItem> _goal1s = [];
  List<Task> tasklist = [];
  int count = 0;
  TextEditingController searchController = TextEditingController();
  var _selectedCategory = null;
  var _selectedStatus = null;
  var _selectedPriority = null;
  var _selectedTag1 = null;
//  var _selectedAction1 = null;
//  var _selectedContext1 = null;
//  var _selectedLocation1 = null;
//  var _selectedGoal1 = null;

  //
  @override
  void initState() {
    super.initState();
    _dropdownMenuItemsShow = buildDropdownMenuShow(_show);
    _dropdownMenuItemsSort = buildDropdownMenuItems(_sort);
    _dropdownMenuSortOrder = buildDropdownMenuOrder(_order);
    _dropdownFilterIsStar = buildDropdownFilterIsStar(_filterIsStar);
    _dropdownFilterIsDone = buildDropdownFilterIsDone(_filterIsDone);
    _dropdownFilterDateDue = buildDropdownFilterDateDue(_filterDateDue);
    _loadCategories();
    _loadStatuses();
    _loadPriorities();
    _loadTag1s();
//    _loadAction1s();
//    _loadContext1s();
//    _loadLocation1s();
//    _loadGoal1s();

    _getCustomSettings();
    ////////////////////////////
    /// filter - date due
    ////////////////////////////
    if (globals.filterDateDue == null) {
      _selectedFilterDateDue = _dropdownFilterDateDue[0].value!;
      globals.filterDateDue = 0;
    } else
      _selectedFilterDateDue =
          _dropdownFilterDateDue[globals.filterDateDue!].value!;

    ////////////////////////////
    /// filter - is star
    ////////////////////////////
    if (globals.filterIsStar == null) {
      _selectedFilterIsStar = _dropdownFilterIsStar[0].value!;
      globals.filterIsStar = 0;
    } else
      _selectedFilterIsStar =
          _dropdownFilterIsStar[globals.filterIsStar!].value!;

    ////////////////////////////
    /// filter - is done
    ////////////////////////////
    if (globals.filterIsDone == null) {
      _selectedFilterIsDone = _dropdownFilterIsDone[0].value!;
      globals.filterIsDone = 0;
    } else
      _selectedFilterIsDone =
          _dropdownFilterIsDone[globals.filterIsDone!].value!;

    ////////////////////////////
    // Sort and Order
    ////////////////////////////
    if (globals.sortField1 == 8) {
      _selectedSortField1 = _dropdownMenuItemsSort[8].value!;
      globals.sortField1 = 8;
    } else
      _selectedSortField1 = _dropdownMenuItemsSort[globals.sortField1!].value!;

    if (globals.sortOrder1 == null) {
      _selectedSortOrder1 = _dropdownMenuSortOrder[0].value!;
      globals.sortOrder1 = 1;
    } else
      _selectedSortOrder1 = _dropdownMenuSortOrder[globals.sortOrder1!].value!;

    if (globals.sortField2 == null) {
      _selectedSortField2 = _dropdownMenuItemsSort[2].value!;
      globals.sortField2 = 2;
    } else
      _selectedSortField2 = _dropdownMenuItemsSort[globals.sortField2!].value!;
    if (globals.sortOrder2 == null) {
      _selectedSortOrder2 = _dropdownMenuSortOrder[0].value!;
      globals.sortOrder2 = 0;
    } else
      _selectedSortOrder2 = _dropdownMenuSortOrder[globals.sortOrder2!].value!;

    if (globals.sortField3 == null) {
      _selectedSortField3 = _dropdownMenuItemsSort[3].value!;
      globals.sortField3 = 3;
    } else
      _selectedSortField3 = _dropdownMenuItemsSort[globals.sortField3!].value!;
    if (globals.sortOrder3 == null) {
      _selectedSortOrder3 = _dropdownMenuSortOrder[0].value!;
      globals.sortOrder3 = 0;
    } else
      _selectedSortOrder3 = _dropdownMenuSortOrder[globals.sortOrder3!].value!;

    if (globals.sortField4 == null) {
      _selectedSortField4 = _dropdownMenuItemsSort[4].value!;
      globals.sortField4 = 0;
    } else
      _selectedSortField4 = _dropdownMenuItemsSort[globals.sortField4!].value!;
    if (globals.sortOrder4 == null) {
      _selectedSortOrder4 = _dropdownMenuSortOrder[0].value!;
      globals.sortOrder4 = 0;
    } else
      _selectedSortOrder4 = _dropdownMenuSortOrder[globals.sortOrder4!].value!;

    ////////////////////////////
    /// show - sec defaults star, dateDue, timeDue RT
    ////////////////////////////
    if (globals.showSec1 == null) {
      _selectedShowSec1 = _dropdownMenuItemsShow[0].value!;
      globals.showSec1 = 10;
    } else
      _selectedShowSec1 = _dropdownMenuItemsShow[globals.showSec1!].value!;

    if (globals.showSec2 == null) {
      _selectedShowSec2 = _dropdownMenuItemsShow[6].value!;
      globals.showSec2 = 0;
    } else
      _selectedShowSec2 = _dropdownMenuItemsShow[globals.showSec2!].value!;

    if (globals.showSec3 == null) {
      _selectedShowSec3 = _dropdownMenuItemsShow[2].value!;
      globals.showSec3 = 1;
    } else
      _selectedShowSec3 = _dropdownMenuItemsShow[globals.showSec3!].value!;

    // super.initState();
  }

//##################Drop Down Items Load from DB #################################################################
  _loadCategories() async {
    var categories = await helper.getCategories();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
//    cus.id = null;
    cus.name = "-- All Categories -- ";
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
    cus.name =
        "-- All Priorities --";
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
    cus.name =
        "-- All Tags --";
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

//##########################################end of Dropdown #################################################################

  List<DropdownMenuItem<ShowItem>> buildDropdownMenuShow(List showItems) {
    List<DropdownMenuItem<ShowItem>> items = [];
    for (ShowItem showItem in showItems) {
      items.add(
        DropdownMenuItem(
          value: showItem,
          child: Text(showItem.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<SortItem>> buildDropdownMenuItems(List sortItems) {
    List<DropdownMenuItem<SortItem>> items = [];
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
    List<DropdownMenuItem<SortOrder>> order = [];
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

  List<DropdownMenuItem<FilterIsStar>> buildDropdownFilterIsStar(
      List filterIsStarItems) {
    List<DropdownMenuItem<FilterIsStar>> items = [];
    for (FilterIsStar filterIsStar in filterIsStarItems) {
      items.add(
        DropdownMenuItem(
          value: filterIsStar,
          child: Text(filterIsStar.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<FilterIsDone>> buildDropdownFilterIsDone(
      List filterIsDoneItems) {
    List<DropdownMenuItem<FilterIsDone>> items = [];
    for (FilterIsDone filterIsDone in filterIsDoneItems) {
      items.add(
        DropdownMenuItem(
          value: filterIsDone,
          child: Text(filterIsDone.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<FilterDateDue>> buildDropdownFilterDateDue(
      List filterDateDueItems) {
    List<DropdownMenuItem<FilterDateDue>> items = [];
    for (FilterDateDue filterDateDue in filterDateDueItems) {
      items.add(
        DropdownMenuItem(
          value: filterDateDue,
          child: Text(filterDateDue.name),
        ),
      );
    }
    return items;
  }


  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
//  _showSuccessSnackBar(message) {
//    var _snackBar = SnackBar(content: message);
//    _globalKey.currentState.showSnackBar(_snackBar);
//  }

  Widget build(BuildContext context) {
//    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      key: _globalKey,
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
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
          icon: Icon(Icons.home, color: Colors.pink[100]),
          tooltip: 'Home',
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TaskHome()));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt, color: Colors.white),
            tooltip: 'Save',
            onPressed: () {
              setState(() {
                if (_selectedSortField1 != null)
                  globals.sortField1 = _selectedSortField1!.id;
                if (_selectedSortOrder1 != null)
                  globals.sortOrder1 = _selectedSortOrder1!.id;
                if (_selectedSortField2 != null)
                  globals.sortField2 = _selectedSortField2!.id;
                if (_selectedSortOrder2 != null)
                  globals.sortOrder2 = _selectedSortOrder2!.id;
                if (_selectedSortField3 != null)
                  globals.sortField3 = _selectedSortField3!.id;
                if (_selectedSortOrder3 != null)
                  globals.sortOrder3 = _selectedSortOrder3!.id;
                if (_selectedSortField4 != null)
                  globals.sortField4 = _selectedSortField4!.id;
                if (_selectedSortOrder4 != null)
                  globals.sortOrder4 = _selectedSortOrder4!.id;
                if (_selectedShowSec1 != null)
                  globals.showSec1 = _selectedShowSec1!.id;
                print(globals.showSec1);
                if (_selectedShowSec2 != null)
                  globals.showSec2 = _selectedShowSec2!.id;
                print(globals.showSec2);
                if (_selectedShowSec3 != null)
                  globals.showSec3 = _selectedShowSec3!.id;
                print(globals.showSec3);
                if (_selectedFilterIsStar != null)
                  globals.filterIsStar = _selectedFilterIsStar!.id;
                if (_selectedFilterIsDone != null)
                  globals.filterIsDone = _selectedFilterIsDone!.id;
                if (_selectedFilterDateDue != null)
                  globals.filterDateDue = _selectedFilterDateDue!.id;

//Save
                if (customSetting == null) {
                  customSetting = new CustomSettings(
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    0,
                    0,
                  );
                }

                customSetting!.sortField1 = _selectedSortField1 == null
                    ? ""
                    : _selectedSortField1!.id.toString();
                customSetting!.sortOrder1 = _selectedSortOrder1 == null
                    ? ""
                    : _selectedSortOrder1!.id.toString();
                customSetting!.sortField2 = _selectedSortField2 == null
                    ? ""
                    : _selectedSortField2!.id.toString();
                customSetting!.sortOrder2 = _selectedSortOrder2 == null
                    ? ""
                    : _selectedSortOrder2!.id.toString();
                customSetting!.sortField3 = _selectedSortField3 == null
                    ? ""
                    : _selectedSortField3!.id.toString();
                customSetting!.sortOrder3 = _selectedSortOrder3 == null
                    ? ""
                    : _selectedSortOrder3!.id.toString();
                customSetting!.sortField4 = _selectedSortField4 == null
                    ? ""
                    : _selectedSortField4!.id.toString();
                customSetting!.sortOrder4 = _selectedSortOrder4 == null
                    ? ""
                    : _selectedSortOrder4!.id.toString();
                customSetting!.showSec1 = _selectedShowSec1 == null
                    ? ""
                    : _selectedShowSec1!.id.toString();
                customSetting!.showSec2 = _selectedShowSec2 == null
                    ? ""
                    : _selectedShowSec2!.id.toString();
                customSetting!.showSec3 = _selectedShowSec3 == null
                    ? ""
                    : _selectedShowSec3!.id.toString();
                customSetting!.filterDateDue = _selectedFilterDateDue == null
                    ? ""
                    : _selectedFilterDateDue!.id.toString();
                if (_selectedFilterIsStar == null) {
                  customSetting!.filterIsStar = 0;
                } else {
                  if (_selectedFilterIsStar!.id == 0) {
                    customSetting!.filterIsStar = 0;
                  } else {
                    customSetting!.filterIsStar = 1;
                  }
                  if (_selectedFilterIsDone == null) {
                    customSetting!.filterIsDone = 0;
                  } else {
                    if (_selectedFilterIsDone!.id == 0) {
                      customSetting!.filterIsDone = 0;
                    } else {
                      customSetting!.filterIsDone = 1;
                    }
                  }

                  customSetting!.filterCategory = (_selectedCategory == null)
                      ? ""
                      : _selectedCategory.toString();
                  customSetting!.filterStatus =
                      _selectedStatus == null ? "" : _selectedStatus.toString();
                  customSetting!.filterPriority = (_selectedPriority == null)
                      ? ""
                      : _selectedPriority.toString();
                  customSetting!.filterTag = (_selectedTag1 == null)
                      ? ""
                      : _selectedTag1.toString();

                  var result;

                  if (customSetting!.id != null) {
                    result = helper.updateCustomSettings(customSetting!);
                  } else {
                    result = helper.insertCustomSettings(customSetting!);
                  }

//end of save
                }
              });
              Navigator.of(context).pushNamed('/dashboard');
            },
          ),
        ],

        title: Center(child: Text('Personalize')),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

///////////////////////////
//  Filters
///////////////////////////
              Text("Filter - Reduce tasks to view", style: _textStyleControls),

//################################# Due Dates #####################################################
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: DropdownButtonFormField<FilterDateDue>(
                  style: _textStyleControls,
                  items: _dropdownFilterDateDue,
                  hint: Text('Filter by Due Date'),
                  value: _selectedFilterDateDue,
                  onChanged: (selectedFilterDateDue) {
                    setState(() {
                      _selectedFilterDateDue = selectedFilterDateDue!;
                    });
                  },
                ),
              ),

//################################# Category #####################################################
              Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonHideUnderline(
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
                  ],
                ),
              ),

//################################# Status #####################################################
              Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonHideUnderline(
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
                  ],
                ),
              ),

//################################# Priority #####################################################
              Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonHideUnderline(
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
                  ],
                ),
              ),

//################################# Tag #####################################################
              Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        style: _textStyleControls,
                        items: _tag1s.map((CustomDropdownItem value) {
                          return DropdownMenuItem<String>(
                              value: value.id, child: Text(value.name!));
                        }).toList(),
                        value: _selectedTag1,
                        onChanged: (value) {
                          setState(() {
                            _selectedTag1 = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),

//################################# Focus #####################################################
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: DropdownButtonFormField<FilterIsStar>(
                  style: _textStyleControls,
                  items: _dropdownFilterIsStar,
                  hint: Text('Filter by Focus Tasks'),
                  value: _selectedFilterIsStar,
                  onChanged: (selectedFilterIsStar) {
                    setState(() {
                      _selectedFilterIsStar = selectedFilterIsStar!;
                    });
                  },
                ),
              ),


//################################# IsDone #####################################################
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: DropdownButtonFormField<FilterIsDone>(
                  style: _textStyleControls,
                  items: _dropdownFilterIsDone,
                  hint: Text('Filter by Is Done Tasks'),
                  value: _selectedFilterIsDone,
                  onChanged: (selectedFilterIsDone) {
                    setState(() {
                      _selectedFilterIsDone = selectedFilterIsDone!;
                    });
                  },
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Text("Picklist | User-defined Dropdowns",
                  style: _textStyleControls),

///////////////////////////
//  Picklists  
///////////////////////////

//################################# Categories #####################################################
              Card(
                elevation: 8.0,
                child: ListTile(
                  tileColor: Colors.orange[100],
                  title: Text('Categories', style: _textStyleControls),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoriesScreen())),
                ),
              ),
              SizedBox(height: 2),

//################################# Statuses  #####################################################
              Card(
                elevation: 8.0,
                child: ListTile(
                  tileColor: Colors.orange[100],
                  title: Text('Statuses', style: _textStyleControls),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StatusesScreen())),
                ),
              ),
              SizedBox(height: 2),

//################################# Priorities  #####################################################
              Card(
                elevation: 8.0,
                child: ListTile(
                  tileColor: Colors.orange[100],
                  title: Text('Priorities', style: _textStyleControls),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PrioritiesScreen())),
                ),
              ),
              SizedBox(height: 2),

//################################# Tags  #####################################################

              Card(
                elevation: 8.0,
                child: ListTile(
                  tileColor: Colors.orange[100],
                  title: Text('Tags', style: _textStyleControls),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Tag1sScreen())),
                ),
              ),
              SizedBox(height: 2),
              SizedBox(
                height: 20,
              ),

///////////////////////////
//  SORT   
///////////////////////////
              Text("Sort Order", style: _textStyleControls),

//################################# Sort Order 1  #####################################################
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.green[100]),
                child: DropdownButtonFormField<SortItem>(
                  style: _textStyleControls,
                  value: _selectedSortField1,
                  items: _dropdownMenuItemsSort,
                  hint: Text('Sort Order 1'),
                  onChanged: (selectedSort) {
                    setState(() {
                      _selectedSortField1 = selectedSort!;
                    });
                  },
                ),
              ),

              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.green[100]),
                child: DropdownButtonFormField<SortOrder>(
                  style: _textStyleControls,
                  value: _selectedSortOrder1,
                  items: _dropdownMenuSortOrder,
                  hint: Text('Sort 1 Ascending/Descending'),
                  onChanged: (selectedOrder) {
                    setState(() {
                      _selectedSortOrder1 = selectedOrder!;
                    });
                  },
                ),
              ),

//################################# Sort Order 2  #####################################################
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.green[100]),
                child: DropdownButtonFormField<SortItem>(
                  style: _textStyleControls,
                  items: _dropdownMenuItemsSort,
                  hint: Text('Sort 2'),
                  value: _selectedSortField2,
                  onChanged: (selectedSort) {
                    setState(() {
                      _selectedSortField2 = selectedSort!;
                    });
                  },
                ),
              ),

              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.green[100]),
                child: DropdownButtonFormField<SortOrder>(
                  style: _textStyleControls,
                  value: _selectedSortOrder2,
                  items: _dropdownMenuSortOrder,
                  hint: Text('Sort 2 Ascending/Descending'),
                  onChanged: (selectedOrder) {
                    setState(() {
                      _selectedSortOrder2 = selectedOrder!;
                    });
                  },
                ),
              ),

//################################# Sort Order 3  #####################################################
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.green[100]),
                child: DropdownButtonFormField<SortItem>(
                  style: _textStyleControls,
                  items: _dropdownMenuItemsSort,
                  hint: Text('Sort 3'),
                  value: _selectedSortField3,
                  onChanged: (selectedSort) {
                    setState(() {
                      _selectedSortField3 = selectedSort!;
                    });
                  },
                ),
              ),

               new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.green[100]),
                child: DropdownButtonFormField<SortOrder>(
                  style: _textStyleControls,
                  value: _selectedSortOrder3,
                  items: _dropdownMenuSortOrder,
                  hint: Text('Sort Order 3 Ascending/Descending'),
                  onChanged: (selectedOrder) {
                    setState(() {
                      _selectedSortOrder3 = selectedOrder!;
                    });
                  },
                ),
              ),

//################################# Sort Order 4  #####################################################
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.green[100]),
                child: DropdownButtonFormField<SortItem>(
                  style: _textStyleControls,
                  items: _dropdownMenuItemsSort,
                  hint: Text('Sort 4'),
                  value: _selectedSortField4,
                  onChanged: (selectedSort) {
                    setState(() {
                      _selectedSortField4 = selectedSort!;
                    });
                  },
                ),
              ),

               new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.green[100]),
                child: DropdownButtonFormField<SortOrder>(
                  style: _textStyleControls,
                  value: _selectedSortOrder4,
                  items: _dropdownMenuSortOrder,
                  hint: Text('Sort Order 4 Ascending/Descending'),
                  onChanged: (selectedOrder) {
                    setState(() {
                      _selectedSortOrder4 = selectedOrder!;
                    });
                  },
                ),
              ),

              SizedBox(
                height: 20,
              ),


///////////////////////////
//  Show Sec 
///////////////////////////
              Text("View - second line up to 3 fields",
                  style: _textStyleControls),

///################################# Show Sec 1  #####################################################

              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.pink[100]),
                child: DropdownButtonFormField<ShowItem>(
                  style: _textStyleControls,
                  items: _dropdownMenuItemsShow,
                  hint: Text('Display Secondary1'),
                  value: _selectedShowSec1,
                  onChanged: (selectedShow) {
                    setState(() {
                      _selectedShowSec1 = selectedShow!;
                    });
                  },
                ),
              ),

///################################# Show Sec 2  #####################################################

              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.pink[100]),
                child: DropdownButtonFormField<ShowItem>(
                  style: _textStyleControls,
                  items: _dropdownMenuItemsShow,
                  hint: Text('Display Secondary2'),
                  value: _selectedShowSec2,
                  onChanged: (selectedShow) {
                    setState(() {
                      _selectedShowSec2 = selectedShow!;
                    });
                  },
                ),
              ),

///################################# Show Sec 3  #####################################################
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.pink[100]),
                child: DropdownButtonFormField<ShowItem>(
                  style: _textStyleControls,
                  items: _dropdownMenuItemsShow,
                  hint: Text('Display Secondary3'),
                  value: _selectedShowSec3,
                  onChanged: (selectedShow) {
                    setState(() {
                      _selectedShowSec3 = selectedShow!;
                    });
                  },
                ),
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

      if (customSetting != null && customSetting!.id != null) {
        if (customSetting!.sortField1 != "") {
          _selectedSortField1 =
              _dropdownMenuItemsSort[int.parse(customSetting!.sortField1!)]
                  .value!;
          globals.sortField1 = int.parse(customSetting!.sortField1!);
        }
        if (customSetting!.sortOrder1 != "") {
          _selectedSortOrder1 =
              _dropdownMenuSortOrder[int.parse(customSetting!.sortOrder1!)]
                  .value!;
          globals.sortField1 = int.parse(
              customSetting!.sortOrder1!); //convert it to session variables
        }
        if (customSetting!.sortField2 != "") {
          _selectedSortField2 =
              _dropdownMenuItemsSort[int.parse(customSetting!.sortField2!)]
                  .value!;
          globals.sortField2 = int.parse(customSetting!.sortField2!);
        }
        if (customSetting!.sortOrder2 != "") {
          _selectedSortOrder2 =
              _dropdownMenuSortOrder[int.parse(customSetting!.sortOrder2!)]
                  .value!;
          globals.sortField2 = int.parse(
              customSetting!.sortOrder2!); //convert it to session variables
        }
        if (customSetting!.sortField3 != "") {
          _selectedSortField3 =
              _dropdownMenuItemsSort[int.parse(customSetting!.sortField3!)]
                  .value!;
          globals.sortField3 = int.parse(customSetting!.sortField3!);
        }
        if (customSetting!.sortOrder3 != "") {
          _selectedSortOrder3 =
              _dropdownMenuSortOrder[int.parse(customSetting!.sortOrder3!)]
                  .value!;
          globals.sortField3 = int.parse(
              customSetting!.sortOrder3!); //convert it to session variables
        }
        if (customSetting!.showSec1 != "") {
          _selectedShowSec1 =
              _dropdownMenuItemsShow[int.parse(customSetting!.showSec1!)]
                  .value!;
          globals.showSec1 = int.parse(customSetting!.showSec1!);
        }
        if (customSetting!.showSec2 != "") {
          _selectedShowSec2 =
              _dropdownMenuItemsShow[int.parse(customSetting!.showSec2!)]
                  .value!;
          globals.showSec2 = int.parse(customSetting!.showSec2!);
        }
        if (customSetting!.showSec3 != "") {
          _selectedShowSec3 =
              _dropdownMenuItemsShow[int.parse(customSetting!.showSec3!)]
                  .value!;
          globals.showSec3 = int.parse(customSetting!.showSec3!);
        }
        if (customSetting!.filterIsStar == 1) {
          _selectedFilterIsStar = _dropdownFilterIsStar[1].value!;
          globals.filterIsStar = 1;
        } else
          _selectedFilterIsStar = _dropdownFilterIsStar[0].value!;
      }
      if (customSetting!.filterIsDone == 1) {
        _selectedFilterIsDone = _dropdownFilterIsDone[1].value!;
        globals.filterIsDone = 1;
      } else
        _selectedFilterIsDone = _dropdownFilterIsDone[0].value!;
    }

    if (customSetting!.filterDateDue != "") {
      _selectedFilterDateDue =
          _dropdownFilterDateDue[int.parse(customSetting!.filterDateDue!)]
              .value!;
      globals.filterDateDue = int.parse(customSetting!.filterDateDue!);
    }
 
     if (customSetting!.filterCategory == "") {
      _selectedCategory = null;
      customSetting!.filterCategory = "";
    } else {
      _selectedCategory = customSetting!.filterCategory.toString();
      globals.filterCategory = int.parse(customSetting!.filterCategory!);
    }

    if (customSetting!.filterStatus == "") {
      _selectedStatus = null;
      customSetting!.filterStatus = "";
    } else {
      _selectedStatus = customSetting!.filterStatus.toString();
      globals.filterStatus = int.parse(customSetting!.filterStatus!);
    }

    if (customSetting!.filterPriority == "") {
      _selectedPriority = null;
      customSetting!.filterPriority = "";
    } else {
      _selectedPriority = customSetting!.filterPriority.toString();
      globals.filterPriority = int.parse(customSetting!.filterPriority!);
    }

    if (customSetting!.filterTag == "") {
      _selectedTag1 = null;
      customSetting!.filterTag = "";
    } else {
      _selectedTag1 = customSetting!.filterTag.toString();
      globals.filterTag = int.parse(customSetting!.filterTag!);
    }

    setState(() {
      customSetting = customSetting;
    });
  }
}
