import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/screens/notificationPlugin.dart';

class LocalNotificationScreen extends StatefulWidget {
  @override
  _LocalNotificationScreenState createState() =>
      _LocalNotificationScreenState();
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen> {
  int count = 0;
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
          title: Text('Notifications Testing - NOW...'),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // addCategorytemp();
                },
                child: Text('Insert Category'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await notificationPlugin.showNotification(
                      'todoMIT showNow title', 'todoMIT showNow body');
                },
                child: Text('Send Notification Now [working]'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await notificationPlugin.scheduleNotification(
                      'todoMIT scheduled ',
                      'todoMIT scheduled body',
                      '2021-11-13',
                      '16:55');
                },
                child: Text('Scheduled - 5s delay [working]'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await notificationPlugin.repeatNotification();
                },
                child: Text('Repeated Notification - Every minute [working]'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await notificationPlugin.showDailyAtTime();
                },
                child: Text('Show Daily At 6.57am - watch NHK news [working]'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  count =
                      await notificationPlugin.getPendingNotificationCount();
                },
                child: Text('Pending Notification Count: $count [working]'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await notificationPlugin.cancelAllNotification();
                },
                child: Text('Cancel All Notifications [placeholder]'),
              ),
            )
          ],
        ));
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}

  onNotificationClick(String payload) {
    print('Payload $payload');
  }
}
