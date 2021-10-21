// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show File, Platform;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:rxdart/subjects.dart';

class NotificationPlugin {
  //
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  NotificationPlugin._() {
    init();
    tz.initializeTimeZones();
  }

  get http => null;

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('notifytodomit');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id, 
            title: title!, 
            body: body!, 
            payload: payload!);
        didReceivedLocalNotificationSubject.add(receivedNotification);
      },
    );

    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin!.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      onNotificationClick(payload);
    });
  }

////////////////////////
  /// 1. Show notification now
////////////////////////
  Future<void> showNotification(String _nTitle, String _nBody) async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID_12',
      'CHANNEL_NAME',
      //"CHANNEL_DESCRIPTION",
      color: const Color.fromARGB(255, 255, 0, 0),
//      color: Colors.yellow,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 5000,
      ledColor: const Color.fromARGB(255, 0, 255, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
      styleInformation: DefaultStyleInformation(true, true),
      enableLights: true,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin!.show(
      0,
      _nTitle,
      _nBody,
      platformChannelSpecifics,
      payload: 'New Payload',
    );
  }

  TimeOfDay timeConvert(String normTime) {
    int hour;
    int minute;
    String ampm = normTime.substring(normTime.length - 2);
    String result = normTime.substring(0, normTime.indexOf(' '));
    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
      hour = int.parse(result.split(':')[0]);
      if (hour == 12) hour = 0;
      minute = int.parse(result.split(":")[1]);
    } else {
      hour = int.parse(result.split(':')[0]) - 12;
      if (hour <= 0) {
        hour = 24 + hour;
      }
      minute = int.parse(result.split(":")[1]);
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

////////////////////////
  /// 2. scheduled notification
////////////////////////
  Future<void> scheduleNotification(
      String _nTitle, String _nBody, String _nDate, String _nTime) async {
    var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    int hour;
    int minute;
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 1',
      'CHANNEL_NAME 1',
      //"CHANNEL_DESCRIPTION 1",
//      icon: 'secondary_icon',
//      largeIcon: DrawableResourceAndroidBitmap('large_notf_icon'),
//      sound: RawResourceAndroidNotificationSound('my_sound'),
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails(
//      sound: 'my_sound.aiff',
        );
    var platformChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics,
      iOS: iosChannelSpecifics,
    );

    DateTime _notifyDate = DateTime.parse(_nDate);
    TimeOfDay _scheduledTime;

/////////////////
    /// check _timeDue is 24h or 12h format
/////////////////
    if (_nTime.contains('M')) {
      _scheduledTime = timeConvert(_nTime);
    } else {
      _scheduledTime = TimeOfDay(
          hour: int.parse(_nTime.split(":")[0]),
          minute: int.parse(_nTime.split(":")[1]));
    }
    ;

    if (_nTime != "") {
      DateTime _notifyDateTime = new DateTime(
          _notifyDate.year,
          _notifyDate.month,
          _notifyDate.day,
          _scheduledTime.hour,
          _scheduledTime.minute);
      DateTime _nowDateTime = DateTime.now();

      if (_notifyDateTime.isBefore(_nowDateTime)) {
        // notify time passed. do nothing
        print(_notifyDateTime);
      } else {
        var _tzNowDateTime = tz.TZDateTime.from(DateTime.now(), tz.local);
        var _tzNotifyDateTime = tz.TZDateTime.from(_notifyDateTime, tz.local);
        await flutterLocalNotificationsPlugin!.zonedSchedule(
            0,
            _nTitle,
            _nBody,
//        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
            _tzNotifyDateTime,
            NotificationDetails(
                android: AndroidNotificationDetails(
              'CHANNEL_ID 1',
              'CHANNEL_NAME 1',
            )),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
//    }
      }
    }
  }

////////////////////////
  /// 3. repeat notification - every minute
////////////////////////

  Future<void> repeatNotification() async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 3',
      'CHANNEL_NAME 3',
      // "CHANNEL_DESCRIPTION 3",
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin!.periodicallyShow(
      0,
      'Repeating Test Title',
      'Repeating Test Body',
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
  }

////////////////////////
  /// 4. showDaily at time
////////////////////////

  Future<void> showDailyAtTime() async {
    var time = Time(6, 57, 0);
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 4',
      'CHANNEL_NAME 4',
      // "CHANNEL_DESCRIPTION 4",
      importance: Importance.max,
      priority: Priority.high,
//            largeIcon: DrawableResourceAndroidBitmap('large_notf_icon'),
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin!.showDailyAtTime(
      0,
      'Test Title at ${time.hour}:${time.minute}.${time.second}',
      'Test Body', //null
      time,
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
  }

////////////////////////
  /// 4a. showWeekly at time
////////////////////////

  Future<void> showWeeklyAtDayTime() async {
    var time = Time(21, 5, 0);
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 5',
      'CHANNEL_NAME 5',
      // "CHANNEL_DESCRIPTION 5",
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin!.showWeeklyAtDayAndTime(
      0,
      'Test Title at ${time.hour}:${time.minute}.${time.second}',
      'Test Body', //null
      Day.saturday,
      time,
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
  }

  Future<void> showNotificationWithAttachment() async {
    var attachmentPicturePath = await _downloadAndSaveFile(
        'https://via.placeholder.com/800x200', 'attachment_img.jpg');
    var iOSPlatformSpecifics = IOSNotificationDetails(
      attachments: [IOSNotificationAttachment(attachmentPicturePath)],
    );
    var bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(attachmentPicturePath),
      contentTitle: '<b>Attached Image</b>',
      htmlFormatContentTitle: true,
      summaryText: 'Test Image',
      htmlFormatSummaryText: true,
    );
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL ID 2',
      'CHANNEL NAME 2',
      // 'CHANNEL DESCRIPTION 2',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
    );
    var notificationDetails = NotificationDetails(
        android: androidChannelSpecifics, iOS: iOSPlatformSpecifics);
    await flutterLocalNotificationsPlugin!.show(
      0,
      'Title with attachment',
      'Body with Attachment',
      notificationDetails,
    );
  }

  _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<int> getPendingNotificationCount() async {
    List<PendingNotificationRequest> p =
        await flutterLocalNotificationsPlugin!.pendingNotificationRequests();
    return p.length;
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin!.cancel(0);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin!.cancelAll();
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}
