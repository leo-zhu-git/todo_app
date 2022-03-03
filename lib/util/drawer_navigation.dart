import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/Community.dart';
import 'package:todo_app/screens/Cupertino_screen.dart';
import 'package:todo_app/screens/LocalNotification_screen.dart';
import 'package:todo_app/screens/entry.dart';
import 'package:todo_app/screens/wipe.dart';
import 'package:todo_app/screens/taskhome.dart';
import 'package:todo_app/screens/categories_screen.dart';
import 'package:todo_app/screens/goal1s_screen.dart';
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
  void dispose() {
    // DO STUFF
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      decoration: BoxDecoration(color: Colors.amber),
      child: Container(
        color: Colors.teal[50],
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
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal, Colors.black38],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                    color: Colors.teal[800]),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.pink[200]),
                title: Text('Home'),
                tileColor: Colors.teal[50],
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => TaskHome())),
              ),
              Divider(color: Colors.teal[50]),
              ListTile(
                leading: Icon(Icons.settings),
                tileColor: Colors.teal[50],
                title: Text('Personalize'),
                onTap: () =>
                    Navigator.of(context).pushNamed('/personalizeview'),
              ),
              Divider(color: Colors.teal[50]),
              ListTile(
                leading: Icon(Icons.cloud_download),
                tileColor: Colors.teal[50],
                title: Text('Wipe'),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WipeScreen())),
              ),
              Divider(color: Colors.teal[50]),

              ListTile(
                tileColor: Colors.teal[50],
                leading: Icon(Icons.help_outlined),
                title: Text('Help - FAQ'),
                onTap: () {
                  _launchURL('https://2ndhalf.online/community/foro-faq/');
                },
              ),
              Divider(color: Colors.teal[50]),
              ListTile(
                tileColor: Colors.teal[50],
                leading: Icon(Icons.help_outlined),
                title: Text('Report a bug'),
                onTap: () {
                  _launchURL('https://2ndhalf.online/community/foro-reports/');
                },
              ),
              Divider(color: Colors.teal[50]),
              ListTile(
                tileColor: Colors.teal[50],
                leading: Icon(Icons.help_outlined),
                title: Text('Request a feature'),
                onTap: () {
                  _launchURL('https://2ndhalf.online/community/foro-feature/');
                },
              ),
              Divider(color: Colors.teal[50]),
              ListTile(
                tileColor: Colors.teal[50],
                leading: Icon(Icons.perm_device_info),
                title: Text('About todoMIT'),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'todoMIT',
                    applicationVersion: '1.0.1',
                    applicationLegalese: 'todoMIT will help you manage your Most Important Things / Tasks / Thoughts on [almost] any mobile device! ',
                  );
                },

//                onTap: () => Navigator.of(context)
//                    .push(MaterialPageRoute(builder: (context) => TaskHome())),
              ),

              Divider(color: Colors.teal[50]),
              ListTile(
                tileColor: Colors.teal[50],
                leading: Icon(Icons.connect_without_contact),
                title: Text('Notification [testing]',
                    style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LocalNotificationScreen())),
              ),

              Divider(),
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

  _launchURL(String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }
}
