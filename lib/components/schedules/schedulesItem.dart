import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../screens/screen-edit-meeting.dart';
import '../../classes/classes.dart';

bool isEmptyL = true, isEmptyS = true, isEmptyC = true;

Widget itemTileL(
    void Function() refresh,
    DocumentSnapshot data,
    DocumentReference reference,
    String crStatus,
    BuildContext mainScaffoldContext) {
  final record = Schedule.fromSnapshot(data);
  if (record.meetingStatus == "0") {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      color: Colors.grey[900],
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Text(
            record.subjectCode.toString().substring(0, 2),
            style: TextStyle(
                color: Colors.grey[900],
                fontSize: 12,
                fontWeight: FontWeight.w700),
          ),
        ),
        subtitle: Text(
          record.startTime + " to " + record.endTime,
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
        title: Text(
          record.subjectName.toString(),
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        trailing: meetingStatus(record.meetingStatus.toString()),
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(record.about.toString()),
              ),
            ],
          ),
          (crStatus == "true")
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.surround_sound),
                              onPressed: () => {
                                    showDialog(
                                      context: mainScaffoldContext,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          actions: <Widget>[
                                            FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                onPressed: () => {
                                                      reference.firestore
                                                          .document(
                                                              reference.path)
                                                          .updateData(
                                                              {"mStatus": "0"})
                                                    },
                                                child: Text("Live")),
                                            FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                onPressed: () => {
                                                      reference.firestore
                                                          .document(
                                                              reference.path)
                                                          .updateData(
                                                              {"mStatus": "2"})
                                                    },
                                                child: Text("Completed")),
                                            FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                onPressed: () => {
                                                      reference.firestore
                                                          .document(
                                                              reference.path)
                                                          .updateData(
                                                              {"mStatus": "1"})
                                                    },
                                                child: Text("Sceduled"))
                                          ],
                                        );
                                      },
                                    )
                                  }),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                            ),
                            onPressed: () => {
                              Navigator.of(mainScaffoldContext).push(
                                  PageTransition(
                                      child: EditAMeeting(
                                          record.subjectName,
                                          record.subjectCode,
                                          record.startTime,
                                          record.endTime,
                                          record.link,
                                          record.about,
                                          reference.path),
                                      type: PageTransitionType.fade))
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => {
                              reference.firestore
                                  .document(reference.path)
                                  .delete()
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 0.8,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text("       Join Meeting       "),
                          onPressed: () async {
                            try {
                              bool launched = await launch(record.link,
                                  forceWebView: false);

                              if (!launched) {
                                await launch(record.link, forceWebView: false);
                              }
                            } catch (e) {
                              showDialog(
                                  context: mainScaffoldContext,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                          "Something is not right, contact CR."),
                                    );
                                  });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.white,
                            width: 0.8,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text("       Join Meeting       "),
                    onPressed: () async {
                      try {
                        bool launched =
                            await launch(record.link, forceWebView: false);

                        if (!launched) {
                          await launch(record.link, forceWebView: false);
                        }
                      } catch (e) {
                        showDialog(
                            context: mainScaffoldContext,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content:
                                    Text("Something is not right, contact CR."),
                              );
                            });
                      }
                    },
                  ),
                )
        ],
      ),
    );
  } else {
    return Center();
  }
}

Widget itemTileS(
    void Function() refresh,
    DocumentSnapshot data,
    DocumentReference reference,
    String crStatus,
    BuildContext mainScaffoldContext) {
  final record = Schedule.fromSnapshot(data);

  if (record.meetingStatus == "1") {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      color: Colors.grey[900],
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Text(
            record.subjectCode.toString().substring(0, 2),
            style: TextStyle(
                color: Colors.grey[900],
                fontSize: 12,
                fontWeight: FontWeight.w700),
          ),
        ),
        subtitle: Text(
          record.startTime + " to " + record.endTime,
          style: TextStyle(fontSize: 10),
        ),
        title: Text(
          record.subjectName.toString(),
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        trailing: meetingStatus(record.meetingStatus.toString()),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(record.about.toString()),
          ),
          (crStatus == "true")
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.surround_sound),
                              onPressed: () => {
                                    showDialog(
                                      context: mainScaffoldContext,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          actions: <Widget>[
                                            FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                onPressed: () => {
                                                      reference.firestore
                                                          .document(
                                                              reference.path)
                                                          .updateData(
                                                              {"mStatus": "0"})
                                                    },
                                                child: Text("Live")),
                                            FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                onPressed: () => {
                                                      reference.firestore
                                                          .document(
                                                              reference.path)
                                                          .updateData(
                                                              {"mStatus": "2"})
                                                    },
                                                child: Text("Completed")),
                                            FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                onPressed: () => {
                                                      reference.firestore
                                                          .document(
                                                              reference.path)
                                                          .updateData(
                                                              {"mStatus": "1"})
                                                    },
                                                child: Text("Sceduled"))
                                          ],
                                        );
                                      },
                                    )
                                  }),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                            ),
                            onPressed: () => {
                              Navigator.of(mainScaffoldContext).push(
                                  PageTransition(
                                      child: EditAMeeting(
                                          record.subjectName,
                                          record.subjectCode,
                                          record.startTime,
                                          record.endTime,
                                          record.link,
                                          record.about,
                                          reference.path),
                                      type: PageTransitionType.fade))
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => {
                              reference.firestore
                                  .document(reference.path)
                                  .delete()
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 0.8,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text("       Join Meeting       "),
                          onPressed: () async {
                            try {
                              bool launched = await launch(record.link,
                                  forceWebView: false);

                              if (!launched) {
                                await launch(record.link, forceWebView: true);
                              }
                            } catch (e) {
                              showDialog(
                                  context: mainScaffoldContext,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                          "Something is not right, contact CR."),
                                    );
                                  });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.white,
                            width: 0.8,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text("       Join Meeting       "),
                    onPressed: () async {
                      try {
                        bool launched =
                            await launch(record.link, forceWebView: false);

                        if (!launched) {
                          await launch(record.link, forceWebView: false);
                        }
                      } catch (e) {
                        showDialog(
                            context: mainScaffoldContext,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content:
                                    Text("Something is not right, contact CR."),
                              );
                            });
                      }
                    },
                  ),
                )
        ],
      ),
    );
  } else {
    return Center();
  }
}

Widget itemTileC(
    void Function() refresh,
    DocumentSnapshot data,
    DocumentReference reference,
    String crStatus,
    BuildContext mainScaffoldContext) {
  final record = Schedule.fromSnapshot(data);

  if (record.meetingStatus == "2") {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      color: Colors.grey[900],
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Text(
            record.subjectCode.toString().substring(0, 2),
            style: TextStyle(
                color: Colors.grey[900],
                fontSize: 12,
                fontWeight: FontWeight.w700),
          ),
        ),
        subtitle: Text(
          record.startTime + " to " + record.endTime,
          style: TextStyle(fontSize: 10),
        ),
        title: Text(
          record.subjectName.toString(),
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        trailing: meetingStatus(record.meetingStatus.toString()),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(record.about.toString()),
          ),
          (crStatus == "true")
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.surround_sound),
                          onPressed: () => {
                                showDialog(
                                  context: mainScaffoldContext,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      actions: <Widget>[
                                        FlatButton(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                            onPressed: () => {
                                                  reference.firestore
                                                      .document(reference.path)
                                                      .updateData(
                                                          {"mStatus": "0"})
                                                },
                                            child: Text("Live")),
                                        FlatButton(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                            onPressed: () => {
                                                  reference.firestore
                                                      .document(reference.path)
                                                      .updateData(
                                                          {"mStatus": "2"})
                                                },
                                            child: Text("Completed")),
                                        FlatButton(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                            onPressed: () => {
                                                  reference.firestore
                                                      .document(reference.path)
                                                      .updateData(
                                                          {"mStatus": "1"})
                                                },
                                            child: Text("Sceduled"))
                                      ],
                                    );
                                  },
                                )
                              }),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                        ),
                        onPressed: () => {
                          Navigator.of(mainScaffoldContext).push(PageTransition(
                              child: EditAMeeting(
                                  record.subjectName,
                                  record.subjectCode,
                                  record.startTime,
                                  record.endTime,
                                  record.link,
                                  record.about,
                                  reference.path),
                              type: PageTransitionType.fade))
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () => {
                          reference.firestore.document(reference.path).delete()
                        },
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(0.0),
                )
        ],
      ),
    );
  } else {
    return Center();
  }
}

meetingStatus(String x) {
  if (x == "0")
    return Container(
      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
      decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: Text(
        "Live",
        style: TextStyle(color: Colors.red[700]),
      ),
    );
  else if (x == "1") {
    return Text(
      "Upcoming",
      style: TextStyle(color: Colors.yellow),
    );
  }
  if (x == "2")
    return Text(
      "Completed",
      style: TextStyle(color: Colors.grey),
    );
}
