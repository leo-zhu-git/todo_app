import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/action1.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';

class Action1sScreen extends StatefulWidget {
  @override
  _Action1sScreenState createState() => _Action1sScreenState();
}

class _Action1sScreenState extends State<Action1sScreen> {
  var _action1NameController = TextEditingController();
  var _action1DescriptionController = TextEditingController();

  var _action1 = Action1();

  var _action1Service = DbHelper();

  var _editAction1NameController = TextEditingController();
  var _editAction1DescriptionController = TextEditingController();

  List<Action1> _actionList = List<Action1>();

  var action1;

  @override
  void initState() {
    super.initState();
    getAllActions();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllActions() async {
    _actionList = List<Action1>();
    var action = await _action1Service.getActions();
    action.forEach((action) {
      setState(() {
        var actionModel = Action1();
        actionModel.name = action['name'];
        actionModel.description = action['description'];
        actionModel.id = action['id'];
        _actionList.add(actionModel);
      });
    });
    if (action.length == 0) {
      setState(() {
        _actionList.clear();
      });
    }
  }

  _editAction(BuildContext context, actionId) async {
    action1 = await _action1Service.getActionbyID(actionId);
    setState(() {
      _editAction1NameController.text = action1[0]['name'] ?? 'No Name';
      _editAction1DescriptionController.text =
          action1[0]['description'] ?? 'No Description';
    });
    _editFormDialogue(context);
  }

  _showFormDialog(BuildContext context) {
    _action1NameController.text = '';
    _action1DescriptionController.text = '';
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.brown[500]),
                  )),
              FlatButton(
                  color: Colors.brown[500],
                  onPressed: () {
                    _action1.name = _action1NameController.text;
                    _action1.description = _action1DescriptionController.text;
                    _action1.id = null;

                    var result = _action1Service.insertAction(_action1);
                    Navigator.pop(context);
                    getAllActions();
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
                            ' Added ',
                            style: (TextStyle(color: Colors.black)),
                          )
                        ],
                      ),
                    ));
                  },
                  child: Text('Save')),
            ],
            backgroundColor: Colors.blue[100],
            title: Text('Actions Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _action1NameController,
                    decoration: InputDecoration(
                      hintText: 'Write a action',
                      labelText: 'Action',
                    ),
                  ),
                  TextField(
                    controller: _action1DescriptionController,
                    decoration: InputDecoration(
                      hintText: 'Write a description',
                      labelText: 'Description',
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _editFormDialogue(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.blue[100],
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.brown[500]),
                  )),
              FlatButton(
                color: Colors.brown[500],
                onPressed: () async {
                  _action1.id = action1[0]['id'];
                  _action1.name = _editAction1NameController.text;
                  _action1.description = _editAction1DescriptionController.text;

                  var result = await _action1Service.updateAction(_action1);
                  print(result);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllActions();
                    _showSuccessSnackBar(
                      Container(
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
                              ' Updated ',
                              style: (TextStyle(color: Colors.black)),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
                child: Text('Update'),
              ),
            ],
            title: Text('Edit Actions Form'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _editAction1NameController,
                  decoration: InputDecoration(
                    hintText: 'Write a action',
                    labelText: 'Action',
                  ),
                ),
                TextField(
                  controller: _editAction1DescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Write a description',
                    labelText: 'Description',
                  ),
                )
              ],
            )),
          );
        });
  }

  _deleteFormDialogue(BuildContext context, actionId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.blue[100],
            actions: <Widget>[
              FlatButton(
                  color: Colors.brown[500],
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
              FlatButton(
                onPressed: () async {
                  var result = await _action1Service.deleteAction(actionId);
                  print(result);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllActions();
                    _showSuccessSnackBar(
                      Container(
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
                              ' Deleted ',
                              style: (TextStyle(color: Colors.black)),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  'Delete?',
                  style: TextStyle(color: Colors.brown[500]),
                ),
              ),
            ],
            title: Text('Are you sure you want to delete this'),
          );
        });
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown[900],
        title: Center(child: Text('Actions')),
      ),
      body: ListView.builder(
        itemCount: _actionList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
            child: Card(
              elevation: 8.0,
              color: Colors.blue[100],
              child: ListTile(
                leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editAction(context, _actionList[index].id);
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(_actionList[index].name,
                          overflow: TextOverflow.ellipsis),
                    ),
                    IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          _deleteFormDialogue(context, _actionList[index].id);
                        }),
                  ],
                ),
              ),
            ),
          );
        },
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
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                tooltip: 'Add Action',
                onPressed: () {
                  _showFormDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
