import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/customSettings.dart';
import 'package:todo_app/model/goal1.dart';
import 'package:todo_app/model/location1.dart';
import 'package:todo_app/model/priority.dart';
import 'package:todo_app/model/status.dart';
import 'package:todo_app/model/tag1.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/model/action1.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/context1.dart';
import 'package:todo_app/model/todouser.dart';
import 'package:todo_app/model/globals.dart' as globals;
import 'package:todo_app/screens/taskdetail.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  String tblTodo = "todo";
  String colId = 'id';
  String colTask = 'task';
  String colNote = 'note';
  String colDateDue = 'dateDue';
  String colTimeDue = 'timeDue';
  String colStatus = 'status';
  String colPriority = 'priority';
  String colCategory = 'category';
  String colTag1 = 'tag1';
  String colIsStar = 'isStar';
  String colIsDone = 'isDone';
  String colDateDone = 'dateDone';
  String colLastModified = 'lastModified';

  String tblCustomSettings = "customSettings";
  String colsortField1 = "sortField1";
  String colsortOrder1 = "sortOrder1";
  String colsortField2 = "sortField2";
  String colsortOrder2 = "sortOrder2";
  String colsortField3 = "sortField3";
  String colsortOrder3 = "sortOrder3";
  String colsortField4 = "sortField4";
  String colsortOrder4 = "sortOrder4";
  String colshowMain1 = 'showMain1';
  String colshowMain2 = 'showMain2';
  String colshowSec1 = 'showSec1';
  String colshowSec2 = 'showSec2';
  String colshowSec3 = 'showSec3';
  String? colfilterDateDue = 'filterDateDue';
  String colfilterTimeDue = 'filterTimeDue';
  String colfilterCategory = 'filterCategory';
  String colfilterStatus = 'filterStatus';
  String colfilterPriority = 'filterPriority';
  String colfilterTag1 = 'filterTag';
  String colfilterIsStar = 'filterIsStar';
  String colfilterIsDone = 'filterIsDone';

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todo_V22.i4.db";
    var dbTodovn = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodovn;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTask TEXT, $colNote TEXT, " +
            "$colDateDue TEXT, $colTimeDue TEXT, " +
            "$colCategory TEXT, $colStatus TEXT, " +
            "$colPriority TEXT, $colTag1 TEXT, " +
            "$colIsStar INTEGER, $colIsDone INTEGER, $colDateDone TEXT, $colLastModified TEXT)");

    await db.execute(
        "CREATE TABLE $tblCustomSettings($colId INTEGER PRIMARY KEY, $colsortField1 TEXT, $colsortOrder1 TEXT, $colsortField2 TEXT, " +
            "$colsortOrder2 TEXT, $colsortField3 TEXT, $colsortOrder3 TEXT, $colsortField4 TEXT, $colsortOrder4 TEXT, " +
            "$colshowSec1 TEXT,$colshowSec2 TEXT,$colshowSec3 TEXT, " +
            "$colfilterDateDue TEXT, $colfilterTimeDue TEXT, " +
            "$colfilterCategory TEXT,  " +
            "$colfilterStatus TEXT, " +
            "$colfilterPriority TEXT, " +
            "$colfilterTag1 TEXT, " +
            "$colfilterIsStar INTEGER, $colfilterIsDone INTEGER)");

    // Create table categories
    await db.execute(
        "CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

    // Create table statuses
    await db.execute(
        "CREATE TABLE statuses(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

    // Create table priorities
    await db.execute(
        "CREATE TABLE priorities(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

    // Create table tags
    await db.execute(
        "CREATE TABLE tag1s(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

    // Create table USers
    await db.execute(
        "CREATE TABLE todouser(id INTEGER PRIMARY KEY, userid TEXT, email TEXT)");

    //call tis to default the values
    setDefaultDB(db);
  }

  Future<List> addCategorytemp() async {
    Database? db = await this.db;
    await db!.rawQuery(
        "INSERT INTO categories ( 'id', 'name', 'description')  values (10, 'xxxx', 'Bootstrap - please delete or rename if necessary')");
    var result = await db.rawQuery("SELECT * FROM categories");
    print(result);
    return result;
  }

  void setDefaultDB(Database db) async {
    //////
    //Create Default Values for Catergories
    //////
    await db.execute(
        "INSERT INTO categories ( 'name', 'description')  values (?, ?)",
        ['zen moment', 'Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO categories ( 'name', 'description')  values (?, ?)", [
      'lifelong learning',
      'Bootstrap - please delete or rename if necessary'
    ]);

    await db.execute(
        "INSERT INTO categories ( 'name', 'description')  values (?, ?)",
        ['connect', 'Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO categories ( 'name', 'description')  values (?, ?)",
        ['work', 'Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO categories ( 'name', 'description')  values (?, ?)",
        ['health', '2Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO categories ( 'name', 'description')  values (?, ?)",
        ['wealth', '2Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO categories ( 'name', 'description')  values (?, ?)",
        ['flow', '2Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO categories ( 'name', 'description')  values (?, ?)",
        ['outdoors', '2Bootstrap - please delete or rename if necessary']);

    //////
    //Create Default Values for statuses
    //////
    await db.execute(
        "INSERT INTO statuses ( 'name', 'description')  values (?, ?)",
        ['Next Action', '1Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO statuses ( 'name', 'description')  values (?, ?)",
        ['Someday', '2Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO statuses ( 'name', 'description')  values (?, ?)",
        ['Hold', '3Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO statuses ( 'name', 'description')  values (?, ?)",
        ['Waiting', '4Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO statuses ( 'name', 'description')  values (?, ?)",
        ['Delegated', '5Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO statuses ( 'name', 'description')  values (?, ?)",
        ['Reference', '6Bootstrap - please delete or rename if necessary']);

    //////
    //Create Default Values for priorities
    //////
    await db.execute(
        "INSERT INTO priorities ( 'name', 'description')  values (?, ?)",
        ['Low1', '1Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO priorities ( 'name', 'description')  values (?, ?)",
        ['Low2', '2Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO priorities ( 'name', 'description')  values (?, ?)",
        ['Medium1', '3Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO priorities ( 'name', 'description')  values (?, ?)",
        ['Medium2', '4Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO priorities ( 'name', 'description')  values (?, ?)",
        ['High1', '5Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO priorities ( 'name', 'description')  values (?, ?)",
        ['High2', '6Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO priorities ( 'name', 'description')  values (?, ?)",
        ['Top', '7Bootstrap - please delete or rename if necessary']);

    //////
    //Create Default Values for Tags
    //////
    await db.execute(
        "INSERT INTO tag1s ( 'name', 'description')  values (?, ?)",
        ['Family', '1Bootstrap - please delete or rename if necessary']);

    await db.execute(
        "INSERT INTO tag1s ( 'name', 'description')  values (?, ?)",
        ['Friend', '2Bootstrap - please delete or rename if necessary']);

    //Default value for Custom Setting
    CustomSettings customSetting = new CustomSettings(
      "8", // sort1 - star
      '1', // order1 - descending order
      '2', // sort2 - due date
      '0', // order2
      '3', // sort3 - due time
      '0', // order3
      '0', // sort4 - task
      '0', // order4
      '0', // sec1 - dateDue
      '1', // sec2 - dueTime
      '2', // sec3 - Category
      '0', // dateDue
      "", // category - set to null
      "", // status
      "", // priority
      "", // tag
      0, // isStar
      1, //isDone
    ); //
    var result = insertCustomSettings(customSetting);

    DateTime _dateDue = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedate = formatter.format(_dateDue);

    Task task = Task(
        "1.Welcome to todoMIT",
        '''
Greetings/ Nihao/ Hola/ Namaste/ Ayubowan,

We welcome you to our community. 

Our philosophy - do only what are the Most Important Tasks (MIT) - not everything

You keep your options open - be a traveller (unplanned), not a tourist (pre-planned)

We'd love to hear from you - what is the #1 feature you wish to have. Contact us at help@2half.online

Connect soon
    ''',
        formattedate, // dateDue
        '', // timeDue
        '', // category
        '', // status
        '', // priority
        '', // tag
        0, // isStar
        0, // isDone
        '', // dateDone
        '', // last modified
        '1', // sec1
        '3', // sec2
        '2'); // sec3
    insertTask(task);

    task = Task(
        "2.Navigation | Moving about ",
        '''
Top-Left (Drawer) | support, community, plans, logout 

Top-Right (Sync) | never lose data, sync your device to cloud 

Bottom-Left (Personalize) | filter, sort, view, picklists

Bottom middle (Add Task) | quick add or many hooks to remember  

Bottom-Right (Search) | keyword search or more powerful advance dropdown search 
''',
        formattedate, // dateDue
        '', // timeDue
        '', // category
        '', // status
        '', // priority
        '', // tag
        0, // isStar
        0, // isDone
        '', // dateDone
        '', // last modified
        '1', // sec1
        '3', // sec2
        '2'); // sec3
    insertTask(task);

    task = Task(
        "3.Practice | Baby Steps",
        '''
View | Check on left box (or swipe) to complete a task

Personalize | filters, order, view, picklists 

Search | using normal search or advanced search

Sync | never lose your data with backup in cloud

Contact us | share the good, bad, ugly 

    ''',
        formattedate, // dateDue
        '', // timeDue
        '', // category
        '', // status
        '', // priority
        '', // tag
        0, // isStar
        0, // isDone
        '', // dateDone
        '', // last modified
        '1', // sec1
        '3', // sec2
        '2'); // sec3
    insertTask(task);

    task = Task(
        "4.Subcription Plans",
        '''
First 30 days | free full features, is this tool for you?

Plan A - USD 4 | 1 month before you commit

Plan B - USD 15 | 6 month 

Plan C - USD 24 | 12 month  
        ''',
        formattedate, // dateDue
        '', // timeDue
        '', // category
        '', // status
        '', // priority
        '', // tag
        0, // isStar
        0, // isDone
        '', // dateDone
        '', // last modified
        '1', // sec1
        '3', // sec2
        '2'); // sec3
    insertTask(task);
  }

  Future<int> insertTask(Task task) async {
    Database? db = await this.db;

    var result = await db!.insert(tblTodo, task.toMap());
    print(result);
    return result;
  }

  Future<int> insertTaskClone(Task task) async {
    Database? db = await this.db;

    var result = await db!.insert(tblTodo, task.toMapNoID());
    print(result);
    return result;
  }

  Future<List> getTasksByID(String taskID) async {
    Database? db = await this.db;
    var result =
        await db!.rawQuery("SELECT * FROM todo where $colId = $taskID");
    return result;
  }

  Future<List> getAllTasks() async {
    Database? db = await this.db;
    var result = await db!.rawQuery("SELECT * FROM todo");
    return result;
  }

  Future<List> getTasksFromLastFewDays(int days) async {
    Database? db = await this.db;
    var result = await db!.rawQuery(
        "SELECT * FROM todo where (julianday(Date('now')) - julianday(date($colLastModified)) > 3)");

    return result;
  }

  Future<List> getTasks() async {
    Database? db = await this.db;
    var result = await db!.rawQuery(
        "SELECT * FROM $tblTodo where ($colIsDone != 1) order by $colCategory $colsortOrder1, $colDateDue ASC, $colTimeDue $colsortOrder2, $colTask $colsortOrder3");
    return result;
  }

////////////////////////////////
  ///
  /// MAIN SCREEN GET TASKS SORT
  ///
/////////////////////////////////

  Future<List> getTasksSort(
      String? colsortField1,
      String? colsortOrder1,
      String? colsortField2,
      String? colsortOrder2,
      String? colsortField3,
      String? colsortOrder3,
      String? colsortField4,
      String? colsortOrder4,
      String? colfilterDateDue,
      String? colfilterCategory,
      String? colfilterStatus,
      String? colfilterPriority,
      String? colfilterTag,
      int? colfilterIsStar,
      int? colfilterIsDone) async {
    Database? db = await this.db;

////////////////
/// build query
////////////////
    String queryStr = "";

    queryStr =
        "SELECT $tblTodo.id,$tblTodo.task, $tblTodo.note, dateDue,timeDue,   " +
            "category, status, priority, tag1, " +
            "isStar, isDone, dateDone, lastModified, " +
            "categories.name as categoriesname, " +
            "statuses.name as statusesname, " +
            "priorities.name as prioritiesname, " +
            "tag1s.name as tag1sname " +
            "FROM $tblTodo  " +
            " LEFT JOIN categories ON  $tblTodo.category = categories.id" +
            " LEFT JOIN statuses ON  $tblTodo.status = statuses.id" +
            " LEFT JOIN priorities ON  $tblTodo.priority = priorities.id" +
            " LEFT JOIN tag1s ON  $tblTodo.tag1 = tag1s.id";

////////////////
    /// build query - add filterIsDone
////////////////
    if (colfilterIsDone == 0 || colfilterIsDone == null) // show
    {
      queryStr = queryStr + " where ($colIsDone == $colIsDone)";
    } else
      queryStr = queryStr + " where ($colIsDone != 1)";

////////////////
    /// build query - add filterIsStar
////////////////
    if (colfilterIsStar == 0 || colfilterIsStar == null) // show
    {
//      queryStr = queryStr + " and ($colIsStar == $colIsStar)";
    } else
      queryStr = queryStr + " and ($colIsStar == '1')";

////////////////
    /// build query - add DateDue
////////////////

    String _startDate;
    String _endDate;

    final DateTime _today = DateTime.now();
    final DateTime _yesterday =
        DateTime(_today.year, _today.month, _today.day - 1);
    final DateTime _tomo = DateTime(_today.year, _today.month, _today.day + 1);
    final DateTime _N7D = DateTime(_today.year, _today.month, _today.day + 6);
    final DateTime _N30D = DateTime(_today.year, _today.month, _today.day + 29);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedToday = formatter.format(_today);
    final String formattedYesterday = formatter.format(_yesterday);
    final String formattedTomo = formatter.format(_tomo);
    final String formattedN7D = formatter.format(_N7D);
    final String formattedN30D = formatter.format(_N30D);

    if (colfilterDateDue == "Today") {
      _startDate = formattedToday;
      _endDate = formattedToday;
      queryStr = queryStr + " and ($colDateDue == '$_startDate')";
    } else if (colfilterDateDue == "Tomorrow") {
      _startDate = formattedTomo;
      _endDate = formattedTomo;
      queryStr = queryStr + " and ($colDateDue == '$_startDate')";
    } else if (colfilterDateDue == "Next 7 days") {
      _startDate = formattedToday;
      _endDate = formattedN7D;
      queryStr = queryStr +
          " and ($colDateDue >= '$_startDate') and ($colDateDue<= '$_endDate')";
    } else if (colfilterDateDue == "Next 30 days") {
      _startDate = formattedToday;
      _endDate = formattedN30D;
      queryStr = queryStr +
          " and ($colDateDue >= '$_startDate') and ($colDateDue<= '$_endDate')";
    } else if (colfilterDateDue == "Any Due Date") {
      queryStr = queryStr + " and ($colDateDue != '')";
    } else if (colfilterDateDue == "No Due Date") {
      queryStr = queryStr + " and ($colDateDue == '')";
    } else if (colfilterDateDue == "Overdues Only") {
      _endDate = formattedYesterday;
      queryStr = queryStr +
          " and ($colDateDue <= '$_endDate') and ($colDateDue != '')";
    } else if (colfilterDateDue == "Overdues and Today") {
      _endDate = formattedToday;
      queryStr = queryStr +
          " and ($colDateDue <= '$_endDate') and ($colDateDue != '')";
    } else if (colfilterDateDue == "Overdues, Today and Tomorrow") {
      _endDate = formattedTomo;
      queryStr = queryStr +
          " and ($colDateDue <= '$_endDate') and ($colDateDue != '')";
    } else if (colfilterDateDue == "All Tasks") {
    } else {
// select all tasks regardless of due dates
    }
    ;

////////////////
    /// build query - add category
////////////////
    if (colfilterCategory == "0" || colfilterCategory == "null") {
    } // hide
// include all
    else {
      queryStr = queryStr + " and ($colCategory == $colfilterCategory)";
    }

////////////////
    /// build query - add status
////////////////
    if (colfilterStatus == "0" || colfilterStatus == "null") {
    } // hide
// include all
    else {
      queryStr = queryStr + " and ($colStatus == $colfilterStatus)";
    }

////////////////
    /// build query - add priority
////////////////
    if (colfilterPriority == "0" || colfilterPriority == "null") {
    } // hide
    else {
      queryStr = queryStr + " and ($colPriority == $colfilterPriority)";
    }

////////////////
    /// build query - add tag
////////////////
    if (colfilterTag == "0" || colfilterTag == "null") {
    } else {
      queryStr = queryStr + " and ($colTag1 == $colfilterTag)";
    }

////////////////
    /// build query - add order by
////////////////
    queryStr = queryStr +
        " order by $colsortField1 $colsortOrder1, $colsortField2 $colsortOrder2, $colsortField3 $colsortOrder3, $colsortField4 $colsortOrder4";

    print(queryStr);
    var result = await db!.rawQuery(queryStr);
    return result;
  }

////////////////////////////////
  ///
  /// SEARCH SCREEN
  ///
/////////////////////////////////

  Future<List> searchTasks(
      String? colsortField1,
      String? colsortOrder1,
      String? colsortField2,
      String? colsortOrder2,
      String? colsortField3,
      String? colsortOrder3,
      String? colsortField4,
      String? colsortOrder4,
      String? searchText,
      String? searchCategory,
      String? searchStatus,
      String? searchPriority,
      String? searchTag1,
      int? includeIsStar,
      int? includeIsDone) async {
    Database? db = await this.db;

////////////////
    /// build query
////////////////
    String queryStr = "";

    queryStr =
        "SELECT $tblTodo.id,$tblTodo.task, $tblTodo.note, dateDue,timeDue,   " +
            "category, status, priority, tag1, " +
            "isStar, isDone, dateDone, lastModified, " +
            "categories.name as categoriesname, " +
            "statuses.name as statusesname, " +
            "priorities.name as prioritiesname, " +
            "tag1s.name as tag1sname " +
            " FROM $tblTodo  " +
            " LEFT JOIN categories ON  $tblTodo.category = categories.id" +
            " LEFT JOIN statuses ON  $tblTodo.status = statuses.id " +
            " LEFT JOIN priorities ON  $tblTodo.priority = priorities.id " +
            " LEFT JOIN tag1s ON  $tblTodo.tag1 = tag1s.id " +
            "WHERE ($colTask LIKE '%$searchText%' OR $colNote LIKE '%$searchText%' " +
            " OR categoriesname LIKE '%$searchText%' OR statusesname LIKE '%$searchText%' OR prioritiesname LIKE '%$searchText%' OR tag1sname LIKE '%$searchText%')";

////////////////
    /// build query - add filterIsDone
////////////////

    if (includeIsDone! == 1) {
      //queryStr = queryStr + " AND  $colIsDone = $includeIsDone";
    } else {
      queryStr = queryStr + " AND  $colIsDone = 0 ";
    }

////////////////
    /// build query - add filterIsStar
////////////////

    if (includeIsStar! == 0) {
      //queryStr = queryStr + " AND  $colIsDone = $includeIsDone";
    } else {
      queryStr = queryStr + " AND  $colIsStar = 1 ";
    }

////////////////
    /// build query - add category
////////////////

    if (searchCategory != "null") {
      queryStr = queryStr + " AND $colCategory = '$searchCategory' ";
    }

////////////////
    /// build query - add status
////////////////

    if (searchStatus != "null") {
      queryStr = queryStr + " AND $colStatus = '$searchStatus' ";
    }

////////////////
    /// build query - add priority
////////////////

    if (searchPriority != "null") {
      queryStr = queryStr + " AND $colPriority = '$searchPriority' ";
    }

////////////////
    /// build query - add tag
////////////////

    if (searchTag1 != "null") {
      queryStr = queryStr + " AND $colTag1 = '$searchTag1' ";
    }

////////////////
    /// build query - add order by
////////////////
    queryStr = queryStr +
        " order by $colsortField1 $colsortOrder1, $colsortField2 $colsortOrder2, $colsortField3 $colsortOrder3, $colsortField4 $colsortOrder4";

    print(queryStr);
    var result = await db!.rawQuery(queryStr);
    return result;
  }

  Future<int?> getCount() async {
    Database? db = await this.db;
    var result = Sqflite.firstIntValue(
        await db!.rawQuery('select count (*) from $tblTodo'));

    return result;
  }

  Future<int> updateTask(Task task) async {
    Database? db = await this.db;
    var result = await db!.update(tblTodo, task.toMap(),
        where: "$colId =?", whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM $tblTodo WHERE $colId = $id');
    return result;
  }

  Future<int> deleteAllTask() async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM $tblTodo WHERE $colId <> 0');
    return result;
  }

//////#########################Categories ##########################################

  Future<int> insertCategories(Category categories) async {
    Database? db = await this.db;

    var result = await db!.insert('categories', categories.categoryMap());
    return result;
  }

  Future<List> getCategories() async {
    Database? db = await this.db;
    var result = await db!.rawQuery("SELECT * FROM categories");

    return result;
  }

  Future<List> getCategoriesbyID(int categoriesId) async {
    Database? db = await this.db;
    var result =
        await db!.rawQuery("SELECT * FROM categories WHERE id=$categoriesId");
    return result;
  }

  Future<int> updateCategories(Category categories) async {
    Database? db = await this.db;
    var result = await db!.update("categories", categories.categoryMap(),
        where: "$colId =?", whereArgs: [categories.id]);
    return result;
  }

  Future<int> deleteCategoriesbyID(int id) async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM categories WHERE id = $id');
    return result;
  }

  Future<int> deleteAllCategories() async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM categories WHERE id <> 0');
    return result;
  }

//######################### ENd of Categories ##########################################
////######################### Statuses ##########################################

  Future<int> insertStatuses(Status statuses) async {
    Database? db = await this.db;

    var result = await db!.insert('statuses', statuses.statusMap());
    return result;
  }

  Future<List> getStatuses() async {
    Database? db = await this.db;
    var result = await db!.rawQuery("SELECT * FROM statuses");

    return result;
  }

  Future<List> getStatusesbyID(int statusesId) async {
    Database? db = await this.db;
    var result =
        await db!.rawQuery("SELECT * FROM statuses WHERE id=$statusesId");
    return result;
  }

  Future<int> updateStatuses(Status statuses) async {
    Database? db = await this.db;
    var result = await db!.update("statuses", statuses.statusMap(),
        where: "$colId =?", whereArgs: [statuses.id]);
    return result;
  }

  Future<int> deleteStatusesbyID(int id) async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM statuses WHERE id = $id');
    return result;
  }

  Future<int> deleteAllStatuses() async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM statuses WHERE id <> 0');
    return result;
  }

//######################### ENd of Statuses ##########################################

//######################### Priorities ##########################################

  Future<int> insertPriorities(Priority priorities) async {
    Database? db = await this.db;

    var result = await db!.insert('priorities', priorities.priorityMap());
    return result;
  }

  Future<List> getPriorities() async {
    Database? db = await this.db;
    var result = await db!.rawQuery("SELECT * FROM priorities");

    return result;
  }

  Future<List> getPrioritiesbyID(int prioritiesId) async {
    Database? db = await this.db;
    var result =
        await db!.rawQuery("SELECT * FROM priorities WHERE id=$prioritiesId");
    return result;
  }

  Future<int> updatePriorities(Priority priorities) async {
    Database? db = await this.db;
    var result = await db!.update("priorities", priorities.priorityMap(),
        where: "$colId =?", whereArgs: [priorities.id]);
    return result;
  }

  Future<int> deletePrioritiesbyID(int id) async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM priorities WHERE id = $id');
    return result;
  }

  Future<int> deleteAllPriorities() async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM priorities WHERE id <> 0');
    return result;
  }

//######################### ENd of Priorities ##########################################

//#########################Action ##########################################

  Future<int> insertAction1s(Action1 action1) async {
    Database? db = await this.db;

    var result = await db!.insert('action1s', action1.action1Map());
    return result;
  }

  Future<List> getAction1s() async {
    var result;
    try {
      Database? db = await this.db;
      result = await db!.query("action1s");
      result = await db.rawQuery("SELECT * FROM action1s");
      return result;
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<List> getAction1sbyID(int action1Id) async {
    Database? db = await this.db;
    var result =
        await db!.rawQuery("SELECT * FROM action1s WHERE id=$action1Id");
    return result;
  }

  Future<int> updateAction1s(Action1 action1) async {
    Database? db = await this.db;
    var result = await db!.update("action1s", action1.action1Map(),
        where: "$colId =?", whereArgs: [action1.id]);
    return result;
  }

  Future<int> deleteAction1s(int id) async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM action1s WHERE id = $id');
    return result;
  }

  Future<int> deleteAllAction1s() async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM action1s WHERE id <> 0');
    return result;
  }

//######################### ENd of Action ##########################################

//#########################Context ##########################################

  Future<int> insertContext1s(Context1 context1) async {
    Database? db = await this.db;

    var result = await db!.insert('context1s', context1.context1Map());
    return result;
  }

  Future<List> getContext1s() async {
    Database? db = await this.db;
    var result = await db!.rawQuery("SELECT * FROM context1s");
    return result;
  }

  Future<List> getContext1sbyID(int context1ID) async {
    Database? db = await this.db;
    var result =
        await db!.rawQuery("SELECT * FROM context1s WHERE id=$context1ID");
    return result;
  }

  Future<int> updateContext1s(Context1 context1) async {
    Database? db = await this.db;
    var result = await db!.update("context1s", context1.context1Map(),
        where: "$colId =?", whereArgs: [context1.id]);
    return result;
  }

  Future<int> deleteContext1sbyID(int id) async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM context1s WHERE id = $id');
    return result;
  }

  Future<int> deleteAllContext1s() async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM context1s WHERE id <> 0');
    return result;
  }

//######################### ENd of Contexts ##########################################

//#########################Locations ##########################################

  Future<int> insertLocation1s(Location1 location1s) async {
    Database? db = await this.db;

    var result = await db!.insert('location1s', location1s.location1Map());
    return result;
  }

  Future<List> getLocation1s() async {
    Database? db = await this.db;
    var result = await db!.rawQuery("SELECT * FROM location1s");
    return result;
  }

  Future<List> getLocation1sbyID(int location1s) async {
    Database? db = await this.db;
    var result =
        await db!.rawQuery("SELECT * FROM location1s WHERE id=$location1s");
    return result;
  }

  Future<int> updateLocation1s(Location1 location1s) async {
    Database? db = await this.db;
    var result = await db!.update("location1s", location1s.location1Map(),
        where: "$colId =?", whereArgs: [location1s.id]);
    return result;
  }

  Future<int> deleteLocation1sbyID(int id) async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM location1s WHERE id = $id');
    return result;
  }

  Future<int> deleteAllLocation1s() async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM location1s WHERE id <> 0');
    return result;
  }

//######################### ENd of locations ##########################################

//#########################Tag ##########################################

  Future<int> insertTag1s(Tag1 tag1s) async {
    Database? db = await this.db;

    var result = await db!.insert('tag1s', tag1s.tag1Map());
    return result;
  }

  Future<List> getTag1s() async {
    Database? db = await this.db;
    var result = await db!.rawQuery("SELECT * FROM tag1s");
    return result;
  }

  Future<List> getTag1sbyID(int tag1s) async {
    Database? db = await this.db;
    var result = await db!.rawQuery("SELECT * FROM tag1s WHERE id=$tag1s");
    return result;
  }

  Future<int> updateTag1s(Tag1 tag1s) async {
    Database? db = await this.db;
    var result = await db!.update("tag1s", tag1s.tag1Map(),
        where: "$colId =?", whereArgs: [tag1s.id]);
    return result;
  }

  Future<int> deleteTag1sbyID(int id) async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM tag1s WHERE id = $id');
    return result;
  }

  Future<int> deleteAllTag1s() async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM tag1s WHERE id <> 0');
    return result;
  }

//######################### ENd of Tag ##########################################

//######################### Goal ##########################################

  Future<int> insertGoal1s(Goal1 goal1s) async {
    Database? db = await this.db;

    var result = await db!.insert('goal1s', goal1s.goal1Map());
    return result;
  }

  Future<List> getGoal1s() async {
    Database? db = await this.db;
    var result = await db!.rawQuery("SELECT * FROM goal1s");
    return result;
  }

  Future<List> getGoal1sbyID(int goal1s) async {
    Database? db = await this.db;
    var result = await db!.rawQuery("SELECT * FROM goal1s WHERE id=$goal1s");
    return result;
  }

  Future<int> updateGoal1s(Goal1 goal1s) async {
    Database? db = await this.db;
    var result = await db!.update("goal1s", goal1s.goal1Map(),
        where: "$colId =?", whereArgs: [goal1s.id]);
    return result;
  }

  Future<int> deleteGoal1sbyID(int id) async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM goal1s WHERE id = $id');
    return result;
  }

  Future<int> deleteAllGoal1s() async {
    int result;
    Database? db = await this.db;
    result = await db!.rawDelete('DELETE FROM goal1s WHERE id <> 0');
    return result;
  }

//######################### ENd of Goal ##########################################/

  ///########################## Custom Settings #########################
  Future<int> insertCustomSettings(CustomSettings customSetting) async {
    Database? db = await this.db;

    var result = await db!.insert(tblCustomSettings, customSetting.toMap());
    return result;
  }

  Future<List> getCustomSettings() async {
    Database? db = await this.db;
    var result = await db!.rawQuery("SELECT * FROM $tblCustomSettings");

    return result;
  }

  Future<List> getCustomSettingsbyID(int customsettingsId) async {
    Database? db = await this.db;
    var result = await db!.rawQuery(
        "SELECT * FROM $tblCustomSettings WHERE id=$customsettingsId");
    return result;
  }

  Future<int> updateCustomSettings(CustomSettings customSetting) async {
    Database? db = await this.db;
    var result = await db!.update(tblCustomSettings, customSetting.toMap(),
        where: "$colId =?", whereArgs: [customSetting.id]);
    return result;
  }

//############################end of Custom Settings ###########################################3

//############################# User Table ##############################################

  Future<int> insertUser(todoUser todouser) async {
    Database? db = await this.db;

    var result = await db!.insert('todouser', todouser.todouserMap());
    return result;
  }

  Future<List> getUser() async {
    Database? db = await this.db;
    var result = await db!.rawQuery("SELECT * FROM todouser");
    return result;
  }

  Future getUserID() async {
    Database? db = await this.db;
    var result = await db!.rawQuery("SELECT userid FROM todouser");
    var userid = result[0]['userid'];
    return userid;
  }
}
