import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/context1.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';

class Context1sScreen extends StatefulWidget {
  @override
  _Context1sScreenState createState() => _Context1sScreenState();
}

class _Context1sScreenState extends State<Context1sScreen> {
  var _context1NameController = TextEditingController();
  var _context1DescriptionController = TextEditingController();

  var _context1 = Context1();
  var _context1Service = DbHelper();

  var _editContext1NameController = TextEditingController();
  var _editContext1DescriptionController = TextEditingController();

  List<Context1> _context1List = [];

  var context1;

  @override
  void initState() {
    super.initState();
    getAllContext1s();
  }

  @override
  void dispose() {
    // DO STUFF
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllContext1s() async {
    _context1List = [];
    var context1s = await _context1Service.getContext1s();
    context1s.forEach((context1) {
      setState(() {
        var context1Model = Context1();
        context1Model.name = context1['name'];
        context1Model.description = context1['description'];
        context1Model.id = context1['id'];
        _context1List.add(context1Model);
      });
    });

    if (context1s.length == 0) {
      setState(() {
        _context1List.clear();
      });
    }
  }

  _editContext1(BuildContext context, context1Id) async {
    context1 = await _context1Service.getContext1sbyID(context1Id);
    setState(() {
      _editContext1NameController.text = context1[0]['name'] ?? 'No Name';
      _editContext1DescriptionController.text =
          context1[0]['description'] ?? 'No Description';
    });
    _editFormDialogue(context);
  }

  _showFormDialog(BuildContext context) {
    _context1NameController.text = '';
    _context1DescriptionController.text = '';

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
                    _context1.name = _context1NameController.text;
                    _context1.description = _context1DescriptionController.text;
//                    _context1.id = null;

                    var result = _context1Service.insertContext1s(_context1);
                    print(result);
                    Navigator.pop(context);
                    getAllContext1s();
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
//                         Text(
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
            title: Text('Add Context'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _context1NameController,
                    decoration: InputDecoration(
                      hintText: 'Write a context',
                      labelText: 'Context',
                    ),
                  ),
                  TextField(
                    controller: _context1DescriptionController,
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
                    _context1.id = context1[0]['id'];
                    _context1.name = _editContext1NameController.text;
                    _context1.description =
                        _editContext1DescriptionController.text;

                    var result =
                        await _context1Service.updateContext1s(_context1);
                    print(result);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllContext1s();
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
//                             )
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
            title: Text('Edit Context'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _editContext1NameController,
                  decoration: InputDecoration(
                    hintText: 'Write a context',
                    labelText: 'Context',
                  ),
                ),
                TextField(
                  controller: _editContext1DescriptionController,
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

  _deleteFormDialogue(BuildContext context, context1Id) {
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
                    primary: Colors.white,
                  ),
                  onPressed: () async {
                    var result =
                        await _context1Service.deleteContext1sbyID(context1Id);
                    print(result);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllContext1s();
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
                  child: Text('Contexts     '),
                  shape: BadgeShape.square,
                  position: BadgePosition.topEnd(),
                  badgeContent: Text(_context1List.length.toString(),
                      style: TextStyle(color: Colors.black)),
                  badgeColor: Colors.orange[100]!,
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _context1List.length,
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
                      _editContext1(context, _context1List[index].id);
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(_context1List[index].name!,
                          overflow: TextOverflow.ellipsis),
                    ),
                    IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          _deleteFormDialogue(context, _context1List[index].id);
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
                tooltip: 'Add Context',
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
