import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';

class SyncScreen extends StatefulWidget {
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  GlobalKey<ScaffoldState> _key;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown[900],
        title: Center(child: Text('Sync')),
      ),
      body: Column(
        children: [
//          SingleChildScrollView(
//            scrollDirection: Axis.horizontal,
//            child: rowChips(),
//          ),
//          Center(child: wrapWidget()),
            actionChips(), 
        ],
      ),
      bottomNavigationBar: Container(
        height: 55.0,
        child: BottomAppBar(
          color: Colors.brown[900],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                tooltip: 'Back to Home',
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TaskHome()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  rowChips() {
    return Row(
      children: [
        chipForRow('Force Device->Database Sync', Colors.blue),
        chipForRow('Force Database->Device Sync', Colors.pink),
      ],
    );
  }

  wrapWidget() {
    return Wrap(
      children: [
        chipForRow('Force Device->Database Sync', Colors.orange),
        chipForRow('Force Database->Device Sync', Colors.orange),
      ],
    );
  }

  actionChips() {
    return Column(
      children: [
        ActionChip(    
          elevation: 6.0, 
          padding: EdgeInsets.all(10.0),
          label: Text('Force DEVICE->DATABASE sync'),
          onPressed: () {

          }
        ),
        ActionChip(    
          elevation: 6.0, 
          padding: EdgeInsets.all(10.0),
          label: Text('Force DATABASE->DEVICE sync'),
          onPressed: () {

          }
        ), 
      ],
    );
  }

  Widget chipForRow(String label, Color color) {
    return Container(
      margin: EdgeInsets.all(6.0),
      child: Chip(
        labelPadding: EdgeInsets.all(5.0),
//          avatar: CircleAvatar(
//            backgroundColor: Colors.green,
//            child: Text('AB'),
//          ),
        label: Text(label,
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: color,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(6.0),
      ),
    );
  }
}
