import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/priority.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';

class PrioritiesScreen extends StatefulWidget {
  @override
  _PrioritiesScreenState createState() => _PrioritiesScreenState();
}

class _PrioritiesScreenState extends State<PrioritiesScreen> {
  var _priorityNameController = TextEditingController();
  var _priorityDescriptionController = TextEditingController();

  var _priority = Priority();
  var _priorityService = DbHelper();

  var _editPriorityNameController = TextEditingController();
  var _editPriorityDescriptionController = TextEditingController();

  List<Priority> _priorityList = List<Priority>();

  var priority;

  @override
  void initState() {
    super.initState();
    getAllPriorities();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllPriorities() async {
    _priorityList = List<Priority>();
    var priorities = await _priorityService.getPriorities();
    if (priorities.length != 0) {
      priorities.forEach((priority) {
        setState(() {
          var priorityModel = Priority();
          priorityModel.name = priority['name'];
          priorityModel.description = priority['description'];
          priorityModel.id = priority['id'];
          _priorityList.add(priorityModel);
        });
      });
    } else {
      setState(() {
        _priorityList.clear();
      });
    }
  }

  _editPriority(BuildContext context, priorityId) async {
    priority = await _priorityService.getPrioritiesbyID(priorityId);
    setState(() {
      _editPriorityNameController.text = priority[0]['name'] ?? 'No Name';
      _editPriorityDescriptionController.text =
          priority[0]['description'] ?? 'No Description';
    });
    _editFormDialogue(context);
  }

  _showFormDialogue(BuildContext context) {
    _priorityNameController.text = '';
    _priorityDescriptionController.text = '';

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.blue[100],
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[300],
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.brown[900]),
                    )),
              ElevatedButton(
                  onPressed: () async {
                    _priority.name = _priorityNameController.text;
                    _priority.description = _priorityDescriptionController.text;
                    _priority.id = null;

                    var result = _priorityService.insertPriorities(_priority);
                    print(result);
                    print(_priority.name);
                    Navigator.pop(context);
                    getAllPriorities();
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
                            style: (TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ));
                  },
                                      style: ElevatedButton.styleFrom(
                      primary: Colors.brown[900],
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    )),
          
            ],
            title: Text('Add Priority'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _priorityNameController,
                  decoration: InputDecoration(
                    hintText: 'Write a priority',
                    labelText: 'Priority',
                  ),
                ),
                TextField(
                  controller: _priorityDescriptionController,
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

  _editFormDialogue(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.blue[100],
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[300],
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.brown[900]),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    _priority.id = priority[0]['id'];
                    _priority.name = _editPriorityNameController.text;
                    _priority.description =
                        _editPriorityDescriptionController.text;

                    var result =
                        await _priorityService.updatePriorities(_priority);
                    print(result);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllPriorities();
                      _showSuccessSnackBar(
                        Container(
                          color: Colors.tealAccent[100],
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (Icon(
                                Icons.thumb_up,
                                color: Colors.white,
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
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown[900],
                  ),
                  child: 
                  Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  )
                  ),
            ],
            title: Text('Edit Priority'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _editPriorityNameController,
                  decoration: InputDecoration(
                    hintText: 'Write a priority',
                    labelText: 'Priority',
                  ),
                ),
                TextField(
                  controller: _editPriorityDescriptionController,
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

  _deleteFormDialogue(BuildContext context, priorityId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.blue[100],
            actions: <Widget>[
              ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.brown[900],
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  onPressed: () => Navigator.pop(context),
                  ),
              ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),

                onPressed: () async {
                  var result =
                      await _priorityService.deletePrioritybyID(priorityId);
                  print(result);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllPriorities();
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
                child: 
                  Text(
                    'Delete',
                    style: TextStyle(color: Colors.brown[900]),
                  )
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
      backgroundColor: Colors.amber[50],
      key: _globalKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown[900],
        elevation: 8,
        title: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Badge(
                  child: Text('Priorities     '),
                  shape: BadgeShape.square,
                  position: BadgePosition.topEnd(),
                  badgeContent: Text(_priorityList.length.toString(),
                      style: TextStyle(color: Colors.black)),
                  badgeColor: Colors.blue[200],
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: ListView.builder(
        itemCount: _priorityList.length,
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
                      _editPriority(context, _priorityList[index].id);
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(_priorityList[index].name,
                          overflow: TextOverflow.ellipsis),
                    ),
                    IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          _deleteFormDialogue(context, _priorityList[index].id);
                        })
                  ],
                ),
//                subtitle: Text(_priorityList[index].description),
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
                icon: Icon(Icons.arrow_back, color: Colors.white),
                tooltip: 'Back',
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                tooltip: 'Add Priority',
                onPressed: () {
                  _showFormDialogue(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
