import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../classes/classes.dart';
import '../../screens/assignmentsScreen/screen-assignmentListDetailView.dart';

Widget itemTileAssignement(
    DocumentSnapshot data, BuildContext context, String isCR) {
  final record = Assignment.fromSnapshot(data);
  bool active = record.active == true ? true : false;

  void detailedAssignmentView() {
    Navigator.of(context).push(PageTransition(
        child: AssignmentDetailView(record), type: PageTransitionType.fade));
  }

  void updateStatusOfAssignment(int index) {
    Firestore.instance
        .document(record.reference.path)
        .updateData({"active": index == 0 ? true : false}).then((value) => {
              print("######################################################"),
              print("##### Assignement Status Updated to Database #####"),
              print("assignmentRef    : " + record.reference.path),
              print("status           :  + ${index == 0 ? true : false}"),
              print("######################################################"),
            });
  }

  return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      padding: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
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
        children: [
          isCR == "true"
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Assignment Status :",
                        style: TextStyle(color: Colors.grey[900]),
                      ),
                      ToggleSwitch(
                        activeBgColor: Colors.grey[900],
                        activeFgColor: Colors.grey[100],
                        inactiveBgColor: Colors.grey[100],
                        inactiveFgColor: Colors.grey[900],
                        initialLabelIndex: active ? 0 : 1,
                        labels: ['Due', 'Done'],
                        onToggle: (index) => updateStatusOfAssignment(index),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
        trailing: InkWell(
          onTap: detailedAssignmentView,
          child: Icon(
            AntDesign.rightcircleo,
            color: Colors.grey[900],
          ),
        ),
      ));
}
