import '../components/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/reusables.dart';

BuildContext globalContext;

class AddMeetingScreen extends StatefulWidget {
  @override
  _AddMeetingScreenState createState() => _AddMeetingScreenState();
}

class _AddMeetingScreenState extends State<AddMeetingScreen> {
  final meetingForm = new GlobalKey<FormState>();

  String sName;
  String sCode;
  String about;
  String startTime;
  String endTime;
  String mStatus = "1";
  String mLink;

  void validateAndSaveToDb() async {
    showProgressBar(globalContext);
    SharedPreferences cacheData = await SharedPreferences.getInstance();
    String dbUrl = cacheData.getString("dbUrlSchedules").toString();
    final meetingFormData = meetingForm.currentState;
    if (meetingFormData.validate()) {
      meetingFormData.save();

      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('ddMMyyyy');
      final String formatted = formatter.format(now);

      Firestore.instance
          .collection(dbUrl)
          .document(formatted)
          .collection("meetings")
          .add({
        "sName": sName,
        "sCode": sCode,
        "about": about,
        "startTime": startTime,
        "endTime": endTime,
        "mStatus": mStatus,
        "link": mLink
      }).then((_) => {
                print("######################################################"),
                print("##### Meeting Data Added to Database #####"),
                print("sName       : " + sName),
                print("sCode       : " + sCode),
                print("about       : " + about),
                print("startTime   : " + startTime),
                print("endTime     : " + endTime),
                print("link        : " + mLink),
                print("######################################################"),
                showPromisedSomeAlerts(
                        "You have successfully added a meeting. You can join the meeting from the meetings section.",
                        globalContext)
                    .then((_) => {
                          Navigator.of(context).pop(),
                          Navigator.of(context).pop()
                        }),
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      body: formElement(),
    );
  }

  Widget formElement() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.black87,
      child: Form(
        key: meetingForm,
        child: Center(
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FadeInLTR(
                1,
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      screentitleBoldMedium("Add a meeting"),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "You cannot add meeting prior of Today",
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 75, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FadeInLTR(
                      1.3,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Subject Name",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.4,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value) => value.isEmpty
                                  ? "Subject Name cannot be empty."
                                  : null,
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) => sName = value,
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      1.6,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Subject Code",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.4,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value) => value.isEmpty
                                  ? "Subject Code cannot be empty."
                                  : null,
                              keyboardType: TextInputType.text,
                              onSaved: (value) => sCode = value.toUpperCase(),
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      1.9,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Start Time",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.4,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value) => value.isEmpty
                                  ? "Start Time cannot be empty."
                                  : null,
                              keyboardType: TextInputType.text,
                              onSaved: (value) =>
                                  startTime = value.toUpperCase(),
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      2.1,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "End Time",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.4,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value) => value.isEmpty
                                  ? "End Time cannot be empty."
                                  : null,
                              keyboardType: TextInputType.text,
                              onSaved: (value) => endTime = value.toUpperCase(),
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      2.4,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Link",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.4,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value) => value.isEmpty
                                  ? "Link cannot be empty."
                                  : null,
                              keyboardType: TextInputType.url,
                              onSaved: (value) => mLink = value,
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      2.7,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "About",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.4,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value) => value.isEmpty
                                  ? "About cannot be empty."
                                  : null,
                              keyboardType: TextInputType.visiblePassword,
                              // obscureText: true,
                              onSaved: (value) => about = value,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeInLTR(
                      3.2,
                      FlatButton(
                        padding: EdgeInsets.all(10),
                        onPressed: validateAndSaveToDb,
                        child: Text('           Add           ',
                            style:
                                TextStyle(color: Colors.yellow, fontSize: 18)),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.yellow,
                                width: 0.8,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
