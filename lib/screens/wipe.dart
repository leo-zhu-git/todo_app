import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';

class WipeScreen extends StatefulWidget {
  @override
  _WipeScreenState createState() => _WipeScreenState();
}

class _WipeScreenState extends State<WipeScreen> {
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
        title: Center(child: Text('Wipe')),
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
        chipForRow('Force Device->Database Wipe', Colors.blue),
        chipForRow('Force Database->Device Wipe', Colors.pink),
      ],
    );
  }

  wrapWidget() {
    return Wrap(
      children: [
        chipForRow('Force Device->Database Wipe', Colors.orange),
        chipForRow('Force Database->Device Wipe', Colors.orange),
      ],
    );
  }

  actionChips() {
    String _optionText;
    int _option;
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionChip(
              elevation: 6.0,
              padding: EdgeInsets.all(20.0),
              backgroundColor: Colors.pink[100],
              label: Center(child: Text('Force DEVICE->DATABASE wipe')),
              onPressed: () {
                _optionText =
                    'All tasks on this DEVICE will be slowly forced down to DATABASE, potentionally overwriting change you have made on backend. Are you sure you want to do this?';
                _option = 0;
                _ConfirmDialogue(_option, _optionText);
              }),
          SizedBox(height: 20.0),
          ActionChip(
              elevation: 6.0,
              backgroundColor: Colors.pink[100],
              padding: EdgeInsets.all(20.0),
              label: Center(child: Text('Force DATABASE->DEVICE wipe')),
              onPressed: () {
                _optionText =
                    'All tasks on DATABASE will be slowly forced up to this DEVICE, potentionally overwriting change you have made on this device. Are you sure you want to do this?';
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

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _key.currentState.showSnackBar(_snackBar);
  }

  _ConfirmDialogue(int _option, String message) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
              backgroundColor: Colors.pink[100],
              actions: <Widget>[
                FlatButton(
                    color: Colors.brown[900],
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel')),
                FlatButton(
                  onPressed: () async {
                    if (_option == 0) {
                      mysqlDBhelper.wipeTaskDataToMySql();
                      Navigator.pop(context);
                      _showSuccessSnackBar(Container(
                        color: Colors.tealAccent[100],
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (Icon(
                              Icons.thumb_up,
                              color: Colors.black,
                            )),
                            Text(
                              ' DEVICE->DATABASE wipe SUCCESSFUL ',
                              style: (TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      ));
                    } else {
                      mysqlDBhelper.wipeTaskDataFromMySql();
                      mysqlDBhelper.syncTagsData();
                      mysqlDBhelper.syncContextData();
                      mysqlDBhelper.syncCategoriesData();

                      Navigator.pop(context);
                      _showSuccessSnackBar(Container(
                        color: Colors.tealAccent[100],
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (Icon(
                              Icons.thumb_up,
                              color: Colors.black,
                            )),
                            Text(
                              ' DATABASE->DEVICE wipe SUCCESSFUL ',
                              style: (TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      ));
                    }
                  },
                  child: Text(
                    'Wipe',
                    style: TextStyle(color: Colors.brown[900]),
                  ),
                ),
              ],
              title: Text(message));
        });
  }
}
