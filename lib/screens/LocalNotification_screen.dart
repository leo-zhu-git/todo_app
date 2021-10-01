import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/screens/notificationPlugin.dart';

class LocalNotificationScreen extends StatefulWidget {
  @override
  _LocalNotificationScreenState createState() =>
      _LocalNotificationScreenState();
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen> {
  @override
  void initState() {
    super.initState();
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications Testing...'),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await notificationPlugin.showNotification();
                },
                child: Text('Send Notification'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await notificationPlugin.scheduleNotification();
                },
                child: Text('Scheduled Notification - 5s [Placeholder]'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await notificationPlugin.scheduleNotification();
                },
                child: Text('Repeated Notification - Every minute'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await notificationPlugin.showDailyAtTime();
                },
                child: Text('Show Daily At Time [Placeholder]'),
              ),
            ),
          ],
        ));
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}

  onNotificationClick(String payload) {
    print('Payload $payload');
  }
}
