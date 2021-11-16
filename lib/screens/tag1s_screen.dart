import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/tag1.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';

class Tag1sScreen extends StatefulWidget {
  @override
  _Tag1sScreenState createState() => _Tag1sScreenState();
}

class _Tag1sScreenState extends State<Tag1sScreen> {
  var _tag1NameController = TextEditingController();
  var _tag1DescriptionController = TextEditingController();

  var _tag1 = Tag1();
  var _tag1Service = DbHelper();

  var _editTag1NameController = TextEditingController();
  var _editTag1DescriptionController = TextEditingController();

  List<Tag1> _tag1List = [];

  var tag1;

  @override
  void initState() {
    super.initState();
    getAllTag1s();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllTag1s() async {
    _tag1List = [];
    var tag1 = await _tag1Service.getTag1s();
    tag1.forEach((tag1) {
      setState(() {
        var tag1Model = Tag1();
        tag1Model.name = tag1['name'];
        tag1Model.description = tag1['description'];
        tag1Model.id = tag1['id'];
        _tag1List.add(tag1Model);
      });
    });
    if (tag1.length == 0) {
      setState(() {
        _tag1List.clear();
      });
    }
  }

  _editTag1(BuildContext context, tag1Id) async {
    tag1 = await _tag1Service.getTag1sbyID(tag1Id);
    setState(() {
      _editTag1NameController.text = tag1[0]['name'] ?? 'No Name';
      _editTag1DescriptionController.text =
          tag1[0]['description'] ?? 'No Description';
    });
    _editFormDialogue(context);
  }

  _showFormDialogue(BuildContext context) {
    _tag1NameController.text = '';
    _tag1DescriptionController.text = '';
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
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
                    _tag1.name = _tag1NameController.text;
                    _tag1.description = _tag1DescriptionController.text;
                    _tag1.id = null;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Tag Added"),
                    ));

                    var result = _tag1Service.insertTag1s(_tag1);
                    Navigator.pop(context);
                    getAllTag1s();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
            backgroundColor: Colors.orange[100],
            title: Text('Add Tag'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _tag1NameController,
                    decoration: InputDecoration(
                      hintText: 'Write a tag',
                      labelText: 'Tag',
                    ),
                  ),
                  TextField(
                    controller: _tag1DescriptionController,
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
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[300],
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.teal[800]),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal[800],
                  ),
                  onPressed: () async {
                    _tag1.id = tag1[0]['id'];
                    _tag1.name = _editTag1NameController.text;
                    _tag1.description = _editTag1DescriptionController.text;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Tag Updated"),
                    ));

                    var result = await _tag1Service.updateTag1s(_tag1);
                    print(result);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllTag1s();
                    }
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
            title: Text('Edit Tag'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _editTag1NameController,
                  decoration: InputDecoration(
                    hintText: 'Write a tag',
                    labelText: 'Tag',
                  ),
                ),
                TextField(
                  controller: _editTag1DescriptionController,
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

  _deleteFormDialogue(BuildContext context, tag1Id) {
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
                    var result = await _tag1Service.deleteTag1sbyID(tag1Id);
                    print(result);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllTag1s();
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
            tooltip: 'Add Tag',
            onPressed: () {
              _showFormDialogue(context);
            },
          ),
        ],
        backgroundColor: Colors.teal[800],
        title: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Badge(
                  child: Text('Tags     '),
                  shape: BadgeShape.square,
                  position: BadgePosition.topEnd(),
                  badgeContent: Text(_tag1List.length.toString(),
                      style: TextStyle(color: Colors.black)),
                  badgeColor: Colors.orange[100]!,
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _tag1List.length,
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
                      _editTag1(context, _tag1List[index].id);
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(_tag1List[index].name!,
                          overflow: TextOverflow.ellipsis),
                    ),
//                    IconButton(
//                        icon: Icon(Icons.delete, color: Colors.grey),
//                        onPressed: () {
//                          _deleteFormDialogue(context, _tag1List[index].id);
//                        }),
                  ],
                ),
//                subtitle: Text(_tag1List[index].description),
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
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              IconButton(
//                icon: Icon(Icons.arrow_back, color: Colors.white),
//                tooltip: 'Back',
//                onPressed: () {
//                  Navigator.pop(context, true);
//                },
//              ),
//             IconButton(
//                icon: Icon(Icons.add, color: Colors.white),
//                tooltip: 'Add Tag',
//                onPressed: () {
//                  _showFormDialog(context);
//                },
//              ),
//            ],
//          ),
//        ),
//      ),
    );
  }
}
