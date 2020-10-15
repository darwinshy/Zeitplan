import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'screen-adding-assignment.dart';
import 'sceen-adding-meeting.dart';
import 'package:flutter/material.dart';
import '../components/adminTools/adminTile.dart';
import '../components/reusables.dart';

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
            child: Column(
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
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    height: MediaQuery.of(context).size.height,
                    child: GridView.count(
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 2,
                        children: <Widget>[
                          adminTool("Add Assignements", Icons.note_rounded,
                              goToAddAssignmentScreen),
                          adminTool("Add Meetings", AntDesign.addusergroup,
                              goToAddMeetingScreen)
                        ])),
              ],
            )));
  }
}
