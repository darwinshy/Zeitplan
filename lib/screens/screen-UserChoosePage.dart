import 'package:Zeitplan/components/animations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/reusables.dart';
import 'loginScreen/screen-login.dart';
import 'registerScreen/screen-register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class UserChoosePage extends StatefulWidget {
  @override
  _UserChoosePageState createState() => _UserChoosePageState();
}

class _UserChoosePageState extends State<UserChoosePage> {
  // Constants;

  void goToLoginSceen() {
    Navigator.of(context).push(PageTransition(
        child: LoginPageScreen(), type: PageTransitionType.fade));
  }

  void goToSignUpSceen() {
    Navigator.of(context).push(PageTransition(
        child: SignUpPageScreen(), type: PageTransitionType.fade));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeIn(
                  1,
                  Text(
                    "Zeitplan",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 35,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FadeIn(
                  1.5,
                  Text(
                    "Classes Made Easy",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
            FadeIn(
              2,
              Center(
                  child: Image.asset(
                "asset/img/welcome.png",
                // width: 500,
              )),
            ),
            FadeIn(
              2.5,
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
            ),
          ],
        ),
      ),
    );
  }
}
