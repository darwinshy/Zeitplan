import 'package:Zeitplan/components/animations.dart';

import '../../components/whatsappDirectory/whatsappItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget streamBuildWhatsappDirectoryList(
    AsyncSnapshot<List<String>> snapshot,
    Future<List<String>> Function() retriveProfileDetails,
    BuildContext context) {
  var batchYear = snapshot.data.elementAt(5);
  var batchBranch = snapshot.data.elementAt(6);
  print(batchYear);
  return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("users")
          .orderBy("scholarId")
          .where(
            "branch",
            isEqualTo: batchBranch,
          )
          .where("batch", isEqualTo: batchYear)
          .snapshots(),
      builder: (context, snapshot) {
        try {
          return _buildListofNames(snapshot.data.documents, context);
        } catch (e) {
          print(e);
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

Widget _buildListofNames(
    List<DocumentSnapshot> documents, BuildContext context) {
  return ListView(addAutomaticKeepAlives: true, children: <Widget>[
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        "Batchmates",
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w800)),
      ),
    ),
    ...documents
        .map((data) => FadeInLTR(1, whatsappItemTile(data, context)))
        .toList()
  ]);
}
