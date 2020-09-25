import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

BuildContext ctx;

class WhatsappScreen extends StatelessWidget {
  Future<List<String>> retriveProfileDetails() async {
    SharedPreferences cacheData = await SharedPreferences.getInstance();
    return [
      cacheData.getString("fullname").toString(),
      cacheData.getString("email").toString(),
      cacheData.getString("phone").toString(),
      cacheData.getString("scholarId").toString(),
      cacheData.getString("section").toString(),
      cacheData.getString("batchYear").toString(),
      cacheData.getString("branch").toString(),
      cacheData.getBool("CR").toString(),
      cacheData.getString("userUID").toString()
    ];
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
          future: retriveProfileDetails(),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              return _streamBuild(snapshot, retriveProfileDetails);
            } else {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ));
            }
          }),
    );
  }
}

Widget _streamBuild(AsyncSnapshot<List<String>> snapshot,
    Future<List<String>> Function() retriveProfileDetails) {
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
          return _buildListofNames(snapshot.data.documents);
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

Widget _buildListofNames(List<DocumentSnapshot> documents) {
  return ListView(children: <Widget>[
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
    ...documents.map((data) => _itemTile(data)).toList()
  ]);
}

Widget _itemTile(DocumentSnapshot data) {
  final record = Classmate.fromSnapshot(data);
  Color badgeBg =
      record.cr != "true" ? Colors.grey[800] : Color.fromRGBO(229, 194, 102, 1);

  Color badgeTx =
      record.cr == "true" ? Color.fromRGBO(92, 68, 0, 1) : Colors.white;

  return Container(
    margin: EdgeInsets.all(8),
    padding: EdgeInsets.all(8),
    decoration:
        BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(10)),
    child: ExpansionTile(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email Address",
                      style: TextStyle(color: badgeTx),
                    ),
                    SelectableText(record.email.toString(),
                        style: TextStyle(color: badgeTx, fontSize: 18))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Phone Number", style: TextStyle(color: badgeTx)),
                    SelectableText(record.phoneNumber.toString(),
                        style: TextStyle(color: badgeTx, fontSize: 18))
                  ],
                ),
              ),
              FlatButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.white,
                          width: 0.8,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    showDialog(
                        context: ctx,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                              "Do you want to text " +
                                  record.fullname +
                                  " on Whatsapp ?",
                            ),
                            actions: [
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
                                            "Something is not right, please try again"),
                                      );
                                    }
                                  },
                                  child: Text("Yes")),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No"))
                            ],
                          );
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Text on Whatsapp  "),
                      Icon(FontAwesome.whatsapp),
                    ],
                  ))
            ],
          ),
        )
      ],
      leading: InkWell(
        onTap: () {
          showDialog(
              context: ctx,
              builder: (BuildContext ctx) {
                return AlertDialog(
                    backgroundColor: Colors.transparent,
                    content: (record.photoURL != 'null')
                        ? Container(
                            width: 200.0,
                            height: 200.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: new NetworkImage(record.photoURL))))
                        : Icon(
                            Icons.account_circle,
                            size: 100,
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
                size: 50,
              ),
      ),
      title: Text(
        record.fullname.toUpperCase(),
        style: TextStyle(color: badgeTx, fontSize: 15),
      ),
      subtitle: Text(
        record.scholarId,
        style: TextStyle(color: badgeTx, fontSize: 10),
      ),
      trailing: record.cr == "true" ? Icon(FontAwesome5.crown) : null,
    ),
  );
}

class Classmate {
  final String email;
  final String fullname;
  final String cr;
  final String batchBranch;
  final String phoneNumber;
  final String scholarId;
  final String section;
  final String photoURL;
  final DocumentReference reference;

  Classmate.fromMap(Map<String, dynamic> map, {this.reference})
      : cr = map['CR'].toString(),
        photoURL = map['url'].toString(),
        batchBranch = map['branch'],
        phoneNumber = map['phone'],
        scholarId = map['scholarId'],
        fullname = map["name"],
        section = map['section'],
        email = map["email"];

  Classmate.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
