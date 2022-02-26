import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAMeeting extends StatefulWidget {
  final String sName;
  final String sCode;
  final String about;
  final String startTime;
  final String endTime;
  final String mLink;
  final String firestore;
  const EditAMeeting(this.sName, this.sCode, this.startTime, this.endTime, this.mLink,
      this.about, this.firestore);

  @override
  _EditAMeetingScreenState createState() => _EditAMeetingScreenState();
}

class _EditAMeetingScreenState extends State<EditAMeeting> {
  final meetingForm = GlobalKey<FormState>();

  void validateAndUpdateToDb() {
    final meetingFormData = meetingForm.currentState;
    print(widget.firestore);
    if (meetingFormData.validate()) {
      meetingFormData.save();

      FirebaseFirestore.instance.doc(widget.firestore).update({
        "sName": sName,
        "sCode": sCode,
        "about": about,
        "startTime": startTime,
        "endTime": endTime,
        "link": mLink
      }).then((value) => Navigator.of(context).pop());
    }
  }

  String sName;
  String sCode;
  String about;
  String startTime;
  String endTime;
  String mLink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: formElement(),
    );
  }

  Widget formElement() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.black87,
      child: Form(
        key: meetingForm,
        child: Center(
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Edit Meeting",
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Omit the changes below",
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      )),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "Subject Name",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          TextFormField(
                            initialValue: widget.sName,
                            decoration: const InputDecoration(
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
                            style: const TextStyle(color: Colors.white),
                            validator: (value) => value.isEmpty
                                ? "Subject Name cannot be empty."
                                : null,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => sName = value,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "Subject Code",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          TextFormField(
                            initialValue: widget.sCode,
                            decoration: const InputDecoration(
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
                            style: const TextStyle(color: Colors.white),
                            validator: (value) => value.isEmpty
                                ? "Subject Code cannot be empty."
                                : null,
                            keyboardType: TextInputType.text,
                            onSaved: (value) => sCode = value.toUpperCase(),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "Start Time",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          TextFormField(
                            initialValue: widget.startTime,
                            decoration: const InputDecoration(
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
                            style: const TextStyle(color: Colors.white),
                            validator: (value) => value.isEmpty
                                ? "Start Time cannot be empty."
                                : null,
                            keyboardType: TextInputType.text,
                            onSaved: (value) => startTime = value.toUpperCase(),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "End Time",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          TextFormField(
                            initialValue: widget.endTime,
                            decoration: const InputDecoration(
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
                            style: const TextStyle(color: Colors.white),
                            validator: (value) => value.isEmpty
                                ? "End Time cannot be empty."
                                : null,
                            keyboardType: TextInputType.text,
                            onSaved: (value) => endTime = value.toUpperCase(),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "Link",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          TextFormField(
                            initialValue: widget.mLink,
                            decoration: const InputDecoration(
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
                            style: const TextStyle(color: Colors.white),
                            validator: (value) =>
                                value.isEmpty ? "Link cannot be empty." : null,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => mLink = value,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "About",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          TextFormField(
                            initialValue: widget.about,
                            decoration: const InputDecoration(
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
                            style: const TextStyle(color: Colors.white),
                            validator: (value) =>
                                value.isEmpty ? "About cannot be empty." : null,
                            keyboardType: TextInputType.visiblePassword,
                            // obscureText: true,
                            onSaved: (value) => about = value,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      padding: const EdgeInsets.all(10),
                      onPressed: validateAndUpdateToDb,
                      child: const Text('           Update           ',
                          style: TextStyle(color: Colors.yellow, fontSize: 18)),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.yellow,
                              width: 0.8,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(20)),
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
