import 'package:flutter/material.dart';
import 'package:todo_app/model/location1.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';

class Location1sScreen extends StatefulWidget {
  @override
  _Location1sScreenState createState() => _Location1sScreenState();
}

class _Location1sScreenState extends State<Location1sScreen> {
  var _location1NameController = TextEditingController();
  var _location1DescriptionController = TextEditingController();

  var _location1 = Location1();
  var _location1Service = DbHelper();

  var _editLocation1NameController = TextEditingController();
  var _editLocation1DescriptionController = TextEditingController();

  List<Location1> _location1List = List<Location1>();

  var location1;

  @override
  void initState() {
    super.initState();
    getAllLocation1s();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllLocation1s() async {
    _location1List = List<Location1>();
    var location1s = await _location1Service.getLocations();
    location1s.forEach((location1) {
      setState(() {
        var location1Model = Location1();
        location1Model.name = location1['name'];
        location1Model.description = location1['description'];
        location1Model.id = location1['id'];
        _location1List.add(location1Model);
      });
    });
  }

  _editLocation1(BuildContext context, location1Id) async {
    location1 = await _location1Service.getLocationsbyID(location1Id);
    setState(() {
      _editLocation1NameController.text = location1[0]['name'] ?? 'No Name';
      _editLocation1DescriptionController.text =
          location1[0]['description'] ?? 'No Description';
    });
    _editFormDialogue(context);
  }

  _showFormDialog(BuildContext context) {
    _location1NameController.text = '';
    _location1DescriptionController.text = '';

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.pink[100],
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
                    _location1.name = _location1NameController.text;
                    _location1.description = _location1DescriptionController.text;
                    _location1.id = null; 

                    var result = _location1Service.insertLocations(_location1);
                    print(result);
                    Navigator.pop(context);
                    getAllLocation1s();
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
            title: Text('Location Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _location1NameController,
                    decoration: InputDecoration(
                      hintText: 'Write a location',
                      labelText: 'Location',
                    ),
                  ),
                  TextField(
                    controller: _location1DescriptionController,
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
            backgroundColor: Colors.pink[100],
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
                  _location1.id = location1[0]['id'];
                  _location1.name = _editLocation1NameController.text;
                  _location1.description =
                      _editLocation1DescriptionController.text;

                  var result = await _location1Service.updateLocations(_location1);
                  print(result);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllLocation1s();
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
            title: Text('Edit Location Form'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _editLocation1NameController,
                  decoration: InputDecoration(
                    hintText: 'Write a location',
                    labelText: 'Location',
                  ),
                ),
                TextField(
                  controller: _editLocation1DescriptionController,
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

  _deleteFormDialogue(BuildContext context, location1Id) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.pink[100],
            actions: <Widget>[
              FlatButton(
                  color: Colors.brown[500],
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
              FlatButton(
                onPressed: () async {
                  var result =
                      await _location1Service.deleteLocationsbyID(location1Id);
                  print(result);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllLocation1s();
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
        title: Center(child: Text('Locations')),
      ),
      body: ListView.builder(
        itemCount: _location1List.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Card(
              elevation: 8.0,
              color: Colors.pink[100],
              child: ListTile(
                leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editLocation1(context, _location1List[index].id);
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_location1List[index].name),
                    IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          _deleteFormDialogue(context, _location1List[index].id);
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
                tooltip: 'Add Location',
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
