import 'package:flutter_icons/flutter_icons.dart';

import '../../classes/classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../reusables.dart';

Widget questionPaperTile(
    DocumentSnapshot data, BuildContext context, String uid) {
  final record = QuestionPaper.fromSnapshot(data);
  bool canDelete = uid == record.questionPaperSubmitterUID ? true : false;
  final date = DateTime.parse(record.questionPaperUploadDateAndTime);

  void openQuestionPaper() async {
    String url = record.questionPaperLink;
    print(url);
    try {
      bool launched = await launch(url, forceWebView: false);

      if (!launched) {
        await launch(url, forceWebView: false);
      }
    } catch (e) {
      showSomeAlerts("Sorry, the URL seems to broken.", context);
    }
  }

  void deleteThisQuestionPaper() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            backgroundColor: Colors.grey[100],
            titleTextStyle: TextStyle(color: Colors.grey[900]),
            contentTextStyle: TextStyle(color: Colors.grey[900]),
            title: Text("Do you want to delete this question paper ?"),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey[900]),
                  )),
              FlatButton(
                onPressed: () => {
                  record.reference
                      .delete()
                      .then((value) => Navigator.of(context).pop())
                },
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.grey[900]),
                ),
              )
            ],
          );
        });
  }

  return Container(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(18),
    decoration: BoxDecoration(
        color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[900],
          radius: 20,
          child: Text(
            record.questionPaperYear,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[100], fontSize: 10),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              child: Text(
                record.questionPaperSubjectName,
                style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "for " + record.questionPaperMidEnd,
              style: TextStyle(color: Colors.grey[900], fontSize: 10),
            ),
            Text(
              "by " + record.questionPaperSubmitterName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 10,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 10,
                  color: Colors.grey[900],
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  giveMePMAM(date.toString().substring(11, 16)) +
                      ", " +
                      date.toString().substring(0, 11),
                  style: TextStyle(color: Colors.grey[900], fontSize: 10),
                ),
              ],
            )
          ],
        ),
        Spacer(),
        Row(
          children: [
            canDelete
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: deleteThisQuestionPaper)
                : Center(),
            IconButton(
                icon: Icon(
                  EvilIcons.external_link,
                  color: Colors.grey[900],
                  size: 30,
                ),
                onPressed: openQuestionPaper)
          ],
        ),
      ],
    ),
  );
}
