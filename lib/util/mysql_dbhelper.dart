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
import 'package:todo_app/screens/taskdetail.dart';

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

///////////////////////////
  /// Wipe tasks
///////////////////////////
  Future<List<Map<dynamic, dynamic>>?> getTasksFromMySql() async {
    final tasksRequest = request('getAllTasks', formData: null);
    List<Map> taskList = [];
    await tasksRequest.then((value) {
      final data = json.decode(value.toString());
      taskList = (data['Tasks'] as List).cast();

      // print(taskList);
    });
    return taskList;
  }

///////////////////////////
  /// Wipe statuses
///////////////////////////
  Future<List<Map>?> getStatusesDataFromMysql() async {
    final statusRequest = request('statusContent', formData: null);
    List<Map> statusList = [];
    await statusRequest.then((value) {
      final data = json.decode(value.toString());
      // print(data);
      statusList = (data['Status'] as List).cast();

      print(statusList);
    });

    return statusList;
    // print(count);
    // var statusList = [];
    // for (int i = 0; i < swiperDataList.length; i++) {
    //   Status status = new Status();
    //   String dbId = swiperDataList[i]['id'].toString();
    //   String dbUserID = swiperDataList[i]['userId'].toString();
    //   String appId = dbId.substring(dbUserID.length, dbId.length);
    //   status.id = int.parse(appId);
    //   status.name = swiperDataList[i]['name'];
    //   status.description = swiperDataList[i]['desc'];

    // final statusFuture = helper.getStatusesbyID(int.parse(appId));
    // statusFuture.then((result) {
    //   count = result.length;
    //   //for (int i = 0; i < count; i++) {
    //   //helper.deleteAction(i);
    //   //}
    //   if (count > 0) {
    //     helper.updateStatuses(status);
    //     //helper.deleteAction(swiperDataList[i]['TaskID']);
    //   } else {
    //     helper.insertStatuses(status);
    //     // helper.deleteAction(swiperDataList[i]['TaskID']);
    //   }
    // });
    //     statusList.add(status);
    //   }
    //   // print(statusList);
    //   // return statusList;
    // });
  }

///////////////////////////
  /// Wipe priorities
///////////////////////////
  Future<List<Map>?> getPrioritiesDataFromMysql() async {
    final prioritiesRequest = request('priorityContent', formData: null);
    List<Map> prioritiesList = [];
    await prioritiesRequest.then((value) {
      final data = json.decode(value.toString());
      // print(data);
      prioritiesList = (data['Priority'] as List).cast();
      // print(prioritiesList);
      // // print(count);
      // var prioritiesList = [];
      // for (int i = 0; i < swiperDataList.length; i++) {
      //   Priority priority = new Priority();
      //   String dbId = swiperDataList[i]['id'].toString();
      //   String dbUserID = swiperDataList[i]['userId'].toString();
      //   String appId = dbId.substring(dbUserID.length, dbId.length);
      //   priority.id = int.parse(appId);
      //   priority.name = swiperDataList[i]['name'];
      //   priority.description = swiperDataList[i]['desc'];

      // final priorityFuture = helper.getPrioritiesbyID(int.parse(appId));
      // priorityFuture.then((result) {
      //   count = result.length;
      //   //for (int i = 0; i < count; i++) {
      //   //helper.deleteAction(i);
      //   //}
      //   if (count > 0) {
      //     helper.updatePriorities(priority);
      //     //helper.deleteAction(swiperDataList[i]['TaskID']);
      //   } else {
      //     helper.insertPriorities(priority);
      //     // helper.deleteAction(swiperDataList[i]['TaskID']);
      //   }
      // });

      //   prioritiesList.add(priority);
      // }
      // print(prioritiesList);
      // return prioritiesList;
    });
    return prioritiesList;
  }

///////////////////////////
  /// Wipe categories
///////////////////////////

  Future<List<Map>?> getCategoriesDataFromMysql() async {
    final categoriesRequest = request('categoriesContent', formData: null);
    List<Map> categoriesList = [];
    await categoriesRequest.then((value) {
      final data = json.decode(value.toString());
      // print(data);
      categoriesList = (data['Categories'] as List).cast();
      // print(categoriesList);
    });
    return categoriesList;
  }

///////////////////////////
  /// Wipe tags
///////////////////////////
  Future<List<Map>?> getTag1sDataFromMysql() async {
    final tagRequest = request('tagContent', formData: null);
    List<Map> tagList = [];
    await tagRequest.then((value) {
      final data = json.decode(value.toString());
      // print(data);
      tagList = (data['Tags'] as List).cast();
      // print(tagList);
    });
    return tagList;
  }

  Future<Map<dynamic, dynamic>?> wipeTaskDataToMySql() async {
    var result = await helper.getAllTasks();

    var taskList = [];
    var tasks = {};

    for (int i = 0; i < result.length; i++) {
      var task = "";
      var note = "";
      var dateDue = "";
      var timeDue = "";
      var category = "";
      var status = "";
      var priority = "";
      var tag1 = "";
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

    return tasks;
  }

///////////////////////////
  /// Sync all Tasks
///////////////////////////

  void syncTasks() async {
    var tasks = dbHelper.getTasksforSync();
  }

  Future<Map<dynamic, dynamic>?> wipeCatatoryToMySql() async {
    // this.deleteAllTaskFromMySQL();
    var dbDataFuture = await helper.getCategories();

    var dataList = [];
    var data = {};

    for (int i = 0; i < dbDataFuture.length; i++) {
      var id = "";
      var name = "";
      var description = "";

      if (dbDataFuture[i]["id"].toString() != null) {
        id = dbDataFuture[i]["id"].toString();
      }
      if (dbDataFuture[i]["name"] != null) {
        name = dbDataFuture[i]["name"];
      }
      if (dbDataFuture[i]["description"] != null) {
        description = dbDataFuture[i]["description"].toString();
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

    data = {"catatory": dataList};

    return data;
  }

  Future<Map<dynamic, dynamic>?> wipePriorityToMySql() async {
    // this.deleteAllTaskFromMySQL();
    var dbDataFuture = await helper.getPriorities();

    var dataList = [];
    var data = {};

    for (int i = 0; i < dbDataFuture.length; i++) {
      var id = "";
      var name = "";
      var description = "";

      if (dbDataFuture[i]["id"].toString() != null) {
        id = dbDataFuture[i]["id"].toString();
      }
      if (dbDataFuture[i]["name"] != null) {
        name = dbDataFuture[i]["name"];
      }
      if (dbDataFuture[i]["description"] != null) {
        description = dbDataFuture[i]["description"].toString();
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

    data = {"priority": dataList};

    return data;
  }

  Future<Map<dynamic, dynamic>?> wipeStatusToMySql() async {
    var dbDataFuture = await helper.getStatuses();

    var dataList = [];
    var data = {};

    for (int i = 0; i < dbDataFuture.length; i++) {
      var id = "";
      var name = "";
      var description = "";

      if (dbDataFuture[i]["id"].toString() != null) {
        id = dbDataFuture[i]["id"].toString();
      }
      if (dbDataFuture[i]["name"] != null) {
        name = dbDataFuture[i]["name"];
      }
      if (dbDataFuture[i]["description"] != null) {
        description = dbDataFuture[i]["description"].toString();
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

    data = {"status": dataList};

    return data;
  }

  Future<Map<dynamic, dynamic>?> wipeTagToMySql1() async {
    var result = await helper.getTag1s();

    var data = {};
    var dataList = [];

    for (int i = 0; i < result.length; i++) {
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

    data = {"tag": dataList};

    return data;
  }

  Future wipeAllDataFromMysql() async {
    List<Map>? tasks = await getTasksFromMySql();
    List<Map>? status = await getStatusesDataFromMysql();
    List<Map>? proiorities = await getPrioritiesDataFromMysql();
    List<Map>? catagories = await getCategoriesDataFromMysql();
    List<Map>? tags = await getTag1sDataFromMysql();
    await dbHelper.wipeAllDataFromMysql(
        tasks!, status!, proiorities!, catagories!, tags!);
  }

  Future wipeAllDataToMySql() async {
    var tasks = await wipeTaskDataToMySql();
    var status = await wipeStatusToMySql();
    var proiority = await wipePriorityToMySql();
    var catagory = await wipeCatatoryToMySql();
    var tags = await wipeTagToMySql1();
    var allData = {};

    allData.addAll(tasks!);
    allData.addAll(status!);
    allData.addAll(proiority!);
    allData.addAll(catagory!);
    allData.addAll(tags!);

    request('wipeTasksfromDevice', formData: allData);

    dbHelper.setLastSyncDate();
  }
}
