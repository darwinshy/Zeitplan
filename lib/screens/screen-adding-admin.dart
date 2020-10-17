import '../components/animations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'screen-adding-assignment.dart';
import 'sceen-adding-meeting.dart';
import 'package:flutter/material.dart';
import '../components/adminTools/adminTile.dart';
import '../components/reusables.dart';
import 'screen-adding-questionpaper.dart';

class AddingScreen extends StatefulWidget {
  @override
  _AddingScreenState createState() => _AddingScreenState();
}

class _AddingScreenState extends State<AddingScreen> {
  // Navigations
  void goToAddMeetingScreen() {
    Navigator.of(context).push(PageTransition(
        child: AddMeetingScreen(), type: PageTransitionType.fade));
  }

  void goToAddAssignmentScreen() {
    Navigator.of(context).push(PageTransition(
        child: AddAssignmentScreen(), type: PageTransitionType.fade));
  }

  void goToAddQuestionPaperScreen() {
    Navigator.of(context).push(PageTransition(
        child: AddQuestionPaperScreen(), type: PageTransitionType.fade));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
      ),
      backgroundColor: Colors.grey[900],
      body: buildAddingOptions(),
    );
  }

  Widget buildAddingOptions() {
    return SafeArea(
        child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: FadeIn(
              1,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  screentitleBoldBig("Admin Panel"),
                  SizedBox(
                    height: 10,
                  ),
                  screentitleBoldMedium("Choose an action"),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      height: MediaQuery.of(context).size.height,
                      child: GridView.count(
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 2,
                          children: <Widget>[
                            FadeIn(
                              1.3,
                              adminTool("Add Assignements", Icons.note_rounded,
                                  goToAddAssignmentScreen),
                            ),
                            FadeIn(
                              1.6,
                              adminTool("Add Meetings", AntDesign.addusergroup,
                                  goToAddMeetingScreen),
                            ),
                            FadeIn(
                              1.9,
                              adminTool(
                                  "Add Question Paper",
                                  MaterialCommunityIcons.file_question,
                                  goToAddQuestionPaperScreen),
                            ),
                          ])),
                ],
              ),
            )));
  }
}
