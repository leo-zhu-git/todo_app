import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/customSettings.dart';
import 'package:todo_app/model/goal1.dart';
import 'package:todo_app/model/location1.dart';
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
  String colTitle = 'title';
  String colDescription = 'description';
  String colCategory = 'category';
  String colAction1 = 'action1';
  String colContext1 = 'context1';
  String colLocation1 = 'location1';
  String colTag1 = 'tag1';
  String colGoal1 = 'goal1';
  String colPriorityint = 'priorityvalue';
  String colPrioritytxt = 'prioritytext';
  String colDateDue = 'dateDue';
  String colTimeDue = 'timeDue';
  String colIsDone = 'isDone';
  String colDateDone = 'dateDone';
  String colStatus = 'status';
  String colLastModified = 'lastModified';

  String tblCustomSettings = "customSettings";
  String colsortField1 = "sortField1";
  String colsortOrder1 = "sortOrder1";
  String colsortField2 = "sortField2";
  String colsortOrder2 = "sortOrder2";
  String colsortField3 = "sortField3";
  String colsortOrder3 = "sortOrder3";
  String colshowMain1 = 'showMain1';
  String colshowMain2 = 'showMain2';
  String colshowSec1 = 'showSec1';
  String colshowSec2 = 'showSec2';
  String colshowSec3 = 'showSec3';
  String colfilterIsDone = 'filterIsDone';
  String colfilterDateDue = 'filterDateDue';
  String colfilterCategory = 'filterCategory';
  String colfilterAction = 'filterAction';
  String colfilterContext = 'filterContext';
  String colfilterLocation = 'filterLocation';
  String colfilterTag = 'filterTag';

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todo_V18.d.db";
// <<<<<<< HEAD
//     print(path);
// =======
// >>>>>>> bd41ba8c11d876c998cc25b5140b747922b0dc9f
    var dbTodovn = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodovn;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colDescription TEXT, " +
            " $colCategory TEXT, $colAction1 TEXT, " +
            "$colContext1 TEXT, $colLocation1 TEXT, $colTag1 TEXT, $colGoal1 TEXT, " +
            " $colPriorityint INTEGER, $colPrioritytxt TEXT, $colDateDue TEXT, $colTimeDue TEXT, " +
            " $colIsDone INTEGER, $colDateDone TEXT, $colStatus TEXT, $colLastModified TEXT)");

//this table need to include hash key to track users.... i would say all the tables
    await db.execute(
        "CREATE TABLE $tblCustomSettings($colId INTEGER PRIMARY KEY, $colsortField1 TEXT, $colsortOrder1 TEXT, $colsortField2 TEXT, " +
            "$colsortOrder2 TEXT, $colsortField3 TEXT, $colsortOrder3 TEXT, $colshowMain1 TEXT,$colshowMain2 TEXT, " +
            "$colshowSec1 TEXT,$colshowSec2 TEXT,$colshowSec3 TEXT," +
            " $colfilterIsDone INTEGER, $colfilterDateDue TEXT, $colfilterCategory TEXT, $colfilterAction TEXT, $colfilterContext TEXT, $colfilterLocation TEXT, $colfilterTag TEXT)");

    // Create table categories
    await db.execute(
        "CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

    // Create table actions
    await db.execute(
        "CREATE TABLE action1s(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

    // Create table contexts
    await db.execute(
        "CREATE TABLE context1s(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

    // Create table locations
    await db.execute(
        "CREATE TABLE location1s(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

    // Create table tags
    await db.execute(
        "CREATE TABLE tag1s(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

    // Create table goals
    await db.execute(
        "CREATE TABLE goal1s(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

    // Create table USers
    await db.execute(
        "CREATE TABLE todouser(id INTEGER PRIMARY KEY, userid TEXT, email TEXT)");
  }

  Future<int> insertTask(Task task) async {
    Database db = await this.db;

    var result = await db.insert(tblTodo, task.toMap());
    print(result);
    return result;
  }

  Future<List> getTasksByID(String taskID) async {
    Database db = await this.db;
    var result = await db
//        .rawQuery("SELECT * FROM  where $colLastModified order by $colDateDue ASC");
        .rawQuery("SELECT * FROM todo where $colId = $taskID");
    return result;
  }

  Future<List> getAllTasks() async {
    Database db = await this.db;
    var result = await db
//        .rawQuery("SELECT * FROM  where $colLastModified order by $colDateDue ASC");
        .rawQuery("SELECT * FROM todo where $colId < 6");
    return result;
  }

  Future<List> getTasksFromLastFewDays(int days) async {
    Database db = await this.db;
    var result = await db
//        .rawQuery("SELECT * FROM  where $colLastModified order by $colDateDue ASC");
        .rawQuery(
            "SELECT * FROM todo where (julianday(Date('now')) - julianday(date($colLastModified)) > 3)");

    return result;
  }

  Future<List> getTasks() async {
    Database db = await this.db;
    var result = await db
//        .rawQuery("SELECT * FROM $tblTodo order by $colDateDue ASC");
        .rawQuery(
            "SELECT * FROM $tblTodo where ($colIsDone != 1) order by $colCategory $colsortOrder1, $colDateDue ASC, $colTimeDue $colsortOrder2, $colTitle $colsortOrder3");
    return result;
  }

  Future<List> getTasksSort(
      String colsortField1,
      String colsortOrder1,
      String colsortField2,
      String colsortOrder2,
      String colsortField3,
      String colsortOrder3,
      String colfilterDateDue,
      int colfilterIsDone) async {
////////////////
    /// build query 0
////////////////
    Database db = await this.db;

    String queryStr = "";
    queryStr = "SELECT $tblTodo.id,$tblTodo.title,$tblTodo.description,$tblTodo.category,action1,context1,location1,tag1,priorityvalue,prioritytext," +
        "dateDue,timeDue,isDone,dateDone,status,lastModified,categories.name as categoriesname, " +
        "action1s.name as action1name,context1s.name as context1name, location1s.name as location1name," +
        " tag1s.name as tag1name, goal1s.name as goal1name    FROM $tblTodo  " +
        " LEFT JOIN categories ON  $tblTodo.category = categories.id" +
        " LEFT JOIN action1s ON $tblTodo.action1 = action1s.id " +
        " LEFT JOIN context1s ON  $tblTodo.context1 = context1s.id" +
        " LEFT JOIN location1s ON  $tblTodo.location1 = location1s.id" +
        " LEFT JOIN tag1s ON  $tblTodo.tag1 = tag1s.id" +
        " LEFT JOIN goal1s ON  $tblTodo.goal1 = goal1s.id ";

////////////////
    /// build query - add filterIsDone
////////////////
    if (colfilterIsDone == 0) // hide
      queryStr = queryStr + "where ($colIsDone ==0)";
    else
      queryStr = queryStr + "where ($colIsDone not Null)";

////////////////
    /// build query - add filterDateDue
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
      queryStr = queryStr + "and ($colDateDue == '$_startDate')";
    } else if (colfilterDateDue == "Tomorrow") {
      _startDate = formattedTomo;
      _endDate = formattedTomo;
      queryStr = queryStr + "and ($colDateDue == '$_startDate')";
    } else if (colfilterDateDue == "Next 7 days") {
      _startDate = formattedToday;
      _endDate = formattedN7D;
      queryStr = queryStr +
          "and ($colDateDue >= '$_startDate') and ($colDateDue<= '$_endDate')";
    } else if (colfilterDateDue == "Next 30 days") {
      _startDate = formattedToday;
      _endDate = formattedN30D;
      queryStr = queryStr +
          "and ($colDateDue >= '$_startDate') and ($colDateDue<= '$_endDate')";
    } else if (colfilterDateDue == "Any Due Date") {
      queryStr = queryStr + "and ($colDateDue != '')";
    } else if (colfilterDateDue == "No Due Date") {
      queryStr = queryStr + "and ($colDateDue == '')";
    } else if (colfilterDateDue == "Overdues Only") {
      _endDate = formattedYesterday;
      queryStr =
          queryStr + "and ($colDateDue <= '$_endDate') and ($colDateDue != '')";
    } else if (colfilterDateDue == "All Tasks") {
    } else {
// select all tasks regardless of due dates
    }
    ;

////////////////
    /// build query - add order
////////////////
    /// queryStr = queryStr +
    " order by $colsortField1 $colsortOrder1, $colsortField2 $colsortOrder2, $colsortField3 $colsortOrder3";

    print(queryStr);
    var result = await db.rawQuery(queryStr);
    return result;
//    if (colfilterIsDone == 1) {
//      var result = await db.rawQuery(// show IsDone
//          "SELECT * FROM $tblTodo where ($colIsDone not NULL) order by $colsortField1 $colsortOrder1, $colsortField2 $colsortOrder2, $colsortField3 $colsortOrder3");
//      return result;
//    } else {
//      // hide IsDone
//      var result = await db.rawQuery(
//          "SELECT * FROM $tblTodo where ($colIsDone == 0 and $colDateDue >= '$_startDate') order by $colsortField1 $colsortOrder1, $colsortField2 $colsortOrder2, $colsortField3 $colsortOrder3");
//          "SELECT * FROM $tblTodo where ($colIsDone == 0 and $colDateDue >= '$_startDate' and $colDateDue <= '$_endDate') order by $colsortField1 $colsortOrder1, $colsortField2 $colsortOrder2, $colsortField3 $colsortOrder3");
//          "SELECT * FROM $tblTodo where ($colIsDone == 0) order by $colsortField1 $colsortOrder1, $colsortField2 $colsortOrder2, $colsortField3 $colsortOrder3");
//      return result;
  }

//  Future<List> searchTasks(String searchText, String searchPriorityTxt, String searchCategory, String searchAction1,
//   String searchContext1,String searchLocation1, String searchTag1, String  searchGoal1) async{
  Future<List> searchTasks(
      String searchText,
      String searchCategory,
      String searchAction1,
      String searchContext1,
      String searchLocation1,
      String searchTag1) async {
    Database db = await this.db;

    String queryStr = "";
    queryStr =
        "SELECT * FROM $tblTodo WHERE ($colTitle LIKE '%$searchText%' OR $colDescription LIKE '%$searchText%') ";

    // queryStr = queryStr + " AND $colIsDone = 0";//  if (searchPriorityTxt.trim() != "")
//  {
//    queryStr = queryStr + " AND $colPrioritytxt = '$searchPriorityTxt'";
//  }

    if (searchCategory != null) {
      queryStr =
          queryStr + " AND $colCategory = '$searchCategory' AND $colIsDone = 0";
    }
    if (searchAction1 != null) {
      queryStr =
          queryStr + " AND $colAction1 = '$searchAction1' AND $colIsDone = 0";
    }
    if (searchContext1 != null) {
      queryStr =
          queryStr + " AND $colContext1 = '$searchContext1' AND $colIsDone = 0";
    }
    if (searchLocation1 != null) {
      queryStr = queryStr +
          " AND $colLocation1 = '$searchLocation1' AND $colIsDone = 0";
    }
    if (searchTag1 != null) {
      queryStr = queryStr + " AND $colTag1 = '$searchTag1' AND $colIsDone = 0";
    }
//  if (searchGoal1.trim() != "")
//  {
//    queryStr = queryStr + " AND $colGoal1 = '$searchGoal1'";
//  }

    print(queryStr);
    var result = await db.rawQuery(queryStr);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery('select count (*) from $tblTodo'));

    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    var result = await db.update(tblTodo, task.toMap(),
        where: "$colId =?", whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblTodo WHERE $colId = $id');
    return result;
  }

  Future<int> deleteAllTask() async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblTodo WHERE $colId <> 0');
    return result;
  }

//#########################Action ##########################################

  Future<int> insertAction(Action1 action1) async {
    Database db = await this.db;

    var result = await db.insert('action1s', action1.action1Map());
    return result;
  }

  Future<List> getActions() async {
    var result;
    try {
      Database db = await this.db;
      result = await db.query("action1s");
      // result =
      //  await db.rawQuery("SELECT * FROM action1s");
      return result;
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<List> getActionbyID(int action1Id) async {
    Database db = await this.db;
    var result =
        await db.rawQuery("SELECT * FROM action1s WHERE id=$action1Id");
    return result;
  }

  Future<int> updateAction(Action1 action1) async {
    Database db = await this.db;
    var result = await db.update("action1s", action1.action1Map(),
        where: "$colId =?", whereArgs: [action1.id]);
    return result;
  }

  Future<int> deleteAction(int id) async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM action1s WHERE id = $id');
    return result;
  }

//######################### ENd of Action ##########################################

//#########################Categories ##########################################

  Future<int> insertCategories(Category categories) async {
    Database db = await this.db;

    var result = await db.insert('categories', categories.categoryMap());
    return result;
  }

  Future<List> getCategories() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM categories");

    return result;
  }

  Future<List> getCategoriesbyID(int categoriesId) async {
    Database db = await this.db;
    var result =
        await db.rawQuery("SELECT * FROM categories WHERE id=$categoriesId");
    return result;
  }

  Future<int> updateCategories(Category categories) async {
    Database db = await this.db;
    var result = await db.update("categories", categories.categoryMap(),
        where: "$colId =?", whereArgs: [categories.id]);
    return result;
  }

  Future<int> deleteCategoriesbyID(int id) async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM categories WHERE id = $id');
    return result;
  }

  Future<int> deleteAllCategories() async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM categories WHERE id <> 0');
    return result;
  }

//######################### ENd of Categories ##########################################

//#########################Context ##########################################

  Future<int> insertContexts(Context1 context1) async {
    Database db = await this.db;

    var result = await db.insert('context1s', context1.context1Map());
    return result;
  }

  Future<List> getContexts() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM context1s");
    return result;
  }

  Future<List> getContextbyID(int context1ID) async {
    Database db = await this.db;
    var result =
        await db.rawQuery("SELECT * FROM context1s WHERE id=$context1ID");
    return result;
  }

  Future<int> updateContext(Context1 context1) async {
    Database db = await this.db;
    var result = await db.update("context1s", context1.context1Map(),
        where: "$colId =?", whereArgs: [context1.id]);
    return result;
  }

  Future<int> deleteContextbyID(int id) async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM context1s WHERE id = $id');
    return result;
  }

  Future<int> deleteAllContext() async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM context1s WHERE id <> 0');
    return result;
  }

//######################### ENd of Contexts ##########################################

//#########################Goal ##########################################

  Future<int> insertGoals(Goal1 goal1s) async {
    Database db = await this.db;

    var result = await db.insert('goal1s', goal1s.goal1Map());
    return result;
  }

  Future<List> getGoals() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM goal1s");
    return result;
  }

  Future<List> getGoalsbyID(int goal1Id) async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM goal1s WHERE id=$goal1Id");
    return result;
  }

  Future<int> updateGoal(Goal1 goal1s) async {
    Database db = await this.db;
    var result = await db.update("goal1s", goal1s.goal1Map(),
        where: "$colId =?", whereArgs: [goal1s.id]);
    return result;
  }

  Future<int> deleteGoalbyID(int id) async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM goal1s WHERE id = $id');
    return result;
  }

//######################### ENd of Goal ##########################################

//#########################Locations ##########################################

  Future<int> insertLocations(Location1 location1s) async {
    Database db = await this.db;

    var result = await db.insert('location1s', location1s.location1Map());
    return result;
  }

  Future<List> getLocations() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM location1s");
    return result;
  }

  Future<List> getLocationsbyID(int location1s) async {
    Database db = await this.db;
    var result =
        await db.rawQuery("SELECT * FROM location1s WHERE id=$location1s");
    return result;
  }

  Future<int> updateLocations(Location1 location1s) async {
    Database db = await this.db;
    var result = await db.update("location1s", location1s.location1Map(),
        where: "$colId =?", whereArgs: [location1s.id]);
    return result;
  }

  Future<int> deleteLocationsbyID(int id) async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM location1s WHERE id = $id');
    return result;
  }

//######################### ENd of locations ##########################################

//#########################Tag ##########################################

  Future<int> insertTags(Tag1 tag1s) async {
    Database db = await this.db;

    var result = await db.insert('tag1s', tag1s.tag1Map());
    return result;
  }

  Future<List> getTags() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM tag1s");
    return result;
  }

  Future<List> getTagsbyID(int tag1s) async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM tag1s WHERE id=$tag1s");
    return result;
  }

  Future<int> updateTags(Tag1 tag1s) async {
    Database db = await this.db;
    var result = await db.update("tag1s", tag1s.tag1Map(),
        where: "$colId =?", whereArgs: [tag1s.id]);
    return result;
  }

  Future<int> deleteTagbyID(int id) async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM tag1s WHERE id = $id');
    return result;
  }

  Future<int> deleteAllTags() async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM tag1s WHERE id <> 0');
    return result;
  }

//######################### ENd of Tag ##########################################

//########################## Custom Settings #########################
  Future<int> insertCustomSettings(CustomSettings customSetting) async {
    Database db = await this.db;

    var result = await db.insert(tblCustomSettings, customSetting.toMap());
    return result;
  }

  Future<List> getCustomSettings() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblCustomSettings");

    return result;
  }

  Future<List> getCustomSettingsbyID(int customsettingsId) async {
    Database db = await this.db;
    var result = await db.rawQuery(
        "SELECT * FROM $tblCustomSettings WHERE id=$customsettingsId");
    return result;
  }

  Future<int> updateCustomSettings(CustomSettings customSetting) async {
    Database db = await this.db;
    var result = await db.update(tblCustomSettings, customSetting.toMap(),
        where: "$colId =?", whereArgs: [customSetting.id]);
    return result;
  }

//############################end of Custom Settings ###########################################3

//############################# User Table ##############################################

  Future<int> insertUser(todoUser todouser) async {
    Database db = await this.db;

    var result = await db.insert('todouser', todouser.todouserMap());
    return result;
  }

  Future<List> getUser() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM todouser");
    return result;
  }

  Future<String> getUserID() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT userid FROM todouser");
    var userid = result[0]['userid'];
    return userid;
  }
}
