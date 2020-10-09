import 'package:Zeitplan/authentication/auth.dart';
import 'package:Zeitplan/components/reusables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

class LoginPageScreen extends StatefulWidget {
  @override
  _LoginPageScreenState createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  String email;
  String password;
  String uid;
  BuildContext globalContext;
  bool stateOfLoading = false;

  final formKeyLogin = new GlobalKey<FormState>();

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

  void validateForLogin() async {
    // Loader starts
    changeStateOfLoading();
    SharedPreferences cacheData = await SharedPreferences.getInstance();
    final formLogin = formKeyLogin.currentState;
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
      print("##### Login Initialised for credentials #####");
      print("email       : " + email);
      print("password    : " + password);
      print("######################################################");

      Future<String> authResult =
          auth.signInWithEmailAndPassword(email, password);

      authResult.then((result) => {
            // If no error is recieved from the API
            if (result.substring(0, 1) != "#")
              {
                uid = result,
                cacheData.setBool("loggedInStatus", true),
                print("######################################################"),
                print("##### Login Successfull #####"),
                print("email       : " + email),
                print("UID         : " + uid),
                print("######################################################"),
                // Navigator.of(context).pop(),
                changeStateOfLoading(),
                Navigator.of(context).pop(),
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
        child: loginForm(),
      ),
    );
  }

  Widget loginForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKeyLogin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "LOGIN",
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
                  "Did you miss me ?",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  )),
                ),
              ],
            ),
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
                        decoration:
                            inputDecoration("Your email address goes here."),
                        style: TextStyle(color: Colors.white),
                        validator: (value) =>
                            value.isEmpty ? "Email cannot be empty." : null,
                        keyboardType: TextInputType.text,
                        onSaved: (value) => email = value,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Password",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      TextFormField(
                        decoration:
                            inputDecoration("Your secret password goes here."),
                        style: TextStyle(color: Colors.white),
                        validator: (value) =>
                            value.isEmpty ? "Password cannot be empty." : null,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        onSaved: (value) => password = value,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                stateOfLoading == false
                    ? genericFlatButtonWithRoundedBorders(
                        '           Login           ', validateForLogin)
                    : genericFlatButtonWithLoader()
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('New here ? Register now.',
                    style: TextStyle(color: Colors.white38, fontSize: 12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
