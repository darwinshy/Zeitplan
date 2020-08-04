import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/loginScreen.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootState extends State<Root> {
  AuthStatus signStatus = AuthStatus.notSignedIn;

  void areYouLoggedIn() async {
    SharedPreferences loggedInStatus = await SharedPreferences.getInstance();

    print(loggedInStatus.getBool('loggedInStatus'));

    if (loggedInStatus.getBool('loggedInStatus') == null) {
      signStatus = AuthStatus.notSignedIn;
    }
    if (loggedInStatus.getBool('loggedInStatus') == true) {
      signStatus = AuthStatus.signedIn;
    }
    if (loggedInStatus.getBool('loggedInStatus') == false) {
      signStatus = AuthStatus.notSignedIn;
    }
  }

  @override
  Widget build(BuildContext context) {
    areYouLoggedIn();
    switch (signStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage();
        break;
      case AuthStatus.signedIn:
        return Scaffold(
          appBar: AppBar(
            title: Text("SignedIn"),
          ),
        );
      default:
        return Scaffold();
    }
  }
}
