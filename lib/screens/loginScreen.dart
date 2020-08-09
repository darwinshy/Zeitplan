import 'package:Zeitplan/authentication/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final BaseAuth auth;

  const LoginPage(this.auth);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  String fullname;
  String scholarId;
  String phoneNumber;
  String section;

  final formKeyLogin = new GlobalKey<FormState>();
  final formKeySignUp = new GlobalKey<FormState>();

  void validateForLogin() async {
    String userID;
    SharedPreferences cacheData = await SharedPreferences.getInstance();
    final formLogin = formKeyLogin.currentState;

    if (formLogin.validate()) {
      formLogin.save();

      await widget.auth
          .signInWithEmailAndPassword(email, password)
          .then((value) => {
                print(value),
                userID = value,
                showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.transparent,
                            title: Center(
                              child: RefreshProgressIndicator(),
                            ),
                          );
                        })
                    .timeout(Duration(seconds: 2),
                        onTimeout: () => Navigator.pop(context))
                    .whenComplete(() async => {
                          if (userID.substring(0, 1) != "#")
                            {
                              // ##################################################
                              cacheData.setBool("loggedInStatus", true),
                              // ##################################################
                            }
                          else
                            {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      title: Center(
                                        child: Text(
                                          userID,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                            }
                        })
              });
    }
  }

  void validateForSignUp() async {
    String userID;
    SharedPreferences cacheData = await SharedPreferences.getInstance();
    final formSignUp = formKeySignUp.currentState;
    if (formSignUp.validate()) {
      formSignUp.save();

      await widget.auth
          .createUserWithEmailAndPassword(
              email, password, fullname, scholarId, section, phoneNumber)
          .then((value) => {
                userID = value,
                showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.transparent,
                            title: Center(
                              child: RefreshProgressIndicator(),
                            ),
                          );
                        })
                    .timeout(Duration(seconds: 2),
                        onTimeout: () => Navigator.pop(context))
                    .whenComplete(() async => {
                          if (userID.substring(0, 1) != "#")
                            {
                              //Storage Caching of User ID
                              print("Saving a new User to Storage : " + userID),
                              cacheData.setString("userUID", userID),
                              cacheData.setBool("loggedInStatus", true)
                            }
                          else
                            {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      title: Center(
                                        child: Text(
                                          userID,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                            }
                        })
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        pageSnapping: true,
        children: <Widget>[login(), signUp()],
      ),
    );
  }

  Widget login() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.black87,
      child: Form(
        key: formKeyLogin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "LOGIN",
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
                  "Welcome Back",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
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
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 0.4,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 0.2,
                            ),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        validator: (value) =>
                            value.isEmpty ? "Email cannot be empty." : null,
                        keyboardType: TextInputType.emailAddress,
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
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 0.4,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 0.2,
                            ),
                          ),
                        ),
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
                FlatButton(
                  padding: EdgeInsets.all(10),
                  onPressed: validateForLogin,
                  child: Text('           Login           ',
                      style: TextStyle(color: Colors.yellow, fontSize: 18)),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.yellow,
                          width: 0.8,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),
            Center(
              child: FlatButton(
                padding: EdgeInsets.all(10),
                onPressed: null,
                child: Text('Swipe right to create a new account',
                    style: TextStyle(color: Colors.white38, fontSize: 12)),
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget signUp() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.black87,
      child: Form(
        key: formKeySignUp,
        child: Center(
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "SIGN UP",
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
                      "Enter you Details",
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
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.4,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.2,
                                ),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) =>
                                value.isEmpty ? "Name cannot be empty." : null,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => fullname = value,
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
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.4,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.2,
                                ),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) => value.isEmpty
                                ? "Scholar ID cannot be empty."
                                : null,
                            keyboardType: TextInputType.text,
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
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          TextFormField(
                            // initialValue: "eg. BranchCode-BatchYear-Section",
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.4,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.2,
                                ),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) => value.isEmpty
                                ? "Section cannot be empty."
                                : null,
                            keyboardType: TextInputType.text,
                            onSaved: (value) => section = value,
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
                            "Email",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.4,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.2,
                                ),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) =>
                                value.isEmpty ? "Email cannot be empty." : null,
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
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.4,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.2,
                                ),
                              ),
                            ),
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
                    FlatButton(
                      padding: EdgeInsets.all(10),
                      onPressed: validateForSignUp,
                      child: Text('           SignUp           ',
                          style: TextStyle(color: Colors.yellow, fontSize: 18)),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.yellow,
                              width: 0.8,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(20)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
