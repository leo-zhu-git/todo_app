import 'package:flutter/material.dart';
import 'package:todo_app/screens/taskhome.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tasks',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.amber[100],
          primaryColor: Colors.brown[900],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: ''),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(
      // title: new Text(widget.title),
      // ),
      body: TaskHome(),
    );
  }
}