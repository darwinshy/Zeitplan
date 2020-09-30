import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import '../../classes/classes.dart';
import '../../screens/screen-assignmentDetailView.dart';

Widget itemTileAssignement(DocumentSnapshot data, BuildContext context) {
  final record = Assignment.fromSnapshot(data);
  bool active = record.active == true ? true : false;

  void detailedAssignmentView() {
    Navigator.of(context).push(PageTransition(
        child: AssignmentDetailView(record), type: PageTransitionType.fade));
  }

  return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      padding: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: detailedAssignmentView,
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Icon(
              active
                  ? MaterialCommunityIcons.progress_clock
                  : AntDesign.checkcircleo,
              color: active ? Colors.yellow[900] : Colors.green,
            ),
          ),
          title: Text(record.subjectName,
              style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 18,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.bold)),
          subtitle: Text("Due Date : " + record.assignmentDueDate,
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 10,
                fontFamily: "OpenSans",
              )),
        ),
      ));
}
