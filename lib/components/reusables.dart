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
