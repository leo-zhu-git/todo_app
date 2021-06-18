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

  List<Context1> _context1List = List<Context1>();

  var context1;

  @override
  void initState() {
    super.initState();
    getAllContext1s();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllContext1s() async {
    _context1List = List<Context1>();
    var context1s = await _context1Service.getContexts();
    context1s.forEach((context1) {
      setState(() {
        var context1Model = Context1();
        context1Model.name = context1['name'];
        context1Model.description = context1['description'];
        context1Model.id = context1['id'];
        _context1List.add(context1Model);
      });
    });
  }

  _editContext1(BuildContext context, context1Id) async {
    context1 = await _context1Service.getContextbyID(context1Id);
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
            backgroundColor: Colors.pink[100],
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
                    _context1.name = _context1NameController.text;
                    _context1.description = _context1DescriptionController.text;
                    _context1.id = null; 

                    var result = _context1Service.insertContexts(_context1);
                    print(result);
                    Navigator.pop(context);
                    getAllContext1s();
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
            title: Text('Context Form'),
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
            backgroundColor: Colors.pink[100],
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
                  _context1.id = context1[0]['id'];
                  _context1.name = _editContext1NameController.text;
                  _context1.description =
                      _editContext1DescriptionController.text;

                  var result = await _context1Service.updateContext(_context1);
                  print(result);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllContext1s();
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
            title: Text('Edit Context Form'),
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
            backgroundColor: Colors.pink[100],
            actions: <Widget>[
              FlatButton(
                  color: Colors.brown[900],
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
              FlatButton(
                onPressed: () async {
                  var result =
                      await _context1Service.deleteContextbyID(context1Id);
                  print(result);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllContext1s();
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
        title: Center(child: Text('Contexts')),
      ),
      body: ListView.builder(
        itemCount: _context1List.length,
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
                      _editContext1(context, _context1List[index].id);
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_context1List[index].name),
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
