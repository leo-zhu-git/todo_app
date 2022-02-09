import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/screens/notificationPlugin.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int count = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // DO STUFF
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Early Adoptors Program')),
        ),
        body: Row(
          children: [
            Text('a'),
          ],
        ));
  }
}
