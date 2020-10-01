import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/screen-main.dart';

BuildContext globalContext;

class Schedules extends StatefulWidget {
  @override
  _SchedulesState createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  @override
  Widget build(BuildContext context) {
    Future<List<String>> canIaccess() async {
      try {
        SharedPreferences cacheData = await SharedPreferences.getInstance();
        ConnectivityResult connectivityResult =
            await Connectivity().checkConnectivity();
        final snapShot = await Firestore.instance
            .collection('superadmin')
            .document("access")
            .get();

        // print(connectivityResult);
        return [
          snapShot.data["access"],
          snapShot.data["message"],
          connectivityResult.toString(),
          cacheData.getString("welcomeScreenShow")
        ];
      } catch (e) {
        print(e);
        return [
          e.toString(),
          "Couldn't connect to the Internet",
          "ConnectivityResult.none",
          "true",
          "null"
        ];
      }
    }

// For connectivity status
// ###################################################################
    return FutureBuilder<List<String>>(
      initialData: ["true", "Internet Issues", "null", "null"],
      future: canIaccess(),
      builder: (context, snapshots) {
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
          return MainScreenScaffold(snapshots);
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
  }
}
