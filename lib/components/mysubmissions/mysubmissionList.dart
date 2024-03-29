import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../streamproviders.dart';
import '../animations.dart';
import '../reusables.dart';
import 'mySubmissionItem.dart';

BuildContext globalContenxt;
Widget buildMySubmissionList(BuildContext context) {
  globalContenxt = context;
  final sharedpreferencedata =
      Provider.of<SharedPreferencesProviders>(context, listen: false);
// Streaming Shared Preference Data
  return FutureBuilder(
      future: sharedpreferencedata.getAllSharedPreferenceData(),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData) {
          return _streamBuildList(snapshot, context);
        } else {
          return centerLoading();
        }
      });
}

Widget _streamBuildList(
    AsyncSnapshot<List<String>> sharedPrefsData, BuildContext context) {
  final databaseQuery = Provider.of<DatabaseQueries>(context, listen: false);
  String uid = sharedPrefsData.data[7];
  // print(path);
  return StreamBuilder<QuerySnapshot>(
    stream: databaseQuery.provideSubCollectionstreams("uploaded", uid),
    builder: (context, assignmentDataSnapshot) {
      try {
        // print(assignmentDataSnapshot.data.documents);
        if (assignmentDataSnapshot.data.docs.isNotEmpty) {
          return itemListMySubmission(
              assignmentDataSnapshot.data.docs, sharedPrefsData);
        } else {
          return _noAssignmentScreen();
        }
      } catch (e) {
        return centerLoading();
      }
    },
  );
}

Widget itemListMySubmission(List<DocumentSnapshot> documents,
    AsyncSnapshot<List<String>> sharedPrefsData) {
  return ListView(children: <Widget>[
    Padding(
        padding: const EdgeInsets.all(20.0),
        child: screentitleBoldBig(
          "My Submissions",
        )),
    const SizedBox(
      height: 20,
    ),
    ...documents
        .map((data) => FadeIn(1, itemTileMySubmission(data, globalContenxt)))
        .toList(),
  ]);
}

Widget _noAssignmentScreen() {
  return Column(children: <Widget>[
    Padding(
        padding: const EdgeInsets.all(20.0),
        child: screentitleBoldBig("My Submissions")),
    const SizedBox(
      height: 20,
    ),
    Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image.asset(
            "asset/img/class.png",
            height: 200,
          )),
          Center(
              child: Text(
                  "No Submissions found. \nAdd some in the assigments section.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500])))
        ],
      ),
    )
  ]);
}
