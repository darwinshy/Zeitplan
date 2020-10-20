import 'dart:ui';

import '../components/reusables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:fluttericon/typicons_icons.dart';

import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> reportBug() async {
      const url =
          'mailto:shatish123123@gmail.com?subject=Reporting a Bug&body=Note : Bug description must be brief. \n';

      try {
        bool launched = await launch(url, forceWebView: false);

        if (!launched) {
          await launch(url, forceWebView: false);
        }
      } catch (e) {
        SnackBar(
          content: Text("Something went wrong"),
        );
      }
    }

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
            screentitleBoldBig("About"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Zeitplan is Class Management Service (CMS) that aims to manage classes efficiently.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w300)),
                ),
                SizedBox(
                  height: 5,
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
                    "1. Share and get assigments with your batchmates.",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12, height: 1.25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "2. Share and get Question Paper from the Question Bank.",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12, height: 1.25),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Divider(),
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
                    "1. Join the Class meetings easily.",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12, height: 1.25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "2. See batchmates basic details and Whatsapp them directly, without saving his/her contact.",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12, height: 1.25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "3. Change your Profile Picture by long pressing on your picture.",
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
                                  'https://www.instagram.com/i_am_the_darwin';

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
            InkWell(
              onTap: reportBug,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Report a bug",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
