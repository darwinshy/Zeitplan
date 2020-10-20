import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

Drawer mainDrawer(
  void Function() gotoAddScreen,
  void Function() goToAssignmentsScreen,
  void Function() goToEditScreen,
  void Function() goToAboutScreen,
  void Function() goToWhatsappDirectoryScreen,
  // void Function() goToMySubmissionScreen,
  void Function() goToDeveloperScreen,
  void Function() goToQuestionScreen,
  void Function() refresh,
  BuildContext context,
  void Function() signOut,
) {
  return Drawer(
    elevation: 100,
    child: Container(
      color: Colors.black45,
      // alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "More",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: refresh,
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white60,
                    )),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.note),
                FlatButton(
                    onPressed: goToAssignmentsScreen,
                    child: Text("Assignments"))
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(
                  MaterialCommunityIcons.file_question,
                ),
                FlatButton(
                    onPressed: goToQuestionScreen, child: Text("Question Bank"))
              ],
            ),
          ),
          // ListTile(
          //   title: Row(
          //     children: <Widget>[
          //       Icon(Icons.notes),
          //       FlatButton(
          //           onPressed: goToMySubmissionScreen,
          //           child: Text("My Submissions"))
          //     ],
          //   ),
          // ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.person_outline),
                FlatButton(
                    onPressed: goToWhatsappDirectoryScreen,
                    child: Text("Batchmates"))
              ],
            ),
          ),
          Divider(
            color: Colors.white60,
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.account_circle),
                FlatButton(
                    onPressed: goToEditScreen, child: Text("Edit Profile"))
              ],
            ),
          ),
          ListTile(
              title: Row(
            children: <Widget>[
              Icon(
                Icons.exit_to_app,
              ),
              FlatButton(onPressed: signOut, child: Text("Log Out"))
            ],
          )),
          Divider(
            color: Colors.white60,
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.code),
                FlatButton(
                    onPressed: goToDeveloperScreen,
                    child: Text("Know the Developer"))
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.adb),
                FlatButton(
                    onPressed: goToAboutScreen, child: Text("Version Info")),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
