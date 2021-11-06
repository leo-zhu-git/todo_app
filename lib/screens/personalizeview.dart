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
//      SortItem(6, 'Priority'),
//      SortItem(7, 'Action'),
//      SortItem(8, 'Context'),
//      SortItem(9, 'Location'),
//      SortItem(7, 'Tag'),
//      SortItem(11, 'Goal'),
      SortItem(6, 'Focus'),
      SortItem(7, 'Done'),
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
//      ShowItem(4, 'Priority'),
//      ShowItem(5, 'Action'),
//      ShowItem(6, 'Context'),
//      ShowItem(7, 'Location'),
//      ShowItem(5, 'Tag'),
//      ShowItem(9, 'Goal'),
      ShowItem(4, 'Focus'),
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
    ];
  }
}

//class FilterStatus {
//  int id;
//  String name;
//
//  FilterStatus(this.id, this.name);
//  static List<FilterStatus> getStatus() {
//    return <FilterStatus>[
//      FilterStatus(0, '-- All Statuses -- '),
//      FilterStatus(1, 'Next Action'),
//      FilterStatus(2, 'Action'),
//      FilterStatus(3, 'Planning'),
//      FilterStatus(4, 'Delegated'),
//      FilterStatus(5, 'Waiting'),
//      FilterStatus(6, 'Hold'),
//    ];
//  }
//}

//class FilterPriority {
//  int id;
//  String name;
//
//  FilterPriority(this.id, this.name);
//  static List<FilterPriority> getPriority() {
//    return <FilterPriority>[
//      FilterPriority(0, '-- All Priorities --'),
//      FilterPriority(1, 'Low'),
//      FilterPriority(2, 'Medium'),
//      FilterPriority(3, 'High'),
//      FilterPriority(4, 'Top'),
//    ];
//  }
//}

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
  ShowItem? _selectedShowSec1;
  ShowItem? _selectedShowSec2;
  ShowItem? _selectedShowSec3;
  DbHelper helper = DbHelper();
  CustomSettings? customSetting;
  List<CustomDropdownItem> _categories = [];
  List<CustomDropdownItem> _statuses = [];
//  List<CustomDropdownItem> _priorities = [];
//  List<CustomDropdownItem> _action1s = [];
//  List<CustomDropdownItem> _context1s = [];
//  List<CustomDropdownItem> _location1s = [];
//  List<CustomDropdownItem> _tag1s = [];
//  List<CustomDropdownItem> _goal1s = [];
  List<Task> tasklist = [];
  int count = 0;
  TextEditingController searchController = TextEditingController();
  var _selectedCategory = null;
  var _selectedStatus = null;
//  var _selectedPriority = null;
//  var _selectedAction1 = null;
//  var _selectedContext1 = null;
//  var _selectedLocation1 = null;
//  var _selectedTag1 = null;
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
//    _loadPriorities();
//    _loadAction1s();
//    _loadContext1s();
//    _loadLocation1s();
//    _loadTag1s();
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
    if (globals.sortField1 == 6) {
      _selectedSortField1 = _dropdownMenuItemsSort[6].value!;
      globals.sortField1 = 6;
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

    ////////////////////////////
    /// show - main1 is hard coded to tasks always RT
    ////////////////////////////
//    if (globals.showMain1 == null) {
//      _selectedShowMain1 = _dropdownMenuItemsShow[0].value;
//      globals.showMain1 = 0;
//    } else
//      _selectedShowMain1 = _dropdownMenuItemsShow[globals.showMain1].value;

//    if (globals.showMain2 == null) {
//      _selectedShowMain2 = _dropdownMenuItemsShow[2].value;
//      globals.showMain2 = 2;
//    } else
//      _selectedShowMain2 = _dropdownMenuItemsShow[globals.showMain2].value;

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
    cus.name =
        "12345678901234567890123456789012345678901234567890123456789012345678901234567890";
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
    cus.name =
        "12345678901234567890123456789012345678901234567890123456789012345678901234567890";
    cus.name =
        "-- All Statuses --";
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

//  _loadPriorities() async {
//    var priorities = await helper.getPriorities();
//    CustomDropdownItem cus;
//    cus = new CustomDropdownItem();
//    cus.id = null;
//    cus.name =
//        "12345678901234567890123456789012345678901234567890123456789012345678901234567890";
//    cus.name =
//        "-- All Priorities --";
//    _priorities.add(cus);
//    priorities.forEach((priority) {
//      setState(() {
//        cus = new CustomDropdownItem();
//        cus.id = priority['id'].toString();
//        String tempPriority;
//        if (priority['name'].toString().length > 30)
//          tempPriority = priority['name'].toString().substring(0, 30) + "...";
//        else
//          tempPriority = priority['name'];

//        cus.name = tempPriority;

//        _priorities.add(cus);
//      });
//    });
//  }

//  _loadAction1s() async {
//    var action1s = await helper.getAction1s();
//    CustomDropdownItem cus;
//    cus = new CustomDropdownItem();
//    cus.id = null;
//    cus.name =
//        "12345678901234567890123456789012345678901234567890123456789012345678901234567890";
//    cus.name =
//        "-- All Actions --";
//    _action1s.add(cus);
//    action1s.forEach((action1) {
//      setState(() {
//        cus = new CustomDropdownItem();
//        cus.id = action1['id'].toString();
//        String tempAct;
//        if (action1['name'].toString().length > 20)
//          tempAct = action1['name'].toString().substring(0, 20) + "...";
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
//    cus.name =
//        "12345678901234567890123456789012345678901234567890123456789012345678901234567890";
//    cus.name =
//        "-- All Contexts --";
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
//    cus.name =
//        "12345678901234567890123456789012345678901234567890123456789012345678901234567890";
//    cus.name =
//        "-- All Locations --";
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

//  _loadTag1s() async {
//    var tag1s = await helper.getTag1s();
//    CustomDropdownItem cus;
//    cus = new CustomDropdownItem();
//    cus.id = null;
//    cus.name =
//        "12345678901234567890123456789012345678901234567890123456789012345678901234567890";
//    cus.name =
//        "-- All Tags --";
//    _tag1s.add(cus);
//    tag1s.forEach((tag1) {
//      setState(() {
//        cus = new CustomDropdownItem();
//        cus.id = tag1['id'].toString();
//        String tempTag;
//        if (tag1['name'].toString().length > 30)
//          tempTag = tag1['name'].toString().substring(0, 30) + "...";
//        else
//          tempTag = tag1['name'];

//        cus.name = tempTag;
//        _tag1s.add(cus);
//      });
//    });
//  }

//  _loadGoal1s() async {
//    var goal1s = await helper.getGoal1s();
//    CustomDropdownItem cus;
//    cus = new CustomDropdownItem();
//    cus.id = null;
//    cus.name =
//        "12345678901234567890123456789012345678901234567890123456789012345678901234567890";
//    cus.name =
//        "-- All Goals --";
//    _goal1s.add(cus);
//    goal1s.forEach((goal1) {
//      setState(() {
//        cus = new CustomDropdownItem();
//        cus.id = goal1['id'].toString();
//        String tempGoal;
//        if (goal1['name'].toString().length > 30)
//          tempGoal = goal1['name'].toString().substring(0, 30) + "...";
//        else
//          tempGoal = goal1['name'];

//        cus.name = tempGoal;
//        _goal1s.add(cus);
//      });
//    });
//  }

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

//  List<DropdownMenuItem<FilterStatus>> buildDropdownFilterStatus(
//      List filterStatusItems) {
//    List<DropdownMenuItem<FilterStatus>> items = List();
//    for (FilterStatus filterStatus in filterStatusItems) {
//      items.add(
//        DropdownMenuItem(
//          value: filterStatus,
//          child: Text(filterStatus.name),
//        ),
//      );
//    }
//    return items;
//  }

//  List<DropdownMenuItem<FilterPriority>> buildDropdownFilterPriority(
//      List filterPriorityItems) {
//    List<DropdownMenuItem<FilterPriority>> items = List();
//    for (FilterPriority filterPriority in filterPriorityItems) {
//      items.add(
//        DropdownMenuItem(
//          value: filterPriority,
//          child: Text(filterPriority.name),
//        ),
//      );
//    }
//    return items;
//  }

//  List<DropdownMenuItem<FilterStar>> buildDropdownFilterStar(
//      List filterStarItems) {
//    List<DropdownMenuItem<FilterStar>> items = List();
//    for (FilterStar filterStar in filterStarItems) {
//      items.add(
//        DropdownMenuItem(
//          value: filterStar,
//          child: Text(filterStar.name),
//        ),
//      );
//    }
//    return items;
//  }

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
//      backgroundColor: Colors.teal[50],
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
//        backgroundColor: Colors.indigo[600],
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.pink[100]),
          tooltip: 'Home',
          onPressed: () {
//            Navigator.pop(context, true);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TaskHome()));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt, color: Colors.white),
            tooltip: 'Add Tag',
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
//                print(globals.showMain2);
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
//                          customSetting.showMain1 = _selectedShowMain1 == null
//                              ? ""
//                              : _selectedShowMain1.id.toString();
//                          customSetting.showMain2 = _selectedShowMain2 == null
//                              ? ""
//                              : _selectedShowMain2.id.toString();
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

                  customSetting!.filterCategory = _selectedCategory == null
                      ? ""
                      : _selectedCategory.toString();
                  customSetting!.filterStatus =
                      _selectedStatus == null ? "" : _selectedStatus.toString();
//                  customSetting!.filterPriority = _selectedPriority == null
//                      ? ""
//                      : _selectedPriority.toString();
//                  customSetting!.filterAction = _selectedAction1 == null
//                      ? ""
//                      : _selectedAction1.toString();
//                  customSetting!.filterContext = _selectedContext1 == null
//                      ? ""
//                      : _selectedContext1.toString();
//                  customSetting!.filterLocation = _selectedLocation1 == null
//                      ? ""
//                      : _selectedLocation1.toString();
//                  customSetting!.filterTag =
//                      _selectedTag1 == null ? "" : _selectedTag1.toString();
//                  customSetting!.filterGoal =
//                      _selectedGoal1 == null ? "" : _selectedGoal1.toString();

                  var result;

                  if (customSetting!.id != null) {
                    result = helper.updateCustomSettings(customSetting!);
                  } else {
                    result = helper.insertCustomSettings(customSetting!);
                  }

//end of save
                }
              });
//                        _showSuccessSnackBar(
//                          Container(
//                            color: Colors.tealAccent[100],
//                            height: 40,
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: [
//                                (Icon(
//                                  Icons.thumb_up,
//                                  color: Colors.black,
//                                )),
//                                Text(
//                                  ' Added ',
//                                  style: (TextStyle(color: Colors.black)),
//                                )
//                              ],
//                            ),
//                          ),
//                        );
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
//  Filter Date Due
///////////////////////////
              Text("Filter - Reduce tasks to view", style: _textStyleControls),

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

//#################################Category#####################################################
              Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
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
                  ],
                ),
              ),

//#################################Status#####################################################
              Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.blue[100]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
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
                  ],
                ),
              ),

//#################################Priority#####################################################
//              Container(
//                margin: const EdgeInsets.all(2.0),
//                decoration: BoxDecoration(
//                    shape: BoxShape.rectangle, color: Colors.blue[100]),
//                child: Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: [
//                    DropdownButton<String>(
//                        style: _textStyleControls,
//                        items: _priorities.map((CustomDropdownItem value) {
//                          return DropdownMenuItem<String>(
//                              value: value.id,
//                              child: Text(
//                                value.name!,
//                                overflow: TextOverflow.ellipsis,
//                              ));
//                        }).toList(),
//                        value: _selectedPriority,
//                        onChanged: (newValue) {
//                          setState(() {
//                            _selectedPriority = newValue;
//                          });
//                        }),
//                  ],
//                ),
//              ),

//########################################### Action  ######### #################################3
//              Container(
//                margin: const EdgeInsets.all(2.0),
//                decoration: BoxDecoration(
//                    shape: BoxShape.rectangle, color: Colors.blue[100]),
//                child: Flexible(
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: [
//                      DropdownButton<String>(
//                        items: _action1s.map((CustomDropdownItem value) {
//                          return DropdownMenuItem<String>(
//                              value: value.id, child: Text(value.name!));
//                        }).toList(),
//                        value: _selectedAction1,
//                        onChanged: (value) {
//                          setState(() {
//                            _selectedAction1 = value;
//                            //                    searchData(_searchText, _selectedpriority, _selectedCategory, _selectedAction1, _selectedContext1, _selectedLocation1, _selectedTag1, _selectedGoal1);
//                          });
//                        },
//                      )
//                    ],
//                  ),
//                ),
//              ),

//######### Context  #########
//              Container(
//                margin: const EdgeInsets.all(2.0),
//                decoration: BoxDecoration(
//                    shape: BoxShape.rectangle, color: Colors.blue[100]),
//                child: Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: [
//                    DropdownButton<String>(
//                      items: _context1s.map((CustomDropdownItem value) {
//                        return DropdownMenuItem<String>(
//                            value: value.id, child: Text(value.name!));
//                      }).toList(),
//                      value: _selectedContext1,
//                      onChanged: (value) {
//                        setState(() {
//                          _selectedContext1 = value;
//                        });
//                      },
//                    )
//                  ],
//                ),
//              ),

// //######### Location  #########
//              Container(
//                margin: const EdgeInsets.all(2.0),
//                decoration: BoxDecoration(
//                    shape: BoxShape.rectangle, color: Colors.blue[100]),
//                child: Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: [
//                    DropdownButton<String>(
//                      items: _location1s.map((CustomDropdownItem value) {
//                        return DropdownMenuItem<String>(
//                            value: value.id, child: Text(value.name!));
//                      }).toList(),
//                      value: _selectedLocation1,
//                      onChanged: (value) {
//                        setState(() {
//                          _selectedLocation1 = value;
//                        });
//                      },
//                    )
//                  ],
//                ),
//              ),

// //######### Tag  #########
//              Container(
//                margin: const EdgeInsets.all(2.0),
//                decoration: BoxDecoration(
//                    shape: BoxShape.rectangle, color: Colors.blue[100]),
//                child: Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: [
//                    DropdownButton<String>(
//                      style: _textStyleControls,
//                      items: _tag1s.map((CustomDropdownItem value) {
//                        return DropdownMenuItem<String>(
//                            value: value.id, child: Text(value.name!));
//                      }).toList(),
//                      value: _selectedTag1,
//                      onChanged: (value) {
//                        setState(() {
//                          _selectedTag1 = value;
//                        });
//                      },
//                    )
//                  ],
//                ),
//              ),

// //######### Goal  #########
//              Container(
//                margin: const EdgeInsets.all(2.0),
//                decoration: BoxDecoration(
//                    shape: BoxShape.rectangle, color: Colors.blue[100]),
//                child: Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: [
//                    DropdownButton<String>(
//                      items: _goal1s.map((CustomDropdownItem value) {
//                        return DropdownMenuItem<String>(
//                            value: value.id, child: Text(value.name!));
//                      }).toList(),
//                      value: _selectedGoal1,
//                      onChanged: (value) {
//                        setState(() {
//                          _selectedGoal1 = value;
//                        });
//                      },
//                    )
//                  ],
//                ),
//              ),

///////////////////////////
//  Filter Is Star
///////////////////////////

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
///////////////////////////
//  Filter Is Done
///////////////////////////

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

///////////////////////////
//  SORT ORDER 1
///////////////////////////
              Text("Sort - first, second, third", style: _textStyleControls),
///////////////////////////
//  SORT ORDER 1
///////////////////////////
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
///////////////////////////
//  SORT ORDER 1 ASC/DESC
///////////////////////////
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
///////////////////////////
//  SORT ORDER 2
///////////////////////////
//              Text("Sort 2"),
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
///////////////////////////
//  SORT ORDER 2 ASC/DESC
///////////////////////////
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
///////////////////////////
//  SORT ORDER 3
///////////////////////////
//              Text("Sort 3"),
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
///////////////////////////
//  SORT ORDER 3 ASC/DESC
///////////////////////////
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

              SizedBox(
                height: 20,
              ),

              Text("Picklist | User-defined Dropdowns",
                  style: _textStyleControls),

///////////////////////////
//  Picklist - Categories
///////////////////////////
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

///////////////////////////
//  Picklist - Action
///////////////////////////
//              Card(
//                elevation: 8.0,
//                child: ListTile(
//                  tileColor: Colors.orange[100],
//                  title: Text('Actions'),
//                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
//                      builder: (context) => Action1sScreen())),
//                ),
//              ),
//              SizedBox(height: 2),

///////////////////////////
//  Picklist - Statuses
///////////////////////////
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

///////////////////////////
//  Picklist - Priorities
///////////////////////////
//              Card(
//                elevation: 8.0,
//                child: ListTile(
//                  tileColor: Colors.orange[100],
//                  title: Text('Priorities', style: _textStyleControls),
//                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
//                      builder: (context) => PrioritiesScreen())),
//                ),
//              ),
//              SizedBox(height: 2),
///////////////////////////
//  Picklist - Contexts
///////////////////////////
//              Card(
//                elevation: 8.0,
//                child: ListTile(
//                  tileColor: Colors.orange[100],
//                  title: Text('Contexts'),
//                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => Context1sScreen())),
//                ),
//              ),
//              SizedBox(height: 2),

///////////////////////////
//  Picklist - Locations
///////////////////////////
//              Card(
//                elevation: 8.0,
//                child: ListTile(
//                  tileColor: Colors.orange[100],
//                  title: Text('Locations'),
//                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
//                      builder: (context) => Location1sScreen())),
//                ),
//              ),
//              SizedBox(height: 2),

///////////////////////////
//  Picklist - Tags
///////////////////////////
//              Card(
//                elevation: 8.0,
//                child: ListTile(
//                  tileColor: Colors.orange[100],
//                  title: Text('Tags', style: _textStyleControls),
//                  onTap: () => Navigator.of(context).push(
//                      MaterialPageRoute(builder: (context) => Tag1sScreen())),
//                ),
//              ),
//              SizedBox(height: 2),

///////////////////////////
//  Picklist - Goals
///////////////////////////
//              Card(
//                elevation: 8.0,
//                child: ListTile(
//                  tileColor: Colors.orange[100],
//                  title: Text('Goals'),
//                  onTap: () => Navigator.of(context).push(
//                      MaterialPageRoute(builder: (context) => Goal1sScreen())),
//                ),
//              ),
              SizedBox(
                height: 20,
              ),
              Text("View - second line up to 3 fields",
                  style: _textStyleControls),
///////////////////////////
//  Show Main 1
///////////////////////////
//              new Container(
//                margin: const EdgeInsets.all(2.0),
//                decoration: BoxDecoration(
//                    shape: BoxShape.rectangle, color: Colors.yellow[200]),
//                child: DropdownButtonFormField(
//                  items: _dropdownMenuItemsSort,
//                  hint: Text('Display Main1'),
//                  value: _selectedShowMain1,
//                  onChanged: (selectedShow) {
//                    setState(() {
//                      _selectedShowMain1 = selectedShow;
//                    });
//                  },
//                ),
//              ),
///////////////////////////
//  Show Secondary 1
///////////////////////////
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

///////////////////////////
//  Show Secondary 2
///////////////////////////
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

///////////////////////////
//  Show Secondary 3
///////////////////////////
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

//              SizedBox(
//                height: 20,
//              ),

              /// form - save or cancel
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: [
//                  ElevatedButton(
//                      onPressed: () {
//                        Navigator.pop(context);
//                      },
//                      style: ElevatedButton.styleFrom(
//                        primary: Colors.grey[300],
//                      ),
//                      child: Text(
//                        'Cancel',
//                        style: TextStyle(color: Colors.teal[800]),
//                      )),
//                  SizedBox(width: 5),
//                  ElevatedButton(
//                      onPressed: () {
//                        setState(() {
//                          if (_selectedSortField1 != null)
//                            globals.sortField1 = _selectedSortField1!.id;
//                          if (_selectedSortOrder1 != null)
//                            globals.sortOrder1 = _selectedSortOrder1!.id;
//                          if (_selectedSortField2 != null)
//                            globals.sortField2 = _selectedSortField2!.id;
//                          if (_selectedSortOrder2 != null)
//                            globals.sortOrder2 = _selectedSortOrder2!.id;
//                          if (_selectedSortField3 != null)
//                            globals.sortField3 = _selectedSortField3!.id;
//                          if (_selectedSortOrder3 != null)
//                            globals.sortOrder3 = _selectedSortOrder3!.id;
//                          print(globals.showMain2);
//                          if (_selectedShowSec1 != null)
//                            globals.showSec1 = _selectedShowSec1!.id;
//                          print(globals.showSec1);
//                          if (_selectedShowSec2 != null)
//                            globals.showSec2 = _selectedShowSec2!.id;
//                          print(globals.showSec2);
//                          if (_selectedShowSec3 != null)
//                            globals.showSec3 = _selectedShowSec3!.id;
//                         print(globals.showSec3);
//                          if (_selectedFilterIsStar != null)
//                            globals.filterIsStar = _selectedFilterIsStar!.id;
//                          if (_selectedFilterIsDone != null)
//                            globals.filterIsDone = _selectedFilterIsDone!.id;
//                          if (_selectedFilterDateDue != null)
//                            globals.filterDateDue = _selectedFilterDateDue!.id;

//Save
//                          if (customSetting == null) {
//                            customSetting = new CustomSettings(
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              "",
//                              "",
//                              "",
//                              0,
//                              0,
//                            );
//                          }

//                          customSetting!.sortField1 =
//                              _selectedSortField1 == null
//                                  ? ""
//                                  : _selectedSortField1!.id.toString();
//                          customSetting!.sortOrder1 =
//                              _selectedSortOrder1 == null
//                                  ? ""
//                                  : _selectedSortOrder1!.id.toString();
//                          customSetting!.sortField2 =
//                              _selectedSortField2 == null
//                                  ? ""
//                                  : _selectedSortField2!.id.toString();
//                          customSetting!.sortOrder2 =
//                              _selectedSortOrder2 == null
//                                  ? ""
//                                  : _selectedSortOrder2!.id.toString();
//                          customSetting!.sortField3 =
//                              _selectedSortField3 == null
//                                  ? ""
//                                  : _selectedSortField3!.id.toString();
//                          customSetting!.sortOrder3 =
//                              _selectedSortOrder3 == null
//                                  ? ""
//                                  : _selectedSortOrder3!.id.toString();
//                          customSetting.showMain1 = _selectedShowMain1 == null
//                              ? ""
//                              : _selectedShowMain1.id.toString();
//                          customSetting.showMain2 = _selectedShowMain2 == null
//                              ? ""
//                              : _selectedShowMain2.id.toString();
//                          customSetting!.showSec1 = _selectedShowSec1 == null
//                              ? ""
//                            : _selectedShowSec1!.id.toString();
//                          customSetting!.showSec2 = _selectedShowSec2 == null
//                              ? ""
//                              : _selectedShowSec2!.id.toString();
//                          customSetting!.showSec3 = _selectedShowSec3 == null
//                              ? ""
//                              : _selectedShowSec3!.id.toString();
//                          customSetting!.filterDateDue =
//                             _selectedFilterDateDue == null
//                                  ? ""
//                                  : _selectedFilterDateDue!.id.toString();
//                          if (_selectedFilterIsStar == null) {
//                            customSetting!.filterIsStar = 0;
//                          } else {
//                            if (_selectedFilterIsStar!.id == 0) {
//                              customSetting!.filterIsStar = 0;
//                            } else {
//                              customSetting!.filterIsStar = 1;
//                            }
//                            if (_selectedFilterIsDone == null) {
//                              customSetting!.filterIsDone = 0;
//                            } else {
//                              if (_selectedFilterIsDone!.id == 0) {
//                                customSetting!.filterIsDone = 0;
//                              } else {
//                                customSetting!.filterIsDone = 1;
//                              }
//                            }

//                            customSetting!.filterStatus =
//                                _selectedStatus == null
//                                    ? ""
//                                    : _selectedStatus.toString();
//                            customSetting!.filterPriority =
//                                _selectedPriority == null
//                                    ? ""
//                                    : _selectedPriority.toString();
//                            customSetting!.filterCategory =
//                                _selectedCategory == null
//                                    ? ""
//                                    : _selectedCategory.toString();
//                            customSetting!.filterAction =
//                                _selectedAction1 == null
//                                    ? ""
//                                    : _selectedAction1.toString();
//                            customSetting!.filterContext =
//                                _selectedContext1 == null
//                                    ? ""
//                                    : _selectedContext1.toString();
//                            customSetting!.filterLocation =
//                                _selectedLocation1 == null
//                                    ? ""
//                                    : _selectedLocation1.toString();
//                            customSetting!.filterTag = _selectedTag1 == null
//                                ? ""
//                                : _selectedTag1.toString();
//                            customSetting!.filterGoal = _selectedGoal1 == null
//                                ? ""
//                                : _selectedGoal1.toString();

//                            var result;

//                            if (customSetting!.id != null) {
//                              result =
//                                  helper.updateCustomSettings(customSetting!);
//                            } else {
//                              result =
//                                  helper.insertCustomSettings(customSetting!);
//                            }

//end of save
//                          }
//                        });
//                        _showSuccessSnackBar(
//                          Container(
//                            color: Colors.tealAccent[100],
//                            height: 40,
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: [
//                                (Icon(
//                                  Icons.thumb_up,
//                                  color: Colors.black,
//                                )),
//                                Text(
//                                  ' Added ',
//                                  style: (TextStyle(color: Colors.black)),
//                                )
//                              ],
//                            ),
//                          ),
//                        );
//                        Navigator.of(context).pushNamed('/dashboard');
//                      },
//                      style: ElevatedButton.styleFrom(
//                        primary: Colors.teal[800],
//                      ),
//                      child: Text(
//                        'Save',
//                        style: TextStyle(color: Colors.white),
//                      ))
//                ],
//              ),
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
//        if (customSetting.showMain1 != "") {
//          _selectedShowMain1 =
//              _dropdownMenuItemsSort[int.parse(customSetting.showMain1)].value;
//          globals.showMain1 = int.parse(customSetting.showMain1);
//        }
//        if (customSetting.showMain2 != "") {
//          _selectedShowMain2 =
//              _dropdownMenuItemsSort[int.parse(customSetting.showMain2)].value;
//          globals.showMain2 = int.parse(customSetting.showMain2);
//        }
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
    ////////////////////////////
    /// filter - picklists
    ////////////////////////////
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

//    if (customSetting!.filterPriority == "") {
//      _selectedPriority = null;
//      customSetting!.filterPriority = "";
//    } else {
//      _selectedCategory = customSetting!.filterCategory.toString();
//      globals.filterCategory = int.parse(customSetting!.filterCategory!);
//    }

//    if (customSetting!.filterAction == "") {
//      _selectedAction1 = null;
//      customSetting!.filterAction = "";
//    } else {
//      _selectedAction1 = customSetting!.filterAction.toString();
//      globals.filterAction = int.parse(customSetting!.filterAction!);
//    }
//    if (customSetting!.filterContext == "") {
//      _selectedContext1 = null;
//      customSetting!.filterContext = "";
//    } else {
//      _selectedContext1 = customSetting!.filterContext.toString();
//      globals.filterContext = int.parse(customSetting!.filterContext!);
//    }

//    if (customSetting!.filterTag == "") {
//      _selectedTag1 = null;
//      customSetting!.filterTag = "";
//    } else {
//      _selectedTag1 = customSetting!.filterTag.toString();
//      globals.filterTag = int.parse(customSetting!.filterTag!);
//    }

//    if (customSetting!.filterGoal == "") {
//      _selectedGoal1 = null;
//      customSetting!.filterGoal = "";
//    } else {
//      _selectedGoal1 = customSetting!.filterGoal.toString();
//      globals.filterGoal = int.parse(customSetting!.filterGoal!);
//    }

//    if (customSetting!.filterLocation == "") {
//      _selectedLocation1 = null;
//      customSetting!.filterLocation = "";
//    } else {
//      _selectedLocation1 = customSetting!.filterLocation.toString();
//      globals.filterLocation = int.parse(customSetting!.filterLocation!);
//    }

    setState(() {
      customSetting = customSetting;
    });
  }
}
