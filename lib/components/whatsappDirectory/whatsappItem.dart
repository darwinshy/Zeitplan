import 'package:fluttericon/font_awesome_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../classes/classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget whatsappItemTile(DocumentSnapshot data, BuildContext ctx) {
  final record = Classmate.fromSnapshot(data);
  Color badgeBg =
      record.cr != "true" ? Colors.grey[100] : Colors.amberAccent[100];

  Color badgeTx =
      record.cr == "true" ? const Color.fromRGBO(92, 68, 0, 1) : Colors.grey[900];
  if (record.verified == "true") {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: badgeBg, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                      context: ctx,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                            elevation: 0,
                            backgroundColor: Colors.grey[100],
                            titleTextStyle: TextStyle(color: Colors.grey[900]),
                            contentTextStyle:
                                TextStyle(color: Colors.grey[900]),
                            content: (record.photoURL != 'null')
                                ? Container(
                                    width: 200.0,
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                record.photoURL))))
                                : Icon(
                                    Icons.account_circle,
                                    size: 100,
                                    color: badgeTx,
                                  ));
                      });
                },
                child: record.photoURL != "null"
                    ? Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          record.photoURL,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50,
                        color: badgeTx,
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.fullname.toUpperCase(),
                        style: TextStyle(color: badgeTx, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        record.email,
                        style: TextStyle(color: badgeTx, fontSize: 10),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        record.phoneNumber,
                        style: TextStyle(color: badgeTx, fontSize: 10),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        record.scholarId,
                        style: TextStyle(color: badgeTx, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
              FlatButton(
                  onPressed: () {
                    showDialog(
                        context: ctx,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 0,
                            backgroundColor: Colors.grey[100],
                            content: Text(
                              "Do you want to text " +
                                  record.fullname +
                                  " on Whatsapp ?",
                              style: TextStyle(color: Colors.grey[900]),
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "No",
                                    style: TextStyle(color: Colors.grey[900]),
                                  )),
                              FlatButton(
                                  onPressed: () async {
                                    String url = 'https://wa.me/' +
                                        record.phoneNumber.toString();

                                    try {
                                      bool launched = await launch(url,
                                          forceWebView: false);

                                      if (!launched) {
                                        await launch(url, forceWebView: false);
                                      }
                                    } catch (e) {
                                      AlertDialog(
                                        content: Text(
                                          "Something is not right, please try again",
                                          style: TextStyle(
                                              color: Colors.grey[900]),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.grey[900]),
                                  )),
                            ],
                          );
                        });
                  },
                  child: Icon(
                    FontAwesome.whatsapp,
                    color: badgeTx,
                  ))
            ],
          )
        ],
      ),
    );
  } else {
    return const SizedBox(
      height: 0,
    );
  }
}
