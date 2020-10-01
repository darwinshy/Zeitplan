import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget screentitleBoldBig(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: GoogleFonts.montserrat(
        textStyle: TextStyle(
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800)),
  );
}

Widget screentitleBoldMedium(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: GoogleFonts.montserrat(
        textStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
  );
}

void showSomeAlerts(String text, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Colors.grey[100],
          titleTextStyle: TextStyle(color: Colors.grey[900]),
          contentTextStyle: TextStyle(color: Colors.grey[900]),
          title: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        );
      });
}

void showProgressBar(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: Center(child: CircularProgressIndicator()),
        );
      });
}

Widget centerLoading() {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Loading",
        style: TextStyle(color: Colors.white),
      ),
      SizedBox(
        height: 30,
      ),
      CircularProgressIndicator()
    ],
  ));
}

Widget linearProgressbar() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      LinearProgressIndicator(
        backgroundColor: Colors.white,
      )
    ],
  );
}

String giveMePMAM(String time) {
  int hrs = int.parse(time.substring(0, 2));
  String minutes = (time.substring(3, 5));
  // print(time);
  // print(hrs.toString() + " " + minutes.toString());
  String meridian = "AM";
  if (hrs > 12) {
    hrs = hrs - 12;
    meridian = "PM";
  }
  String meridian2 = hrs.toString() + ":" + minutes + " " + meridian;
  // print(meridian2);
  return meridian2;
}
