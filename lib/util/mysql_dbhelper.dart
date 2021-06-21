import 'dart:async';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

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

  void syncTaskDataFromMySql() async {
    final tasksRequest = request('homePageContent', formData: null);

    tasksRequest.then((value) {
      final data = json.decode(value.toString());
      List<Map> swiperDataList = (data['Tasks'] as List).cast();

      var count = swiperDataList.length;
      print(count);

      for (int i = 0; i < swiperDataList.length; i++) {
        String dbTaskID = swiperDataList[i]['TaskID'].toString();
        String dbUserID = swiperDataList[i]['TaskUserId'].toString();
        String appTaskID = dbTaskID.substring(dbUserID.length, dbTaskID.length);
        print(appTaskID);
        print("woaibeijingtiananmen,jalsdjflksdjf+13333");
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

  // void syncActionData() async {
  //   final tasksRequest = request('actionContent', formData: null);

  //   tasksRequest.then((value) {
  //     final data = json.decode(value.toString());
  //     print(data);
  //     List<Map> swiperDataList = (data['Actions'] as List).cast();

  //     var count = swiperDataList.length;
  //     print(count);

  //     for (int i = 0; i < swiperDataList.length; i++) {
  //       Action1 action = new Action1();
  //       action.id = swiperDataList[i]['ActionId'];
  //       action.name = swiperDataList[i]['ActionTitle'];
  //       action.description = swiperDataList[i]['ActionDesc'];

  //       //print(swiperDataList[i]['TaskTitle']);
  //       //helper.deleteTask(swiperDataList[i]['TaskID']);
  //       final actionFuture =
  //           helper.searchTaskbyID(swiperDataList[i]['ActionId']);
  //       actionFuture.then((result) {
  //         count = result.length;
  //         //for (int i = 0; i < count; i++) {
  //         //helper.deleteAction(i);
  //         //}
  //         if (count > 0) {
  //           helper.updateAction(action);
  //           //helper.deleteAction(swiperDataList[i]['TaskID']);
  //         } else {
  //           helper.insertAction(action);
  //           // helper.deleteAction(swiperDataList[i]['TaskID']);
  //         }
  //       });
  //     }
  //   });
  // }

  // void syncContextData() async {
  //   final tasksRequest = request('contextContent', formData: null);

  //   tasksRequest.then((value) {
  //     final data = json.decode(value.toString());
  //     print(data);
  //     List<Map> swiperDataList = (data['Contexts'] as List).cast();

  //     var count = swiperDataList.length;
  //     print(count);

  //     for (int i = 0; i < swiperDataList.length; i++) {
  //       Context1 context = new Context1();
  //       context.id = swiperDataList[i]['ContextID'];
  //       context.name = swiperDataList[i]['ContextTitle'];
  //       context.description = swiperDataList[i]['ContextDesc'];

  //       print(swiperDataList[i]['ContextTitle']);
  //       //helper.deleteTask(swiperDataList[i]['TaskID']);
  //       final actionFuture =
  //           helper.getContextbyID(swiperDataList[i]['ContextID']);
  //       actionFuture.then((result) {
  //         count = result.length;

  //         if (count > 0) {
  //           //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
  //           helper.updateContext(context);
  //         } else {
  //           helper.insertContexts(context);
  //           //helper.deleteContextbyID(swiperDataList[i]['ContextID']);
  //         }
  //       });
  //     }
  //   });
  // }

  void syncTaskDataToMySql() async {
    final dbTaskFuture = helper.getTasksFromLastFewDays();
    dbTaskFuture.then((result) {
      for (int i = 0; i < result.length; i++) {
        print(result[i]);
        // print(result[i]["id"]);
        // print("title::::" + result[i]["title"]);
        // print(result[i]["description"]);
        // print(result[i]["category"]);
        // print(result[i]["action1"]);
        // print(result[i]["context1"]);
        // print(result[i]["tag1"]);
        // print(result[i]["goal1"]);
        // print(result[i]["priorityvalue"]);
        // print(result[i]["prioritytext"]);
        // print(result[i]["dateDue"]);
        // print(result[i]["isDone"]);
        // print(result[i]["dateDone"]);
        final tasksRequest = request('contextSaveContent', formData: result[i]);
      }
    });
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
