import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget dashboardTile(AsyncSnapshot<List<String>> snapshot, BuildContext context,
    void Function() refresh) {
  Color badgeBg = Colors.grey[800];
  Color badgeBgGold = Colors.grey[100];
  Color badgeTx = Colors.grey[100];
  Color badgeTxGold = Colors.grey[800];
  String isCr = snapshot.data.elementAt(7);
  return Container(
    decoration: BoxDecoration(
        color: (isCr == "false") ? badgeBg : badgeBgGold,
        borderRadius: BorderRadius.circular(20)),
    margin: EdgeInsets.all(20),
    padding: EdgeInsets.fromLTRB(20, 30, 30, 30),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                child: Text(
                  snapshot.data.elementAt(0),
                  style: TextStyle(
                      color: (isCr == "false") ? badgeTx : badgeTxGold,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Text(
                  snapshot.data.elementAt(1),
                  style: TextStyle(
                    fontSize: 12,
                    color: (isCr == "false") ? badgeTx : badgeTxGold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 18, 4, 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      snapshot.data.elementAt(6),
                      style: TextStyle(
                        color: (isCr == "false") ? badgeTx : badgeTxGold,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      color: (isCr == "false") ? badgeTx : badgeTxGold,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          (isCr == "true") ? " CR " : " Student ",
                          style: TextStyle(
                            color: (isCr == "false") ? badgeTxGold : badgeTx,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                        backgroundColor: Colors.transparent,
                        content: (snapshot.data.elementAt(9) != 'null')
                            ? Container(
                                width: 200.0,
                                height: 200.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: new NetworkImage(
                                            snapshot.data.elementAt(9)))))
                            : Icon(
                                Icons.account_circle,
                                size: 100,
                              ));
                  });
            },
            onLongPress: () async {
              try {
                File _image;
                final picker = ImagePicker();

                final pickedFile = await picker.getImage(
                    imageQuality: 50, source: ImageSource.gallery);

                _image = File(pickedFile.path);
                var storage = FirebaseStorage.instance;
                String url = "images/" + snapshot.data.elementAt(8);

                StorageTaskSnapshot snapshotx =
                    await storage.ref().child(url).putFile(_image).onComplete;

                if (snapshot.error == null) {
                  final String downloadUrl =
                      await snapshotx.ref.getDownloadURL();
                  SharedPreferences cacheData =
                      await SharedPreferences.getInstance();
                  final snapShot = Firestore.instance
                      .collection('users')
                      .where("uid", isEqualTo: snapshot.data.elementAt(8))
                      .snapshots();
                  await Firestore.instance
                      .collection("users")
                      .document(snapshot.data.elementAt(8))
                      .updateData({
                    "url": downloadUrl,
                  }).whenComplete(() => refresh());
                  snapShot.forEach((element) {
                    cacheData.setString("photoURL", downloadUrl);
                  });

                  final snackBar = SnackBar(content: Text('Yay! Success'));
                  Scaffold.of(context).showSnackBar(snackBar);
                } else {
                  print('Error from image repo ${snapshotx.error.toString()}');
                  throw ('This file is not an image');
                }

                print(snapshot.data.elementAt(9));
              } catch (e) {
                final snackBar =
                    SnackBar(content: Text('Image selection failed.'));
                Scaffold.of(context).showSnackBar(snackBar);
              }
            },
            child: (snapshot.data.elementAt(9) != 'null')
                ? Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      snapshot.data.elementAt(9),
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
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
                    size: 40,
                  ))
      ],
    ),
  );
}