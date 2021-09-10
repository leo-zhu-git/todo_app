import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/goal1.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';

class Goal1sScreen extends StatefulWidget {
  @override
  _Goal1sScreenState createState() => _Goal1sScreenState();
}

class _Goal1sScreenState extends State<Goal1sScreen> {
  var _goal1NameController = TextEditingController();
  var _goal1DescriptionController = TextEditingController();

  var _goal1 = Goal1();
  var _goal1Service = DbHelper();

  var _editGoal1NameController = TextEditingController();
  var _editGoal1DescriptionController = TextEditingController();

  List<Goal1> _goal1List = List<Goal1>();

  var goal1;

  @override
  void initState() {
    super.initState();
    getAllGoal1s();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllGoal1s() async {
    _goal1List = List<Goal1>();
    var goal1 = await _goal1Service.getGoals();
    goal1.forEach((goal1) {
      setState(() {
        var goal1Model = Goal1();
        goal1Model.name = goal1['name'];
        goal1Model.description = goal1['description'];
        goal1Model.id = goal1['id'];
        _goal1List.add(goal1Model);
      });
    });
  }

  _editGoal1(BuildContext context, goal1Id) async {
    goal1 = await _goal1Service.getGoalsbyID(goal1Id);
    setState(() {
      _editGoal1NameController.text = goal1[0]['name'] ?? 'No Name';
      _editGoal1DescriptionController.text =
          goal1[0]['description'] ?? 'No Description';
    });
    _editFormDialogue(context);
  }

  _showFormDialog(BuildContext context) {
    _goal1NameController.text = '';
    _goal1DescriptionController.text = '';
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
                    style: TextStyle(color: Colors.brown[900]),
                  )),
              FlatButton(
                  color: Colors.brown[900],
                  onPressed: () {
                    _goal1.name = _goal1NameController.text;
                    _goal1.description = _goal1DescriptionController.text;
                    _goal1.id = null; 

                    var result = _goal1Service.insertGoals(_goal1);
                    Navigator.pop(context);
                    getAllGoal1s();
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
            title: Text('Goals Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _goal1NameController,
                    decoration: InputDecoration(
                      hintText: 'Write a goal',
                      labelText: 'Goal',
                    ),
                  ),
                  TextField(
                    controller: _goal1DescriptionController,
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
                    style: TextStyle(color: Colors.brown[900]),
                  )),
              FlatButton(
                color: Colors.brown[900],
                onPressed: () async {
                  _goal1.id = goal1[0]['id'];
                  _goal1.name = _editGoal1NameController.text;
                  _goal1.description =
                      _editGoal1DescriptionController.text;

                  var result = await _goal1Service.updateGoals(_goal1);
                  print(result);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllGoal1s();
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
            title: Text('Edit Goal Form'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _editGoal1NameController,
                  decoration: InputDecoration(
                    hintText: 'Write a goal',
                    labelText: 'Goal',
                  ),
                ),
                TextField(
                  controller: _editGoal1DescriptionController,
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

  _deleteFormDialogue(BuildContext context, goal1Id) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.blue[100],
            actions: <Widget>[
              FlatButton(
                  color: Colors.brown[900],
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
              FlatButton(
                onPressed: () async {
                  var result =
                      await _goal1Service.deleteGoalbyID(goal1Id);
                  print(result);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllGoal1s();
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
                    style: TextStyle(color: Colors.brown[900]),
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
        title: Center(child: Text('Goals')),
      ),
      body: ListView.builder(
        itemCount: _goal1List.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Card(
              elevation: 8.0,
              color: Colors.blue[100],
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.edit),
                    onPressed: () {
                      _editGoal1(context, _goal1List[index].id);
                    }
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_goal1List[index].name),
                    IconButton(
                      icon: Icon(
                        Icons.delete, color: Colors.grey),
                        onPressed: () {
                          _deleteFormDialogue(context, _goal1List[index].id);
                        }
                  ),
                  ],                  
                ),
//                subtitle: Text(_goal1List[index].description),
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
                tooltip: 'Add Goal',
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
