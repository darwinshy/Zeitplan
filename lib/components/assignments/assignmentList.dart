import '../reusables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../streamproviders.dart';
import 'assignmentItem.dart';

BuildContext globalContenxt;

Widget buildAssignmentList(BuildContext context) {
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

// Streaming Database Data
Widget _streamBuildList(
    AsyncSnapshot<List<String>> sharedPrefsData, BuildContext context) {
  final databaseQuery = Provider.of<DatabaseQueries>(context, listen: false);
  String path = sharedPrefsData.data[12];
  print(path);
  return StreamBuilder<QuerySnapshot>(
    stream: databaseQuery.providestreams(path, 'assignmentId'),
    builder: (context, assignmentDataSnapshot) {
      try {
        if (assignmentDataSnapshot.data.documents.length != 0) {
          return itemListAssignement(assignmentDataSnapshot.data.documents);
        } else {
          return _noAssignmentScreen();
        }
      } catch (e) {
        return centerLoading();
      }
    },
  );
}

// Rendering the page
Widget itemListAssignement(List<DocumentSnapshot> documents) {
  return ListView(children: <Widget>[
    Padding(
        padding: const EdgeInsets.all(20.0),
        child: screentitleBoldBig("Assignments")),
    SizedBox(
      height: 20,
    ),
    ...documents
        .map((data) => itemTileAssignement(data, globalContenxt))
        .toList(),
  ]);
}

Widget _noAssignmentScreen() {
  return Column(children: <Widget>[
    Padding(
        padding: const EdgeInsets.all(20.0),
        child: screentitleBoldBig("Assignments")),
    SizedBox(
      height: 20,
    ),
    Center(
        child: Text(
      "No assignments found. Ask your CR to add one.",
      style: TextStyle(fontSize: 12),
    ))
  ]);
}
