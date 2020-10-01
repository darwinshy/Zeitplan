import 'package:flutter/material.dart';
import '../components/mysubmissions/mysubmissionList.dart';

class MySubmssionScreen extends StatefulWidget {
  @override
  _MySubmssionScreenState createState() => _MySubmssionScreenState();
}

class _MySubmssionScreenState extends State<MySubmssionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: buildMySubmissionList(context),
    );
  }
}
