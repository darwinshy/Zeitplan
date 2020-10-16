import 'dart:async';
import 'components/reusables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/screen-userChoosePage.dart';
import 'screens/screen-mainScaffold.dart';

enum AuthStatus { notSignedIn, signedIn }

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  AuthStatus signStatus = AuthStatus.notSignedIn;

  void alreadyloggedInStatus() async {
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

  Stream<QuerySnapshot> getAdminAccessStatus() {
    return Firestore.instance
        .collection("superadmin")
        .where("type", isEqualTo: "access")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    alreadyloggedInStatus();
    // ########################################################################
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().checkConnectivity().asStream(),
      builder: (context, snapshotOfConnectivity) {
        // #####################################################################
        return StreamBuilder<QuerySnapshot>(
            stream: getAdminAccessStatus(),
            builder: (context, snapshotOfSuperAdmin) {
              // ###############################################################
              try {
                if (snapshotOfConnectivity.hasData &&
                    snapshotOfSuperAdmin.hasData) {
                  // ###########################################################
                  bool superAccess = snapshotOfSuperAdmin.data.documents
                              .elementAt(0)
                              .data["access"] ==
                          "true"
                      ? true
                      : false;
                  String superMessage = snapshotOfSuperAdmin.data.documents
                      .elementAt(0)
                      .data["message"];
                  // ###########################################################
                  switch (snapshotOfConnectivity.data) {
                    case ConnectivityResult.none:
                      return noConnectionScreen();
                      break;
                    case ConnectivityResult.wifi:
                      return adminAndAuthRerouter(superAccess, superMessage);
                      break;
                    case ConnectivityResult.mobile:
                      return adminAndAuthRerouter(superAccess, superMessage);
                      break;
                    default:
                      return connectingScreen();
                  }
                } else {
                  return connectingScreen();
                }
              } catch (e) {
                return errorScreen();
              }
              // ###############################################################
            });
      },
    );
  }

  Widget adminAndAuthRerouter(bool superAccess, String superMessage) {
    if (superAccess == true) {
      switch (signStatus) {
        case AuthStatus.notSignedIn:
          return UserChoosePage();
          break;
        case AuthStatus.signedIn:
          return MainScreenScaffold();
        default:
          return UserChoosePage();
      }
    } else {
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
                  superMessage,
                  style: TextStyle(color: Colors.grey[900]),
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ));
    }
  }

  Widget noConnectionScreen() {
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

  Widget connectingScreen() {
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

  Widget errorScreen() {
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
