import 'package:Zeitplan/classes/classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../reusables.dart';

Widget itemTileMySubmission(DocumentSnapshot data, BuildContext context) {
  final record = Submission.fromSnapshot(data);
  // Functions
  void deleteThisSubmission() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            backgroundColor: Colors.grey[100],
            titleTextStyle: TextStyle(color: Colors.grey[900]),
            contentTextStyle: TextStyle(color: Colors.grey[900]),
            title: Text("Do you want to delete this submission ? "),
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
                      .then((_) => Navigator.of(context).pop())
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

  void openLink() async {
    String url = record.submitterFileLink;
    try {
      bool launched = await launch(url, forceWebView: false);

      if (!launched) {
        await launch(url, forceWebView: false);
      }
    } catch (e) {
      await launch(url, forceWebView: true);
    }
  }

  return Container(
    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
    child: ExpansionTile(
      leading: Icon(
        Entypo.documents,
        color: Colors.grey[800],
      ),
      title: Text(
        record.submitterName,
        style:
            TextStyle(color: Colors.grey[900], fontSize: 15, fontFamily: "rob"),
      ),
      subtitle: Text(
        'Subject : ' + record.submissionTopic,
        style:
            TextStyle(color: Colors.grey[900], fontSize: 10, fontFamily: "rob"),
      ),
      trailing: InkWell(
        onTap: deleteThisSubmission,
        child: Icon(Icons.delete, color: Colors.red),
      ),
      children: [
        Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Submitted On',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 10,
                    fontFamily: "OpenSans",
                  )),
              SizedBox(
                height: 4,
              ),
              Text(
                  giveMePMAM(record.submitterDateAndTime.substring(11, 16)) +
                      ", " +
                      record.submitterDateAndTime.substring(0, 11),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.grey[900],
                  )),
              SizedBox(
                height: 8,
              ),
              Text("Description",
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 10,
                    fontFamily: "OpenSans",
                  )),
              SizedBox(
                height: 4,
              ),
              Text(record.submitterDescription,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.grey[900],
                  )),
              SizedBox(
                height: 8,
              ),
              Text("Click here",
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 10,
                    fontFamily: "OpenSans",
                  )),
              SizedBox(
                height: 4,
              ),
              OutlineButton(
                  borderSide: BorderSide(color: Colors.grey[900]),
                  child: new Text(
                    "Visit",
                    style: TextStyle(color: Colors.grey[900]),
                  ),
                  onPressed: openLink,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)))
            ],
          ),
        ),
      ],
    ),
  );
}
