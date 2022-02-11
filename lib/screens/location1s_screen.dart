import 'package:badges/badges.dart';
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

  List<Location1> _location1List = [];

  var location1;

  @override
  void initState() {
    super.initState();
    getAllLocation1s();
  }

  @override
  void dispose() {
    // DO STUFF
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllLocation1s() async {
    _location1List = [];
    var location1s = await _location1Service.getLocation1s();
    location1s.forEach((location1) {
      setState(() {
        var location1Model = Location1();
        location1Model.name = location1['name'];
        location1Model.description = location1['description'];
        location1Model.id = location1['id'];
        _location1List.add(location1Model);
      });
    });
    if (location1s.length == 0) {
      setState(() {
        _location1List.clear();
      });
    }
  }

  _editLocation1(BuildContext context, location1Id) async {
    location1 = await _location1Service.getLocation1sbyID(location1Id);
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
            backgroundColor: Colors.orange[100],
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[300],
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.teal[800]),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal[800],
                  ),
                  onPressed: () {
                    _location1.name = _location1NameController.text;
                    _location1.description =
                        _location1DescriptionController.text;
//                    _location1.id = null;

                    var result = _location1Service.insertLocation1s(_location1);
                    print(result);
                    Navigator.pop(context);
                    getAllLocation1s();
//                    _showSuccessSnackBar(Container(
//                      color: Colors.tealAccent[100],
//                      height: 40,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: [
//                          (Icon(
//                            Icons.thumb_up,
//                            color: Colors.black,
//                          )),
//                          Text(
//                            ' Added ',
//                            style: (TextStyle(color: Colors.black)),
//                          )
//                        ],
//                      ),
//                    ));
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
            title: Text('Add Location'),
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
            backgroundColor: Colors.orange[100],
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[300],
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.teal[800]),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal[800],
                  ),
                  onPressed: () async {
                    _location1.id = location1[0]['id'];
                    _location1.name = _editLocation1NameController.text;
                    _location1.description =
                        _editLocation1DescriptionController.text;

                    var result =
                        await _location1Service.updateLocation1s(_location1);
                    print(result);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllLocation1s();
//                      _showSuccessSnackBar(
//                        Container(
//                          color: Colors.tealAccent[100],
//                          height: 40,
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: [
//                              (Icon(
//                                Icons.thumb_up,
//                                color: Colors.black,
//                              )),
//                              Text(
//                                ' Updated ',
//                                style: (TextStyle(color: Colors.black)),
//                              )
//                            ],
//                          ),
//                        ),
//                      );
                    }
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
            title: Text('Edit Location'),
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
            backgroundColor: Colors.orange[100],
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal[800],
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[300],
                  ),
                  onPressed: () async {
                    var result = await _location1Service
                        .deleteLocation1sbyID(location1Id);
                    print(result);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllLocation1s();
//                      _showSuccessSnackBar(
//                        Container(
//                          color: Colors.tealAccent[100],
//                          height: 40,
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: [
//                              (Icon(
//                                Icons.thumb_up,
//                                color: Colors.black,
//                              )),
//                              Text(
//                                ' Deleted ',
//                                style: (TextStyle(color: Colors.black)),
//                              )
//                            ],
//                          ),
//                        ),
//                      );
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

//  _showSuccessSnackBar(message) {
//    var _snackBar = SnackBar(content: message);
//    _globalKey.currentState.showSnackBar(_snackBar);
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      key: _globalKey,
      appBar: AppBar(
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal[800],
        title: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Badge(
                  child: Text('Locations     '),
                  shape: BadgeShape.square,
                  position: BadgePosition.topEnd(),
                  badgeContent: Text(_location1List.length.toString(),
                      style: TextStyle(color: Colors.black)),
                  badgeColor: Colors.orange[100]!,
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _location1List.length,
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
                      _editLocation1(context, _location1List[index].id);
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(_location1List[index].name!,
                          overflow: TextOverflow.ellipsis),
                    ),
                    IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          _deleteFormDialogue(
                              context, _location1List[index].id);
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
          color: Colors.teal[800],
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
