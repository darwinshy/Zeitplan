
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../streamproviders.dart';
import '../animations.dart';
import '../reusables.dart';
import 'questionPaperItem.dart';

Widget buildListofQuestionPaper(
    List<DocumentSnapshot> documents, BuildContext context) {
  final sharedpreferencedata =
      Provider.of<SharedPreferencesProviders>(context, listen: false);
  return FutureBuilder(
      future: sharedpreferencedata.getAllSharedPreferenceData(),
      builder: (context, AsyncSnapshot<List<String>> sharedPrefsDataSnapshot) {
        try {
          if (sharedPrefsDataSnapshot.hasData) {
            if (documents.isNotEmpty) {
              return ListView(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Question Paper",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
                ...documents
                    .map((data) => FadeInLTR(
                        1,
                        questionPaperTile(data, context,
                            sharedPrefsDataSnapshot.data.elementAt(7))))
                    .toList()
              ]);
            } else {
              return _noQuestionScreen();
            }
          } else
            return Center();
        } catch (e) {
          return Center();
        }
      });
}

Widget _noQuestionScreen() {
  return Column(children: <Widget>[
    Padding(
        padding: const EdgeInsets.all(20.0),
        child: screentitleBoldBig("Question Paper")),
    SizedBox(
      height: 20,
    ),
    Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image.asset(
            "asset/img/class.png",
            height: 200,
          )),
          Center(
              child: Text(
                  "No Questions Papers found. \nClick on + icon to add one.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]))),
        ],
      ),
    )
  ]);
}
