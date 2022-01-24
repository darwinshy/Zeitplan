import 'package:Zeitplan/components/animations.dart';
import 'package:Zeitplan/components/reusables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final void Function() refresh;

  const EditProfile(this.refresh);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String fullname;
  String scholarId;
  String phoneNumber;
  String section;
  String branch;
  String batchYear;
  String dbUrlSchedules;
  final editProfileFormKey = new GlobalKey<FormState>();

  Future<SharedPreferences> getSharedPreferenceInstance() {
    return SharedPreferences.getInstance();
  }

  Future<List<String>> retriveBasicProfileDetails() async {
    SharedPreferences cacheData = await getSharedPreferenceInstance();
    return [
      cacheData.getString("fullname").toString(),
      cacheData.getString("scholarId").toString(),
      cacheData.getString("section").toString(),
      cacheData.getString("phone").toString(),
      cacheData.getString("userUID").toString(),
    ];
  }

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

  Future<void> updateProfileOnDatabase() async {
    SharedPreferences cacheData = await getSharedPreferenceInstance();

    String uid = cacheData.getString("userUID").toString();
    final snapShot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (snapShot.exists) {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        "name": fullname,
        "phone": phoneNumber,
        "scholarId": scholarId,
        "section": section.toUpperCase(),
        "batch": batchYear,
        "branch": branch,
      });
      print("######################################################");
      print("##### Profile Data Updated to Database #####");
      print("name       : " + fullname);
      print("phone      : " + phoneNumber);
      print("scholarId  : " + scholarId);
      print("section    : " + section.toUpperCase());
      print("batch      : " + batchYear);
      print("branch     : " + branch);
      print("######################################################");
    }
  }

  void updateProfileDataInSharedPreferences() async {
    SharedPreferences cacheData = await getSharedPreferenceInstance();
    dbUrlSchedules = "schedules/" +
        batchYear.substring(2) +
        "/" +
        branch +
        "/section/" +
        section.toUpperCase() +
        "_SX";

    cacheData.setString("fullname", fullname);
    cacheData.setString("phone", phoneNumber);
    cacheData.setString("scholarId", scholarId);
    cacheData.setString("section", section);
    cacheData.setString("batchYear", batchYear);
    cacheData.setString("branch", branch);
    cacheData.setString("dbUrlSchedules", dbUrlSchedules);
    print("######################################################");
    print("##### Profile Data Updated to Shared Preferences #####");
    print("name               : " + fullname);
    print("phone              : " + phoneNumber);
    print("scholarId          : " + scholarId);
    print("section            : " + section.toUpperCase());
    print("batch              : " + batchYear);
    print("branch             : " + branch);
    print("dbUrlSchedules     : " + dbUrlSchedules);
    print("######################################################");
  }

  void validateAndEditProfile() async {
    final formLogin = editProfileFormKey.currentState;
    if (formLogin.validate()) {
      formLogin.save();
      if (checkTheScholarID()) {
        if (section != "A" &&
            section != "B" &&
            section != "C" &&
            section != "D" &&
            section != "E" &&
            section != "F" &&
            section != "G" &&
            section != "H" &&
            section != "I" &&
            section != "J" &&
            section != "K") {
          return showSomeAlerts("Section can only be from A to K.", context);
        }
        //
        updateProfileOnDatabase().then((value) => {
              //
              updateProfileDataInSharedPreferences(),
              //
              widget.refresh(),
              //
              Navigator.pop(context)
            });
      } else {
        showSomeAlerts(
            "The entered details are not valid please recheck.", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: retriveBasicProfileDetails(),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              return editProfile(snapshot);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget editProfile(AsyncSnapshot<List<String>> snapshot) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.black87,
      child: Form(
        key: editProfileFormKey,
        child: Center(
          child: ListView(
            children: <Widget>[
              FadeInLTR(
                0.5,
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Edit Profile",
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
                        "Enter your Details",
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 75, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FadeInLTR(
                      1,
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
                              initialValue: snapshot.data.elementAt(0),
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
                                  ? "Name cannot be empty."
                                  : null,
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) => fullname = value,
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      1.5,
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
                              initialValue: snapshot.data.elementAt(1),
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
                              keyboardType: TextInputType.number,
                              onSaved: (value) => scholarId = value,
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      1.5,
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
                              initialValue: snapshot.data.elementAt(2),
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
                    ),
                    FadeInLTR(
                      2,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Phone Number (with Country Code)",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              initialValue: snapshot.data.elementAt(3),
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
                              onSaved: (value) => phoneNumber = value,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeInLTR(
                      2.5,
                      FlatButton(
                        padding: EdgeInsets.all(10),
                        onPressed: validateAndEditProfile,
                        child: Text('           Edit Changes           ',
                            style:
                                TextStyle(color: Colors.yellow, fontSize: 18)),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.yellow,
                                width: 0.8,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(20)),
                      ),
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
