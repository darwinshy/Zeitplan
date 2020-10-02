import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:fluttericon/typicons_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "About",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w800)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Zeitplan is Class Management Service (CMS) that aims to manage online classes efficiently.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w300)),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Current version : v1.1",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12, height: 1.25),
                  ),
                ),
                Divider(),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Change your Profile Picture by long pressing on your picture.",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12, height: 1.25),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Features",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12, height: 1.25),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "You can join the Class Meetings easily.",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12, height: 1.25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "You can see your batchmates basic details and Whatsapp them directly, without saving his/her contact",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12, height: 1.25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Change your Profile Picture by long pressing on your picture.",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12, height: 1.25),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(Typicons.facebook),
                            onPressed: () async {
                              const url = 'fb://profile/100003633027901';

                              try {
                                bool launched =
                                    await launch(url, forceWebView: false);

                                if (!launched) {
                                  await launch(url, forceWebView: false);
                                }
                              } catch (e) {
                                await launch(
                                    "https://www.facebook.com/shashwat.priyadarshy.3",
                                    forceWebView: true);
                              }
                            }),
                        IconButton(
                            icon: Icon(AntDesign.github),
                            onPressed: () async {
                              const url = 'https://github.com/reverope';

                              try {
                                bool launched =
                                    await launch(url, forceWebView: false);

                                if (!launched) {
                                  await launch(url, forceWebView: false);
                                }
                              } catch (e) {
                                await launch(url, forceWebView: true);
                              }
                            }),
                        IconButton(
                            icon: Icon(AntDesign.instagram),
                            onPressed: () async {
                              const url =
                                  'https://www.instagram.com/shashu_shashwat';

                              try {
                                bool launched =
                                    await launch(url, forceWebView: false);

                                if (!launched) {
                                  await launch(url, forceWebView: false);
                                }
                              } catch (e) {
                                await launch(url, forceWebView: true);
                              }
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Developed and Designed by",
                        style: TextStyle(
                            height: 1.5,
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w300)),
                    Text("Shashwat Priyadarshy",
                        style: TextStyle(
                            height: 1.5,
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
