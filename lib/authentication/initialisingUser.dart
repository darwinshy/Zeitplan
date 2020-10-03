import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateUserDocuments(FirebaseUser user) async {
  String dbUrlSchedules;
  String dbUrlAssignment;

  final userDocumentSnapshots = Firestore.instance
      .collection('users')
      .where("uid", isEqualTo: user.uid)
      .snapshots();
  await Firestore.instance
      .collection('users')
      .document(user.uid)
      .updateData({"verified": true});
  //
  SharedPreferences cacheData = await SharedPreferences.getInstance();

  userDocumentSnapshots.forEach((element) {
    // ###############################################
    //  Database Path for Getting Schedules
    dbUrlSchedules = "schedules/" +
        element.documents.elementAt(0).data["batch"].substring(2) +
        "/" +
        element.documents.elementAt(0).data["branch"] +
        "/section/" +
        element.documents.elementAt(0).data["section"].toUpperCase() +
        "_SX";
    // Database Path for Getting Assignments
    dbUrlAssignment = "assignment/" +
        element.documents.elementAt(0).data["batch"].substring(2) +
        "/" +
        element.documents.elementAt(0).data["branch"] +
        "/section/" +
        element.documents.elementAt(0).data["section"].toUpperCase() +
        "_SX";
    // ###############################################
    cacheData.setString("userUID", user.uid);
    cacheData.setString(
        "fullname", element.documents.elementAt(0).data["name"]);
    cacheData.setString("email", element.documents.elementAt(0).data["email"]);
    cacheData.setString("phone", element.documents.elementAt(0).data["phone"]);
    cacheData.setString(
        "scholarId", element.documents.elementAt(0).data["scholarId"]);
    cacheData.setString(
        "section", element.documents.elementAt(0).data["section"]);
    cacheData.setString(
        "batchYear", element.documents.elementAt(0).data["batch"]);
    cacheData.setString(
        "branch", element.documents.elementAt(0).data["branch"]);
    cacheData.setBool("CR", element.documents.elementAt(0).data["CR"]);
    cacheData.setString("dbUrlSchedules", dbUrlSchedules);
    cacheData.setString("dbUrlAssignment", dbUrlAssignment);
    cacheData.setString("photoURL", element.documents.elementAt(0).data["url"]);
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
    FirebaseUser user) async {
  String dbUrlProfile;
  String dbUrlSchedules;
  String dbUrlAssignment;
  SharedPreferences cacheData = await SharedPreferences.getInstance();

  final userSnapshotOfCurrentUID =
      await Firestore.instance.collection('users').document(user.uid).get();

  if (!userSnapshotOfCurrentUID.exists) {
// ###############################################
    // Saving the user data to database
    Firestore.instance.collection('users').document(user.uid).setData({
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
