import 'package:flutter/material.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/util/dbhelper.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = DbHelper();

  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();

  List<Category> _categoryList = List<Category>();

  var category;

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.getCategories();
    if (categories.length != 0) {
      categories.forEach((category) {
        setState(() {
          var categoryModel = Category();
          categoryModel.name = category['name'];
          categoryModel.description = category['description'];
          categoryModel.id = category['id'];
          _categoryList.add(categoryModel);
        });
      });
    } else {
      _categoryList = null;
    }
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.getCategoriesbyID(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editCategoryDescriptionController.text =
          category[0]['description'] ?? 'No Description';
    });
    _editFormDialogue(context);
  }

  _showFormDialogue(BuildContext context) {
    _categoryNameController.text = '';
    _categoryDescriptionController.text = '';

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
                    _category.name = _categoryNameController.text;
                    _category.description = _categoryDescriptionController.text;
                    _category.id = null;

                    var result = _categoryService.insertCategories(_category);
                    print(result);
                    print(_category.name);
                    Navigator.pop(context);
                    getAllCategories();
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
                  child: Text('Add')),
            ],
            title: Text('Categories Form'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                    hintText: 'Write a category',
                    labelText: 'Category',
                  ),
                ),
                TextField(
                  controller: _categoryDescriptionController,
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
                  _category.id = category[0]['id'];
                  _category.name = _editCategoryNameController.text;
                  _category.description =
                      _editCategoryDescriptionController.text;

                  var result = await _categoryService.updateCategories(_category);
                  print(result);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategories();
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
            title: Text('Edit Categories Form'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _editCategoryNameController,
                  decoration: InputDecoration(
                    hintText: 'Write a category',
                    labelText: 'Category',
                  ),
                ),
                TextField(
                  controller: _editCategoryDescriptionController,
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

  _deleteFormDialogue(BuildContext context, categoryId) {
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
                      await _categoryService.deleteCategoriesbyID(categoryId);
                  print(result);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategories();
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
        title: Center(child: Text('Categories')),
      ),
      resizeToAvoidBottomInset: false,
      body: ListView.builder(
        itemCount: _categoryList.length,
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
                      _editCategory(context, _categoryList[index].id);
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_categoryList[index].name),
                    IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          _deleteFormDialogue(context, _categoryList[index].id);
                        })
                  ],
                ),
//                subtitle: Text(_categoryList[index].description),
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
//                  Navigator.pop(context, true);
                },
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                tooltip: 'Add Category',
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
