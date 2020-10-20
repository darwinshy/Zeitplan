import 'package:Zeitplan/authentication/auth.dart';
import 'package:Zeitplan/components/animations.dart';
import 'package:Zeitplan/components/reusables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validators/validators.dart';

class ForgotPageScreen extends StatefulWidget {
  @override
  _ForgotPageScreenState createState() => _ForgotPageScreenState();
}

class _ForgotPageScreenState extends State<ForgotPageScreen> {
  String email;
  BuildContext globalContext;
  bool stateOfLoading = false;

  final formKeyReset = new GlobalKey<FormState>();

  @override
  void initState() {
    globalContext = context;
    super.initState();
  }

  // Functions

  void changeStateOfLoading() {
    setState(() {
      stateOfLoading = !stateOfLoading;
    });
  }

  void validateForReset() async {
    // Loader starts
    changeStateOfLoading();
    final formLogin = formKeyReset.currentState;
    formLogin.save();
    Auth auth = Auth();

    if (isEmail(email) != true) {
      // Navigator.of(context).pop(),
      changeStateOfLoading();
      return showSomeAlerts("Enter a valid email address.", context);
    }

    if (formLogin.validate()) {
      formLogin.save();
      print("######################################################");
      print("##### Reset Initialised for credentials #####");
      print("email       : " + email);
      print("######################################################");

      Future<String> authResult = auth.resetPassword(email);

      authResult.then((result) => {
            // If no error is recieved from the API
            if (result.substring(0, 1) != "#")
              {
                print("######################################################"),
                print("##### Reset Email Sent Successfull #####"),
                print("email       : " + email),
                print("######################################################"),
                // Navigator.of(context).pop(),
                changeStateOfLoading(),
                showPromisedSomeAlerts(result, context)
                    .then((value) => {Navigator.of(context).pop()})
              }
            // If error is recieved from the API
            else
              {
                // Navigator.of(context).pop(),
                changeStateOfLoading(),
                showSomeAlerts(result.substring(1), context),
              }
          });
    } else {
      // Navigator.of(context).pop(),
      changeStateOfLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: resetForm(),
      ),
    );
  }

  Widget resetForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKeyReset,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FadeInLTR(
              1,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Forgot Password ?",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w800)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "We'll send you an email with a reset link.",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    )),
                  ),
                ],
              ),
            ),
            FadeInLTR(
              1.5,
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Email",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                        TextFormField(
                          decoration: inputDecoration(
                              "Thank God, we have this feature !"),
                          style: TextStyle(color: Colors.white),
                          validator: (value) =>
                              value.isEmpty ? "Email cannot be empty." : null,
                          keyboardType: TextInputType.text,
                          onSaved: (value) => email = value,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  stateOfLoading == false
                      ? genericFlatButtonWithRoundedBorders(
                          '           Send Reset Link           ',
                          validateForReset)
                      : genericFlatButtonWithLoader()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
