import 'package:Zeitplan/authentication/auth.dart';
import 'package:Zeitplan/screens/schedules.dart';
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
    SharedPreferences cacheData = await SharedPreferences.getInstance();

    // print(cacheData.getBool('loggedInStatus'));
    setState(() {
      if (cacheData.getBool('loggedInStatus') == null) {
        signStatus = AuthStatus.notSignedIn;
      }
      if (cacheData.getBool('loggedInStatus') == true) {
        signStatus = AuthStatus.signedIn;
      }
      if (cacheData.getBool('loggedInStatus') == false) {
        signStatus = AuthStatus.notSignedIn;
      }
    });

    // print(signStatus);
  }

  @override
  Widget build(BuildContext context) {
    areYouLoggedIn();
    switch (signStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage(Auth());
        break;
      case AuthStatus.signedIn:
        return Schedules();
      default:
        return LoginPage(Auth());
    }
  }
}
