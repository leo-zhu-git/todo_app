import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/status.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';

class StatusesScreen extends StatefulWidget {
  @override
  _StatusesScreenState createState() => _StatusesScreenState();
}

class _StatusesScreenState extends State<StatusesScreen> {
  var _statusNameController = TextEditingController();
  var _statusDescriptionController = TextEditingController();

  var _status = Status();
  var _statusService = DbHelper();

  var _editStatusNameController = TextEditingController();
  var _editStatusDescriptionController = TextEditingController();
  TextStyle _textStyleControls =
      TextStyle(fontSize: 17.0, color: Colors.black87);
  TextStyle _textStyleSnack = TextStyle(
      fontSize: 16.0, color: Colors.pink[100], fontWeight: FontWeight.w600);

  List<Status> _statusList = [];

  var status;

  @override
  void initState() {
    super.initState();
    getAllStatuses();
  }

  @override
  void dispose() {
    // DO STUFF
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllStatuses() async {
    _statusList = [];
    var statuses = await _statusService.getStatuses();
    if (statuses.length != 0) {
      statuses.forEach((status) {
        setState(() {
          var statusModel = Status();
          statusModel.name = status['name'];
          statusModel.description = status['description'];
          statusModel.id = status['id'];
          _statusList.add(statusModel);
        });
      });
    } else {
      setState(() {
        _statusList.clear();
      });
    }
  }

  _editStatus(BuildContext context, statusId) async {
    status = await _statusService.getStatusesbyID(statusId);
    setState(() {
      _editStatusNameController.text = status[0]['name'] ?? 'No Name';
      _editStatusDescriptionController.text =
          status[0]['description'] ?? 'No Description';
    });
    _editFormDialogue(context);
  }

  _showFormDialogue(BuildContext context) {
    _statusNameController.text = '';
    _statusDescriptionController.text = '';

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.orange[100],
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
                    _status.name = _statusNameController.text;
                    _status.description = _statusDescriptionController.text;
                    _status.id = null;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.teal[800],
                      duration: Duration(seconds: 3),
                      content: Text("Status Added", style: _textStyleSnack),
                    ));

                    var result = _statusService.insertStatuses(_status);
                    print(result);
                    print(_status.name);
                    Navigator.pop(context);
                    getAllStatuses();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal[800],
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
            title: Text('Add Status'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _statusNameController,
                  decoration: InputDecoration(
                    hintText: 'Write a status',
                    labelText: 'Status',
                  ),
                ),
                TextField(
                  controller: _statusDescriptionController,
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
            backgroundColor: Colors.orange[100],
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
                    _status.id = status[0]['id'];
                    _status.name = _editStatusNameController.text;
                    _status.description = _editStatusDescriptionController.text;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.teal[800],
                      duration: Duration(seconds: 3),
                      content: Text("Status Updated", style: _textStyleSnack),
                    ));

                    var result = await _statusService.updateStatuses(_status);
                    print(result);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllStatuses();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal[800],
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
            title: Text('Edit Status'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _editStatusNameController,
                  decoration: InputDecoration(
                    hintText: 'Write a status',
                    labelText: 'Status',
                  ),
                ),
                TextField(
                  controller: _editStatusDescriptionController,
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

  _deleteFormDialogue(BuildContext context, statusId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.orange[100],
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal[800],
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
                        await _statusService.deleteStatusesbyID(statusId);
                    print(result);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllStatuses();
                    }
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.teal[800]),
                  )),
            ],
            title: Text('Are you sure you want to delete this'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      key: _globalKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            tooltip: 'Add Status',
            onPressed: () {
              _showFormDialogue(context);
            },
          ),
        ],
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
        elevation: 8,
        title: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Badge(
                  child: Text('Statuses     '),
                  shape: BadgeShape.square,
                  position: BadgePosition.topEnd(),
                  badgeContent: Text(_statusList.length.toString(),
                      style: TextStyle(color: Colors.black)),
                  badgeColor: Colors.orange[100]!,
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: ListView.builder(
        itemCount: _statusList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
            child: Card(
              elevation: 8.0,
              color: Colors.orange[100],
              child: ListTile(
                leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editStatus(context, _statusList[index].id);
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(_statusList[index].name!,
                          overflow: TextOverflow.ellipsis),
                    ),
//                    IconButton(
//                        icon: Icon(Icons.delete, color: Colors.grey),
//                        onPressed: () {
//                          _deleteFormDialogue(context, _statusList[index].id);
//                        })
                  ],
                ),
//                subtitle: Text(_statusList[index].description),
              ),
            ),
          );
        },
      ),
//      bottomNavigationBar: Container(
//        height: 55.0,
//        child: BottomAppBar(
//          color: Colors.teal[800],
//          child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              IconButton(
//                icon: Icon(Icons.arrow_back, color: Colors.white),
//                tooltip: 'Back',
//                onPressed: () {
//                  Navigator.pop(context, true);
//                },
//              ),
//              IconButton(
//                icon: Icon(Icons.add, color: Colors.white),
//                tooltip: 'Add Status',
//                onPressed: () {
//                  _showFormDialogue(context);
//                },
//              ),
//            ],
//          ),
//        ),
//      ),
    );
  }
}
