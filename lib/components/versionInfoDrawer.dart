import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void infoDrawer(BuildContext context) {
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          actions: [
            FlatButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.black),
                ))
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
                  "Welcome, \nv1.0\n",
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "You can join the Class Meeting by tapping on \"Join Meeting\"",
                        style: TextStyle(fontSize: 12, height: 1.25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "You can see your batchmates basic details and Whatsapp them directly, without saving his/her contact",
                        style: TextStyle(fontSize: 12, height: 1.25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Change your Profile Picture by long pressing on your picture.",
                        style: TextStyle(fontSize: 12, height: 1.25),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}
