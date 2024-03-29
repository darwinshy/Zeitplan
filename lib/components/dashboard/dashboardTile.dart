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
    margin: const EdgeInsets.all(20),
    padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
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
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            profileCacheData.elementAt(9)))))
                            : const Icon(
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

                TaskSnapshot snapshotx =
                    storage.ref().child(url).putFile(_image).snapshot;

                if (snapshotx == null) {
                  final String downloadUrl =
                      await snapshotx.ref.getDownloadURL();
                  SharedPreferences cacheData =
                      await SharedPreferences.getInstance();
                  final snapShot = FirebaseFirestore.instance
                      .collection('users')
                      .where("uid", isEqualTo: profileCacheData.elementAt(8))
                      .snapshots();
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(profileCacheData.elementAt(8))
                      .update({
                    "url": downloadUrl,
                  }).whenComplete(() => refresh());
                  snapShot.forEach((element) {
                    cacheData.setString("photoURL", downloadUrl);
                  });

                  const snackBar = SnackBar(content: Text('Yay! Success'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  print('Error from image repo ${snapshotx.toString()}');
                  throw ('This file is not an image');
                }
              } catch (e) {
                const snackBar =
                    SnackBar(content: Text('Image selection failed.'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: (profileCacheData.elementAt(8) != 'null')
                ? Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: const BoxDecoration(
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
                : const Icon(
                    Icons.account_circle,
                    size: 70,
                  ))
      ],
    ),
  );
}
