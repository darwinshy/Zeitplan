import 'package:Zeitplan/components/questionBank/selectSemester.dart';
import 'package:Zeitplan/components/reusables.dart';
import 'package:page_transition/page_transition.dart';

import '../../components/questionBank/selectSubject.dart';
import 'package:flutter/material.dart';

import '../addingScreens/screen-adding-questionpaper.dart';
import 'screen-question-paper.dart';

class QuestionPaperScreenSelect extends StatefulWidget {
  @override
  _QuestionPaperScreenSelectState createState() =>
      _QuestionPaperScreenSelectState();
}

class _QuestionPaperScreenSelectState extends State<QuestionPaperScreenSelect> {
  int semesterNumber;
  String subjectCode;
  final _pageController = new PageController();

  void setSemesterNumber(int sem) {
    setState(() {
      semesterNumber = sem;
    });
    switchToSecondPage(1);
  }

  void isSemesterSelected() {
    if (semesterNumber == null) {
      showSomeAlerts("Select Semester", context);
      switchToSecondPage(0);
    }
  }

  void setSubjectCode(String code) {
    setState(() {
      subjectCode = code;
    });
    goToQuestionScreen();
  }

  void goToQuestionScreen() {
    Navigator.of(context).push(PageTransition(
        child: QuestionPaperScreen(semesterNumber, subjectCode),
        type: PageTransitionType.fade));
  }

  void switchToSecondPage(int n) {
    _pageController.animateToPage(n,
        duration: new Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic);
  }

  void goToAddQuestionPaperScreen() {
    Navigator.of(context).push(PageTransition(
        child: AddQuestionPaperScreen(), type: PageTransitionType.fade));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.add), onPressed: goToAddQuestionPaperScreen)
        ],
      ),
      body: Center(
        child: PageView(
          onPageChanged: (_) => isSemesterSelected(),
          controller: _pageController,
          children: [
            selectSemester(setSemesterNumber),
            selectSubject(semesterNumber, context, setSubjectCode),
          ],
        ),
      ),
    );
  }
}
