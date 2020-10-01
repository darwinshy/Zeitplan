import 'package:Zeitplan/authentication/auth.dart';
import 'package:Zeitplan/screens/ConnectivityScreenRerouter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/screen-login-register-screen.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootState extends State<Root> {
  AuthStatus signStatus = AuthStatus.notSignedIn;

  void areYouLoggedIn() async {
    SharedPreferences cacheData = await SharedPreferences.getInstance();

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
  }

  Future<List<String>> canIaccess() async {
    try {
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      final snapShot = await Firestore.instance
          .collection('superadmin')
          .document("access")
          .get();

      return [
        snapShot.data["access"],
        snapShot.data["message"],
        connectivityResult.toString()
      ];
    } catch (e) {
      print(e);
      return [
        e.toString(),
        "Couldn't connect to the Internet",
        "ConnectivityResult.none"
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    areYouLoggedIn();
    try {
      return FutureBuilder<List<String>>(
        initialData: ["true", "Internet Issues", "null"],
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
                    Text("Connecting to Server"),
                    CircularProgressIndicator(
                      backgroundColor: Colors.yellow,
                    ),
                  ],
                )),
              ),
            );
          }
          if (snapshots.data[2] == "ConnectivityResult.none") {
            return Scaffold(
                backgroundColor: Colors.black,
                body: Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Err..",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 60,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Center(
                          child: Text(
                        "No internet connection",
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                ));
          }
          if (snapshots.data[0] == "true") {
            switch (signStatus) {
              case AuthStatus.notSignedIn:
                return LoginPage(Auth());
                break;
              case AuthStatus.signedIn:
                return MainScreen();
              default:
                return LoginPage(Auth());
            }
          } else {
            return Scaffold(
                backgroundColor: Colors.black,
                body: Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Err..",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 60,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Center(
                          child: Text(
                        snapshots.data[1].toString(),
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                ));
          }
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
                  child: Text(
                    "Err..",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Center(
                    child: Text(
                  "Unknown Error",
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ));
    }
  }
}
