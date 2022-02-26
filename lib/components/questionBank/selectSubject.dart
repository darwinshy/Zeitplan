import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../animations.dart';
import '../reusables.dart';

Widget selectSubject(int semesterNumber, BuildContext context,
    void Function(String code) setSubjectCode) {
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.doc("questionbank/bank").snapshots(),
    builder: (context, subjectCodesDataSnapshot) {
      try {
        return questionCodesList(context, subjectCodesDataSnapshot.data.data(),
            semesterNumber, setSubjectCode);
      } catch (e) {
        print(e);
        return centerLoading();
      }
    },
  );
}

Widget questionCodesList(BuildContext context, Map<String, dynamic> documents,
    int semesterNumber, void Function(String code) setSubjectCode) {
  // documents["codes"].forEach((key, value) {
  //   print(value.toString());
  // });

  documents["codes"]
      .removeWhere((key, value) => value["semesterNumber"] != semesterNumber);
  // print(documents);
  if (documents["codes"].isEmpty) {
    return _noAssignmentScreen();
  } else {
    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: screentitleBoldBig("Select Subject")),
        const SizedBox(
          height: 20,
        ),
        ...documents["codes"]
            .entries
            .map((data) => FadeInLTR(
                0.7, questionCodesItem(data, semesterNumber, setSubjectCode)))
            .toList(),
      ],
    );
  }
}

Widget questionCodesItem(MapEntry<String, dynamic> data, int semNumber,
    void Function(String code) setSubjectCode) {
  return InkWell(
    onTap: () => setSubjectCode(data.key),
    child: Container(
        width: 100,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    data.value["subjectName"],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(
                  "Semester : " + data.value["semesterNumber"].toString(),
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 10,
                  ),
                )
              ],
            ),
            Text(
              data.key,
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 12,
              ),
            ),
          ],
        )),
  );
}

Widget _noAssignmentScreen() {
  return Column(children: <Widget>[
    Padding(
        padding: const EdgeInsets.all(20.0),
        child: screentitleBoldBig("Select Subject")),
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
              child: Text("No Entries found. \nClick on + icon to add one.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]))),
        ],
      ),
    )
  ]);
}
