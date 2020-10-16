import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../animations.dart';

Widget dashboardTile(List<String> profileCacheData, BuildContext context,
    void Function() refresh) {
  Color badgeBg = Colors.grey[800];
  Color badgeBgGold = Colors.grey[100];
  Color badgeTx = Colors.grey[100];
  Color badgeTxGold = Colors.grey[800];
  String isCr = profileCacheData.elementAt(10);
  String firstName = profileCacheData.elementAt(0).split(' ').first;
  return Container(
    decoration: BoxDecoration(
        color: (isCr == "false") ? badgeBg : badgeBgGold,
        borderRadius: BorderRadius.circular(20)),
    margin: EdgeInsets.all(20),
    padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeInLTR(
                1,
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                  child: Text(
                    "Hello",
                    style: TextStyle(
                        color: (isCr == "false") ? badgeTx : badgeTxGold,
                        fontSize: 25,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              FadeInLTR(
                1.2,
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: Text(
                    firstName,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                      color: (isCr == "false") ? badgeTx : badgeTxGold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 18, 4, 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      profileCacheData.elementAt(6),
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
                        content: (profileCacheData.elementAt(9) != 'null')
                            ? Container(
                                width: 200.0,
                                height: 200.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: new NetworkImage(
                                            profileCacheData.elementAt(9)))))
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
                String url = "images/" + profileCacheData.elementAt(8);

                StorageTaskSnapshot snapshotx =
                    await storage.ref().child(url).putFile(_image).onComplete;

                if (snapshotx.error == null) {
                  final String downloadUrl =
                      await snapshotx.ref.getDownloadURL();
                  SharedPreferences cacheData =
                      await SharedPreferences.getInstance();
                  final snapShot = Firestore.instance
                      .collection('users')
                      .where("uid", isEqualTo: profileCacheData.elementAt(8))
                      .snapshots();
                  await Firestore.instance
                      .collection("users")
                      .document(profileCacheData.elementAt(8))
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
              } catch (e) {
                final snackBar =
                    SnackBar(content: Text('Image selection failed.'));
                Scaffold.of(context).showSnackBar(snackBar);
              }
            },
            child: (profileCacheData.elementAt(8) != 'null')
                ? Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      profileCacheData.elementAt(8),
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
                    size: 70,
                  ))
      ],
    ),
  );
}
