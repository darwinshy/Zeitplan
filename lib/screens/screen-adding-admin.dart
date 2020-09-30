import 'screen-adding-assignment.dart';
import 'sceen-adding-meeting.dart';
import 'package:flutter/material.dart';

class AddingScreen extends StatefulWidget {
  @override
  _AddingScreenState createState() => _AddingScreenState();
}

class _AddingScreenState extends State<AddingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        clipBehavior: Clip.antiAlias,
        children: [AddMeetingScreen(), AddAssignmentScreen()],
      ),
    );
  }
}
