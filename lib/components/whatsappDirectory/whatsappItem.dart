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
      record.cr == "true" ? Color.fromRGBO(92, 68, 0, 1) : Colors.grey[900];
  if (record.verified == "true")
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(18),
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
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
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
                        decoration: new BoxDecoration(
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
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        record.email,
                        style: TextStyle(color: badgeTx, fontSize: 10),
                      ),
                      SizedBox(
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

  // return Container(
  //   margin: EdgeInsets.all(8),
  //   padding: EdgeInsets.all(8),
  //   decoration: BoxDecoration(
  //       color: badgeBg, borderRadius: BorderRadius.circular(10)),
  //   child: ExpansionTile(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(15.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "Email Address",
  //                     style: TextStyle(color: badgeTx),
  //                   ),
  //                   SelectableText(record.email.toString(),
  //                       style: TextStyle(color: badgeTx, fontSize: 18))
  //                 ],
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text("Phone Number", style: TextStyle(color: badgeTx)),
  //                   SelectableText(record.phoneNumber.toString(),
  //                       style: TextStyle(color: badgeTx, fontSize: 18))
  //                 ],
  //               ),
  //             ),
  //             FlatButton(
  //                 shape: RoundedRectangleBorder(
  //                     side: BorderSide(
  //                         color: Colors.white,
  //                         width: 0.8,
  //                         style: BorderStyle.solid),
  //                     borderRadius: BorderRadius.circular(20)),
  //                 onPressed: () {
  //                   showDialog(
  //                       context: ctx,
  //                       builder: (BuildContext context) {
  //                         return AlertDialog(
  //                           content: Text(
  //                             "Do you want to text " +
  //                                 record.fullname +
  //                                 " on Whatsapp ?",
  //                           ),
  //                           actions: [
  //                             FlatButton(
  //                                 onPressed: () async {
  //                                   String url = 'https://wa.me/' +
  //                                       record.phoneNumber.toString();

  //                                   try {
  //                                     bool launched = await launch(url,
  //                                         forceWebView: false);

  //                                     if (!launched) {
  //                                       await launch(url,
  //                                           forceWebView: false);
  //                                     }
  //                                   } catch (e) {
  //                                     AlertDialog(
  //                                       content: Text(
  //                                           "Something is not right, please try again"),
  //                                     );
  //                                   }
  //                                 },
  //                                 child: Text("Yes")),
  //                             FlatButton(
  //                                 onPressed: () {
  //                                   Navigator.pop(context);
  //                                 },
  //                                 child: Text("No"))
  //                           ],
  //                         );
  //                       });
  //                 },
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text("Text on Whatsapp  "),
  //                     Icon(FontAwesome.whatsapp),
  //                   ],
  //                 ))
  //           ],
  //         ),
  //       )
  //     ],
  //     leading: InkWell(
  //       onTap: () {
  //         showDialog(
  //             context: ctx,
  //             builder: (BuildContext ctx) {
  //               return AlertDialog(
  //                   backgroundColor: Colors.transparent,
  //                   content: (record.photoURL != 'null')
  //                       ? Container(
  //                           width: 200.0,
  //                           height: 200.0,
  //                           decoration: new BoxDecoration(
  //                               shape: BoxShape.rectangle,
  //                               image: new DecorationImage(
  //                                   fit: BoxFit.cover,
  //                                   image:
  //                                       new NetworkImage(record.photoURL))))
  //                       : Icon(
  //                           Icons.account_circle,
  //                           size: 100,
  //                         ));
  //             });
  //       },
  //       child: record.photoURL != "null"
  //           ? Container(
  //               width: 50.0,
  //               height: 50.0,
  //               decoration: new BoxDecoration(
  //                 shape: BoxShape.circle,
  //               ),
  //               clipBehavior: Clip.antiAlias,
  //               child: Image.network(
  //                 record.photoURL,
  //                 loadingBuilder: (BuildContext context, Widget child,
  //                     ImageChunkEvent loadingProgress) {
  //                   if (loadingProgress == null) return child;
  //                   return Center(
  //                     child: CircularProgressIndicator(
  //                       value: loadingProgress.expectedTotalBytes != null
  //                           ? loadingProgress.cumulativeBytesLoaded /
  //                               loadingProgress.expectedTotalBytes
  //                           : null,
  //                     ),
  //                   );
  //                 },
  //               ),
  //             )
  //           : Icon(
  //               Icons.account_circle,
  //               size: 50,
  //             ),
  //     ),
  //     title: Text(
  //       record.fullname.toUpperCase(),
  //       style: TextStyle(color: badgeTx, fontSize: 15),
  //     ),
  //     subtitle: Text(
  //       record.scholarId,
  //       style: TextStyle(color: badgeTx, fontSize: 10),
  //     ),
  //     trailing: record.cr == "true" ? Icon(FontAwesome5.crown) : null,
  //   ),
  // );
  else
    return SizedBox(
      height: 0,
    );
}
