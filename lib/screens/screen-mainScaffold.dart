import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen-about.dart';
import 'screen-adding-admin.dart';
import 'screen-assigmentlist.dart';
import 'screen-developer.dart';
import 'screen-edit-profile.dart';
import 'screen-question-paper-select.dart';
import 'screen-whatsappdirectory.dart';
import '../root.dart';
import '../screens/screen-mySubmission.dart';
import '../authentication/auth.dart';
import '../components/drawer.dart';
import '../components/schedules/schedulesList.dart';
import '../streamproviders.dart';

BuildContext mainScaffoldContext;

class MainScreenScaffold extends StatefulWidget {
  @override
  _MainScreenScaffoldState createState() => _MainScreenScaffoldState();
}

class _MainScreenScaffoldState extends State<MainScreenScaffold> {
  @override
  void initState() {
    refresh();
    mainScaffoldContext = context;
    super.initState();
  }

  // ###################################################################
  String crStatus = "false";
  // ###################################################################
  // Date Formatting for AppBar
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('ddMMyyyy');
  DateFormat formatterAppbar = DateFormat('dd MMM');
  String formattedAppBar = DateFormat('dd MMM ').format(DateTime.now());
  String formatted = DateFormat('ddMMyyyy').format(DateTime.now());
  // ###################################################################
  // Refresh
  void refresh() async {
    print("Refresh was called");
    String dbUrlSchedules;
    String dbUrlAssignment;
    SharedPreferences cacheData = await SharedPreferences.getInstance();
    final userDocumentFromDatabase = Firestore.instance
        .collection('users')
        .where(
          "uid",
          isEqualTo: cacheData.getString("userUID").toString(),
        )
        .snapshots();

    userDocumentFromDatabase.forEach((element) {
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

    setState(() {
      print("setstatecalled");
      crStatus = cacheData.getBool("CR").toString();
      print("crStatus " + crStatus);
    });
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

  void goToWhatsappDirectoryScreen() {
    Navigator.of(context).push(
        PageTransition(child: WhatsappScreen(), type: PageTransitionType.fade));
  }

  void goToDeveloperScreen() {
    Navigator.of(context).push(PageTransition(
        child: DeveloperScreen(), type: PageTransitionType.fade));
  }

  void goToAboutScreen() {
    Navigator.of(context).push(
        PageTransition(child: AboutScreen(), type: PageTransitionType.fade));
  }

  void goToQuestionScreen() {
    Navigator.of(context).push(PageTransition(
        child: QuestionPaperScreenSelect(), type: PageTransitionType.fade));
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
    final retriveProfileDetails =
        Provider.of<SharedPreferencesProviders>(context);
    return Scaffold(
        drawer: mainDrawer(
            gotoAddScreen,
            goToAssignmentsScreen,
            goToEditScreen,
            goToAboutScreen,
            goToWhatsappDirectoryScreen,
            // goToMySubmissionScreen,
            goToDeveloperScreen,
            goToQuestionScreen,
            refresh,
            context,
            signOut),
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          centerTitle: true,
          elevation: 0,
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
        body: buildSchedulesBody(
            refresh,
            context,
            retriveProfileDetails.getAllSharedPreferenceData(),
            formatted,
            crStatus));
  }
}
