import 'dart:io';
import '../authentication/auth.dart';
import '../screens/screen-about.dart';
import 'screen-edit-meeting.dart';
import '../screens/screen-whatsappdirectory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../root.dart';
import 'screen-adding-admin.dart';
import 'screen-edit-profile.dart';
import 'screen-assigmentlist.dart';

BuildContext globalContext;
String crStatus = "false";

DateTime now = DateTime.now();
DateFormat formatter = DateFormat('ddMMyyyy');
String formatted = formatter.format(now);

class Schedules extends StatefulWidget {
  @override
  _SchedulesState createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  @override
  Widget build(BuildContext context) {
    globalContext = context;

    void refresh() async {
      String dbUrlSchedules;
      String dbUrlAssignment;
      SharedPreferences cacheData = await SharedPreferences.getInstance();
      final snapShot = Firestore.instance
          .collection('users')
          .where(
            "uid",
            isEqualTo: cacheData.getString("userUID").toString(),
          )
          .snapshots();
      setState(() {
        crStatus = cacheData.getBool("CR").toString();
        snapShot.forEach((element) {
          dbUrlAssignment = "assignment/" +
              element.documents.elementAt(0).data["batch"].substring(2) +
              "/" +
              element.documents.elementAt(0).data["branch"] +
              "/section/" +
              element.documents.elementAt(0).data["section"].toUpperCase() +
              "_SX";
          dbUrlSchedules = "schedules/" +
              element.documents.elementAt(0).data["batch"].substring(2) +
              "/" +
              element.documents.elementAt(0).data["branch"] +
              "/section/" +
              element.documents.elementAt(0).data["section"].toUpperCase() +
              "_SX";
          cacheData.setString(
              "fullname", element.documents.elementAt(0).data["name"]);
          cacheData.setString(
              "phone", element.documents.elementAt(0).data["phone"]);
          cacheData.setString(
              "section", element.documents.elementAt(0).data["section"]);
          cacheData.setString(
              "branch", element.documents.elementAt(0).data["branch"]);
          cacheData.setBool("CR", element.documents.elementAt(0).data["CR"]);
          cacheData.setString("dbUrlSchedules", dbUrlSchedules);
          cacheData.setString(
              "photoURL", element.documents.elementAt(0).data["url"]);
          cacheData.setString("dbUrlAssignment", dbUrlAssignment);
        });
      });
    }
    // ###################################################################
    // Date Formatting

    final DateFormat formatterAppbar = DateFormat('dd MMM');
    String formattedAppBar = formatterAppbar.format(now);
    // ###################################################################
    // Fetching Cache Data
    Future<String> retriveScheduleURL() async {
      SharedPreferences cacheData = await SharedPreferences.getInstance();
      return cacheData.getString("dbUrlSchedules").toString();
    }

    Future<List<String>> retriveProfileDetails() async {
      SharedPreferences cacheData = await SharedPreferences.getInstance();
      return [
        cacheData.getString("fullname").toString(),
        cacheData.getString("email").toString(),
        cacheData.getString("phone").toString(),
        cacheData.getString("scholarId").toString(),
        cacheData.getString("section").toString(),
        cacheData.getString("batchYear").toString(),
        cacheData.getString("branch").toString(),
        cacheData.getBool("CR").toString(),
        cacheData.getString("userUID").toString(),
        cacheData.getString("photoURL").toString()
      ];
    }

    // ###################################################################
    // Functions
    void gotoaddscreen(BuildContext ctx) {
      Navigator.of(ctx).push(
          PageTransition(child: AddingScreen(), type: PageTransitionType.fade));
    }

    void changeDate() {
      DateFormat formatter = DateFormat('ddMMyyyy');
      showDatePicker(
              context: context,
              initialDate: now,
              firstDate: DateTime(2020),
              lastDate: DateTime.now())
          .then((value) => {formatted = formatter.format(value), now = value})
          .then((value) => refresh());
    }

    Future<List<String>> canIaccess() async {
      try {
        SharedPreferences cacheData = await SharedPreferences.getInstance();
        ConnectivityResult connectivityResult =
            await Connectivity().checkConnectivity();
        final snapShot = await Firestore.instance
            .collection('superadmin')
            .document("access")
            .get();

        // print(connectivityResult);
        return [
          snapShot.data["access"],
          snapShot.data["message"],
          connectivityResult.toString(),
          cacheData.getString("welcomeScreenShow")
        ];
      } catch (e) {
        print(e);
        return [
          e.toString(),
          "Couldn't connect to the Internet",
          "ConnectivityResult.none",
          "true",
          "null"
        ];
      }
    }

// ###################################################################
    return FutureBuilder<List<String>>(
      initialData: ["true", "Internet Issues", "null", "null"],
      future: canIaccess(),
      builder: (context, snapshots) {
        // print(snapshots.data[3]);
        if (snapshots.data[2] == "null") {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Connecting to Server"),
                  CircularProgressIndicator(
                    backgroundColor: Colors.yellow,
                  ),
                ],
              )),
            ),
          );
        }
        if (snapshots.data[2] == "ConnectivityResult.none") {
          return Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Err..",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Center(
                        child: Text(
                      "No internet connection",
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
              ));
        }

        if (snapshots.data[0] == "true") {
          return Scaffold(
              drawer: Drawer(
                elevation: 100,
                child: Container(
                  color: Colors.black45,
                  // alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              "More",
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                onPressed: () {
                                  refresh();
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  color: Colors.white60,
                                )),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.note),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(PageTransition(
                                      child: Assignments(),
                                      type: PageTransitionType.fade));
                                },
                                child: Text("Assignments")),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.person_add),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(PageTransition(
                                      child: WhatsappScreen(),
                                      type: PageTransitionType.fade));
                                },
                                child: Text("Whatsapp Directory")),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.white60,
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.account_circle),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(PageTransition(
                                      child: EditProfile(refresh),
                                      type: PageTransitionType.fade));
                                },
                                child: Text("Edit Profile")),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.adb),
                            FlatButton(
                                onPressed: () {
                                  infoDrawer(context);
                                },
                                child: Text("Version Info")),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.info),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(PageTransition(
                                      child: AboutScreen(),
                                      type: PageTransitionType.fade));
                                },
                                child: Text("About")),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.white60,
                      ),
                      ListTile(
                          title: Row(
                        children: <Widget>[
                          Icon(
                            Icons.exit_to_app,
                          ),
                          FlatButton(
                              onPressed: () {
                                Auth().signOut().whenComplete(() async {
                                  SharedPreferences cacheData =
                                      await SharedPreferences.getInstance();
                                  cacheData.clear();
                                  cacheData.setBool("loggedInStatus", false);
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Root();
                                      },
                                    ),
                                  );
                                });
                              },
                              child: Text("Log Out")),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              appBar: AppBar(
                backgroundColor: Colors.grey[900],
                centerTitle: true,
                title: Text(
                  "Dashboard",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                ),
                actions: <Widget>[
                  InkWell(
                    onTap: changeDate,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          formattedAppBar,
                          style: TextStyle(
                              fontFamily: "rob",
                              color: Colors.white,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              floatingActionButton: (crStatus == "true")
                  ? FloatingActionButton(
                      backgroundColor: Color.fromRGBO(229, 194, 102, 1),
                      child: Icon(Icons.add),
                      onPressed: () => {gotoaddscreen(context)},
                      isExtended: true,
                    )
                  : null,
              backgroundColor: Colors.grey[900],
              body: snapshots.data[3] != "true" || snapshots.data[3] == "null"
                  ? info(context)
                  : _buildSchedulesBody(
                      refresh,
                      context,
                      retriveScheduleURL,
                      retriveProfileDetails,
                    ));
        } else {
          return Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Err..",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Center(
                        child: Text(
                      snapshots.data[1].toString(),
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
              ));
        }
      },
    );
  }
}

void infoDrawer(BuildContext context) {
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          actions: [
            FlatButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.black),
                ))
          ],
          backgroundColor: Colors.grey[900],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Welcome, \nv1.0\n",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "You can join the Class Meeting by tapping on \"Join Meeting\"",
                        style: TextStyle(fontSize: 12, height: 1.25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "You can see your batchmates basic details and Whatsapp them directly, without saving his/her contact",
                        style: TextStyle(fontSize: 12, height: 1.25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Change your Profile Picture by long pressing on your picture.",
                        style: TextStyle(fontSize: 12, height: 1.25),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}

Widget info(BuildContext context) {
  return AlertDialog(
    actions: [
      FlatButton(
          color: Colors.white,
          onPressed: () async {
            globalContext = context;
            SharedPreferences cacheData = await SharedPreferences.getInstance();
            cacheData.setString("welcomeScreenShow", "true");
            Navigator.of(context).pushReplacement(PageTransition(
                child: Schedules(), type: PageTransitionType.fade));
          },
          child: Text(
            "OK",
            style: TextStyle(color: Colors.black),
          ))
    ],
    backgroundColor: Colors.grey[900],
    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Welcome, \nv1.0\n",
            textAlign: TextAlign.start,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800)),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "You can join the Class Meeting by tapping on \"Join Meeting\"",
                  style: TextStyle(fontSize: 12, height: 1.25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "You can see your batchmates basic details and Whatsapp them directly, without saving his/her contact",
                  style: TextStyle(fontSize: 12, height: 1.25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Change your Profile Picture by long pressing on your picture.",
                  style: TextStyle(fontSize: 12, height: 1.25),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget _buildSchedulesBody(
    void Function() refresh,
    BuildContext context,
    Future<String> Function() retriveScheduleURL,
    Future<List<String>> Function() retriveProfileDetails) {
  return FutureBuilder<String>(
      future: retriveScheduleURL(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return _streamBuild(refresh, snapshot, retriveProfileDetails);
        } else {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ));
        }
      });
}

Widget _streamBuild(void Function() refresh, AsyncSnapshot<String> snapshot,
    Future<List<String>> Function() retriveProfileDetails) {
  return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(snapshot.data)
          .document(formatted)
          .collection("meetings")
          .orderBy(
            "mStatus",
            descending: false,
          )
          .snapshots(),
      builder: (context, snapshots) {
        try {
          return _buildListofSchedules(
              refresh, snapshots.data.documents, retriveProfileDetails);
        } catch (e) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Loading",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 30,
              ),
              CircularProgressIndicator()
            ],
          ));
        }
      });
}

Widget _buildListofSchedules(
    void Function() refresh,
    List<DocumentSnapshot> documents,
    Future<List<String>> Function() retriveProfileDetails) {
  Color badgeBg = Colors.grey[700];
  Color badgeBgGold = Color.fromRGBO(229, 194, 102, 1);
  Color badgeTx = Colors.white;
  Color badgeTxGold = Color.fromRGBO(92, 68, 0, 1);

  try {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: <Widget>[
        FutureBuilder(
            future: retriveProfileDetails(),
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              try {
                if (snapshot.data.elementAt(7) == "true") {
                  crStatus = "true";
                } else {
                  crStatus = "false";
                }
              } catch (e) {}

              if (snapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(
                      color: (snapshot.data.elementAt(7) == "false")
                          ? badgeBg
                          : badgeBgGold,
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.fromLTRB(20, 30, 30, 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                              child: Text(
                                snapshot.data.elementAt(0),
                                style: TextStyle(
                                    color:
                                        (snapshot.data.elementAt(7) == "false")
                                            ? badgeTx
                                            : badgeTxGold,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                              child: Text(
                                snapshot.data.elementAt(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: (snapshot.data.elementAt(7) == "false")
                                      ? badgeTx
                                      : badgeTxGold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 18, 4, 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    snapshot.data.elementAt(6),
                                    style: TextStyle(
                                      color: (snapshot.data.elementAt(7) ==
                                              "false")
                                          ? badgeTx
                                          : badgeTxGold,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    color:
                                        (snapshot.data.elementAt(7) == "false")
                                            ? Colors.grey[800]
                                            : Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        (snapshot.data.elementAt(7) == "true")
                                            ? " CR "
                                            : " Student ",
                                        style: TextStyle(
                                          color: (snapshot.data.elementAt(7) ==
                                                  "false")
                                              ? badgeTx
                                              : badgeTxGold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext ctx) {
                                  return AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      content: (snapshot.data.elementAt(9) !=
                                              'null')
                                          ? Container(
                                              width: 200.0,
                                              height: 200.0,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  image: new DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: new NetworkImage(
                                                          snapshot.data
                                                              .elementAt(9)))))
                                          : Icon(
                                              Icons.account_circle,
                                              size: 100,
                                            ));
                                });
                          },
                          onLongPress: () async {
                            try {
                              File _image;
                              final picker = ImagePicker();

                              final pickedFile = await picker.getImage(
                                  imageQuality: 50,
                                  source: ImageSource.gallery);

                              _image = File(pickedFile.path);
                              var storage = FirebaseStorage.instance;
                              String url =
                                  "images/" + snapshot.data.elementAt(8);

                              StorageTaskSnapshot snapshotx = await storage
                                  .ref()
                                  .child(url)
                                  .putFile(_image)
                                  .onComplete;

                              if (snapshot.error == null) {
                                final String downloadUrl =
                                    await snapshotx.ref.getDownloadURL();
                                SharedPreferences cacheData =
                                    await SharedPreferences.getInstance();
                                final snapShot = Firestore.instance
                                    .collection('users')
                                    .where("uid",
                                        isEqualTo: snapshot.data.elementAt(8))
                                    .snapshots();
                                await Firestore.instance
                                    .collection("users")
                                    .document(snapshot.data.elementAt(8))
                                    .updateData({
                                  "url": downloadUrl,
                                }).whenComplete(() => refresh());
                                snapShot.forEach((element) {
                                  cacheData.setString("photoURL", downloadUrl);
                                });

                                final snackBar =
                                    SnackBar(content: Text('Yay! Success'));
                                Scaffold.of(context).showSnackBar(snackBar);
                              } else {
                                print(
                                    'Error from image repo ${snapshotx.error.toString()}');
                                throw ('This file is not an image');
                              }

                              print(snapshot.data.elementAt(9));
                            } catch (e) {
                              final snackBar = SnackBar(
                                  content: Text('Image selection failed.'));
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
                          },
                          child: (snapshot.data.elementAt(9) != 'null')
                              ? Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(
                                    snapshot.data.elementAt(9),
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 40,
                                ))
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        SizedBox(
          height: 30,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Ongoing",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ...documents
                .map((data) => _itemTileL(refresh, data, data.reference))
                .toList(),
            Divider(
              color: Colors.grey[800],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Scheduled",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ...documents
                .map((data) => _itemTileS(refresh, data, data.reference))
                .toList(),
            Divider(
              color: Colors.grey[800],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Completed", style: TextStyle(color: Colors.grey)),
            ),
            ...documents
                .map((data) => _itemTileC(refresh, data, data.reference))
                .toList(),
            Divider(
              color: Colors.grey[800],
            ),
          ],
        )
      ],
    );
  } catch (e) {
    print(e);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Sorry, there must a technical error !",
          style: TextStyle(color: Colors.white),
        ),
      ],
    ));
  }
}

bool isEmptyL = true, isEmptyS = true, isEmptyC = true;

Widget _itemTileL(void Function() refresh, DocumentSnapshot data,
    DocumentReference reference) {
  final record = Schedule.fromSnapshot(data);
  if (record.meetingStatus == "0") {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      color: Colors.grey[900],
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[800],
          child: Text(
            record.subjectCode.toString().substring(0, 2),
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        subtitle: Text(
          record.startTime + " to " + record.endTime,
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
        title: Text(
          record.subjectName.toString(),
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        trailing: meetingStatus(record.meetingStatus.toString()),
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(record.about.toString()),
              ),
            ],
          ),
          (crStatus == "true")
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.surround_sound),
                              onPressed: () => {
                                    showDialog(
                                      context: globalContext,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          actions: <Widget>[
                                            FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                onPressed: () => {
                                                      reference.firestore
                                                          .document(
                                                              reference.path)
                                                          .updateData(
                                                              {"mStatus": "0"})
                                                    },
                                                child: Text("Live")),
                                            FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                onPressed: () => {
                                                      reference.firestore
                                                          .document(
                                                              reference.path)
                                                          .updateData(
                                                              {"mStatus": "2"})
                                                    },
                                                child: Text("Completed")),
                                            FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                onPressed: () => {
                                                      reference.firestore
                                                          .document(
                                                              reference.path)
                                                          .updateData(
                                                              {"mStatus": "1"})
                                                    },
                                                child: Text("Sceduled"))
                                          ],
                                        );
                                      },
                                    )
                                  }),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => {
                              reference.firestore
                                  .document(reference.path)
                                  .delete()
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 0.8,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text("       Join Meeting       "),
                          onPressed: () async {
                            try {
                              bool launched = await launch(record.link,
                                  forceWebView: false);

                              if (!launched) {
                                await launch(record.link, forceWebView: false);
                              }
                            } catch (e) {
                              showDialog(
                                  context: globalContext,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                          "Something is not right, contact CR."),
                                    );
                                  });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.white,
                            width: 0.8,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text("       Join Meeting       "),
                    onPressed: () async {
                      try {
                        bool launched =
                            await launch(record.link, forceWebView: false);

                        if (!launched) {
                          await launch(record.link, forceWebView: false);
                        }
                      } catch (e) {
                        showDialog(
                            context: globalContext,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content:
                                    Text("Something is not right, contact CR."),
                              );
                            });
                      }
                    },
                  ),
                )
        ],
      ),
    );
  } else {
    return Center();
  }
}

Widget _itemTileS(void Function() refresh, DocumentSnapshot data,
    DocumentReference reference) {
  final record = Schedule.fromSnapshot(data);

  if (record.meetingStatus == "1") {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      color: Colors.grey[900],
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[800],
          child: Text(
            record.subjectCode.toString().substring(0, 2),
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        subtitle: Text(
          record.startTime + " to " + record.endTime,
          style: TextStyle(fontSize: 10),
        ),
        title: Text(
          record.subjectName.toString(),
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        trailing: meetingStatus(record.meetingStatus.toString()),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(record.about.toString()),
          ),
          (crStatus == "true")
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.surround_sound),
                              onPressed: () => {
                                    showDialog(
                                      context: globalContext,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          actions: <Widget>[
                                            FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                onPressed: () => {
                                                      reference.firestore
                                                          .document(
                                                              reference.path)
                                                          .updateData(
                                                              {"mStatus": "0"})
                                                    },
                                                child: Text("Live")),
                                            FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                onPressed: () => {
                                                      reference.firestore
                                                          .document(
                                                              reference.path)
                                                          .updateData(
                                                              {"mStatus": "2"})
                                                    },
                                                child: Text("Completed")),
                                            FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                onPressed: () => {
                                                      reference.firestore
                                                          .document(
                                                              reference.path)
                                                          .updateData(
                                                              {"mStatus": "1"})
                                                    },
                                                child: Text("Sceduled"))
                                          ],
                                        );
                                      },
                                    )
                                  }),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => {
                              reference.firestore
                                  .document(reference.path)
                                  .delete()
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 0.8,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text("       Join Meeting       "),
                          onPressed: () async {
                            try {
                              bool launched = await launch(record.link,
                                  forceWebView: false);

                              if (!launched) {
                                await launch(record.link, forceWebView: true);
                              }
                            } catch (e) {
                              showDialog(
                                  context: globalContext,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                          "Something is not right, contact CR."),
                                    );
                                  });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.white,
                            width: 0.8,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text("       Join Meeting       "),
                    onPressed: () async {
                      try {
                        bool launched =
                            await launch(record.link, forceWebView: false);

                        if (!launched) {
                          await launch(record.link, forceWebView: false);
                        }
                      } catch (e) {
                        showDialog(
                            context: globalContext,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content:
                                    Text("Something is not right, contact CR."),
                              );
                            });
                      }
                    },
                  ),
                )
        ],
      ),
    );
  } else {
    return Center();
  }
}

Widget _itemTileC(void Function() refresh, DocumentSnapshot data,
    DocumentReference reference) {
  final record = Schedule.fromSnapshot(data);

  if (record.meetingStatus == "2") {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      color: Colors.grey[900],
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[800],
          child: Text(
            record.subjectCode.toString().substring(0, 2),
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        subtitle: Text(
          record.startTime + " to " + record.endTime,
          style: TextStyle(fontSize: 10),
        ),
        title: Text(
          record.subjectName.toString(),
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        trailing: meetingStatus(record.meetingStatus.toString()),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(record.about.toString()),
          ),
          (crStatus == "true")
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.surround_sound),
                          onPressed: () => {
                                showDialog(
                                  context: globalContext,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      actions: <Widget>[
                                        FlatButton(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                            onPressed: () => {
                                                  reference.firestore
                                                      .document(reference.path)
                                                      .updateData(
                                                          {"mStatus": "0"})
                                                },
                                            child: Text("Live")),
                                        FlatButton(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                            onPressed: () => {
                                                  reference.firestore
                                                      .document(reference.path)
                                                      .updateData(
                                                          {"mStatus": "2"})
                                                },
                                            child: Text("Completed")),
                                        FlatButton(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                            onPressed: () => {
                                                  reference.firestore
                                                      .document(reference.path)
                                                      .updateData(
                                                          {"mStatus": "1"})
                                                },
                                            child: Text("Sceduled"))
                                      ],
                                    );
                                  },
                                )
                              }),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                        ),
                        onPressed: () => {
                          Navigator.of(globalContext).push(PageTransition(
                              child: EditAMeeting(
                                  record.subjectName,
                                  record.subjectCode,
                                  record.startTime,
                                  record.endTime,
                                  record.link,
                                  record.about,
                                  reference.path),
                              type: PageTransitionType.fade))
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () => {
                          reference.firestore.document(reference.path).delete()
                        },
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(0.0),
                )
        ],
      ),
    );
  } else {
    return Center();
  }
}

meetingStatus(String x) {
  if (x == "0")
    return Container(
      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
      decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: Text(
        "Live",
        style: TextStyle(color: Colors.red[700]),
      ),
    );
  else if (x == "1") {
    return Text(
      "Upcoming",
      style: TextStyle(color: Colors.yellow),
    );
  }
  if (x == "2")
    return Text(
      "Completed",
      style: TextStyle(color: Colors.grey),
    );
}

class Schedule {
  final String subjectCode;
  final String subjectName;
  final String startTime;
  final String endTime;
  final String link;
  final String about;
  final String meetingStatus;
  final DocumentReference reference;

  Schedule.fromMap(Map<String, dynamic> map, {this.reference})
      : subjectCode = map['sCode'],
        subjectName = map['sName'],
        startTime = map['startTime'],
        endTime = map['endTime'],
        about = map['about'],
        link = map['link'],
        meetingStatus = map["mStatus"];

  Schedule.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
