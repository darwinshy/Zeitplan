import 'submissionItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../streamproviders.dart';
import '../../reusables.dart';
import '../assignmentList.dart';

Widget streamBuildUploadedAssignmentList(
    String uploadsPath, BuildContext context) {
  final databaseQuery = Provider.of<DatabaseQueries>(context, listen: false);
  final sharedpreferencedata =
      Provider.of<SharedPreferencesProviders>(context, listen: false);
  print("Collection Path :" + uploadsPath);
  return FutureBuilder(
      future: sharedpreferencedata.getAllSharedPreferenceData(),
      builder: (context, AsyncSnapshot<List<String>> sharedPrefsDataSnapshot) {
        if (sharedPrefsDataSnapshot.hasData) {
          return StreamBuilder<QuerySnapshot>(
            stream: databaseQuery.providestreams(
                uploadsPath, "submitterDateAndTime"),
            builder: (context, uploadDataSnapshot) {
              try {
                if (uploadDataSnapshot.data.documents.length != 0) {
                  return submissionList(sharedPrefsDataSnapshot,
                      uploadDataSnapshot.data.documents, context);
                } else {
                  return noSubmissionScreen();
                }
              } catch (e) {
                return linearProgressbar();
              }
            },
          );
        } else {
          return centerLoading();
        }
      });
}

// Rendering the page
Widget submissionList(AsyncSnapshot<List<String>> cacheData,
    List<DocumentSnapshot> submissionsDocuments, BuildContext context) {
  print(submissionsDocuments.elementAt(0).data);
  return Column(children: <Widget>[
    ...submissionsDocuments
        .map((data) => itemTileSubmission(cacheData.data, data, globalContenxt))
        .toList()
  ]);
}

Widget noUploadsScreen() {
  return Center(
      child: Text(
    "No uploads found. Ask your CR to add one.",
    style: TextStyle(fontSize: 12, color: Colors.grey[100]),
  ));
}

Widget noSubmissionScreen() {
  return Center(
      child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      "No Submission made.",
      style: TextStyle(fontSize: 10, color: Colors.grey[900]),
    ),
  ));
}
