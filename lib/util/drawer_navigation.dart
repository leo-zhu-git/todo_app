import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/Community.dart';
import 'package:todo_app/screens/Cupertino_screen.dart';
import 'package:todo_app/screens/LocalNotification_screen.dart';
import 'package:todo_app/screens/entry.dart';
import 'package:todo_app/screens/wipe.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/screens/action1s_screen.dart';
import 'package:todo_app/screens/categories_screen.dart';
import 'package:todo_app/screens/context1s_screen.dart';
import 'package:todo_app/screens/goal1s_screen.dart';
import 'package:todo_app/screens/location1s_screen.dart';
import 'package:todo_app/screens/tag1s_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../amplifyconfiguration.dart';

class DrawerNagivation extends StatefulWidget {
  @override
  _DrawerNagivation createState() => _DrawerNagivation();
}

class _DrawerNagivation extends State<DrawerNagivation> {
  List<Widget> _categoryList = [];
  //DbHelper dbHelper = new DbHelper();

  // CategoryService _categoryService = CategoryService();

  List<Widget> _action1List = [];
  //Action1Service _action1Service = Action1Service();

  List<Widget> _context1List = [];
  //Context1Service _context1Service = Context1Service();

  List<Widget> _location1List = [];
  //Location1Service _location1Service = Location1Service();

  List<Widget> _tag1List = [];
  //Tag1Service _tag1Service = Tag1Service();

  List<Widget> _goal1List = [];
  // Goal1Service _goal1Service = Goal1Service();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      decoration: BoxDecoration(color: Colors.amber),
      child: Container(
        color: Colors.amber[100],
        child: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('images/todoMIToctopus.png'),
                ),
                margin: EdgeInsets.zero,
                accountName: Text('Welcome to'),
                accountEmail: Text('todoMIT'),
                decoration: BoxDecoration(color: Colors.brown[900]),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                tileColor: Colors.amber[100],
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => TaskHome())),
              ),
              Divider(color: Colors.amber[800]),
              ListTile(
                leading: Icon(Icons.cloud_download),
                tileColor: Colors.amber[100],
                title: Text('Wipe'),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WipeScreen())),
              ),
              Divider(color: Colors.amber[800]),
              ListTile(
                tileColor: Colors.amber[100],
                leading: Icon(Icons.connect_without_contact),
                title: Text('Support [temp for testing]'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LocalNotificationScreen())),
              ),
              Divider(),
              ListTile(
                tileColor: Colors.amber[100],
                leading: Icon(Icons.connect_without_contact),
                title: Text('Cupertino [temp for testing]'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CupertinoScreen())),
              ),
              Divider(),
              ListTile(
                tileColor: Colors.amber[100],
                leading: Icon(Icons.help_outlined),
                title: Text('Help - FAQ [placeholder]'),
                onTap: () {
                  _launchURL();
                },
              ),
              Divider(color: Colors.amber[800]),
              ListTile(
                tileColor: Colors.amber[100],
                leading: Icon(Icons.help_outlined),
                title: Text('Report a bug [placeholder]'),
                onTap: () {
                  _launchURL();
                },
              ),
              Divider(color: Colors.amber[800]),
              ListTile(
                tileColor: Colors.amber[100],
                leading: Icon(Icons.help_outlined),
                title: Text('Request a feature [placeholder]'),
                onTap: () {
                  _launchURL();
                },
              ),
              Divider(color: Colors.amber[800]),
              ListTile(
                tileColor: Colors.amber[100],
                leading: Icon(Icons.people),
                title: Text('Early Adoptors Program [placeholder]'),
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
//            Divider(),
              Divider(color: Colors.amber[800]),
              ListTile(
                tileColor: Colors.amber[100],
                leading: Icon(Icons.elevator_rounded),
                title: Text('Subscription Plans [placeholder]'),
                onTap: () {
                  _launchURL();
                },
              ),
              Divider(color: Colors.amber[800]),
              ListTile(
                tileColor: Colors.amber[100],
                leading: Icon(Icons.perm_device_info),
                title: Text('About [placeholder]'),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => TaskHome())),
              ),
              Divider(color: Colors.amber[800]),
//            ListTile(
//                tileColor: Colors.amber[100],
//                leading: Icon(Icons.logout),
//                title: Text('Logout [placeholder]'),
//                onTap: () {
//                  try {
//                    Amplify.Auth.signOut();
//                  } on AuthException catch (e) {
//                    print(e.message);
//                  }
//                }),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    const _url = 'https://2ndhalf.app';
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }
}
