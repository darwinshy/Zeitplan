import 'dart:async';
import 'components/reusables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/screen-userChoosePage.dart';
import 'screens/meetingsScreen/screen-mainScaffold.dart';

enum AuthStatus { notSignedIn, signedIn }

class Root extends StatefulWidget {
  const Root({Key key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    alreadyloggedInStatus();
  }

  Stream<QuerySnapshot> getAdminAccessStatus() {
    return FirebaseFirestore.instance
        .collection("superadmin")
        .where("type", isEqualTo: "access")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: getAdminAccessStatus(),
        builder: (context, snapshotOfSuperAdmin) {
          // ###############################################################
          try {
            if (snapshotOfSuperAdmin.hasData) {
              // ###########################################################
              bool superAccess = (snapshotOfSuperAdmin.data.docs
                          .elementAt(0)
                          .data() as Map)['access'] ==
                      "true"
                  ? true
                  : false;
              String superMessage = (snapshotOfSuperAdmin.data.docs
                  .elementAt(0)
                  .data() as Map)["message"];
              // ###########################################################

              return adminAndAuthRerouter(superAccess, superMessage);
            } else {
              return connectingScreen();
            }
          } catch (e) {
            return errorScreen();
          }
          // ###############################################################
        });
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
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "asset/img/developererror.png",
                    width: 200,
                  ),
                ),
                const SizedBox(
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
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "asset/img/error.png",
                  width: 200,
                ),
              ),
              const SizedBox(
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
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "asset/img/error.png",
                  width: 200,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Center(
                  child: Text(
                "Unknown Error, Contact Administrator",
                textAlign: TextAlign.center,
              )),
            ],
          ),
        ));
  }
}
