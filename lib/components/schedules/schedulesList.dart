import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../dashboard/dashboardTile.dart';
import '../schedules/schedulesItem.dart';
import '../../screens/meetingsScreen/screen-mainScaffold.dart';
import '../animations.dart';
import '../reusables.dart';

Widget buildSchedulesBody(
    void Function() refresh,
    BuildContext context,
    Future<List<String>> retriveProfileDetails,
    String formatted,
    String crStatus) {
  return FutureBuilder<List<String>>(
      future: retriveProfileDetails,
      builder: (context, snapshot) {
        try {
          if (snapshot.hasData) {
            return streamBuildSchedules(refresh, snapshot, formatted, crStatus);
          } else {
            return Center();
          }
        } catch (e) {
          return Center();
        }
      });
}

Widget streamBuildSchedules(void Function() refresh,
    AsyncSnapshot<List<String>> cacheData, String formatted, String crStatus) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(cacheData.data.elementAt(11))
          .doc(formatted)
          .collection("meetings")
          .orderBy(
            "mStatus",
            descending: false,
          )
          .snapshots(),
      builder: (context, snapshots) {
        try {
          print(snapshots.data);
          return buildListofSchedules(
              context, refresh, snapshots.data.docs, cacheData.data, crStatus);
        } catch (e) {
          print("streamBuildSchedules" + e.toString());
          return centerLoading();
        }
      });
}

Widget buildListofSchedules(
  BuildContext context,
  void Function() refresh,
  List<DocumentSnapshot> documents,
  List<String> retriveProfileDetails,
  String crStatus,
) {
  try {
    return ListView(
      padding: const EdgeInsets.only(top: 10.0),
      children: <Widget>[
        FadeIn(1, dashboardTile(retriveProfileDetails, context, refresh)),
        SizedBox(
          height: 30,
        ),
        (documents.length != 0)
            ? FadeIn(1.5, schedulesColumn(documents, refresh, crStatus))
            : FadeIn(1.5, noMeetings())
      ],
    );
  } catch (e) {
    print("buildListofSchedules" + e.toString());
    return Center();
  }
}

Widget schedulesColumn(
    List<DocumentSnapshot> documents, void refresh(), String crStatus) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Ongoing",
          style: TextStyle(color: Colors.grey),
        ),
      ),
      ...documents
          .map((data) => itemTileL(
              refresh, data, data.reference, crStatus, mainScaffoldContext))
          .toList(),
      Divider(
        color: Colors.grey[800],
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Scheduled",
          style: TextStyle(color: Colors.grey),
        ),
      ),
      ...documents
          .map((data) => itemTileS(
              refresh, data, data.reference, crStatus, mainScaffoldContext))
          .toList(),
      Divider(
        color: Colors.grey[800],
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Completed", style: TextStyle(color: Colors.grey)),
      ),
      ...documents
          .map((data) => itemTileC(
              refresh, data, data.reference, crStatus, mainScaffoldContext))
          .toList(),
      Divider(
        color: Colors.grey[800],
      ),
    ],
  );
}

Widget noMeetings() {
  return Container(
    margin: EdgeInsets.only(top: 100),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Image.asset(
          "asset/img/nomeeting.png",
          height: 150,
        )),
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: Text(
            "No classes scheduled today.\n Ask your Class Representative to add one.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        )
      ],
    ),
  );
}
