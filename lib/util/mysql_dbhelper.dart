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
  static Database _db;
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

        Task task = Task.withId(
            int.parse(appTaskID),
            swiperDataList[i]['TaskTask'],
            swiperDataList[i]['TaskNote'],
            swiperDataList[i]['TaskDateDue'],
            swiperDataList[i]['TaskTimeDue'],
            swiperDataList[i]['TaskStatus'],
            swiperDataList[i]['TaskPriority'],
            swiperDataList[i]['TaskCategory'],
            swiperDataList[i]['TaskAction'],
            swiperDataList[i]['TaskContext'],
            swiperDataList[i]['TaskLocation'],
            swiperDataList[i]['TaskTag'],
            swiperDataList[i]['TaskGoal'],
            int.parse(swiperDataList[i]['TaskIsStar']),
            int.parse(swiperDataList[i]['TaskIsDone']),
            swiperDataList[i]['TaskDateDone'],
            swiperDataList[i]['LastModified'],
            "",
            "",
            "",
            "",
            "");
        print("TaskID" + appTaskID);
        print("CategoryID::::::::" + swiperDataList[i]['TaskCategory']);
        print("ContextID::::::::" + swiperDataList[i]['TaskContext']);
        print("TagID::::::::" + swiperDataList[i]['TaskTag']);

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
            swiperDataList[i]['TaskStatus'],
            swiperDataList[i]['TaskPriority'],
            swiperDataList[i]['TaskCategory'],
            swiperDataList[i]['TaskAction'],
            swiperDataList[i]['TaskContext'],
            swiperDataList[i]['TaskLocation'],
            swiperDataList[i]['TaskTag'],
            swiperDataList[i]['TaskGoal'],
            int.parse(swiperDataList[i]['TaskIsStar']),
            int.parse(swiperDataList[i]['TaskIsDone']),
            swiperDataList[i]['TaskDateDone'],
            swiperDataList[i]['LastModified'],
            "",
            "",
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
    final tasksRequest = request('actionContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['statuses'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        Status action = new Status();
        String dbId = swiperDataList[i]['id'].toString();
        String dbUserID = swiperDataList[i]['userId'].toString();
        String appId = dbId.substring(dbUserID.length, dbId.length);
        action.id = int.parse(appId);
        action.name = swiperDataList[i]['name'];
        action.description = swiperDataList[i]['desc'];

        final actionFuture = helper.getStatusesbyID(int.parse(appId));
        actionFuture.then((result) {
          count = result.length;
          //for (int i = 0; i < count; i++) {
          //helper.deleteAction(i);
          //}
          if (count > 0) {
            helper.updateStatuses(action);
            //helper.deleteAction(swiperDataList[i]['TaskID']);
          } else {
            helper.insertStatuses(action);
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
    final tasksRequest = request('actionContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['priorities'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        Priority action = new Priority();
        String dbId = swiperDataList[i]['id'].toString();
        String dbUserID = swiperDataList[i]['userId'].toString();
        String appId = dbId.substring(dbUserID.length, dbId.length);
        action.id = int.parse(appId);
        action.name = swiperDataList[i]['name'];
        action.description = swiperDataList[i]['desc'];

        final actionFuture = helper.getPrioritiesbyID(int.parse(appId));
        actionFuture.then((result) {
          count = result.length;
          //for (int i = 0; i < count; i++) {
          //helper.deleteAction(i);
          //}
          if (count > 0) {
            helper.updatePriorities(action);
            //helper.deleteAction(swiperDataList[i]['TaskID']);
          } else {
            helper.insertPriorities(action);
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
    final tasksRequest = request('actionContent', formData: null);

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
      List<Map> swiperDataList = (data['Action1s'] as List).cast();

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
    helper.deleteAllContext1s();
    final tasksRequest = request('contextContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['Context1s'] as List).cast();

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
    final tasksRequest = request('contextContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['Location1s'] as List).cast();

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
      List<Map> swiperDataList = (data['Tag1s'] as List).cast();

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
    helper.deleteAllTag1s();
    final tasksRequest = request('goalContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['Goal1s'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        Goal1 action = new Goal1();
        String dbId = swiperDataList[i]['id'].toString();
        String dbUserID = swiperDataList[i]['userId'].toString();
        String appId = dbId.substring(dbUserID.length, dbId.length);
        action.id = int.parse(appId);
        action.name = swiperDataList[i]['name'];
        action.description = swiperDataList[i]['desc'];

        print(swiperDataList[i]['name']);
        //helper.deleteTask(swiperDataList[i]['TaskID']);
        final actionFuture = helper.getGoal1sbyID(int.parse(appId));
        actionFuture.then((result) {
          count = result.length;

          if (count > 0) {
            //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
            helper.updateGoal1s(action);
          } else {
            helper.insertGoal1s(action);
            //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
          }
        });
      }
    });
  }

  void wipeTaskDataToMySql() {
    this.deleteAllTaskFromMySQL();
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
        var status = "";
        var priority = "";
        var category = "";
        var action1 = "";
        var context1 = "";
        var location1 = "";
        var tag1 = "";
        var goal1 = "";
        var isStar = "";
        var isDone = "";
        var lastModified = "";
        var dateDone = "";

        if (result[i]["task"] != null) {
          task = stringReplace(result[i]["task"]);
        }
        if (result[i]["note"] != null) {
          note = stringReplace(result[i]["note"]);
        }
        if (result[i]["dateDue"] != null) {
          dateDue = result[i]["dateDue"].toString();
        }
        if (result[i]["timeDue"] != null) {
          timeDue = result[i]["timeDue"];
        }
        if (result[i]["status"] != null) {
          status = result[i]["status"].toString();
        }
        if (result[i]["priority"] != null) {
          priority = result[i]["priority"].toString();
        }
        if (result[i]["category"] != null) {
          category = result[i]["category"].toString();
        }
        if (result[i]["action1"] != null) {
          action1 = result[i]["action1"];
        }
        if (result[i]["context1"] != null) {
          context1 = result[i]["context1"].toString();
        }
        if (result[i]["location1"] != null) {
          location1 = result[i]["location1"].toString();
        }
        if (result[i]["tag1"] != null) {
          tag1 = result[i]["tag1"].toString();
        }
        if (result[i]["goal1"] != null) {
          goal1 = result[i]["goal1"].toString();
        }
        if (result[i]["isStar"] != null) {
          isDone = result[i]["isStar"].toString();
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
        if (result[i]["goal1"] != null) {
          goal1 = result[i]["goal1"].toString();
        }
        if (result[i]["location1"] != null) {
          timeDue = result[i]["location1"].toString();
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
            status +
            '",' +
            '"taskStatus":"' +
            status +
            '",' +
            '"taskPriority":"' +
            priority +
            '",' +
            '"taskCategory":"' +
            category +
            '",' +
            '"taskAction":"' +
            action1 +
            '",' +
            '"taskContext":"' +
            context1 +
            '",' +
            '"taskLocation":"' +
            location1 +
            '",' +
            '"taskTag":"' +
            tag1 +
            '",' +
            '"taskGoal":"' +
            goal1 +
            '",' +
            '"taskIsStar":"' +
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

  String stringReplace(String str) {
    str = str.replaceAll("\\", "\\\\");
    str = str.replaceAll("\n", "\\n");
    str = str.replaceAll("\r", "\\r");
    str = str.replaceAll("\t", "\\t");
    str = str.replaceAll("(" ")", "\"\"");
    str = str.replaceAll(" ", "&nbsp;");
    str = str.replaceAll("<", "&lt;");
    str = str.replaceAll(">", "&gt;");
    str = str.replaceAll('"', '”');
    str = str.replaceAll('@', 'a:t');
    str = str.replaceAll("'", '’');

    return str;
  }

  // void getTaskData() {
  //   final dbTaskFuture = helper.initializeDb();
  //   dbTaskFuture.then((result) {
  //     final tasksDataFuture = helper.getTasks();
  //     tasksDataFuture.then((result) {
  //       List<Task> taskList = List<Task>();
  //       count = result.length;
  //       print(count);
  //       for (int i = 0; i < count; i++) {
  //         taskList.add(Task.fromObject(result[i]));
  //         request('contextSaveContent', formData: result[i]);
  //       }
  //     });
  //   });
  // }
}
