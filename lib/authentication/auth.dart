import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password,
      String fullName, String scholarId, String section, String phoneNumber);
  Future<String> signInWithGoogle();
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth extends BaseAuth with ChangeNotifier {
  Future<String> signInWithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    final snapShot =
        await Firestore.instance.collection('users').document(user.uid).get();
    if (!snapShot.exists) {
      Firestore.instance.collection("users").document(user.uid).setData({
        "uid": user.uid,
        "name": user.displayName,
        "email": user.email,
        "phone": user.phoneNumber,
        "address": null,
      });
    } else {
      print("User Exists");
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Saving User to Storage : " + user.uid);
    prefs.setString("userTYPE", "client");
    prefs.setString("userUID", user.uid);

    notifyListeners();

    return user.uid;
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    String dbUrlSchedules;
    String dbUrlAssignment;
    try {
      AuthResult authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = authResult.user;

      if (user.isEmailVerified) {
        final snapShot = Firestore.instance
            .collection('users')
            .where("uid", isEqualTo: user.uid)
            .snapshots();
        await Firestore.instance
            .collection('users')
            .document(user.uid)
            .updateData({"verified": true});
        //
        SharedPreferences cacheData = await SharedPreferences.getInstance();

        snapShot.forEach((element) {
          //
          dbUrlSchedules = "schedules/" +
              element.documents.elementAt(0).data["batch"].substring(2) +
              "/" +
              element.documents.elementAt(0).data["branch"] +
              "/section/" +
              element.documents.elementAt(0).data["section"].toUpperCase() +
              "_SX";
          //
          dbUrlAssignment = "assignment/" +
              element.documents.elementAt(0).data["batch"].substring(2) +
              "/" +
              element.documents.elementAt(0).data["branch"] +
              "/section/" +
              element.documents.elementAt(0).data["section"].toUpperCase() +
              "_SX";
          //
          cacheData.setString("userUID", user.uid);
          cacheData.setString(
              "fullname", element.documents.elementAt(0).data["name"]);
          cacheData.setString(
              "email", element.documents.elementAt(0).data["email"]);
          cacheData.setString(
              "phone", element.documents.elementAt(0).data["phone"]);
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
          cacheData.setString(
              "photoURL", element.documents.elementAt(0).data["url"]);
        });

        notifyListeners();
        return user.uid;
      }
      await user.sendEmailVerification();
      return "#Please complete the email verification process before logging in. Check you email once.";
    } catch (e) {
      return "#" + e.toString();
    }
  }

  Future<String> createUserWithEmailAndPassword(
      String email,
      String password,
      String fullName,
      String scholarId,
      String section,
      String phoneNumber) async {
    String batchYear;
    String branch;
    String dbUrlProfile;
    String dbUrlSchedules;
    String dbUrlAssignment;
    SharedPreferences cacheData = await SharedPreferences.getInstance();
    batchYear = "20" + scholarId.substring(0, 2);

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
      }
    }

    print(branch);

    try {
      AuthResult authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = authResult.user;
      try {
        await user.sendEmailVerification();

        final snapShot = await Firestore.instance
            .collection('users')
            .document(user.uid)
            .get();
        if (!snapShot.exists) {
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
//
          dbUrlAssignment = "assignment/" +
              batchYear.substring(2) +
              "/" +
              branch +
              "/section/" +
              section.toUpperCase() +
              "_SX";
          //
          dbUrlProfile = "users/" + user.uid;
          //
          dbUrlSchedules = "schedules/" +
              batchYear.substring(2) +
              "/" +
              branch +
              "/section/" +
              section.toUpperCase() +
              "_SX";

          cacheData.setString("userUID", user.uid);
          cacheData.setString("fullname", fullName);
          cacheData.setString("email", email);
          cacheData.setBool("CR", false);
          cacheData.setString("phone", phoneNumber);
          cacheData.setString("scholarId", scholarId);
          cacheData.setString("section", section);
          cacheData.setString("batchYear", batchYear);
          cacheData.setString("branch", branch);
          cacheData.setString("dbUrlSchedules", dbUrlSchedules);
          cacheData.setString("dbUrlAssignment", dbUrlAssignment);
          cacheData.setString("dbUrlProfile", dbUrlProfile);
        }

        notifyListeners();
        return "#Notice: An email verification link has been sent to your email. Please follow the link to verify your account";
      } catch (e) {
        print(e.message);
        return "#" + e.toString();
      }
    } catch (e) {
      return "#" + e.toString();
    }
  }

  Future<String> currentUser() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      notifyListeners();

      return user.uid;
    } catch (e) {
      return null;
    }
  }

  Future<String> getEmail() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    notifyListeners();

    return user.email;
  }

  Future<String> getName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    notifyListeners();

    return user.displayName;
  }

  Future<String> getPhoto() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    notifyListeners();

    return user.photoUrl;
  }

  Future<void> signOut() {
    notifyListeners();
    try {
      return FirebaseAuth.instance.signOut();
    } catch (e) {
      return null;
    }
  }
}
