import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'initialisingUser.dart';

abstract class BaseAuth {
  Future<String> resetPassword(String email);
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(
      String email,
      String password,
      String fullName,
      String scholarId,
      String section,
      String phoneNumber,
      String branch,
      String batchYear);
  Future<String> signInWithGoogle();
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth extends BaseAuth with ChangeNotifier {
  Future<String> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "We have sent you an email with the password reset link. Please follow the link to reset your password.";
    } catch (e) {
      return "#" + e.message.toString();
    }
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User user = authResult.user;

      if (user.emailVerified) {
        await updateUserDocuments(user);
        notifyListeners();
        return user.uid;
      }
      await user.sendEmailVerification();
      return "#Please complete the email verification process before logging in. We have sent you an email. If not recieved contact administrator.";
    } catch (e) {
      print(e);
      return "#" + e.message.toString();
    }
  }

  Future<String> createUserWithEmailAndPassword(
      String email,
      String password,
      String fullName,
      String scholarId,
      String section,
      String phoneNumber,
      String branch,
      String batchYear) async {
    try {
      UserCredential authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = authResult.user;
      try {
        await user.sendEmailVerification().then((_) => {
              creatingUserDocuments(email, password, fullName, scholarId,
                  section, phoneNumber, branch, batchYear, user)
            });

        notifyListeners();
        return "#A verification link has been sent to your email. Please follow the link to verify your account";
      } catch (e) {
        return "#" + e.message.toString();
      }
    } catch (e) {
      return "#" + e.message.toString();
    }
  }

  Future<String> currentUser() async {
    try {
      User user = FirebaseAuth.instance.currentUser;
      notifyListeners();

      return user.uid;
    } catch (e) {
      return e.message.toString();
    }
  }

  Future<String> getEmail() async {
    User user = FirebaseAuth.instance.currentUser;
    notifyListeners();
    return user.email;
  }

  Future<String> getName() async {
    User user = FirebaseAuth.instance.currentUser;
    notifyListeners();
    return user.displayName;
  }

  Future<String> getPhoto() async {
    User user = FirebaseAuth.instance.currentUser;
    notifyListeners();
    return user.photoURL;
  }

  Future<void> signOut() {
    notifyListeners();
    try {
      return FirebaseAuth.instance.signOut();
    } catch (e) {
      return null;
    }
  }

  Future<String> signInWithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    final snapShot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!snapShot.exists) {
      FirebaseFirestore.instance.collection("users").doc(user.uid).set({
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
}
