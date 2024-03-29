import 'package:zeitplan/authentication/auth.dart';
import 'package:zeitplan/components/animations.dart';
import 'package:zeitplan/components/reusables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';
import '../forgotPasswordScreen/screen-forgot-password.dart';
import '../../root.dart';

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

  final formKeyLogin = GlobalKey<FormState>();

  @override
  void initState() {
    globalContext = context;
    super.initState();
  }

  // Functions
  void goToForgotScreen() {
    Navigator.of(context).push(PageTransition(
        child: ForgotPageScreen(), type: PageTransitionType.fade));
  }

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
                Navigator.of(context).pop(),
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (BuildContext context) => const Root(),
                ))
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
            FadeInLTR(
              1,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "LOGIN",
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Welcome back !",
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
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
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Email",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                        TextFormField(
                          decoration:
                              inputDecoration("Your email address goes here."),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) =>
                              value.isEmpty ? "Email cannot be empty." : null,
                          keyboardType: TextInputType.text,
                          onSaved: (value) => email = value,
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Password",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        TextFormField(
                          decoration: inputDecoration(
                              "Your secret password goes here."),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) => value.isEmpty
                              ? "Password cannot be empty."
                              : null,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          onSaved: (value) => password = value,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  stateOfLoading == false
                      ? genericFlatButtonWithRoundedBorders(
                          '           Login           ', validateForLogin)
                      : genericFlatButtonWithLoader()
                ],
              ),
            ),
            FadeInLTR(
              2,
              Center(
                child: InkWell(
                  onTap: goToForgotScreen,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Forgot Password ?',
                        style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
