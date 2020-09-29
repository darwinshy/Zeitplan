import 'package:Zeitplan/components/reusables.dart';
import 'package:flutter/material.dart';

class Assignments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Consumers

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: screentitleBoldBig("Assignments")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
