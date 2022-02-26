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
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "More",
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: refresh,
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white60,
                    )),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                const Icon(Icons.note),
                FlatButton(
                    onPressed: goToAssignmentsScreen,
                    child: const Text("Assignments"))
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                const Icon(
                  MaterialCommunityIcons.file_question,
                ),
                FlatButton(
                    onPressed: goToQuestionScreen, child: const Text("Question Bank"))
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
                const Icon(Icons.person_outline),
                FlatButton(
                    onPressed: goToWhatsappDirectoryScreen,
                    child: const Text("Batchmates"))
              ],
            ),
          ),
          const Divider(
            color: Colors.white60,
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                const Icon(Icons.account_circle),
                FlatButton(
                    onPressed: goToEditScreen, child: const Text("Edit Profile"))
              ],
            ),
          ),
          ListTile(
              title: Row(
            children: <Widget>[
              const Icon(
                Icons.exit_to_app,
              ),
              FlatButton(onPressed: signOut, child: const Text("Log Out"))
            ],
          )),
          const Divider(
            color: Colors.white60,
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                const Icon(Icons.code),
                FlatButton(
                    onPressed: goToDeveloperScreen,
                    child: const Text("Know the Developer"))
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                const Icon(Icons.adb),
                FlatButton(
                    onPressed: goToAboutScreen, child: const Text("Version Info")),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
