import 'package:google_fonts/google_fonts.dart';

import '../components/reusables.dart';
import '../screens/screen-login.dart';
import '../screens/screen-register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class UserChoosePage extends StatefulWidget {
  @override
  _UserChoosePageState createState() => _UserChoosePageState();
}

class _UserChoosePageState extends State<UserChoosePage> {
  void goToLoginSceen() {
    Navigator.of(context).push(PageTransition(
        child: LoginPageScreen(), type: PageTransitionType.downToUp));
  }

  void goToSignUpSceen() {
    Navigator.of(context).push(PageTransition(
        child: SignUpPageScreen(), type: PageTransitionType.downToUp));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                "Zeitplan",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 40,
                        fontWeight: FontWeight.w800)),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Classes Made Easy",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 15,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
          Center(
              child: Image.asset(
            "asset/img/welcome.png",
            width: 200,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                flatButtonWithRoundedShape('Login', goToLoginSceen),
                SizedBox(
                  height: 20,
                ),
                flatButtonWithRoundedShape('Sign Up', goToSignUpSceen),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "By continuing, you agree to the terms and conditions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 10,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
