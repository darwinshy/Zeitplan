import 'package:page_transition/page_transition.dart';

import '../../components/assignments/assignmentList.dart';
import 'package:flutter/material.dart';

import 'screen-assignment-mySubmission.dart';

class Assignments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void goToMySubmissionScreen() {
      Navigator.of(context).push(PageTransition(
          child: MySubmssionScreen(), type: PageTransitionType.fade));
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
            onTap: goToMySubmissionScreen,
            child: Container(
                margin: const EdgeInsets.only(right: 10, top: 18),
                child: const Text(
                  "My Submissions",
                  style: TextStyle(fontSize: 13),
                )),
          )
        ],
      ),
      body: buildAssignmentList(context),
    );
  }
}
