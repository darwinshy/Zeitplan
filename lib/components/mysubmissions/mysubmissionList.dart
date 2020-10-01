import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../streamproviders.dart';
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
        if (assignmentDataSnapshot.data.documents.length != 0) {
          return itemListMySubmission(
              assignmentDataSnapshot.data.documents, sharedPrefsData);
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
    SizedBox(
      height: 20,
    ),
    ...documents
        .map((data) => itemTileMySubmission(data, globalContenxt))
        .toList(),
  ]);
}

Widget _noAssignmentScreen() {
  return Column(children: <Widget>[
    Padding(
        padding: const EdgeInsets.all(20.0),
        child: screentitleBoldBig("My Submissions")),
    SizedBox(
      height: 20,
    ),
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
          child: Text(
        "No Submissions found. Add some in the assigment section.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      )),
    )
  ]);
}
