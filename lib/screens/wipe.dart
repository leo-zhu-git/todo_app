import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WipeScreen extends StatefulWidget {
  @override
  _WipeScreenState createState() => _WipeScreenState();
}

class _WipeScreenState extends State<WipeScreen> {
  late GlobalKey<ScaffoldState> _key;

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
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),

        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.black38],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        backgroundColor: Colors.teal[800],
        title: Center(child: Text('Wipe')),
      ),
      body: Column(
        children: [
          actionChips(),
        ],
      ),
//      bottomNavigationBar: Container(
//        height: 55.0,
//        child: BottomAppBar(
//          color: Colors.teal[800],
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              IconButton(
//                icon: Icon(Icons.home, color: Colors.white),
//                tooltip: 'Back to Home',
//                onPressed: () {
//                  Navigator.of(context).push(
//                      MaterialPageRoute(builder: (context) => TaskHome()));
//                },
//              ),
//            ],
//          ),
//        ),
//      ),
    );
  }

  rowChips() {
    return Row(
      children: [
        chipForRow('Force Device -> Cloud Wipe', Colors.blue),
        chipForRow('Force Cloud -> Device Wipe', Colors.pink),
      ],
    );
  }

  wrapWidget() {
    return Wrap(
      children: [
        chipForRow('Force Device -> Cloud Wipe', Colors.orange),
        chipForRow('Force Cloud -> Device Wipe', Colors.orange),
      ],
    );
  }

  actionChips() {
    String _optionText;
    int _option;
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionChip(
              avatar: Icon(Icons.devices_rounded),
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0),
                      bottomRight: Radius.circular(0))),
              padding: EdgeInsets.all(20.0),
              backgroundColor: Colors.pink[100],
              label: Center(child: Text('Force Device -> Cloud wipe')),
              onPressed: () {
                _optionText =
                    'All tasks on this DEVICE will be slowly forced up to CLOUD, potentionally wiping out changes you have made. Are you sure?';
                _option = 0;
                _ConfirmDialogue(_option, _optionText);
              }),
          SizedBox(height: 20.0),
          ActionChip(
              avatar: Icon(Icons.cloud_circle),
              elevation: 8.0,
              backgroundColor: Colors.pink[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0),
                      bottomRight: Radius.circular(0))),
              padding: EdgeInsets.all(20.0),
              label: Center(child: Text('Force Cloud -> Device wipe')),
              onPressed: () {
                _optionText =
                    'All tasks on CLOUD will be slowly forced down to this DEVICE, potentionally wiping out changes you have made on this device. Are you sure?';
                _option = 1;
                _ConfirmDialogue(_option, _optionText);
              }),
        ],
      ),
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

//  _showSuccessSnackBar(message) {
//    var _snackBar = SnackBar(content: message);
//    _key.currentState.showSnackBar(_snackBar);
//  }

  _ConfirmDialogue(int _option, String message) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
              backgroundColor: Colors.pink[100],
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[300],
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.teal[800]),
                    )),
                ElevatedButton(
                    onPressed: () async {
                      if (_option == 0) {
                        mysqlDBhelper.wipeTaskDataToMySql();
                        mysqlDBhelper.wipeActionToMySql();
                        mysqlDBhelper.wipeCatatoryToMySql();
                        mysqlDBhelper.wipeGoalToMySql();
                        mysqlDBhelper.wipeContextToMySql();
                        mysqlDBhelper.wipeLocationToMySql();
                        mysqlDBhelper.wipePriorityToMySql();
                        mysqlDBhelper.wipeStatusToMySql();
                        mysqlDBhelper.wipeTagToMySql();
                        Navigator.pop(context);
//                      _showSuccessSnackBar(Container(
//                        color: Colors.tealAccent[100],
//                        height: 40,
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: [
//                            (Icon(
//                              Icons.thumb_up,
//                              color: Colors.black,
//                            )),
//                            Text(
//                              ' DEVICE -> CLOUD wipe SUCCESSFUL ',
//                              style: (TextStyle(color: Colors.black)),
//                            ),
//                          ],
//                        ),
//                      ));
                      } else {
                        mysqlDBhelper.wipeTaskDataFromMySql();
                        // mysqlDBhelper.syncStatusesData();
                        // mysqlDBhelper.syncPrioritiesData();
                        mysqlDBhelper.syncCategoriesData();
                        mysqlDBhelper.syncAction1sData();
                        mysqlDBhelper.syncContext1sData();
                        mysqlDBhelper.syncLocation1sData();
                        mysqlDBhelper.syncTag1sData();
                        mysqlDBhelper.syncGoal1sData();

                        Navigator.pop(context);
//                      _showSuccessSnackBar(Container(
//                        color: Colors.tealAccent[100],
//                        height: 40,
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: [
//                            (Icon(
//                              Icons.thumb_up,
//                              color: Colors.black,
//                            )),
//                            Text(
//                              ' CLOUD ->DEVICE wipe SUCCESSFUL ',
//                              style: (TextStyle(color: Colors.black)),
//                            ),
//                          ],
//                        ),
//                      ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal[800],
                    ),
                    child: Text(
                      'Wipe',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
              title: Text(message));
        });
  }
}
