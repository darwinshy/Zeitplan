import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/reusables.dart';
import '../../classes/classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget itemTileSubmission(
    List<String> cacehData, DocumentSnapshot data, BuildContext context) {
  final record = Submission.fromSnapshot(data);
  bool canModify = record.submitterUID == cacehData.elementAt(7) ? true : false;
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

  void deleteThisSubmission() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            backgroundColor: Colors.grey[100],
            titleTextStyle: TextStyle(color: Colors.grey[900]),
            contentTextStyle: TextStyle(color: Colors.grey[900]),
            title: const Text("Do you want to delete this submission ? "),
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

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 3),
    padding: const EdgeInsets.all(10),
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
        'Submitted On : ' +
            giveMePMAM(record.submitterDateAndTime.substring(11, 16)) +
            ", " +
            record.submitterDateAndTime.substring(0, 11),
        style:
            TextStyle(color: Colors.grey[900], fontSize: 10, fontFamily: "rob"),
      ),
      trailing: canModify
          ? InkWell(
              onTap: deleteThisSubmission,
              child: const Icon(Icons.delete, color: Colors.red),
            )
          : const SizedBox(width: 0, height: 0),
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Description",
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 10,
                    fontFamily: "OpenSans",
                  )),
              const SizedBox(
                height: 8,
              ),
              Text(record.submitterDescription,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.grey[900],
                  )),
              const SizedBox(
                height: 16,
              ),
              Text("Click here",
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 10,
                    fontFamily: "OpenSans",
                  )),
              const SizedBox(
                height: 4,
              ),
              OutlineButton(
                  borderSide: BorderSide(color: Colors.grey[900]),
                  child: Text(
                    "Visit",
                    style: TextStyle(color: Colors.grey[900]),
                  ),
                  onPressed: openLink,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)))
            ],
          ),
        ),
      ],
    ),
  );
}
