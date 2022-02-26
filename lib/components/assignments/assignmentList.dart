import '../animations.dart';
import '../reusables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    stream: databaseQuery.providestreamsOrderMinusOne(path, "active"),
    builder: (context, assignmentDataSnapshot) {
      try {
        if (assignmentDataSnapshot.data.docs.isNotEmpty) {
          return itemListAssignement(
              assignmentDataSnapshot.data.docs, sharedPrefsData.data[10]);
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
Widget itemListAssignement(List<DocumentSnapshot> documents, String isCR) {
  return ListView(children: <Widget>[
    Padding(
        padding: const EdgeInsets.all(20.0),
        child: screentitleBoldBig("Assignments")),
    const SizedBox(
      height: 20,
    ),
    ...documents
        .map((data) =>
            FadeInLTR(0.7, itemTileAssignement(data, globalContenxt, isCR)))
        .toList(),
  ]);
}

Widget _noAssignmentScreen() {
  return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: screentitleBoldBig("Assignments")),
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
                      "No assignments found.\n Ask your Class Representative to add one.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500])))
            ],
          ),
        )
      ]);
}
