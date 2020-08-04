import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
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
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                padding: EdgeInsets.all(10),
                onPressed: null,
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
              child: Text('Swipe Right to Create a new Account',
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget signUp() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.black87,
      child: Center(
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
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
                          style: TextStyle(color: Colors.white70, fontSize: 12),
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
                          validator: (value) =>
                              value.isEmpty ? "Section cannot be empty." : null,
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
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                    onPressed: null,
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
    );
  }
}
