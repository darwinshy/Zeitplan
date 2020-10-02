import 'package:Zeitplan/authentication/auth.dart';
import 'package:Zeitplan/components/reusables.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

class SignUpPageScreen extends StatefulWidget {
  @override
  _SignUpPageScreenState createState() => _SignUpPageScreenState();
}

class _SignUpPageScreenState extends State<SignUpPageScreen> {
  String email;
  String password;
  String fullname;
  String scholarId;
  String phoneNumber;
  String section;
  String batchYear;
  String branch;
  String uid;
  BuildContext globalContext;
  final formKeySignUp = new GlobalKey<FormState>();
  final _signuppagecontroller = new PageController();

  @override
  void initState() {
    globalContext = context;
    super.initState();
  }

  void openAppNow() async {
    const url = 'mailto:';

    try {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      bool launched = await launch(url, forceWebView: false);

      if (!launched) {
        await launch(url, forceWebView: false);
      }
    } catch (e) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      SnackBar(
        content: Text("Something went wrong"),
      );
    }
  }

  void wantToOpenGmailApp(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            backgroundColor: Colors.grey[100],
            titleTextStyle: TextStyle(color: Colors.grey[900]),
            contentTextStyle: TextStyle(color: Colors.grey[900]),
            title: Text(
                "A verification link has been sent to your email. Please follow the link to verify your account. Do you want to open you G-Mail app ? "),
            actions: [
              FlatButton(
                  onPressed: () => {
                        Navigator.of(context).pop(),
                        Navigator.of(context).pop(),
                        Navigator.of(context).pop()
                      },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey[900]),
                  )),
              FlatButton(
                onPressed: () => openAppNow(),
                child: Text(
                  "Open",
                  style: TextStyle(color: Colors.grey[900]),
                ),
              )
            ],
          );
        });
  }

  // Functions
  bool checkTheScholarID() {
    if (scholarId.length == 7) {
      batchYear = "20" + scholarId.substring(0, 2);
      if (int.parse(batchYear) > 2017) {
        if (batchYear == "2018" || batchYear == "2017") {
          switch (scholarId.substring(3, 4)) {
            case "1":
              branch = "CE";
              break;
            case "2":
              branch = "ME";
              break;
            case "3":
              branch = "EE";
              break;
            case "4":
              branch = "ECE";
              break;
            case "5":
              branch = "CSE";
              break;
            case "6":
              branch = "E&I";
              break;
            default:
              return false;
          }
        } else {
          switch (scholarId.substring(3, 4)) {
            case "1":
              branch = "CE";
              break;
            case "2":
              branch = "CSE";
              break;
            case "3":
              branch = "EE";
              break;
            case "4":
              branch = "ECE";
              break;
            case "5":
              branch = "E&I";
              break;
            case "6":
              branch = "ME";
              break;
            default:
              return false;
          }
        }
      } else {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  void finalSignUpStepPageSwitcherAndValidator() {
    final formSignUp = formKeySignUp.currentState;
    formSignUp.save();
    if (fullname.length < 5) {
      return showSomeAlerts("Name is too short.", context);
    }

    if (checkTheScholarID() == false) {
      return showSomeAlerts("Scholar ID is not valid", context);
    }

    if (section != "A" && section != "B") {
      return showSomeAlerts("Section can only be A or B.", context);
    }

    if (phoneNumber.length == 0) {
      return showSomeAlerts("Phone Number is invalid.", context);
    }
    if (phoneNumber.length != 12 && phoneNumber.length != 13) {
      return showSomeAlerts(
          "Enter phone number with your country code.", context);
    }
    _signuppagecontroller.animateToPage(2,
        duration: new Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic);
  }

  void validateForSignUp() async {
    // Loader starts
    showProgressBar(context);
    SharedPreferences cacheData = await SharedPreferences.getInstance();
    final formSignUp = formKeySignUp.currentState;
    formSignUp.save();
    Auth auth = Auth();

    if (isEmail(email) != true) {
      Navigator.of(context).pop();
      return showSomeAlerts("Enter a valid email address.", context);
    }
    if (password.length < 5) {
      Navigator.of(context).pop();
      return showSomeAlerts("Password too short.", context);
    }

    if (formSignUp.validate()) {
      formSignUp.save();
      print("######################################################");
      print("##### Registration Initialised for credentials #####");
      print("email        : " + email);
      print("password     : " + password);
      print("fullname     : " + fullname);
      print("scholarId    : " + scholarId);
      print("section      : " + section);
      print("phoneNumber  : " + phoneNumber);
      print("######################################################");

      Future<String> authResult = auth.createUserWithEmailAndPassword(
          email,
          password,
          fullname,
          scholarId,
          section,
          phoneNumber,
          branch,
          batchYear);

      authResult.then((result) => {
            // If no error is recieved from the API
            if (result.substring(0, 1) != "#")
              {
                uid = result,
                cacheData.setBool("loggedInStatus", true),
                print("######################################################"),
                print("##### Registration Successfull #####"),
                print("uid          : " + uid),
                print("email        : " + email),
                print("password     : " + password),
                print("fullname     : " + fullname),
                print("scholarId    : " + scholarId),
                print("section      : " + section),
                print("phoneNumber  : " + phoneNumber),
                print("######################################################"),
              }
            // If error is recieved from the API
            else
              {
                if (result.compareTo(
                        "#A verification link has been sent to your email. Please follow the link to verify your account") ==
                    0)
                  {
                    print(
                        "####################################################################"),
                    wantToOpenGmailApp(context)
                  }
                else
                  {
                    Navigator.of(context).pop(),
                    showSomeAlerts(result.substring(1), context),
                  }
              }
          });
    } else {
      Navigator.of(context).pop();
      showSomeAlerts("Your details are not valid.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: signUpForm(),
      ),
    );
  }

  Widget signUpForm() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: formKeySignUp,
        child: Center(
          child: PageView(
              controller: _signuppagecontroller,
              dragStartBehavior: DragStartBehavior.down,
              // physics: new NeverScrollableScrollPhysics(),
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Get Started",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Fill up your basic details",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 75, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Full Name",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                TextFormField(
                                  initialValue: fullname,
                                  decoration:
                                      inputDecoration("What's your name ?"),
                                  style: TextStyle(color: Colors.white),
                                  validator: (value) => value.isEmpty
                                      ? "Name cannot be empty."
                                      : null,
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: (value) => fullname = value,
                                  maxLength: 30,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Scholar ID",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                TextFormField(
                                  initialValue: scholarId,
                                  decoration: inputDecoration(
                                      "Your 7 digits, college scholar ID."),
                                  style: TextStyle(color: Colors.white),
                                  validator: (value) => value.isEmpty
                                      ? "Scholar ID cannot be empty."
                                      : null,
                                  keyboardType: TextInputType.number,
                                  onSaved: (value) => scholarId = value,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Section",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                TextFormField(
                                  initialValue: section,
                                  // initialValue: "eg. BranchCode-BatchYear-Section",
                                  decoration: inputDecoration("A or B ?"),
                                  style: TextStyle(color: Colors.white),
                                  validator: (value) => value.isEmpty
                                      ? "Section cannot be empty."
                                      : null,
                                  keyboardType: TextInputType.text,
                                  onSaved: (value) => section = value,
                                  maxLength: 1,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Phone Number",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                TextFormField(
                                  initialValue: phoneNumber,
                                  // initialValue: "eg. BranchCode-BatchYear-Section",
                                  decoration: inputDecoration(
                                      "Your phone number along with country code."),
                                  style: TextStyle(color: Colors.white),
                                  validator: (value) => value.isEmpty
                                      ? "Section cannot be empty."
                                      : null,
                                  keyboardType: TextInputType.number,
                                  onSaved: (value) => phoneNumber = value,
                                  maxLength: 13,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          genericFlatButtonWithRoundedBorders(
                              '           Next           ',
                              finalSignUpStepPageSwitcherAndValidator)
                        ],
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Finish Sign Up",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "See you on the other side !",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 75, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                TextFormField(
                                  initialValue: email,
                                  decoration: inputDecoration(
                                      "Your email address goes here."),
                                  style: TextStyle(color: Colors.white),
                                  validator: (value) => value.isEmpty
                                      ? "Email cannot be empty."
                                      : null,
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: (value) => email = value,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Password",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                TextFormField(
                                  initialValue: password,
                                  decoration: inputDecoration(
                                      "Your secret password goes here."),
                                  style: TextStyle(color: Colors.white),
                                  validator: (value) => value.isEmpty
                                      ? "Password cannot be empty."
                                      : null,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  onSaved: (value) => password = value,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          genericFlatButtonWithRoundedBorders(
                              '           Register           ',
                              validateForSignUp)
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}

// if (isEmail(email) != true) {
//   return showSomeAlerts("Enter a valid email address.", context);
// }
// if (password.length < 5) {
//   return showSomeAlerts("Password too short.", context);
// }
