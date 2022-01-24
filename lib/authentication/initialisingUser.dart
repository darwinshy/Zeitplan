import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateUserDocuments(User user) async {
  String dbUrlSchedules;
  String dbUrlAssignment;

  final userDocumentFromDatabase = FirebaseFirestore.instance
      .collection('users')
      .where("uid", isEqualTo: user.uid)
      .snapshots();
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .update({"verified": true});
  //
  SharedPreferences cacheData = await SharedPreferences.getInstance();

  userDocumentFromDatabase.forEach((element) {
    // ###############################################
    //  Database Path for Getting Schedules
    dbUrlSchedules = "schedules/" +
        element.docs.elementAt(0).data()["batch"].substring(2) +
        "/" +
        element.docs.elementAt(0).data()["branch"] +
        "/section/" +
        element.docs.elementAt(0).data()["section"].toUpperCase() +
        "_SX";
    // Database Path for Getting Assignments
    dbUrlAssignment = "assignment/" +
        element.docs.elementAt(0).data()["batch"].substring(2) +
        "/" +
        element.docs.elementAt(0).data()["branch"] +
        "/section/" +
        element.docs.elementAt(0).data()["section"].toUpperCase() +
        "_SX";
    // ###############################################
    cacheData.setString("userUID", user.uid);
    cacheData.setString("fullname", element.docs.elementAt(0).data()["name"]);
    cacheData.setString("email", element.docs.elementAt(0).data()["email"]);
    cacheData.setString("phone", element.docs.elementAt(0).data()["phone"]);
    cacheData.setString(
        "scholarId", element.docs.elementAt(0).data()["scholarId"]);
    cacheData.setString("section", element.docs.elementAt(0).data()["section"]);
    cacheData.setString("batchYear", element.docs.elementAt(0).data()["batch"]);
    cacheData.setString("branch", element.docs.elementAt(0).data()["branch"]);
    cacheData.setBool("CR", element.docs.elementAt(0).data()["CR"]);
    cacheData.setString("dbUrlSchedules", dbUrlSchedules);
    cacheData.setString("dbUrlAssignment", dbUrlAssignment);
    cacheData.setString("photoURL", element.docs.elementAt(0).data()["url"]);
  });
}

Future<void> creatingUserDocuments(
    String email,
    String password,
    String fullName,
    String scholarId,
    String section,
    String phoneNumber,
    String branch,
    String batchYear,
    User user) async {
  String dbUrlProfile;
  String dbUrlSchedules;
  String dbUrlAssignment;
  SharedPreferences cacheData = await SharedPreferences.getInstance();

  final userSnapshotOfCurrentUID =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  if (!userSnapshotOfCurrentUID.exists) {
// ###############################################
    // Saving the user data to database
    FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      "uid": user.uid,
      "name": fullName,
      "email": user.email,
      "phone": phoneNumber,
      "scholarId": scholarId,
      "section": section.toUpperCase(),
      "batch": batchYear,
      "branch": branch,
      "CR": false,
      "verified": false
    });
    // ###############################################
    // Database Path for Getting Assignments
    dbUrlAssignment = "assignment/" +
        batchYear.substring(2) +
        "/" +
        branch +
        "/section/" +
        section.toUpperCase() +
        "_SX";
    // Database Path for Getting User Profile
    dbUrlProfile = "users/" + user.uid;
    //  Database Path for Getting Schedules
    dbUrlSchedules = "schedules/" +
        batchYear.substring(2) +
        "/" +
        branch +
        "/section/" +
        section.toUpperCase() +
        "_SX";
    //
    // ###############################################
    cacheData.setString("userUID", user.uid);
    cacheData.setString("fullname", fullName);
    cacheData.setString("email", email);
    cacheData.setString("phone", phoneNumber);
    cacheData.setString("scholarId", scholarId);
    cacheData.setString("section", section);
    cacheData.setString("batchYear", batchYear);
    cacheData.setString("branch", branch);
    cacheData.setString("dbUrlSchedules", dbUrlSchedules);
    cacheData.setString("dbUrlAssignment", dbUrlAssignment);
    cacheData.setString("dbUrlProfile", dbUrlProfile);
    cacheData.setBool("CR", false);
  }
}
