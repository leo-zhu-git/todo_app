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

  List<Tag1> _tag1List = List<Tag1>();

  var tag1;

  @override
  void initState() {
    super.initState();
    getAllTag1s();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllTag1s() async {
    _tag1List = List<Tag1>();
    var tag1 = await _tag1Service.getTags();
    tag1.forEach((tag1) {
      setState(() {
        var tag1Model = Tag1();
        tag1Model.name = tag1['name'];
        tag1Model.description = tag1['description'];
        tag1Model.id = tag1['id'];
        _tag1List.add(tag1Model);
      });
    });
  }

  _editTag1(BuildContext context, tag1Id) async {
    tag1 = await _tag1Service.getTagsbyID(tag1Id);
    setState(() {
      _editTag1NameController.text = tag1[0]['name'] ?? 'No Name';
      _editTag1DescriptionController.text =
          tag1[0]['description'] ?? 'No Description';
    });
    _editFormDialogue(context);
  }

  _showFormDialog(BuildContext context) {
    _tag1NameController.text = '';
    _tag1DescriptionController.text = '';
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
                    _tag1.name = _tag1NameController.text;
                    _tag1.description = _tag1DescriptionController.text;
                    _tag1.id = null; 

                    var result = _tag1Service.insertTags(_tag1);
                    Navigator.pop(context);
                    getAllTag1s();
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
            backgroundColor: Colors.pink[100],
            title: Text('Tags Form'),
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
                  _tag1.id = tag1[0]['id'];
                  _tag1.name = _editTag1NameController.text;
                  _tag1.description =
                      _editTag1DescriptionController.text;

                  var result = await _tag1Service.updateTags(_tag1);
                  print(result);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllTag1s();
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
            title: Text('Edit Tag Form'),
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
            backgroundColor: Colors.pink[100],
            actions: <Widget>[
              FlatButton(
                  color: Colors.brown[500],
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
              FlatButton(
                onPressed: () async {
                  var result =
                      await _tag1Service.deleteTagbyID(tag1Id);
                  print(result);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllTag1s();
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
        title: Center(child: Text('Tags')),
      ),
      body: ListView.builder(
        itemCount: _tag1List.length,
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
                      _editTag1(context, _tag1List[index].id);
                    }
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_tag1List[index].name),
                    IconButton(
                      icon: Icon(
                        Icons.delete, color: Colors.grey),
                        onPressed: () {
                          _deleteFormDialogue(context, _tag1List[index].id);
                        }
                  ),
                  ],                  
                ),
//                subtitle: Text(_tag1List[index].description),
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
                tooltip: 'Add Tag',
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
