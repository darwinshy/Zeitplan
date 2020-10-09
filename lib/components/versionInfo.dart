import '../screens/connectivityScreenRerouter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget info(BuildContext context) {
  return AlertDialog(
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlatButton(
            color: Colors.white,
            onPressed: () async {
              SharedPreferences cacheData =
                  await SharedPreferences.getInstance();
              cacheData.setString("welcomeScreenShow", "true");
              Navigator.of(context).pushReplacement(PageTransition(
                  child: MainScreen(), type: PageTransitionType.fade));
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.black),
            )),
      )
    ],
    backgroundColor: Colors.grey[900],
    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Welcome, \nv1.1\n",
            textAlign: TextAlign.start,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800)),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "New Features",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 12, height: 1.25),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Check what assignments you have to complete.",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 12, height: 1.25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Share your assignment with everyone.",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 12, height: 1.25),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
