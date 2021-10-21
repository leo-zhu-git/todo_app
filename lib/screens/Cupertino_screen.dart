import 'package:todo_app/screens/date_picker_page.dart';
// import 'package:cupertino_datepicker_example/page/date_picker_page.dart';
//import 'package:cupertino_datepicker_example/page/datetime_picker_page.dart';
//import 'package:cupertino_datepicker_example/page/time_picker_page.dart';
//import 'package:cupertino_datepicker_example/page/custom_picker_page.dart';
//import 'package:cupertino_datepicker_example/page/timer_picker_page.dart';
//import 'package:cupertino_datepicker_example/widget/tabbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/widgets/tabbar_widget.dart';

class CupertinoScreen extends StatefulWidget {
  @override
  _CupertinoScreenState createState() => _CupertinoScreenState();
}

class _CupertinoScreenState extends State<CupertinoScreen> {
  @override
  Widget build(BuildContext context) => TabBarWidget(
        title: 'Cupertino Picker',
        tabs: [
          Tab(icon: Icon(Icons.date_range), text: 'Date'),
          Tab(icon: Icon(Icons.access_time), text: 'Time'),
          Tab(icon: Icon(Icons.timer), text: 'Timer'),
          Tab(icon: Icon(Icons.update_outlined), text: 'DateTime'),
          Tab(icon: Icon(Icons.more_horiz_outlined), text: 'Custom'),
        ],
        children: [
          DatePickerPage(),
          DatePickerPage(),
          DatePickerPage(),
          DatePickerPage(),
          DatePickerPage(),
//          TimePickerPage(),
//          TimerPickerPage(),
//          DatetimePickerPage(),
//          CustomPickerPage(),
        ],
      );
}