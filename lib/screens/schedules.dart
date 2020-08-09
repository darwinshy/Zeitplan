import 'package:Zeitplan/authentication/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../root.dart';

class Schedules extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ###################################################################
    // Date Formatting
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMM');
    final String formatted = formatter.format(now);
    // ###################################################################
    // Fetching Cache Data
    Future<String> retriveScheduleURL() async {
      SharedPreferences cacheData = await SharedPreferences.getInstance();
      return cacheData.getString("dbUrlSchedules").toString();
    }

    Future<List<String>> retriveProfileDetails() async {
      SharedPreferences cacheData = await SharedPreferences.getInstance();
      return [
        cacheData.getString("fullname").toString(),
        cacheData.getString("email").toString(),
        cacheData.getString("phone").toString(),
        cacheData.getString("scholarId").toString(),
        cacheData.getString("section").toString(),
        cacheData.getString("batchYear").toString(),
        cacheData.getString("branch").toString(),
        cacheData.getBool("CR").toString()
      ];
    }

    // Future<String> retriveUID() async {
    //   SharedPreferences cacheData = await SharedPreferences.getInstance();
    //   return cacheData.getString("userUID").toString();
    // }

    // ###################################################################
    // retriveData();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
            child: Text(
              formatted,
              style: TextStyle(
                  fontFamily: "rob", color: Colors.white, fontSize: 12),
            ),
          ),
          title: Text(
            "Zeitplan",
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -1),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Auth().signOut().whenComplete(() async {
                  SharedPreferences cacheData =
                      await SharedPreferences.getInstance();
                  cacheData.clear();
                  cacheData.setBool("loggedInStatus", false);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return Root();
                      },
                    ),
                  );
                });
              },
            )
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => {print("Add")},
        //   isExtended: true,
        // ),
        backgroundColor: Colors.black87,
        body: _buildSchedulesBody(
          context,
          retriveScheduleURL,
          retriveProfileDetails,
        ));
  }
}

Widget _buildSchedulesBody(
    BuildContext context,
    Future<String> Function() retriveScheduleURL,
    Future<List<String>> Function() retriveProfileDetails) {
  return FutureBuilder<String>(
      future: retriveScheduleURL(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return _streamBuild(snapshot, retriveProfileDetails);
        } else {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ));
        }
      });
}

Widget _streamBuild(AsyncSnapshot<String> snapshot,
    Future<List<String>> Function() retriveProfileDetails) {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('ddMMyyyy');
  final String formatted = formatter.format(now);
  // print(snapshot.data);
  // return Text("data");

  // print(Firestore.instance
  //     .collection(snapshot.data)
  //     .document(formatted)
  //     .collection("meetings")
  //     .path);

  return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(snapshot.data)
          .document(formatted)
          .collection("meetings")
          .orderBy(
            "mStatus",
            descending: false,
          )
          .snapshots(),
      builder: (context, snapshots) {
        try {
          // print(snapshots.data.documents);
          // print(Firestore.instance
          //     .collection(snapshot.data)
          //     .document(formatted)
          //     .collection("meetings")
          //     .path);
          return _buildListofSchedules(
              snapshots.data.documents, retriveProfileDetails);
        } catch (e) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Error",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ));
        }
      });
}

Widget _buildListofSchedules(List<DocumentSnapshot> documents,
    Future<List<String>> Function() retriveProfileDetails) {
  Color badgeBg = Colors.grey[700];
  Color badgeBgGold = Color.fromRGBO(229, 194, 102, 1);
  Color badgeTx = Colors.white;
  Color badgeTxGold = Color.fromRGBO(92, 68, 0, 1);
  // print(documents.elementAt(0).data);
  try {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: <Widget>[
        FutureBuilder(
            future: retriveProfileDetails(),
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              return Container(
                decoration: BoxDecoration(
                    color: (snapshot.data.elementAt(7) == "false")
                        ? badgeBg
                        : badgeBgGold,
                    borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.fromLTRB(20, 30, 30, 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                            child: Text(
                              snapshot.data.elementAt(0),
                              style: TextStyle(
                                  color: (snapshot.data.elementAt(7) == "false")
                                      ? badgeTx
                                      : badgeTxGold,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                            child: Text(
                              snapshot.data.elementAt(1),
                              style: TextStyle(
                                fontSize: 12,
                                color: (snapshot.data.elementAt(7) == "false")
                                    ? badgeTx
                                    : badgeTxGold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 18, 4, 2),
                            child: Text(
                              snapshot.data.elementAt(6),
                              style: TextStyle(
                                color: (snapshot.data.elementAt(7) == "false")
                                    ? badgeTx
                                    : badgeTxGold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Ongoing",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ...documents.map((data) => _itemTileL(data)).toList(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Scheduled"),
            ),
            ...documents.map((data) => _itemTileS(data)).toList(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Completed"),
            ),
            ...documents.map((data) => _itemTileC(data)).toList()
          ],
        )
      ],
    );
  } catch (e) {
    print(e);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Sorry, there must a technical error !",
          style: TextStyle(color: Colors.white),
        ),
      ],
    ));
  }
}

Widget _itemTileL(DocumentSnapshot data) {
  final record = Schedule.fromSnapshot(data);
  if (record.meetingStatus == "0") {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      color: Colors.grey[900],
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[800],
          child: Text(
            record.subjectCode.toString().substring(0, 2),
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
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
          )
        ],
      ),
    );
  } else {
    return Center();
  }
}

Widget _itemTileS(DocumentSnapshot data) {
  final record = Schedule.fromSnapshot(data);

  if (record.meetingStatus == "1") {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      color: Colors.grey[900],
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[800],
          child: Text(
            record.subjectCode.toString().substring(0, 2),
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
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
          )
        ],
      ),
    );
  } else {
    return Center();
  }
}

Widget _itemTileC(DocumentSnapshot data) {
  final record = Schedule.fromSnapshot(data);

  if (record.meetingStatus == "2") {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      color: Colors.grey[900],
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[800],
          child: Text(
            record.subjectCode.toString().substring(0, 2),
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
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
    return Text(
      "Live",
      style: TextStyle(color: Colors.red[700]),
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

class Schedule {
  final String subjectCode;
  final String subjectName;
  final String startTime;
  final String endTime;
  final String link;
  final String about;
  final String meetingStatus;
  final DocumentReference reference;

  Schedule.fromMap(Map<String, dynamic> map, {this.reference})
      : subjectCode = map['sCode'],
        subjectName = map['sName'],
        startTime = map['startTime'],
        endTime = map['endTime'],
        about = map['about'],
        link = map['link'],
        meetingStatus = map["mStatus"];

  Schedule.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
