import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/model/customDropdownItem.dart';
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
      SortItem(0, 'Task'),
      SortItem(1, 'Note'),
      SortItem(2, 'Due Date'),
      SortItem(3, 'Due Time'),
      SortItem(4, 'Status'),
      SortItem(5, 'Priority'),
      SortItem(6, 'Star'),
      SortItem(7, 'Category'),
      SortItem(8, 'Action'),
      SortItem(9, 'Context'),
      SortItem(10, 'Location'),
      SortItem(11, 'Tag'),
      SortItem(12, 'Goal'),
    ];
  }
}

class FilterIsDone {
  int id;
  String name;

  FilterIsDone(this.id, this.name);
  static List<FilterIsDone> getIsDone() {
    return <FilterIsDone>[
      FilterIsDone(0, '-- Completed Tasks - Show --'),
      FilterIsDone(1, 'Completed Tasks - Hide'),
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
    ];
  }
}

class FilterStatus {
  int id;
  String name;

  FilterStatus(this.id, this.name);
  static List<FilterStatus> getStatus() {
    return <FilterStatus>[
      FilterStatus(0, '-- All Statuses -- '),
      FilterStatus(1, 'Next Action'),
      FilterStatus(2, 'Action'),
      FilterStatus(3, 'Planning'),
      FilterStatus(4, 'Delegated'),
      FilterStatus(5, 'Waiting'),
      FilterStatus(6, 'Hold'),
    ];
  }
}


class FilterPriority {
  int id;
  String name;

  FilterPriority(this.id, this.name);
  static List<FilterPriority> getPriority() {
    return <FilterPriority>[
      FilterPriority(0, '-- All Priorities --'),
      FilterPriority(1, 'Low'),
      FilterPriority(2, 'Medium'),
      FilterPriority(3, 'High'),
      FilterPriority(4, 'Top'),
    ];
  }
}

class FilterStar {
  int id;
  String name;

  FilterStar(this.id, this.name);
  static List<FilterStar> getStar() {
    return <FilterStar>[
      FilterStar(0, '-- All Star/ No Star -- '),
      FilterStar(1, 'No Star'),
      FilterStar(2, 'Star Only'),
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
  List<FilterIsDone> _filterIsDone = FilterIsDone.getIsDone();
  List<FilterDateDue> _filterDateDue = FilterDateDue.getDateDue();
  List<FilterStatus> _filterStatus = FilterStatus.getStatus();
  List<FilterPriority> _filterPriority = FilterPriority.getPriority();
  List<FilterStar> _filterStar = FilterStar.getStar();
  List<DropdownMenuItem<SortItem>> _dropdownMenuItemsSort;
  List<DropdownMenuItem<SortOrder>> _dropdownMenuSortOrder;
  List<DropdownMenuItem<FilterIsDone>> _dropdownFilterIsDone;
  List<DropdownMenuItem<FilterDateDue>> _dropdownFilterDateDue;
  List<DropdownMenuItem<FilterStatus>> _dropdownFilterStatus;
  List<DropdownMenuItem<FilterPriority>> _dropdownFilterPriority;
  List<DropdownMenuItem<FilterStar>> _dropdownFilterStar;
//  List<DropdownMenuItem<FilterCategory>> _dropdownFilterCategory;
//  List<DropdownMenuItem<FilterAction>> _dropdownFilterAction;
//  List<DropdownMenuItem<FilterContext>> _dropdownFilterContext;
//  List<DropdownMenuItem<FilterLocation>> _dropdownFilterLocation;
//  List<DropdownMenuItem<FilterTag>> _dropdownFilterTag;
  FilterIsDone _selectedFilterIsDone;
  FilterDateDue _selectedFilterDateDue;
  FilterStatus _selectedFilterStatus;
  FilterPriority _selectedFilterPriority;
  FilterStar _selectedFilterStar;
  SortItem _selectedSortField1;
  SortOrder _selectedSortOrder1;
  SortItem _selectedSortField2;
  SortOrder _selectedSortOrder2;
  SortItem _selectedSortField3;
  SortOrder _selectedSortOrder3;
  SortItem _selectedShowMain1;
  SortItem _selectedShowMain2;
  SortItem _selectedShowSec1;
  SortItem _selectedShowSec2;
  SortItem _selectedShowSec3;
  DbHelper helper = DbHelper();
  CustomSettings customSetting;
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

  //
  @override
  void initState() {
    super.initState();
    _dropdownMenuItemsSort = buildDropdownMenuItems(_sort);
    _dropdownMenuSortOrder = buildDropdownMenuOrder(_order);
    _dropdownFilterIsDone = buildDropdownFilterIsDone(_filterIsDone);
    _dropdownFilterDateDue = buildDropdownFilterDateDue(_filterDateDue);
    _dropdownFilterStatus = buildDropdownFilterStatus(_filterStatus);
    _dropdownFilterPriority = buildDropdownFilterPriority(_filterPriority);
    _dropdownFilterStar = buildDropdownFilterStar(_filterStar);
    _loadCategories();
    _loadAction1s();
    _loadContext1s();
    _loadLocation1s();
    _loadTag1s();
    _loadGoal1s();

    _getCustomSettings();
    ////////////////////////////
    /// filter - date due
    ////////////////////////////
    if (globals.filterDateDue == null) {
      _selectedFilterDateDue = _dropdownFilterDateDue[0].value;
      globals.filterDateDue = 0;
    } else
      _selectedFilterDateDue =
          _dropdownFilterDateDue[globals.filterDateDue].value;

    ////////////////////////////
    /// filter - status
    ////////////////////////////
    if (globals.filterStatus == null) {
      _selectedFilterStatus = _dropdownFilterStatus[0].value;
      globals.filterStatus = 0;
    } else
      _selectedFilterStatus =
          _dropdownFilterStatus[globals.filterStatus].value;

    ////////////////////////////
    /// filter - priority
    ////////////////////////////
    if (globals.filterPriority == null) {
      _selectedFilterPriority = _dropdownFilterPriority[0].value;
      globals.filterPriority = 0;
    } else
      _selectedFilterPriority =
          _dropdownFilterPriority[globals.filterPriority].value;

    ////////////////////////////
    /// filter - star
    ////////////////////////////
    if (globals.filterStar == null) {
      _selectedFilterStar = _dropdownFilterStar[0].value;
      globals.filterStar = 0;
    } else
      _selectedFilterStar =
          _dropdownFilterStar[globals.filterStar].value;

    ////////////////////////////
    /// filter - is done
    ////////////////////////////
    if (globals.filterIsDone == null) {
      _selectedFilterIsDone = _dropdownFilterIsDone[0].value;
      globals.filterIsDone = 0;
    } else
      _selectedFilterIsDone = _dropdownFilterIsDone[globals.filterIsDone].value;

    ////////////////////////////
    // Sort and Order
    ////////////////////////////
    if (globals.sortField1 == null) {
      _selectedSortField1 = _dropdownMenuItemsSort[2].value;
      globals.sortField1 = 2;
    } else
      _selectedSortField1 = _dropdownMenuItemsSort[globals.sortField1].value;

    if (globals.sortOrder1 == null) {
      _selectedSortOrder1 = _dropdownMenuSortOrder[0].value;
      globals.sortOrder1 = 0;
    } else
      _selectedSortOrder1 = _dropdownMenuSortOrder[globals.sortOrder1].value;

    if (globals.sortField2 == null) {
      _selectedSortField2 = _dropdownMenuItemsSort[3].value;
      globals.sortField2 = 3;
    } else
      _selectedSortField2 = _dropdownMenuItemsSort[globals.sortField2].value;
    if (globals.sortOrder2 == null) {
      _selectedSortOrder2 = _dropdownMenuSortOrder[0].value;
      globals.sortOrder2 = 0;
    } else
      _selectedSortOrder2 = _dropdownMenuSortOrder[globals.sortOrder2].value;

    if (globals.sortField3 == null) {
      _selectedSortField3 = _dropdownMenuItemsSort[0].value;
      globals.sortField3 = 0;
    } else
      _selectedSortField3 = _dropdownMenuItemsSort[globals.sortField3].value;
    if (globals.sortOrder3 == null) {
      _selectedSortOrder3 = _dropdownMenuSortOrder[0].value;
      globals.sortOrder3 = 0;
    } else
      _selectedSortOrder3 = _dropdownMenuSortOrder[globals.sortOrder3].value;

    ////////////////////////////
    /// show
    ////////////////////////////
    if (globals.showMain1 == null) {
      _selectedShowMain1 = _dropdownMenuItemsSort[0].value;
      globals.showMain1 = 0;
    } else
      _selectedShowMain1 = _dropdownMenuItemsSort[globals.showMain1].value;

    if (globals.showMain2 == null) {
      _selectedShowMain2 = _dropdownMenuItemsSort[2].value;
      globals.showMain2 = 2;
    } else
      _selectedShowMain2 = _dropdownMenuItemsSort[globals.showMain2].value;

    if (globals.showSec1 == null) {
      _selectedShowSec1 = _dropdownMenuItemsSort[1].value;
      globals.showSec1 = 1;
    } else
      _selectedShowSec1 = _dropdownMenuItemsSort[globals.showSec1].value;

    if (globals.showSec2 == null) {
      _selectedShowSec2 = _dropdownMenuItemsSort[3].value;
      globals.showSec2 = 3;
    } else
      _selectedShowSec2 = _dropdownMenuItemsSort[globals.showSec2].value;

    if (globals.showSec3 == null) {
      _selectedShowSec3 = _dropdownMenuItemsSort[4].value;
      globals.showSec3 = 4;
    } else
      _selectedShowSec3 = _dropdownMenuItemsSort[globals.showSec3].value;

    // super.initState();
  }

  //##################Drop Down Items Load from DB #################################################################
  _loadCategories() async {
    var categories = await helper.getCategories();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
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

  _loadAction1s() async {
    var action1s = await helper.getActions();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = null;
    cus.name = "-- All Actions --             ";
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
    cus.name = "-- All Contexts --            ";
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
    cus.name = "-- All Locations --           ";
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
    cus.name = "-- All Tags --                ";
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
    cus.name = "-- All Goals --                ";
    _goal1s.add(cus);
    goal1s.forEach((goal) {
      setState(() {
        cus = new CustomDropdownItem();
        cus.id = goal['id'].toString();
        String tempGoal;
        if (goal['name'].toString().length > 30)
          tempGoal = goal['name'].toString().substring(0, 30) + "...";
        else
          tempGoal = goal['name'];

        cus.name = tempGoal;
        _goal1s.add(cus);
      });
    });
  }

//##########################################end of Dropdown #################################################################

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

  List<DropdownMenuItem<FilterIsDone>> buildDropdownFilterIsDone(
      List filterIsDoneItems) {
    List<DropdownMenuItem<FilterIsDone>> items = List();
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
    List<DropdownMenuItem<FilterDateDue>> items = List();
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

  List<DropdownMenuItem<FilterStatus>> buildDropdownFilterStatus(
      List filterStatusItems) {
    List<DropdownMenuItem<FilterStatus>> items = List();
    for (FilterStatus filterStatus in filterStatusItems) {
      items.add(
        DropdownMenuItem(
          value: filterStatus,
          child: Text(filterStatus.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<FilterPriority>> buildDropdownFilterPriority(
      List filterPriorityItems) {
    List<DropdownMenuItem<FilterPriority>> items = List();
    for (FilterPriority filterPriority in filterPriorityItems) {
      items.add(
        DropdownMenuItem(
          value: filterPriority,
          child: Text(filterPriority.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<FilterStar>> buildDropdownFilterStar(
      List filterStarItems) {
    List<DropdownMenuItem<FilterStar>> items = List();
    for (FilterStar filterStar in filterStarItems) {
      items.add(
        DropdownMenuItem(
          value: filterStar,
          child: Text(filterStar.name),
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
        title: Center(child: Text('Personalize - Filter, Sort, View')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
///////////////////////////
//  Filter Date Due
///////////////////////////
              Text("Filter - Reduce tasks to view"),

              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: DropdownButtonFormField(
                  items: _dropdownFilterDateDue,
                  hint: Text('Filter by Due Date'),
                  value: _selectedFilterDateDue,
                  onChanged: (selectedFilterDateDue) {
                    setState(() {
                      _selectedFilterDateDue = selectedFilterDateDue;
                    });
                  },
                ),
              ),

///////////////////////////
//  Filter Status
///////////////////////////

              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: DropdownButtonFormField(
                  items: _dropdownFilterStatus,
                  hint: Text('Filter by Status'),
                  value: _selectedFilterStatus,
                  onChanged: (selectedFilterStatus) {
                    setState(() {
                      _selectedFilterStatus = selectedFilterStatus;
                    });
                  },
                ),
              ),

///////////////////////////
//  Filter Priority
///////////////////////////

              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: DropdownButtonFormField(
                  items: _dropdownFilterPriority,
                  hint: Text('Filter by Priority'),
                  value: _selectedFilterPriority,
                  onChanged: (selectedFilterPriority) {
                    setState(() {
                      _selectedFilterPriority = selectedFilterPriority;
                    });
                  },
                ),
              ),

///////////////////////////
//  Filter Star
///////////////////////////
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: DropdownButtonFormField(
                  items: _dropdownFilterStar ,
                  hint: Text('Filter by Star'),
                  value: _selectedFilterStar,
                  onChanged: (selectedFilterStar) {
                    setState(() {
                      _selectedFilterStar = selectedFilterStar;
                    });
                  },
                ),
              ),


///////////////////////////
//  Filter Is Done
///////////////////////////
//              Text("Filter - Is Done"),

              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: DropdownButtonFormField(
                  items: _dropdownFilterIsDone,
                  hint: Text('Filter by Is Done Tasks'),
                  value: _selectedFilterIsDone,
                  onChanged: (selectedFilterIsDone) {
                    setState(() {
                      _selectedFilterIsDone = selectedFilterIsDone;
                    });
                  },
                ),
              ),

//#################################Category#####################################################
              Container(
                margin: const EdgeInsets.all(2.0),
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
                        value: _selectedCategory,
                        onChanged: (String newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        }),
                  ],
                ),
              ),

//########################################### Action  ######### #################################3
              Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        items: _action1s.map((CustomDropdownItem value) {
                          return DropdownMenuItem<String>(
                              value: value.id, child: Text(value.name));
                        }).toList(),
                        value: _selectedAction1,
                        onChanged: (value) {
                          setState(() {
                            _selectedAction1 = value;
                            //                    searchData(_searchText, _selectedpriority, _selectedCategory, _selectedAction1, _selectedContext1, _selectedLocation1, _selectedTag1, _selectedGoal1);
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
//######### Context  #########
              Container(
                margin: const EdgeInsets.all(2.0),
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
                      value: _selectedContext1,
                      onChanged: (value) {
                        setState(() {
                          _selectedContext1 = value;
                        });
                      },
                    )
                  ],
                ),
              ),
// //######### Location  #########
              Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      items: _location1s.map((CustomDropdownItem value) {
                        return DropdownMenuItem<String>(
                            value: value.id, child: Text(value.name));
                      }).toList(),
                      value: _selectedLocation1,
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation1 = value;
                        });
                      },
                    )
                  ],
                ),
              ),
// //######### Tag  #########
              Container(
                margin: const EdgeInsets.all(2.0),
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
                      value: _selectedTag1,
                      onChanged: (value) {
                        setState(() {
                          _selectedTag1 = value;
                        });
                      },
                    )
                  ],
                ),
              ),

// //######### Goal  #########
              Container(
                margin: const EdgeInsets.all(2.0),
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
                      value: _selectedGoal1,
                      onChanged: (value) {
                        setState(() {
                          _selectedGoal1 = value;
                        });
                      },
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),

///////////////////////////
//  SORT ORDER 1
///////////////////////////
              Text("Sort - first, second, third"),
///////////////////////////
//  SORT ORDER 1
///////////////////////////
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.pink[100]),
                child: DropdownButtonFormField(
                  value: _selectedSortField1,
                  items: _dropdownMenuItemsSort,
                  hint: Text('Sort Order 1'),
                  onChanged: (selectedSort) {
                    setState(() {
                      _selectedSortField1 = selectedSort;
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
                  value: _selectedSortOrder1,
                  items: _dropdownMenuSortOrder,
                  hint: Text('Sort 1 Ascending/Descending'),
                  onChanged: (selectedOrder) {
                    setState(() {
                      _selectedSortOrder1 = selectedOrder;
                    });
                  },
                ),
              ),
///////////////////////////
//  SORT ORDER 2
///////////////////////////
//              Text("Sort 2"),
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.pink[100]),
                child: DropdownButtonFormField(
                  items: _dropdownMenuItemsSort,
                  hint: Text('Sort 2'),
                  value: _selectedSortField2,
                  onChanged: (selectedSort) {
                    setState(() {
                      _selectedSortField2 = selectedSort;
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
                  value: _selectedSortOrder2,
                  items: _dropdownMenuSortOrder,
                  hint: Text('Sort 2 Ascending/Descending'),
                  onChanged: (selectedOrder) {
                    setState(() {
                      _selectedSortOrder2 = selectedOrder;
                    });
                  },
                ),
              ),
///////////////////////////
//  SORT ORDER 3
///////////////////////////
//              Text("Sort 3"),
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.pink[100]),
                child: DropdownButtonFormField(
                  items: _dropdownMenuItemsSort,
                  hint: Text('Sort 3'),
                  value: _selectedSortField3,
                  onChanged: (selectedSort) {
                    setState(() {
                      _selectedSortField3 = selectedSort;
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
                  value: _selectedSortOrder3,
                  items: _dropdownMenuSortOrder,
                  hint: Text('Sort Order 3 Ascending/Descending'),
                  onChanged: (selectedOrder) {
                    setState(() {
                      _selectedSortOrder3 = selectedOrder;
                    });
                  },
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Text("View - Main and Second Line"),
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
                  value: _selectedShowMain1,
                  onChanged: (selectedShow) {
                    setState(() {
                      _selectedShowMain1 = selectedShow;
                    });
                  },
                ),
              ),
///////////////////////////
//  Show Secondary 1
///////////////////////////
//              Text("Show - Second Line"),
              new Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.green[100]),
                child: DropdownButtonFormField(
                  items: _dropdownMenuItemsSort,
                  hint: Text('Display Secondary1'),
                  value: _selectedShowSec1,
                  onChanged: (selectedShow) {
                    setState(() {
                      _selectedShowSec1 = selectedShow;
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
                          if (_selectedSortField1 != null)
                            globals.sortField1 = _selectedSortField1.id;
                          if (_selectedSortOrder1 != null)
                            globals.sortOrder1 = _selectedSortOrder1.id;
                          if (_selectedSortField2 != null)
                            globals.sortField2 = _selectedSortField2.id;
                          if (_selectedSortOrder2 != null)
                            globals.sortOrder2 = _selectedSortOrder2.id;
                          if (_selectedSortField3 != null)
                            globals.sortField3 = _selectedSortField3.id;
                          if (_selectedSortOrder3 != null)
                            globals.sortOrder3 = _selectedSortOrder3.id;
                          if (_selectedShowMain1 != null)
                            globals.showMain1 = _selectedShowMain1.id;
                          print(globals.showMain1);
                          if (_selectedShowMain2 != null)
                            globals.showMain2 = _selectedShowMain2.id;
                          print(globals.showMain2);
                          if (_selectedShowSec1 != null)
                            globals.showSec1 = _selectedShowSec1.id;
                          print(globals.showSec1);
                          if (_selectedShowSec2 != null)
                            globals.showSec2 = _selectedShowSec2.id;
                          print(globals.showSec2);
                          if (_selectedShowSec3 != null)
                            globals.showSec3 = _selectedShowSec3.id;
                          print(globals.showSec3);
                          if (_selectedFilterIsDone != null)
                            globals.filterIsDone = _selectedFilterIsDone.id;
                          if (_selectedFilterDateDue != null)
                            globals.filterDateDue = _selectedFilterDateDue.id;
                          if (_selectedFilterStatus != null)
                            globals.filterStatus = _selectedFilterStatus.id;
                          if (_selectedFilterPriority != null)
                            globals.filterPriority = _selectedFilterPriority.id;
                          if (_selectedFilterStar != null)
                            globals.filterStar = _selectedFilterStar.id;
//                          if (_selectedFilterCategory != null)
//                            globals.filterCategory = _selectedFilterCategory.id;
//                          if (_selectedFilterAction != null)
//                            globals.filterAction = _selectedFilterAction.id;
//                          if (_selectedFilterContext != null)
//                            globals.filterContext = _selectedFilterContext.id;
//                          if (_selectedFilterLocation != null)
//                            globals.filterLocation = _selectedFilterLocation.id;
//                          if (_selectedFilterTag != null)
//                            globals.filterTag = _selectedFilterTag.id;

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
                                '', 
                                "",
                                "",
                                "",
                                "",
                             false,);
                          }

                          customSetting.sortField1 = _selectedSortField1 == null
                              ? ""
                              : _selectedSortField1.id.toString();
                          customSetting.sortOrder1 = _selectedSortOrder1 == null
                              ? ""
                              : _selectedSortOrder1.id.toString();
                          customSetting.sortField2 = _selectedSortField2 == null
                              ? ""
                              : _selectedSortField2.id.toString();
                          customSetting.sortOrder2 = _selectedSortOrder2 == null
                              ? ""
                              : _selectedSortOrder2.id.toString();
                          customSetting.sortField3 = _selectedSortField3 == null
                              ? ""
                              : _selectedSortField3.id.toString();
                          customSetting.sortOrder3 = _selectedSortOrder3 == null
                              ? ""
                              : _selectedSortOrder3.id.toString();
                          customSetting.showMain1 = _selectedShowMain1 == null
                              ? ""
                              : _selectedShowMain1.id.toString();
                          customSetting.showMain2 = _selectedShowMain2 == null
                              ? ""
                              : _selectedShowMain2.id.toString();
                          customSetting.showSec1 = _selectedShowSec1 == null
                              ? ""
                              : _selectedShowSec1.id.toString();
                          customSetting.showSec2 = _selectedShowSec2 == null
                              ? ""
                              : _selectedShowSec2.id.toString();
                          customSetting.showSec3 = _selectedShowSec3 == null
                              ? ""
                              : _selectedShowSec3.id.toString();
                          customSetting.filterDateDue =
                              _selectedFilterDateDue == null
                                  ? ""
                                  : _selectedFilterDateDue.id.toString();
                          if (_selectedFilterIsDone == null) {
                            customSetting.filterIsDone = false;
                          } else {
                            if (_selectedFilterIsDone.id == 0) {
                              customSetting.filterIsDone = false;
                            } else {
                              customSetting.filterIsDone = true;
                            }
                          }

                          customSetting.filterCategory =
                              _selectedCategory == null
                                  ? ""
                                  : _selectedCategory.toString();
                          customSetting.filterAction = _selectedAction1 == null
                              ? ""
                              : _selectedAction1.toString();
                          customSetting.filterContext =
                              _selectedContext1 == null
                                  ? ""
                                  : _selectedContext1.toString();
                          customSetting.filterLocation =
                              _selectedLocation1 == null
                                  ? ""
                                  : _selectedLocation1.toString();
                          customSetting.filterTag = _selectedTag1 == null
                              ? ""
                              : _selectedTag1.toString();
                          customSetting.filterGoal = _selectedGoal1 == null
                              ? ""
                              : _selectedGoal1.toString();


                          var result;

                          if (customSetting.id != null) {
                            result = helper.updateCustomSettings(customSetting);
                          } else {
                            result = helper.insertCustomSettings(customSetting);
                          }

//end of save
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
        if (customSetting.sortOrder1 != "") {
          _selectedSortOrder1 =
              _dropdownMenuSortOrder[int.parse(customSetting.sortOrder1)].value;
          globals.sortField1 = int.parse(
              customSetting.sortOrder1); //convert it to session variables
        }
        if (customSetting.sortField2 != "") {
          _selectedSortField2 =
              _dropdownMenuItemsSort[int.parse(customSetting.sortField2)].value;
          globals.sortField2 = int.parse(customSetting.sortField2);
        }
        if (customSetting.sortOrder2 != "") {
          _selectedSortOrder2 =
              _dropdownMenuSortOrder[int.parse(customSetting.sortOrder2)].value;
          globals.sortField2 = int.parse(
              customSetting.sortOrder2); //convert it to session variables
        }
        if (customSetting.sortField3 != "") {
          _selectedSortField3 =
              _dropdownMenuItemsSort[int.parse(customSetting.sortField3)].value;
          globals.sortField3 = int.parse(customSetting.sortField3);
        }
        if (customSetting.sortOrder3 != "") {
          _selectedSortOrder3 =
              _dropdownMenuSortOrder[int.parse(customSetting.sortOrder3)].value;
          globals.sortField3 = int.parse(
              customSetting.sortOrder3); //convert it to session variables
        }
        if (customSetting.showMain1 != "") {
          _selectedShowMain1 =
              _dropdownMenuItemsSort[int.parse(customSetting.showMain1)].value;
          globals.showMain1 = int.parse(customSetting.showMain1);
        }
        if (customSetting.showMain2 != "") {
          _selectedShowMain2 =
              _dropdownMenuItemsSort[int.parse(customSetting.showMain2)].value;
          globals.showMain2 = int.parse(customSetting.showMain2);
        }
        if (customSetting.showSec1 != "") {
          _selectedShowSec1 =
              _dropdownMenuItemsSort[int.parse(customSetting.showSec1)].value;
          globals.showSec1 = int.parse(customSetting.showSec1);
        }
        if (customSetting.showSec2 != "") {
          _selectedShowSec2 =
              _dropdownMenuItemsSort[int.parse(customSetting.showSec2)].value;
          globals.showSec2 = int.parse(customSetting.showSec2);
        }
        if (customSetting.showSec3 != "") {
          _selectedShowSec3 =
              _dropdownMenuItemsSort[int.parse(customSetting.showSec3)].value;
          globals.showSec3 = int.parse(customSetting.showSec3);
        }
        if (customSetting.filterIsDone == true) {
          _selectedFilterIsDone = _dropdownFilterIsDone[1].value;
          globals.filterIsDone = 1;
        } else
          _selectedFilterIsDone = _dropdownFilterIsDone[0].value;
      }

      if (customSetting.filterDateDue != "") {
        _selectedFilterDateDue =
            _dropdownFilterDateDue[int.parse(customSetting.filterDateDue)]
                .value;
        globals.filterDateDue = int.parse(customSetting.filterDateDue);
      }

      if (customSetting.filterStatus != "") {
        _selectedFilterStatus =
            _dropdownFilterStatus[int.parse(customSetting.filterStatus)]
                .value;
        globals.filterStatus = int.parse(customSetting.filterStatus);
      }

      if (customSetting.filterPriority != "") {
        _selectedFilterPriority =
            _dropdownFilterPriority[int.parse(customSetting.filterPriority)]
                .value;
        globals.filterPriority = int.parse(customSetting.filterPriority);
      }

      if (customSetting.filterStar != "") {
        _selectedFilterStar =
            _dropdownFilterStar[int.parse(customSetting.filterStar)]
                .value;
        globals.filterStar = int.parse(customSetting.filterStar);
      }

      ////////////////////////////
      /// filter - category
      ////////////////////////////
      if (customSetting.filterCategory == "") {
        _selectedCategory = null;
        customSetting.filterCategory = null;
      } else {
        _selectedCategory = customSetting.filterCategory.toString();
        globals.filterCategory = int.parse(customSetting.filterCategory);
      }

      if (customSetting.filterAction == "") {
        _selectedAction1 = null;
        customSetting.filterAction = null;
      } else {
        _selectedAction1 = customSetting.filterAction.toString();
        globals.filterAction = int.parse(customSetting.filterAction);
      }
      if (customSetting.filterContext == "") {
        _selectedContext1 = null;
        customSetting.filterContext = null;
      } else {
        _selectedContext1 = customSetting.filterContext.toString();
        globals.filterContext = int.parse(customSetting.filterContext);
      }

      if (customSetting.filterTag == "") {
        _selectedTag1 = null;
        customSetting.filterTag = null;
      } else {
        _selectedTag1 = customSetting.filterTag.toString();
        globals.filterTag = int.parse(customSetting.filterTag);
      }

      if (customSetting.filterGoal == "") {
        _selectedGoal1 = null;
        customSetting.filterGoal = null;
      } else {
        _selectedGoal1 = customSetting.filterGoal.toString();
        globals.filterGoal = int.parse(customSetting.filterGoal);
      }

      if (customSetting.filterLocation == "") {
        _selectedLocation1 = null;
        customSetting.filterLocation = null;
      } else {
        _selectedLocation1 = customSetting.filterLocation.toString();
        globals.filterLocation = int.parse(customSetting.filterLocation);
      }
    }
    setState(() {
      customSetting = customSetting;
    });
  }
}
