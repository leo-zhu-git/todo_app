import 'dart:async';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/action1.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/context1.dart';
import 'package:todo_app/model/tag1.dart';

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
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        String dbTaskID = swiperDataList[i]['TaskID'].toString();
        String dbUserID = swiperDataList[i]['TaskUserId'].toString();
        String appTaskID = dbTaskID.substring(dbUserID.length, dbTaskID.length);
        print(dbTaskID);

        Task task = Task.withId(
            int.parse(appTaskID),
            swiperDataList[i]['TaskTitle'],
            swiperDataList[i]['TaskDesc'],
            swiperDataList[i]['TaskCategory'],
            swiperDataList[i]['TaskAction'],
            swiperDataList[i]['TaskContext'],
            swiperDataList[i]['TaskLocation'],
            swiperDataList[i]['TaskTag'],
            swiperDataList[i]['TaskGole'],
            int.parse(swiperDataList[i]['TaskPriorityint']),
            swiperDataList[i]['TaskProiortyText'],
            swiperDataList[i]['TaskDateDue'],
            swiperDataList[i]['TaskTimeDue'],
            int.parse(swiperDataList[i]['TaskIsDone']),
            swiperDataList[i]['TaskDateDone'],
            swiperDataList[i]['TaskStatus'],
            swiperDataList[i]['LastModified'],
            "",
            "",
            "",
            "",
            "");

        print(task);

        helper.insertTask(task);

        // final tasksFuture = helper.getTasksByID(appTaskID);
        // tasksFuture.then((result) {
        //   count = result.length;

        if (count > 0) {
          helper.updateTask(task);
          //helper.deleteTask(swiperDataList[i]['TaskID']);
        } else {
          helper.insertTask(task);
          //helper.deleteTask(swiperDataList[i]['TaskID']);
        }
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
            swiperDataList[i]['TaskTitle'],
            swiperDataList[i]['TaskDesc'],
            swiperDataList[i]['TaskCategory'],
            swiperDataList[i]['TaskAction'],
            swiperDataList[i]['TaskContext'],
            swiperDataList[i]['TaskLocation'],
            swiperDataList[i]['TaskTag'],
            swiperDataList[i]['TaskGole'],
            int.parse(swiperDataList[i]['TaskPriorityint']),
            swiperDataList[i]['TaskProiortyText'],
            swiperDataList[i]['TaskDateDue'],
            swiperDataList[i]['TaskTimeDue'],
            int.parse(swiperDataList[i]['TaskIsDone']),
            swiperDataList[i]['TaskDateDone'],
            swiperDataList[i]['TaskStatus'],
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

  void syncTagsData() async {
    helper.deleteAllTags();
    final tasksRequest = request('tagContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['Tags'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        Tag1 tag = new Tag1();
        String dbId = swiperDataList[i]['id'].toString();
        String dbUserID = swiperDataList[i]['userId'].toString();
        String appId = dbId.substring(dbUserID.length, dbId.length);
        tag.id = int.parse(appId);
        tag.name = swiperDataList[i]['name'];
        tag.description = swiperDataList[i]['desc'];

        final tagFuture = helper.getTagsbyID(int.parse(appId));
        tagFuture.then((result) {
          count = result.length;
          for (int i = 0; i < 100; i++) {
            helper.deleteCategoriesbyID(i);
            helper.deleteContextbyID(i);
            helper.deleteTagbyID(i);
          }
          if (count > 0) {
            helper.updateTags(tag);
            //helper.deleteAction(swiperDataList[i]['TaskID']);
          } else {
            helper.insertTags(tag);
            // helper.deleteAction(swiperDataList[i]['TaskID']);
          }
        });
      }
    });
  }

  void syncContextData() async {
    helper.deleteAllContext();
    final tasksRequest = request('contextContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      print(data);
      List<Map> swiperDataList = (data['Contexts'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        String dbId = swiperDataList[i]['id'].toString();
        String dbUserID = swiperDataList[i]['userId'].toString();
        String appId = dbId.substring(dbUserID.length, dbId.length);
        Context1 context = new Context1();
        context.id = int.parse(appId);
        context.name = swiperDataList[i]['name'];
        context.description = swiperDataList[i]['desc'];

        print(swiperDataList[i]['name']);
        //helper.deleteTask(swiperDataList[i]['TaskID']);
        final actionFuture = helper.getContextbyID(int.parse(appId));
        actionFuture.then((result) {
          count = result.length;

          if (count > 0) {
            //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
            helper.updateContext(context);
          } else {
            helper.insertContexts(context);
            //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
          }
        });
      }
    });
  }

  void wipeTaskDataToMySql() {
    this.deleteAllTaskFromMySQL();
    final dbTaskFuture = helper.getAllTasks();
    dbTaskFuture.then((result) {
      for (int i = 0; i < result.length; i++) {
        print(result[i]);
        print(result[i]["id"]);
        print("title::::" + result[i]["title"]);
        print(result[i]["description"]);
        print(result[i]["category"]);
        print(result[i]["action1"]);
        print(result[i]["context1"]);
        print(result[i]["tag1"]);
        print(result[i]["goal1"]);
        print(result[i]["priorityvalue"]);
        print(result[i]["prioritytext"]);
        print(result[i]["dateDue"]);
        print(result[i]["isDone"]);
        print(result[i]["dateDone"]);
        request('wipeTasksfromDevice', formData: result[i]);
      }
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
