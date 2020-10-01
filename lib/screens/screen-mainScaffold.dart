import '../screens/screen-mySubmission.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/auth.dart';
import '../components/dashboard/dashboardTile.dart';
import '../components/drawer.dart';
import '../components/schedules/schedulesItem.dart';
import '../components/schedules/schedulesList.dart';
import 'screen-about.dart';
import 'screen-adding-admin.dart';
import 'screen-assigmentlist.dart';
import 'screen-edit-profile.dart';
import 'connectivityScreenRerouter.dart';
import 'screen-whatsappdirectory.dart';
import '../root.dart';

class MainScreenScaffold extends StatefulWidget {
  final AsyncSnapshot<List<String>> snapshotOfInternetAccessibility;
  MainScreenScaffold(this.snapshotOfInternetAccessibility);

  @override
  _MainScreenScaffoldState createState() => _MainScreenScaffoldState();
}

class _MainScreenScaffoldState extends State<MainScreenScaffold> {
  String crStatus = "false";

  // ###################################################################
  // Date Formatting for AppBar and URL
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('ddMMyyyy');
  DateFormat formatterAppbar = DateFormat('dd MMM');
  String formattedAppBar = DateFormat('dd MMM ').format(DateTime.now());
  String formatted = DateFormat('ddMMyyyy').format(DateTime.now());
  // ###################################################################

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
    });

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
  }

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
  // Navigational Function

  void gotoAddScreen() {
    Navigator.of(context).push(
        PageTransition(child: AddingScreen(), type: PageTransitionType.fade));
  }

  void goToEditScreen() {
    Navigator.of(context).push(PageTransition(
        child: EditProfile(refresh), type: PageTransitionType.fade));
  }

  void goToAssignmentsScreen() {
    Navigator.of(context).push(
        PageTransition(child: Assignments(), type: PageTransitionType.fade));
  }

  void goToMySubmissionScreen() {
    Navigator.of(context).push(PageTransition(
        child: MySubmssionScreen(), type: PageTransitionType.fade));
  }

  void goToWhatsappDirectoryScreen() {
    Navigator.of(context).push(
        PageTransition(child: WhatsappScreen(), type: PageTransitionType.fade));
  }

  void goToAboutScreen() {
    Navigator.of(context).push(
        PageTransition(child: AboutScreen(), type: PageTransitionType.fade));
  }

  // ###################################################################
  // Functions

  void changeDate() {
    showDatePicker(
            context: context,
            initialDate: now,
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((value) => setDateOnTheAppBar(value))
        .then((value) => refresh());
  }

  void setDateOnTheAppBar(DateTime value) {
    setState(() {
      formatted = formatter.format(value);
      formattedAppBar = formatterAppbar.format(value);
      now = value;
    });
  }

  void signOut() {
    Auth().signOut().whenComplete(() async {
      SharedPreferences cacheData = await SharedPreferences.getInstance();
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
  }

// ###################################################################
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: mainDrawer(
            gotoAddScreen,
            goToAssignmentsScreen,
            goToEditScreen,
            goToAboutScreen,
            goToWhatsappDirectoryScreen,
            goToMySubmissionScreen,
            refresh,
            context,
            signOut),
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
                        fontFamily: "rob", color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (crStatus == "true")
            ? FloatingActionButton.extended(
                icon: Icon(Icons.add),
                label: Text("Admin Panel",
                    style: TextStyle(color: Colors.grey[800])),
                backgroundColor: Colors.grey[100],
                // child: Icon(Icons.add),
                onPressed: gotoAddScreen,
                isExtended: true,
              )
            : null,
        backgroundColor: Colors.grey[900],
        body: widget.snapshotOfInternetAccessibility.data[3] != "true" ||
                widget.snapshotOfInternetAccessibility.data[3] == "null"
            ? info(context)
            : buildSchedulesBody(refresh, context, retriveScheduleURL,
                retriveProfileDetails, formatted, crStatus));
  }
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
                child: MainScreen(), type: PageTransitionType.fade));
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

Widget buildListofSchedules(
    void Function() refresh,
    List<DocumentSnapshot> documents,
    Future<List<String>> Function() retriveProfileDetails,
    String crStatus) {
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
                  refresh();
                } else {
                  crStatus = "false";
                  refresh();
                }
              } catch (e) {
                print(e);
              }

              if (snapshot.hasData) {
                return dashboardTile(snapshot, context, refresh);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        SizedBox(
          height: 30,
        ),
        (documents.length != 0)
            ? schedulesColumn(documents, refresh, crStatus)
            : noMeetings()
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

Widget noMeetings() {
  return Container(
    margin: EdgeInsets.only(top: 100),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Image.asset(
          "asset/img/nomeeting.png",
          height: 150,
        )),
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: Text(
            "No classes scheduled today.\n Ask your Class Representative to add one.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        )
      ],
    ),
  );
}

Widget schedulesColumn(
    List<DocumentSnapshot> documents, void refresh(), String crStatus) {
  return Column(
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
          .map((data) => itemTileL(refresh, data, data.reference, crStatus))
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
          .map((data) => itemTileS(refresh, data, data.reference, crStatus))
          .toList(),
      Divider(
        color: Colors.grey[800],
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Completed", style: TextStyle(color: Colors.grey)),
      ),
      ...documents
          .map((data) => itemTileC(refresh, data, data.reference, crStatus))
          .toList(),
      Divider(
        color: Colors.grey[800],
      ),
    ],
  );
}
