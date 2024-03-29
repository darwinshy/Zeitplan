import 'package:page_transition/page_transition.dart';
import '../../components/reusables.dart';
import '../../components/questionBank/questionPaperList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../addingScreens/screen-adding-questionpaper.dart';

class QuestionPaperScreen extends StatefulWidget {
  final int semesterNumber;
  final String subjectCode;
  const QuestionPaperScreen(this.semesterNumber, this.subjectCode);
  @override
  _QuestionPaperScreenState createState() => _QuestionPaperScreenState();
}

class _QuestionPaperScreenState extends State<QuestionPaperScreen> {
  @override
  Widget build(BuildContext context) {
    void goToAddQuestionPaperScreen() {
      Navigator.of(context).push(PageTransition(
          child: AddQuestionPaperScreen(), type: PageTransitionType.fade));
    }

    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
                icon: const Icon(Icons.add), onPressed: goToAddQuestionPaperScreen)
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("/questionbank/bank/papers")
                .where("questionPaperSubjectCode",
                    isEqualTo: widget.subjectCode)
                .where("questionPaperSemester",
                    isEqualTo: widget.semesterNumber)
                .orderBy("questionPaperYear")
                .snapshots(),
            builder: (context, snapshot) {
              try {
                return buildListofQuestionPaper(snapshot.data.docs, context);
              } catch (e) {
                print(e);
                return centerLoading();
              }
            }));
  }
}
