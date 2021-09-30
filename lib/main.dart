import 'package:flutter/material.dart';
import 'package:todo_app/model/taskclass.dart';
import 'package:todo_app/screens/LocalNotification_screen.dart';
import 'package:todo_app/screens/signUp.dart';
import 'package:todo_app/screens/signin.dart';
import 'package:todo_app/screens/personalizeview.dart';
import 'package:todo_app/screens/syncview.dart';
import 'package:todo_app/screens/swipe.dart';
import 'package:todo_app/screens/taskdetail.dart';
import 'package:todo_app/screens/taskhome.dart';

import 'package:flutter_login/flutter_login.dart';

import 'screens/entry.dart';
import 'screens/confirm.dart';
import 'screens/confirm_reset.dart';
import 'screens/notify_screen.dart';

//import 'package:todo_app/screens/ExpandApp.dart';

void main() {
//  runApp(MyApp());
  // runApp(new TileApp1());
  //runApp(Swipe());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      
      // rt testing notification 9.23
//      home: LocalNotificationScreen(), 

      onGenerateRoute: (settings) {
        if (settings.name == '/confirm') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ConfirmScreen(data: settings.arguments as LoginData),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        if (settings.name == '/confirm-reset') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ConfirmResetScreen(data: settings.arguments as LoginData),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        if (settings.name == '/dashboard') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => TaskHome(),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }
        if (settings.name == '/personalizeview') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => PersonalizeView(),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        if (settings.name == '/syncview') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => SyncView(),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        return MaterialPageRoute(builder: (_) => EntryScreen());
      },
    );
  }
}

//Comented by KK to use AMpliyfy Login
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScopeNode currentFocus = FocusScope.of(context);
//         if (!currentFocus.hasPrimaryFocus &&
//             currentFocus.focusedChild != null) {
//           currentFocus.focusedChild.unfocus();
//         }
//       },
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         routes: <String, WidgetBuilder>{
//           '/signup': (BuildContext context) => new SignUpPage(),
//           '/main': (BuildContext context) => new TaskHome(),
//           '/customizeview': (BuildContext context) => new CustomizeView(),
//         },
//         home: new MyHomePage(),

//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         //resizeToAvoidBottomPadding: false,
//         backgroundColor: Colors.yellow[200],
//         body: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 child: Stack(
//                   children: <Widget>[
//                     Container(
//                       padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
//                       child: Text(
//                         'Sign',
//                         style: TextStyle(
//                             fontSize: 80.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.brown[700]),
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.fromLTRB(15.0, 175.0, 0.0, 0.0),
//                       child: Text(
//                         'in',
//                         style: TextStyle(
//                             fontSize: 80.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.brown[700]),
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.fromLTRB(80.0, 175.0, 0.0, 0.0),
//                       child: Text(
//                         '.',
//                         style: TextStyle(
//                             fontSize: 80.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                   padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
//                   child: Column(
//                     children: <Widget>[
//                       TextField(
//                         decoration: InputDecoration(
//                             labelText: 'EMAIL',
//                             labelStyle: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey,
//                             ),
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.green),
//                             )),
//                       ),
//                       SizedBox(
//                         height: 20.0,
//                       ),
//                       TextField(
//                         decoration: InputDecoration(
//                             labelText: 'PASSWORD',
//                             labelStyle: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey,
//                             ),
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.green),
//                             )),
//                         obscureText: true,
//                       ),
//                       SizedBox(
//                         height: 5.0,
//                       ),
//                       Container(
//                         alignment: Alignment(1.0, 0.0),
//                         padding: EdgeInsets.only(top: 15.0, left: 20.0),
//                         child: InkWell(
//                             child: Text(
//                           'Forgot Password',
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                             decoration: TextDecoration.underline,
//                           ),
//                         )),
//                       ),
//                       SizedBox(height: 40.0),
//                       Container(
//                         height: 40.0,
//                         child: Material(
//                           borderRadius: BorderRadius.circular(20.0),
//                           shadowColor: Colors.greenAccent,
//                           color: Colors.green,
//                           elevation: 7.0,
//                           child: GestureDetector(
//                             onTap: () {
// // dismiss soft input keyboard
//                               FocusScope.of(context)
//                                   .requestFocus(new FocusNode());
//                               Navigator.of(context).pushNamed('/main');
//                             },
//                             child: Center(
//                               child: Text(
//                                 'LOGIN',
//                                 style: TextStyle(
//                                   color: Colors.brown[700],
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20.0,
//                       ),
//                       Container(
//                         height: 40.0,
//                         color: Colors.transparent,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.black,
//                               style: BorderStyle.solid,
//                               width: 1.0,
//                             ),
//                             color: Colors.transparent,
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Center(
//                                 child: Text('f'),
//                               ),
//                               SizedBox(
//                                 width: 10.0,
//                               ),
//                               Center(
//                                 child: Text(
//                                   'Log in with Facebook',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   )),
//               SizedBox(
//                 height: 15.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'New to Todo?',
//                     style: TextStyle(),
//                   ),
//                   SizedBox(
//                     width: 5.0,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.of(context).pushNamed('/signup');
//                     },
//                     child: Text(
//                       'Register',
//                       style: TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ]));
//   }
// }
