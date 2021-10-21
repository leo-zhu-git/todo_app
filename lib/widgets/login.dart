import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:todo_app/screens/taskdetail.dart';

import '../amplifyconfiguration.dart';
import 'package:todo_app/model/todouser.dart';
import 'package:todo_app/util/dbhelper.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginData? _data;
  bool _isSignedIn = false;
  var _todoUser = todoUser();

  Future<String?> _onLogin(LoginData data) async {
    bool _amplifyConfigured = false;

    //rt  if (Amplify.isConfigured == false)
    //rt  {
    Amplify.addPlugin(AmplifyAuthCognito());
    try {
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
    } on AmplifyAlreadyConfiguredException {
      print(
          "Amplify was already configured. Looks like app restarted on android.");
    }
    //rt  }
    //
    final AuthSession res = await Amplify.Auth.fetchAuthSession();
    if (res.isSignedIn) {
      await Amplify.Auth.signOut();
    }
    try {
      //call signin method
      final res = await Amplify.Auth.signIn(
        username: data.name,
        password: data.password,
      );

      _isSignedIn = res.isSignedIn;
      AuthUser _user;

      Amplify.Auth.getCurrentUser().then((user) {
        setState(() {
          _user = user;
          String userID = _user.userId;
          String username = _user.username;

          _todoUser.email = username;
          _todoUser.userID = userID;
          dbHelper.insertUser(_todoUser);
        });
      }).catchError((error) {
        print((error as AuthException).message);
      });
    } on AuthException catch (e) {
      if (e.message.contains('already a user which is signed in')) {
        await Amplify.Auth.signOut();
        return 'Problem logging in. Please try again.';
      }

      return '${e.message} - ${e.recoverySuggestion}';
    }
  }

  Future<String?> _onRecoverPassword(BuildContext context, String email) async {
    bool _amplifyConfigured = false;

    //rt  if (Amplify.isConfigured == false)
    //rt  {
    Amplify.addPlugin(AmplifyAuthCognito());
    try {
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
    } on AmplifyAlreadyConfiguredException {
      print(
          "Amplify was already configured. Looks like app restarted on android.");
    }
    //rt  }
    //
    final AuthSession res = await Amplify.Auth.fetchAuthSession();
    if (res.isSignedIn) {
      await Amplify.Auth.signOut();
    }

    try {
      final res = await Amplify.Auth.resetPassword(username: email);

      if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
        Navigator.of(context).pushReplacementNamed(
          '/confirm-reset',
          arguments: LoginData(name: email, password: ''),
        );
      }
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
  }

  Future<String?> _onSignup(LoginData data) async {
    bool _amplifyConfigured = false;

//rt    if (Amplify.isConfigured == false)
//rt    {
    Amplify.addPlugin(AmplifyAuthCognito());
    try {
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
    } on AmplifyAlreadyConfiguredException {
      print(
          "Amplify was already configured. Looks like app restarted on android.");
    }
    //rt  }
    //
    final AuthSession res = await Amplify.Auth.fetchAuthSession();
    if (res.isSignedIn) {
      await Amplify.Auth.signOut();
    }

    try {
      await Amplify.Auth.signUp(
        username: data.name,
        password: data.password,
        options: CognitoSignUpOptions(userAttributes: {
          'email': data.name,
        }),
      );

      _data = data;
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Welcome',
      onLogin: _onLogin,
      onRecoverPassword: (String email) => _onRecoverPassword(context, email),
      onSignup: _onSignup,
      theme: LoginTheme(
        primaryColor: Theme.of(context).primaryColor,
      ),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed(
          _isSignedIn ? '/dashboard' : '/confirm',
          arguments: _data,
        );
      },
    );
  }
}
