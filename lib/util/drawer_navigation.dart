import 'package:flutter/material.dart';
import 'package:todo_app/screens/wipe.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/screens/action1s_screen.dart';
import 'package:todo_app/screens/categories_screen.dart';
import 'package:todo_app/screens/context1s_screen.dart';
import 'package:todo_app/screens/goal1s_screen.dart';
import 'package:todo_app/screens/location1s_screen.dart';
import 'package:todo_app/screens/tag1s_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerNagivation extends StatefulWidget {
  @override
  _DrawerNagivation createState() => _DrawerNagivation();
}

class _DrawerNagivation extends State<DrawerNagivation> {
  List<Widget> _categoryList = List<Widget>();
  //DbHelper dbHelper = new DbHelper();

  // CategoryService _categoryService = CategoryService();

  List<Widget> _action1List = List<Widget>();
  //Action1Service _action1Service = Action1Service();

  List<Widget> _context1List = List<Widget>();
  //Context1Service _context1Service = Context1Service();

  List<Widget> _location1List = List<Widget>();
  //Location1Service _location1Service = Location1Service();

  List<Widget> _tag1List = List<Widget>();
  //Tag1Service _tag1Service = Tag1Service();

  List<Widget> _goal1List = List<Widget>();
  // Goal1Service _goal1Service = Goal1Service();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('images/todoMIT.png'),
                  ),
              accountName: Text('2half'),
              accountEmail: Text('2half@gmail.com'),
              decoration: BoxDecoration(color: Colors.brown[900]),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TaskHome())),
            ),
//            ListTile(
//              leading: Icon(Icons.category),
//              title: Text('Categories'),
//              onTap: () => Navigator.of(context).push(
//                  MaterialPageRoute(builder: (context) => CategoriesScreen())),
//            ),
//            Divider(),
//            Column(
//              children: _categoryList,
//            ),
//            ListTile(
//              leading: Icon(Icons.pending_actions_outlined),
//              title: Text('Actions'),
//              onTap: () => Navigator.of(context).push(
//                  MaterialPageRoute(builder: (context) => Action1sScreen())),
//            ),
//            Divider(),
//            Column(
//              children: _action1List,
//            ),
//            ListTile(
//              leading: Icon(Icons.filter_alt_outlined),
//              title: Text('Contexts'),
//             onTap: () => Navigator.of(context).push(
//                  MaterialPageRoute(builder: (context) => Context1sScreen())),
//            ),
//            Divider(),
//            Column(
//              children: _context1List,
//            ),
//            ListTile(
//              leading: Icon(Icons.add_location_outlined),
//              title: Text('Locations'),
//              onTap: () => Navigator.of(context).push(
//                  MaterialPageRoute(builder: (context) => Location1sScreen())),
//            ),
//           Divider(),
//            Column(
//              children: _location1List,
//            ),
//            ListTile(
//              leading: Icon(Icons.bookmark_border_rounded),
//              title: Text('Tags'),
//              onTap: () => Navigator.of(context)
//                  .push(MaterialPageRoute(builder: (context) => Tag1sScreen())),
//            ),
//            Divider(),
//            ListTile(
//              leading: Icon(Icons.bookmark_border_rounded),
//              title: Text('Goals'),
//              onTap: () => Navigator.of(context)
//                  .push(MaterialPageRoute(builder: (context) => Goal1sScreen())),
//            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.cloud_download_outlined),
              title: Text('Wipe'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => WipeScreen())),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.help_outlined),
              title: Text('Help'),
              onTap: () {
                _launchURL();
              },
            ),
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    const _url =
        'https://2ndhalf.app';
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

}
