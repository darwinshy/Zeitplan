import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseQueries with ChangeNotifier {
  Stream<QuerySnapshot> providestreams(String path) {
    return Firestore.instance.collection(path).snapshots();
  }

  Future<void> updateDocument(
      String path, String uniqueDocID, Map<String, dynamic> data) {
    return Firestore.instance
        .collection(path)
        .document(uniqueDocID)
        .updateData(data);
  }

  Future<void> setDocumentWithUniqueID(
      String path, String uniqueID, Map<String, dynamic> data) {
    return Firestore.instance.collection(path).document(uniqueID).setData(data);
  }
}

class SharedPreferencesProviders with ChangeNotifier {
  Future<List<String>> getAllSharedPreferenceData() async {
    SharedPreferences cacheData = await SharedPreferences.getInstance();
    return [
      // 0
      cacheData.getString("fullname").toString(),
      // 1
      cacheData.getString("email").toString(),
      // 2
      cacheData.getString("phone").toString(),
      // 3
      cacheData.getString("scholarId").toString(),
      // 4
      cacheData.getString("section").toString(),
      // 5
      cacheData.getString("batchYear").toString(),
      // 6
      cacheData.getString("branch").toString(),
      // 7
      cacheData.getString("userUID").toString(),
      // 8
      cacheData.getString("photoURL").toString(),
      // 9
      cacheData.getString("photoURL").toString(),
      // 10
      cacheData.getBool("CR").toString(),
      //  11
      cacheData.getString("dbUrlSchedules"),
      //  12
      cacheData.getString("dbUrlAssignment"),
    ];
  }
}
