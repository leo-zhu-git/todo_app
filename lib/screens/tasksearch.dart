import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/model/globals.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/screens/taskdetail.dart';
import 'package:todo_app/model/customDropdownItem.dart';
import 'package:todo_app/model/customSettings.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/globals.dart' as globals;

DbHelper helper = DbHelper();
TextStyle _textStyleControls = TextStyle(fontSize: 17.0, color: Colors.black87);
TextStyle _textStyleControlsSub = TextStyle(color: Colors.black);
TextStyle _textStyleSnack = TextStyle(
    fontSize: 16.0, color: Colors.pink[100], fontWeight: FontWeight.w600);

class FilterDateDue {
  int id;
  String name;

  FilterDateDue(this.id, this.name);
  static List<FilterDateDue> getDateDue() {
    return <FilterDateDue>[
      FilterDateDue(0, '[ All Due Dates ]'),
      FilterDateDue(1, 'Today'),
      FilterDateDue(2, 'Tomorrow'),
      FilterDateDue(3, 'Next 7 days'),
      FilterDateDue(4, 'Next 30 days'),
      FilterDateDue(5, 'Any Due Date'),
      FilterDateDue(6, 'No Due Date'),
      FilterDateDue(7, 'Overdues Only'),
      FilterDateDue(8, 'Overdues and Today'),
      FilterDateDue(9, 'Overdues, Today and Tomorrow'),
    ];
  }
}

class TaskSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TaskSearchState();
}

class TaskSearchState extends State {
  DbHelper helper = DbHelper();
  List<FilterDateDue> _filterDateDue = FilterDateDue.getDateDue();
  List<CustomDropdownItem> _categories = [];
  List<CustomDropdownItem> _statuses = [];
  List<CustomDropdownItem> _priorities = [];
  List<CustomDropdownItem> _tag1s = [];
  List<Task> tasklist = [];
  int count = 0;
  TextEditingController searchController = TextEditingController();
  String? _searchText = "";
  FilterDateDue? _selectedDateDue;
  String? _searchDateDue = "";
  int? _selectedIsStar;
  int? _selectedIsDone;
  int? _includeIsStar = 0;
  int? _includeIsDone = 0;
  String? _selectedCategory = "999";
  String? _selectedStatus = "999";
  String? _selectedPriority = '999';
  String? _selectedTag1 = "999";
  late List<DropdownMenuItem<FilterDateDue>> _dropdownFilterDateDue;

  int? _sortField1 = globals.sortField1 != null ? globals.sortField1 : 8;
  int? _sortField2 = globals.sortField2 != null ? globals.sortField2 : 2;
  int? _sortField3 = globals.sortField3 != null ? globals.sortField3 : 3;
  int? _sortField4 = globals.sortField4 != null ? globals.sortField4 : 0;
  int? _sortOrder1 = globals.sortOrder1 != null ? globals.sortOrder1 : 1;
  int? _sortOrder2 = globals.sortOrder2 != null ? globals.sortOrder2 : 0;
  int? _sortOrder3 = globals.sortOrder3 != null ? globals.sortOrder3 : 0;
  int? _sortOrder4 = globals.sortOrder4 != null ? globals.sortOrder4 : 0;

  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    _getCustomSettings();
    _dropdownFilterDateDue = buildDropdownFilterDateDue(_filterDateDue);
    _loadCategories();
    _loadStatuses();
    _loadPriorities();
    _loadTag1s();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is
    myFocusNode.dispose();

    super.dispose();
  }

  //##################Drop Down Items Load from DB #################################################################
  _loadCategories() async {
    var categories = await helper.getCategories();
    CustomDropdownItem cus;
    cus = new CustomDropdownItem();
    cus.id = "999";
    cus.name = "[ All Categories ]";
    _categories.add(cus);
    cus = new CustomDropdownItem();
    cus.id = "900";
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
    cus.id = "999";
    cus.name = "[ All Statuses ]";
    _statuses.add(cus);
    cus = new CustomDropdownItem();
    cus.id = "900";
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
    cus.id = "999";
    cus.name = "[ All Priorities ]";
    _priorities.add(cus);
    cus = new CustomDropdownItem();
    cus.id = "900";
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
    cus.id = "999";
    cus.name = "[ All Tags ]";
    _tag1s.add(cus);
    cus = new CustomDropdownItem();
    cus.id = "900";
    cus.name = "[ No Tag ]";
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

//##########################################end of Dropdown #################################################################

  @override
  Widget build(BuildContext context) {
//    Future.delayed(const Duration(), () => SystemChannels.textInput.invokeMethod('TextInput.hide'));

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, color: Colors.green[100]),
            Text(count.toString(), style: TextStyle(color: Colors.green[100])),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0, bottom: 2.0),
            child: TextField(
              autofocus: true,
              style: _textStyleControls,
              controller: searchController,
              onChanged: (value) {
                searchData(
                    value,
                    _searchDateDue,
                    _includeIsStar,
                    _includeIsDone,
                    _selectedCategory,
                    _selectedStatus,
                    _selectedPriority,
                    _selectedTag1);
              },
              decoration: InputDecoration(
                fillColor: Colors.green[100],
                border: InputBorder.none,
                filled: true, // dont forget this line
                labelText: "Searching for ...",
                labelStyle: _textStyleControls,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(0.0),
              child: ExpansionTile(
                title: Icon(
                  Icons.filter_alt_outlined,
                  color: Colors.black54,
                ),

                // backgroundColor: Colors.yellow,
                children: [
                  Column(
                    children: [
//################################# Due Dates #####################################################
                      new Container(
                        margin: EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(canvasColor: Colors.lime[100]),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<FilterDateDue>(
                              style: _textStyleControls,
                              items: _dropdownFilterDateDue,
                              hint: Text('Due Date', style: _textStyleControls),
                              value: _selectedDateDue,
                              onChanged: (selectedDateDue) {
                                setState(() {
                                  _selectedDateDue = selectedDateDue!;
                                  _searchDateDue = selectedDateDue.name;
                                  searchData(
                                      _searchText,
                                      _searchDateDue,
                                      _includeIsStar,
                                      _includeIsDone,
                                      _selectedCategory,
                                      _selectedStatus,
                                      _selectedPriority,
                                      _selectedTag1);
                                });
                              },
                            ),
                          ),
                        ),
                      ),

//####################################Show Completed Task Check box
                      Container(
                        margin: EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: (_includeIsDone == 0) ? false : true,
                              onChanged: (value) {
                                setState(() {
                                  _includeIsDone = (value! == false) ? 0 : 1;
                                  searchData(
                                      _searchText,
                                      _searchDateDue,
                                      _includeIsStar,
                                      _includeIsDone,
                                      _selectedCategory,
                                      _selectedStatus,
                                      _selectedPriority,
                                      _selectedTag1);
                                });
                              },
                            ),
                            Text('Include Completed Tasks',
                                style: _textStyleControls),
                          ],
                        ),
                      ),
//####################################end of Show completed

//####################################Show Focus Tasks Task Check box

                      Container(
                        margin: EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.blue[100],
                        ),
                        child: TextField(
                          readOnly: true,
                          style: _textStyleControls,
                          decoration: InputDecoration(
                            labelText: ' Focus Tasks Only ',
                            labelStyle: _textStyleControls,
                            hintText: '',
                            border: InputBorder.none,
                            prefixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  if (_includeIsStar == 1) {
                                    _includeIsStar = 0;
                                    Icon(Icons.lightbulb,
                                        color: Colors.black38);
                                  } else {
                                    _includeIsStar = 1;
                                    Icon(Icons.lightbulb,
                                        color: Colors.amber[800]);
                                  }
                                  searchData(
                                      _searchText,
                                      _searchDateDue,
                                      _includeIsStar,
                                      _includeIsDone,
                                      _selectedCategory,
                                      _selectedStatus,
                                      _selectedPriority,
                                      _selectedTag1);
                                });
                              },
                              child: Icon(Icons.lightbulb,
                                  color: (_includeIsStar == 0)
                                      ? Colors.black12
                                      : Colors.teal),
                            ),
                          ),
                        ),
                      ),

//#################################Category#####################################################
                      Container(
                        margin: EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(canvasColor: Colors.lime[100]),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String?>(
                                    isExpanded: true,
                                    items: _categories
                                        .map((CustomDropdownItem value) {
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
                                            _searchDateDue,
                                            _includeIsStar,
                                            _includeIsDone,
                                            _selectedCategory,
                                            _selectedStatus,
                                            _selectedPriority,
                                            _selectedTag1);
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),

//#################################Status#####################################################
                      Container(
                        margin: EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(canvasColor: Colors.lime[100]),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String?>(
                                    isExpanded: true,
                                    items: _statuses
                                        .map((CustomDropdownItem value) {
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
                                            _searchDateDue,
                                            _includeIsStar,
                                            _includeIsDone,
                                            _selectedCategory,
                                            _selectedStatus,
                                            _selectedPriority,
                                            _selectedTag1);
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),

//#################################Priority#####################################################
                      Container(
                        margin: EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(canvasColor: Colors.lime[100]),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String?>(
                                    isExpanded: true,
                                    items: _priorities
                                        .map((CustomDropdownItem value) {
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
                                            _searchDateDue,
                                            _includeIsStar,
                                            _includeIsDone,
                                            _selectedCategory,
                                            _selectedStatus,
                                            _selectedPriority,
                                            _selectedTag1);
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),

//################################# Tag #####################################################
                      Container(
                        margin: EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.blue[100]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(canvasColor: Colors.lime[100]),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String?>(
                                  isExpanded: true,
                                  items: _tag1s.map((CustomDropdownItem value) {
                                    return DropdownMenuItem<String>(
                                        value: value.id,
                                        child: Text(value.name!));
                                  }).toList(),
                                  style: _textStyleControls,
                                  value: _selectedTag1,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTag1 = value;
                                      searchData(
                                          _searchText,
                                          _searchDateDue,
                                          _includeIsStar,
                                          _includeIsDone,
                                          _selectedCategory,
                                          _selectedStatus,
                                          _selectedPriority,
                                          _selectedTag1);
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )),
          Expanded(
            child: Container(child: taskListItems()),
          ),
        ],
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.teal[800],
                  duration: Duration(seconds: 3),
                  content: Text("Task Completed", style: _textStyleSnack),
                ));
                searchData(
                    _searchText,
                    _searchDateDue,
                    _includeIsStar,
                    _includeIsDone,
                    _selectedCategory,
                    _selectedStatus,
                    _selectedPriority,
                    _selectedTag1);
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
                  elevation: 8,
                  child: ListTile(
                    visualDensity: VisualDensity(horizontal: -4),
                    leading: Checkbox(
                      checkColor: Colors.white,
                      value: (this.tasklist[position].isDone == 1),
                      onChanged: (value) {
                        setState(() {
                          _selectedIsDone = (value! == false) ? 0 : 1;
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.teal[800],
                            duration: Duration(seconds: 3),
                            content:
                                Text("Task Completed", style: _textStyleSnack),
                          ));
                          searchData(
                              _searchText,
                              _searchDateDue,
                              _includeIsStar,
                              _includeIsDone,
                              _selectedCategory,
                              _selectedStatus,
                              _selectedPriority,
                              _selectedTag1);
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
                          searchData(
                              _searchText,
                              _searchDateDue,
                              _includeIsStar,
                              _includeIsDone,
                              _selectedCategory,
                              _selectedStatus,
                              _selectedPriority,
                              _selectedTag1);
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
                    subtitle: Row(
                      children: [
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(
                                  this.tasklist[position].sec1!,
                                  style: _textStyleControlsSub,
                                ))),
                        SizedBox(width: 10),
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(
                                  this.tasklist[position].sec2!,
                                  style: _textStyleControlsSub,
                                ))),
                        SizedBox(width: 10),
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Text(
                                  this.tasklist[position].sec3!,
                                  style: _textStyleControlsSub,
                                ))),
                      ],
                    ),
                    isThreeLine: false,
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    onTap: () async {
                      await navigateToDetail(this.tasklist[position]);
                      searchData(
                          _searchText,
                          _searchDateDue,
                          _includeIsStar,
                          _includeIsDone,
                          _selectedCategory,
                          _selectedStatus,
                          _selectedPriority,
                          _selectedTag1);
                    },
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
      final tasksFuture = helper.searchTasks(
        getSortColumn(_sortField1!),
        getOrderColumn(_sortOrder1!),
        getSortColumn(_sortField2!),
        getOrderColumn(_sortOrder2!),
        getSortColumn(_sortField3!),
        getOrderColumn(_sortOrder3!),
        getSortColumn(_sortField4!),
        getOrderColumn(_sortOrder4!),
        _searchText,
        _searchText,
        globals.filterIsStar,
        globals.filterIsDone,
        globals.filterCategory.toString(),
        globals.filterStatus.toString(),
        globals.filterPriority.toString(),
        globals.filterTag.toString(),
      );
      tasksFuture.then((result) {
        List<Task> taskList = [];
        List<DisplayTask> displaytaskList = [];
        count = result.length;
        for (int i = 0; i < count; i++) {
          countDone = countDone + 1;
          taskList.add(Task.fromObject(result[i]));

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

  Future navigateToDetail(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetail(task)),
    );
//    getData();
  }

  void searchData(
      String? searchText,
      String? searchDateDue,
      int? showIsStar,
      int? includeIsDone,
      String? category,
      String? status,
      String? priority,
      String? tag1) {
    var countDone = 0;

    if (searchText?.trim() != "" || searchText?.trim() == "") {
      final dbFuture = helper.initializeDb();
      dbFuture.then((result) {
        final tasksFuture = helper.searchTasks(
          getSortColumn(_sortField1!),
          getOrderColumn(_sortOrder1!),
          getSortColumn(_sortField2!),
          getOrderColumn(_sortOrder2!),
          getSortColumn(_sortField3!),
          getOrderColumn(_sortOrder3!),
          getSortColumn(_sortField4!),
          getOrderColumn(_sortOrder4!),
          searchText!,
          searchDateDue!,
          _includeIsStar!,
          _includeIsDone!,
          category.toString(),
          status.toString(),
          priority.toString(),
          tag1.toString(),
        );
        tasksFuture.then((result) {
          List<Task> taskList = [];
          List<DisplayTask> displaytaskList = [];
          count = result.length;
          if (result.length == 0) {
            List<Task> taskList = [];
            List<DisplayTask> displaytaskList = [];
            count = 0;
            setState(() {
              tasklist = taskList;
              count = count;
            });
          }
          for (int i = 0; i < count; i++) {
            countDone = countDone + 1;
            taskList.add(Task.fromObject(result[i]));

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
              default:
                {
                  taskList[i].sec3 = taskList[i].categoryText;
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
    }
  }

  //to get the custom user settings.  this in home now,  but depends on login screen logic we can move this method. KK
  _getCustomSettings() async {
    var _customSetting = await helper.getCustomSettings();
    if (_customSetting.length > 0) {
      customSetting = CustomSettings.fromObject(_customSetting[0]);
      if (customSetting != null && customSetting!.id != null) {
//////////////////////
        /// SORT
//////////////////////
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

//////////////////////
        /// SHOW
//////////////////////
        if (customSetting!.showSec1 != "") {
          globals.showSec1 = int.parse(customSetting!.showSec1!);
        }
        if (customSetting!.showSec2 != "") {
          globals.showSec2 = int.parse(customSetting!.showSec2!);
        }
        if (customSetting!.showSec3 != "") {
          globals.showSec3 = int.parse(customSetting!.showSec3!);
        }

//////////////////////
        /// FOCUS, ISDONE
//////////////////////
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

//////////////////////
        /// DATE DUE
//////////////////////
        if (customSetting!.filterDateDue != "") {
          globals.filterDateDue = int.parse(customSetting!.filterDateDue!);
        }

//////////////////////
        /// FILTERS
//////////////////////
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
