import 'dart:async';
import 'components/reusables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/screen-UserChoosePage.dart';
import 'screens/screen-mainScaffold.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootState extends State<Root> {
  AuthStatus signStatus = AuthStatus.notSignedIn;
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  String firstTime;

  void areYouLoggedIn() async {
    SharedPreferences cacheData = await SharedPreferences.getInstance();
    setState(() {
      firstTime = cacheData.getString("welcomeScreenShow");
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
  }

  Future<List<String>> canIaccess() async {
    try {
      connectivityResult = await Connectivity().checkConnectivity();
      final snapShot = await Firestore.instance
          .collection('superadmin')
          .document("access")
          .get();

      return [
        snapShot.data["access"],
        snapShot.data["message"],
        connectivityResult.toString(),
        firstTime
      ];
    } catch (e) {
      print(e);
      return [
        e.toString(),
        "Couldn't connect to the Internet",
        "ConnectivityResult.none",
        firstTime
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      areYouLoggedIn();

      return FutureBuilder<List<String>>(
        initialData: ["true", "Unexpected Error", "null"],
        future: canIaccess(),
        builder: (context, snapshots) {
          // print(snapshots.data);

          if (snapshots.data[2] == "null") {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    animatedLoader(),
                    Text(
                      "Connecting to services, This may take a while.",
                      softWrap: true,
                      style: TextStyle(color: Colors.grey[100]),
                    )
                  ],
                )),
              ),
            );
          }
          if (snapshots.data[2] == "ConnectivityResult.none") {
            return Scaffold(
                backgroundColor: Colors.grey[100],
                body: Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          "asset/img/error.png",
                          width: 200,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Center(
                          child: Text(
                        "No internet connection, \nConnect to Internet and try again.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[900]),
                      )),
                    ],
                  ),
                ));
          }
          if (snapshots.data[0] == "true") {
            switch (signStatus) {
              case AuthStatus.notSignedIn:
                return UserChoosePage();
                break;
              case AuthStatus.signedIn:
                return MainScreenScaffold(snapshots);
              default:
                return UserChoosePage();
            }
          }

          // If Admin Access is revoked
          return Scaffold(
              backgroundColor: Colors.grey[100],
              body: Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "asset/img/error.png",
                        width: 200,
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Center(
                        child: Text(
                      snapshots.data[1].toString(),
                      style: TextStyle(color: Colors.grey[900]),
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
              ));
        },
      );
    } catch (e) {
      return Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "asset/img/error.png",
                    width: 200,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Center(
                    child: Text(
                  "Unknown Error, Contact Administrator",
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ));
    }
  }
}
