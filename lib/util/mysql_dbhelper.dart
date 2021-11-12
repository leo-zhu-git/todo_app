import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/status.dart';
import 'package:todo_app/model/priority.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/action1.dart';
import 'package:todo_app/model/context1.dart';
import 'package:todo_app/model/location1.dart';
import 'package:todo_app/model/tag1.dart';
import 'package:todo_app/model/goal1.dart';

import 'package:todo_app/util/dbhelper.dart';
import '../service/http_service.dart';
import 'dart:convert';
import 'package:todo_app/model/taskclass.dart';

DateTime currentDate = DateTime.now();
DateFormat formatter = DateFormat('dd-MMM-yyyy');
String formattedDate = DateFormat('dd-MMM-yyyy').format(currentDate);

class MySql_DBHelper {
  int count = 0;
  static late Database _db;
  DbHelper helper = DbHelper();

  static final MySql_DBHelper _mySql_DBHelper = MySql_DBHelper._internal();

  MySql_DBHelper._internal();

  factory MySql_DBHelper() {
    return _mySql_DBHelper;
  }

  Future<Database> get db async {
    if (_db == null) {
      _db = await helper.initializeDb();
    }
    return _db;
  }

  void wipeTaskDataFromMySql() async {
    final tasksRequest = request('getAllTasks', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      List<Map> swiperDataList = (data['Tasks'] as List).cast();
      helper.deleteAllTask();
      var taskCount = helper.getCount();
      var count = swiperDataList.length;
      print("TaskCount:::::: $count");

      for (int i = 0; i < swiperDataList.length; i++) {
        String dbTaskID = swiperDataList[i]['TaskID'].toString();
        String dbUserID = swiperDataList[i]['TaskUserId'].toString();
        String appTaskID = dbTaskID.substring(dbUserID.length, dbTaskID.length);

        var appCategoryID = "";
        if (swiperDataList[i]['TaskCategory'] != "" &&
            swiperDataList[i]['TaskCategory'] != null) {
          String dbCategoryID = swiperDataList[i]['TaskCategory'];
          appCategoryID = dbTaskID.substring(dbUserID.length);
        }

        var appContextID = "";
        if (swiperDataList[i]['TaskContext'] != "" &&
            swiperDataList[i]['TaskContext'] != null) {
          String dbContextID = swiperDataList[i]['TaskContext'].toString();
          appContextID =
              dbContextID.substring(dbUserID.length, dbContextID.length);
        }

        var appActionID = "";
        if (swiperDataList[i]['TaskAction'] != "" &&
            swiperDataList[i]['TaskAction'] != null) {
          String dbActionID = swiperDataList[i]['TaskAction'].toString();
          appActionID =
              dbActionID.substring(dbUserID.length, dbActionID.length);
        }
        var appLocationID = "";
        if (swiperDataList[i]['TaskLocation'] != "" &&
            swiperDataList[i]['TaskLocation'] != null) {
          String dbLocationID = swiperDataList[i]['TaskLocation'].toString();
          appLocationID =
              dbLocationID.substring(dbUserID.length, dbLocationID.length);
        }

        var appTagID = "";
        if (swiperDataList[i]['TaskTag'] != "" &&
            swiperDataList[i]['TaskTag'] != null) {
          String dbTagID = swiperDataList[i]['TaskTag'].toString();
          appTagID = dbTagID.substring(dbUserID.length, dbTagID.length);
        }

        var appGoalID = "";
        if (swiperDataList[i]['TaskGoal'] != "" &&
            swiperDataList[i]['TaskGoal'] != null) {
          String dbGoalID = swiperDataList[i]['TaskGoal'].toString();
          appGoalID = dbGoalID.substring(dbUserID.length, dbGoalID.length);
        }

        var appPriorityID = "";
        if (swiperDataList[i]['TaskPriority'] != "" &&
            swiperDataList[i]['TaskPriority'] != null) {
          String dbPriorityID = swiperDataList[i]['TaskPriority'].toString();
          appPriorityID =
              dbPriorityID.substring(dbUserID.length, dbPriorityID.length);
        }

        var appStatusID = "4";
        if (swiperDataList[i]['TaskStatus'] != "" &&
            swiperDataList[i]['TaskStatus'] != null) {
          String dbStatusID = swiperDataList[i]['TaskStatus'].toString();
          appStatusID =
              dbStatusID.substring(dbUserID.length, dbStatusID.length);
        }

        Task task = Task.withId(
            int.parse(appTaskID),
            swiperDataList[i]['TaskTask'],
            swiperDataList[i]['TaskNote'],
            swiperDataList[i]['TaskDateDue'],
            swiperDataList[i]['TaskTimeDue'],
            appCategoryID,
            appStatusID,
            appPriorityID,
            appTagID,
//            appActionID,
//            appContextID,
//            appLocationID,
//            appGoalID,
            0,
            //int.parse(swiperDataList[i]['TaskStar']),
            int.parse(swiperDataList[i]['TaskIsDone']),
            swiperDataList[i]['TaskDateDone'],
            swiperDataList[i]['LastModified'],
            "",
            "",
//            "",
//            "",
            "");
        print("TaskID" + appTaskID);
        print("IIII::" + i.toString());

        if (i == 190 || i == 191) {
          print("stop");
        }
        // print("CategoryID::::::::" + swiperDataList[i]['TaskCategory']);
        // print("ContextID::::::::" + swiperDataList[i]['TaskContext']);
        // print("TagID::::::::" + swiperDataList[i]['TaskTag']);

        helper.insertTask(task);

        // final tasksFuture = helper.getTasksByID(appTaskID);
        // tasksFuture.then((result) {
        //   count = result.length;

        // if (count > 0) {
        //   helper.updateTask(task);
        //   //helper.deleteTask(swiperDataList[i]['TaskID']);
        // } else {
        //   helper.insertTask(task);
        //   //helper.deleteTask(swiperDataList[i]['TaskID']);
        // }
        // });
      }
    });
  }

  void syncTaskDataFromMySqlLastSevenDays() async {
    final tasksRequest = request('getLastSevenDaystasks', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      List<Map> swiperDataList = (data['Tasks'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        String dbTaskID = swiperDataList[i]['TaskID'].toString();
        String dbUserID = swiperDataList[i]['TaskUserId'].toString();
        String appTaskID = dbTaskID.substring(dbUserID.length, dbTaskID.length);
        // print(appTaskID);
        // print("woaibeijingtiananmen");
        Task task = Task.withId(
            int.parse(appTaskID),
            swiperDataList[i]['TaskTask'],
            swiperDataList[i]['TaskNote'],
            swiperDataList[i]['TaskDateDue'],
            swiperDataList[i]['TaskTimeDue'],
            swiperDataList[i]['TaskCategory'],
            swiperDataList[i]['TaskStatus'],
            swiperDataList[i]['TaskPriority'],
            swiperDataList[i]['TaskTag'],
//            swiperDataList[i]['TaskAction'],
//            swiperDataList[i]['TaskContext'],
//            swiperDataList[i]['TaskLocation'],
//            swiperDataList[i]['TaskGoal'],
            int.parse(swiperDataList[i]['TaskIsStar']),
            int.parse(swiperDataList[i]['TaskIsDone']),
            swiperDataList[i]['TaskDateDone'],
            swiperDataList[i]['LastModified'],
//            "",
//            "",
            "",
            "",
            "");
        final tasksFuture = helper.getTasksByID(appTaskID);
        tasksFuture.then((result) {
          count = result.length;

          if (count > 0) {
            helper.updateTask(task);
            //helper.deleteTask(swiperDataList[i]['TaskID']);
          } else {
            helper.insertTask(task);
            //helper.deleteTask(swiperDataList[i]['TaskID']);
          }
        });
      }
    });
  }

///////////////////////////
  /// sync statuses
///////////////////////////
  void syncStatusesData() async {
    helper.deleteAllStatuses();
    final tasksRequest = request('statusContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['Status'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        Status status = new Status();
        String dbId = swiperDataList[i]['id'].toString();
        String dbUserID = swiperDataList[i]['userId'].toString();
        String appId = dbId.substring(dbUserID.length, dbId.length);
        status.id = int.parse(appId);
        status.name = swiperDataList[i]['name'];
        status.description = swiperDataList[i]['desc'];

        final statusFuture = helper.getStatusesbyID(int.parse(appId));
        statusFuture.then((result) {
          count = result.length;
          //for (int i = 0; i < count; i++) {
          //helper.deleteAction(i);
          //}
          if (count > 0) {
            helper.updateStatuses(status);
            //helper.deleteAction(swiperDataList[i]['TaskID']);
          } else {
            helper.insertStatuses(status);
            // helper.deleteAction(swiperDataList[i]['TaskID']);
          }
        });
      }
    });
  }

///////////////////////////
  /// sync priorities
///////////////////////////
  void syncPrioritiesData() async {
    helper.deleteAllPriorities();
    final tasksRequest = request('priorityContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['Priority'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        Priority priority = new Priority();
        String dbId = swiperDataList[i]['id'].toString();
        String dbUserID = swiperDataList[i]['userId'].toString();
        String appId = dbId.substring(dbUserID.length, dbId.length);
        priority.id = int.parse(appId);
        priority.name = swiperDataList[i]['name'];
        priority.description = swiperDataList[i]['desc'];

        final priorityFuture = helper.getPrioritiesbyID(int.parse(appId));
        priorityFuture.then((result) {
          count = result.length;
          //for (int i = 0; i < count; i++) {
          //helper.deleteAction(i);
          //}
          if (count > 0) {
            helper.updatePriorities(priority);
            //helper.deleteAction(swiperDataList[i]['TaskID']);
          } else {
            helper.insertPriorities(priority);
            // helper.deleteAction(swiperDataList[i]['TaskID']);
          }
        });
      }
    });
  }

///////////////////////////
  /// sync categories
///////////////////////////

  void syncCategoriesData() async {
    helper.deleteAllCategories();
    final tasksRequest = request('categoriesContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['Categories'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        Category action = new Category();
        String dbId = swiperDataList[i]['id'].toString();
        String dbUserID = swiperDataList[i]['userId'].toString();
        String appId = dbId.substring(dbUserID.length, dbId.length);
        action.id = int.parse(appId);
        action.name = swiperDataList[i]['name'];
        action.description = swiperDataList[i]['desc'];

        final actionFuture = helper.getCategoriesbyID(int.parse(appId));
        actionFuture.then((result) {
          count = result.length;
          //for (int i = 0; i < count; i++) {
          //helper.deleteAction(i);
          //}
          if (count > 0) {
            helper.updateCategories(action);
            //helper.deleteAction(swiperDataList[i]['TaskID']);
          } else {
            helper.insertCategories(action);
            // helper.deleteAction(swiperDataList[i]['TaskID']);
          }
        });
      }
    });
  }

///////////////////////////
  /// sync actions
///////////////////////////
  void syncAction1sData() async {
    helper.deleteAllAction1s();
    final tasksRequest = request('actionContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['Actions'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        Action1 action = new Action1();
        String dbId = swiperDataList[i]['id'].toString();
        String dbUserID = swiperDataList[i]['userId'].toString();
        String appId = dbId.substring(dbUserID.length, dbId.length);
        action.id = int.parse(appId);
        action.name = swiperDataList[i]['name'];
        action.description = swiperDataList[i]['desc'];

        final actionFuture = helper.getAction1sbyID(int.parse(appId));
        actionFuture.then((result) {
          count = result.length;
          //for (int i = 0; i < count; i++) {
          //helper.deleteAction(i);
          //}
          if (count > 0) {
            helper.updateAction1s(action);
            //helper.deleteAction(swiperDataList[i]['TaskID']);
          } else {
            helper.insertAction1s(action);
            // helper.deleteAction(swiperDataList[i]['TaskID']);
          }
        });
      }
    });
  }

///////////////////////////
  /// sync contexts
///////////////////////////

  void syncContext1sData() async {
    // helper.deleteAllContext1s();
    final tasksRequest = request('contextContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['Contexts'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        Context1 action = new Context1();
        String dbId = swiperDataList[i]['id'].toString();
        String dbUserID = swiperDataList[i]['userId'].toString();
        String appId = dbId.substring(dbUserID.length, dbId.length);
        action.id = int.parse(appId);
        action.name = swiperDataList[i]['name'];
        action.description = swiperDataList[i]['desc'];

        print(swiperDataList[i]['name']);
        //helper.deleteTask(swiperDataList[i]['TaskID']);
        final actionFuture = helper.getContext1sbyID(int.parse(appId));
        actionFuture.then((result) {
          count = result.length;

          if (count > 0) {
            //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
            helper.updateContext1s(action);
          } else {
            helper.insertContext1s(action);
            //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
          }
        });
      }
    });
  }

///////////////////////////
  /// sync locations
///////////////////////////
  void syncLocation1sData() async {
    helper.deleteAllLocation1s();
    final tasksRequest = request('locationContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['Locations'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        Location1 action = new Location1();
        String dbId = swiperDataList[i]['id'].toString();
        String dbUserID = swiperDataList[i]['userId'].toString();
        String appId = dbId.substring(dbUserID.length, dbId.length);
        action.id = int.parse(appId);
        action.name = swiperDataList[i]['name'];
        action.description = swiperDataList[i]['desc'];

        print(swiperDataList[i]['name']);
        //helper.deleteTask(swiperDataList[i]['TaskID']);
        final actionFuture = helper.getLocation1sbyID(int.parse(appId));
        actionFuture.then((result) {
          count = result.length;

          if (count > 0) {
            //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
            helper.updateLocation1s(action);
          } else {
            helper.insertLocation1s(action);
            //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
          }
        });
      }
    });
  }

///////////////////////////
  /// sync tags
///////////////////////////
  void syncTag1sData() async {
    helper.deleteAllTag1s();
    final tasksRequest = request('tagContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['Tags'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        Tag1 action = new Tag1();
        String dbId = swiperDataList[i]['id'].toString();
        String dbUserID = swiperDataList[i]['userId'].toString();
        String appId = dbId.substring(dbUserID.length, dbId.length);
        action.id = int.parse(appId);
        action.name = swiperDataList[i]['name'];
        action.description = swiperDataList[i]['desc'];

        print(swiperDataList[i]['name']);
        //helper.deleteTask(swiperDataList[i]['TaskID']);
        final actionFuture = helper.getTag1sbyID(int.parse(appId));
        actionFuture.then((result) {
          count = result.length;

          if (count > 0) {
            //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
            helper.updateTag1s(action);
          } else {
            helper.insertTag1s(action);
            //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
          }
        });
      }
    });
  }

///////////////////////////
  /// sync goals
///////////////////////////
  void syncGoal1sData() async {
    helper.deleteAllGoal1s();
    final tasksRequest = request('goalContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['Goals'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        Goal1 goal = new Goal1();
        String dbId = swiperDataList[i]['id'].toString();
        String dbUserID = swiperDataList[i]['userId'].toString();
        String appId = dbId.substring(dbUserID.length, dbId.length);
        goal.id = int.parse(appId);
        goal.name = swiperDataList[i]['name'];
        goal.description = swiperDataList[i]['desc'];

        print(swiperDataList[i]['name']);
        //helper.deleteTask(swiperDataList[i]['TaskID']);
        final goalFuture = helper.getGoal1sbyID(int.parse(appId));
        goalFuture.then((result) {
          count = result.length;

          if (count > 0) {
            //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
            helper.updateGoal1s(goal);
          } else {
            helper.insertGoal1s(goal);
            //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
          }
        });
      }
    });
  }

  void wipeTaskDataToMySql() {
    // this.deleteAllTaskFromMySQL();
    final dbTaskFuture = helper.getAllTasks();

    var taskList = [];
    var tasks = {};
    dbTaskFuture.then((result) {
      print(result.length);

      for (int i = 0; i < result.length; i++) {
        print(result[i]);
        var task = "";
        var note = "";
        var dateDue = "";
        var timeDue = "";
        var category = "";
        var status = "";
        var priority = "";
        var tag1 = "";
        // var action1 = "";
        // var context1 = "";
        // var location1 = "";
        // var goal1 = "";
        var isStar = "";
        var isDone = "";
        var lastModified = "";
        var dateDone = "";

        if (result[i]["task"] != null) {
          task = result[i]["task"];
        }
        if (result[i]["note"] != null) {
          note = result[i]["note"];
        }
        if (result[i]["dateDue"] != null) {
          dateDue = result[i]["dateDue"].toString();
        }
        if (result[i]["timeDue"] != null) {
          timeDue = result[i]["timeDue"];
        }
        if (result[i]["category"] != null) {
          category = result[i]["category"].toString();
        }
        if (result[i]["status"] != null) {
          status = result[i]["status"].toString();
        }
        if (result[i]["priority"] != null) {
          priority = result[i]["priority"].toString();
        }
        if (result[i]["tag1"] != null) {
          tag1 = result[i]["tag1"].toString();
        }
        // if (result[i]["action1"] != null) {
        //   action1 = result[i]["action1"];
        // }
        // if (result[i]["context1"] != null) {
        //   context1 = result[i]["context1"].toString();
        // }
        // if (result[i]["location1"] != null) {
        //   location1 = result[i]["location1"].toString();
        // }
        // if (result[i]["goal1"] != null) {
        //   goal1 = result[i]["goal1"].toString();
        // }
        if (result[i]["isStar"] != null) {
          isStar = result[i]["isStar"].toString();
        }
        if (result[i]["isDone"] != null) {
          isDone = result[i]["isDone"].toString();
        }
        if (result[i]["dateDone"] != null) {
          dateDone = result[i]["dateDone"].toString();
        }
        if (result[i]["timeDue"] != null) {
          timeDue = result[i]["timeDue"].toString();
        }
        // if (result[i]["goal1"] != null) {
        //   goal1 = result[i]["goal1"].toString();
        // }
        if (result[i]["location1"] != null) {
          timeDue = result[i]["location1"].toString();
        }

        if (result[i]["lastModified"] != null) {
          lastModified = result[i]["lastModified"].toString();
        }

        String taskTask = '{"taskId":"' +
            result[i]["id"].toString() +
            '",' +
            '"taskTask":"' +
            task +
            '",' +
            '"taskNote":"' +
            note +
            '",' +
            '"taskDateDue":"' +
            dateDue +
            '",' +
            '"taskTimeDue":"' +
            timeDue +
            '",' +
            '"taskCategory":"' +
            category +
            '",' +
            '"taskStatus":"' +
            status +
            '",' +
            '"taskPriority":"' +
            priority +
            '",' +
            '"taskTag":"' +
            tag1 +
            '",' +
            // '"taskAction":"' +
            // action1 +
            // '",' +
            // '"taskContext":"' +
            // context1 +
            // '",' +
            // '"taskLocation":"' +
            // location1 +
            // '",' +
            // '"taskGoal":"' +
            // goal1 +
            //'",' +
            '"taskIsStar":"' +
            isStar +
            '",' +
            '"taskIsDone":"' +
            isDone +
            '",' +
            '"taskDateDone":"' +
            dateDone +
            '",' +
            '"taskLastModified":"' +
            lastModified +
            '"}';

        taskList.add(taskTask);
      }

      tasks = {"tasks": taskList};
      print(tasks);
      request('wipeTasksfromDevice', formData: tasks);
    });
  }

  void deleteAllTaskFromMySQL() {
    request('deleteAllTasks', formData: null);
  }

  void pushTasksToMySql() async {
    final dbTaskFuture = helper.getAllTasks();
    dbTaskFuture.then((result) {
      for (int i = 0; i < result.length; i++) {
        final tasksRequest = request('contextSaveContent', formData: result[i]);
      }
    });
  }

  void syncTasks() async {
    this.pushTasksToMySql();
    this.wipeTaskDataFromMySql();
  }

  // String stringReplace(String str) {
  //   str = str.replaceAll("\\", "\\\\");
  //   str = str.replaceAll("\n", "\\n");
  //   str = str.replaceAll("\r", "\\r");
  //   str = str.replaceAll("\t", "\\t");
  //   str = str.replaceAll("(" ")", "\"\"");
  //   str = str.replaceAll(" ", "&nbsp;");
  //   str = str.replaceAll("<", "&lt;");
  //   str = str.replaceAll(">", "&gt;");
  //   str = str.replaceAll('"', '”');
  //   str = str.replaceAll('@', 'a:t');
  //   str = str.replaceAll("'", '’');

  //   return str;
  // }

  void wipeCatatoryToMySql() {
    // this.deleteAllTaskFromMySQL();
    final dbDataFuture = helper.getCategories();

    var dataList = [];
    var data = {};
    dbDataFuture.then((result) {
      print(result.length);

      for (int i = 0; i < result.length; i++) {
        print(result[i]);
        var id = "";
        var name = "";
        var description = "";

        if (result[i]["id"].toString() != null) {
          id = result[i]["id"].toString();
        }
        if (result[i]["name"] != null) {
          name = result[i]["name"];
        }
        if (result[i]["description"] != null) {
          description = result[i]["description"].toString();
        }

        String datadata = '{"id":"' +
            id +
            '",' +
            '"name":"' +
            name +
            '",' +
            '"description":"' +
            description +
            '"}';

        dataList.add(datadata);
      }

      data = {"data": dataList};
      print(data);
      request('wipeCatagoryfromDevice', formData: data);
    });
  }

  void wipeActionToMySql() {
    // this.deleteAllTaskFromMySQL();
    final dbDataFuture = helper.getAction1s();

    var dataList = [];
    var data = {};
    dbDataFuture.then((result) {
      print(result.length);

      for (int i = 0; i < result.length; i++) {
        print(result[i]);
        var id = "";
        var name = "";
        var description = "";

        if (result[i]["id"].toString() != null) {
          id = result[i]["id"].toString();
        }
        if (result[i]["name"] != null) {
          name = result[i]["name"];
        }
        if (result[i]["description"] != null) {
          description = result[i]["description"].toString();
        }

        String datadata = '{"id":"' +
            id +
            '",' +
            '"name":"' +
            name +
            '",' +
            '"description":"' +
            description +
            '"}';

        dataList.add(datadata);
      }

      data = {"data": dataList};
      print(data);
      request('wipeActionfromDevice', formData: data);
    });
  }

  void wipeContextToMySql() {
    // this.deleteAllTaskFromMySQL();
    final dbDataFuture = helper.getContext1s();

    var dataList = [];
    var data = {};
    dbDataFuture.then((result) {
      print(result.length);

      for (int i = 0; i < result.length; i++) {
        print(result[i]);
        var id = "";
        var name = "";
        var description = "";

        if (result[i]["id"].toString() != null) {
          id = result[i]["id"].toString();
        }
        if (result[i]["name"] != null) {
          name = result[i]["name"];
        }
        if (result[i]["description"] != null) {
          description = result[i]["description"].toString();
        }

        String datadata = '{"id":"' +
            id +
            '",' +
            '"name":"' +
            name +
            '",' +
            '"description":"' +
            description +
            '"}';

        dataList.add(datadata);
      }

      data = {"data": dataList};
      print(data);
      request('wipeContextfromDevice', formData: data);
    });
  }

  void wipeGoalToMySql() {
    // this.deleteAllTaskFromMySQL();
    final dbDataFuture = helper.getGoal1s();

    var dataList = [];
    var data = {};
    dbDataFuture.then((result) {
      print(result.length);

      for (int i = 0; i < result.length; i++) {
        print(result[i]);
        var id = "";
        var name = "";
        var description = "";

        if (result[i]["id"].toString() != null) {
          id = result[i]["id"].toString();
        }
        if (result[i]["name"] != null) {
          name = result[i]["name"];
        }
        if (result[i]["description"] != null) {
          description = result[i]["description"].toString();
        }

        String datadata = '{"id":"' +
            id +
            '",' +
            '"name":"' +
            name +
            '",' +
            '"description":"' +
            description +
            '"}';

        dataList.add(datadata);
      }

      data = {"data": dataList};
      print(data);
      request('wipeGoalfromDevice', formData: data);
    });
  }

  void wipeLocationToMySql() {
    // this.deleteAllTaskFromMySQL();
    final dbDataFuture = helper.getLocation1s();

    var dataList = [];
    var data = {};
    dbDataFuture.then((result) {
      print(result.length);

      for (int i = 0; i < result.length; i++) {
        print(result[i]);
        var id = "";
        var name = "";
        var description = "";

        if (result[i]["id"].toString() != null) {
          id = result[i]["id"].toString();
        }
        if (result[i]["name"] != null) {
          name = result[i]["name"];
        }
        if (result[i]["description"] != null) {
          description = result[i]["description"].toString();
        }

        String datadata = '{"id":"' +
            id +
            '",' +
            '"name":"' +
            name +
            '",' +
            '"description":"' +
            description +
            '"}';

        dataList.add(datadata);
      }

      data = {"data": dataList};
      print(data);
      request('wipeLocationfromDevice', formData: data);
    });
  }

  void wipePriorityToMySql() {
    // this.deleteAllTaskFromMySQL();
    final dbDataFuture = helper.getPriorities();

    var dataList = [];
    var data = {};
    dbDataFuture.then((result) {
      print(result.length);

      for (int i = 0; i < result.length; i++) {
        print(result[i]);
        var id = "";
        var name = "";
        var description = "";

        if (result[i]["id"].toString() != null) {
          id = result[i]["id"].toString();
        }
        if (result[i]["name"] != null) {
          name = result[i]["name"];
        }
        if (result[i]["description"] != null) {
          description = result[i]["description"].toString();
        }

        String datadata = '{"id":"' +
            id +
            '",' +
            '"name":"' +
            name +
            '",' +
            '"description":"' +
            description +
            '"}';

        dataList.add(datadata);
      }

      data = {"data": dataList};
      print(data);
      request('wipePriorityfromDevice', formData: data);
    });
  }

  void wipeStatusToMySql() {
    // this.deleteAllTaskFromMySQL();
    final dbDataFuture = helper.getStatuses();

    var dataList = [];
    var data = {};
    dbDataFuture.then((result) {
      print(result.length);

      for (int i = 0; i < result.length; i++) {
        print(result[i]);
        var id = "";
        var name = "";
        var description = "";

        if (result[i]["id"].toString() != null) {
          id = result[i]["id"].toString();
        }
        if (result[i]["name"] != null) {
          name = result[i]["name"];
        }
        if (result[i]["description"] != null) {
          description = result[i]["description"].toString();
        }

        String datadata = '{"id":"' +
            id +
            '",' +
            '"name":"' +
            name +
            '",' +
            '"description":"' +
            description +
            '"}';

        dataList.add(datadata);
      }

      data = {"data": dataList};
      print(data);
      request('wipeStatusfromDevice', formData: data);
    });
  }

  void wipeTagToMySql() {
    // this.deleteAllTaskFromMySQL();
    final dbDataFuture = helper.getTag1s();

    var dataList = [];
    var data = {};
    dbDataFuture.then((result) {
      print(result.length);

      for (int i = 0; i < result.length; i++) {
        print(result[i]);
        var id = "";
        var name = "";
        var description = "";

        if (result[i]["id"].toString() != null) {
          id = result[i]["id"].toString();
        }
        if (result[i]["name"] != null) {
          name = result[i]["name"];
        }
        if (result[i]["description"] != null) {
          description = result[i]["description"].toString();
        }

        String datadata = '{"id":"' +
            id +
            '",' +
            '"name":"' +
            name +
            '",' +
            '"description":"' +
            description +
            '"}';

        dataList.add(datadata);
      }

      data = {"data": dataList};
      print(data);
      request('wipeTagfromDevice', formData: data);
    });
  }
}
