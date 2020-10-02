import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: 200.0,
                      height: 200.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              scale: 2,
                              image: AssetImage(
                                "asset/img/devimg.png",
                              ))),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Shashwat Priyadarshy",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 25,
                              fontWeight: FontWeight.w800)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                          "Full Stack Web Developer, Flutter Developer,\n UI/UX Designer, Minimalist",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 1.2,
                              color: Colors.grey[900],
                              fontSize: 13,
                              fontWeight: FontWeight.w400)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                          "Undergraduate at NIT Silchar persuing\n Computer Science and Engineering",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 1.2,
                              color: Colors.grey[900],
                              fontSize: 13,
                              fontWeight: FontWeight.w300)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Text(
                          "\"I am in love with technology. This love has helped me develop a very good technological mindset , and given me the curiosity to learn more. I firmly believe that no amount of knowledge is enough knowledge.\"",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 1.5,
                              color: Colors.grey[900],
                              fontSize: 13,
                              fontWeight: FontWeight.w300)),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Text("Follow me",
                            style: TextStyle(
                                height: 1.5,
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w300)),
                        SizedBox(
                          height: 10,
                        ),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
