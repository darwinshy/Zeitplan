import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget screentitleBoldBig(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: GoogleFonts.montserrat(
        textStyle: TextStyle(
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800)),
  );
}

Widget animatedLoader() {
  return Container(
    width: 100,
    height: 100,
    child: Center(
        child: FlareActor(
      "asset/icon/loader.flr",
      animation: "Untitled",
      alignment: Alignment.center,
      fit: BoxFit.contain,
    )),
  );
}

Widget screentitleBoldMedium(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: GoogleFonts.montserrat(
        textStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
  );
}

FlatButton genericFlatButtonWithRoundedBorders(
    String text, void Function() function) {
  return FlatButton(
    padding: EdgeInsets.all(10),
    focusColor: Colors.blue,
    onPressed: function,
    child: Text(text, style: TextStyle(color: Colors.yellow, fontSize: 18)),
    textColor: Colors.white,
    shape: RoundedRectangleBorder(
        side: BorderSide(
            color: Colors.yellow, width: 0.8, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(20)),
  );
}

Widget genericFlatButtonWithLoader() {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: CircularProgressIndicator(
      backgroundColor: Colors.transparent,
      strokeWidth: 3,
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow),
    ),
  );
}

FlatButton flatButtonWithRoundedShape(String text, void Function() function) {
  return FlatButton(
    minWidth: double.infinity,
    height: 60,
    padding: EdgeInsets.all(10),
    color: Colors.grey[200],
    onPressed: function,
    child: Text(text,
        style: TextStyle(
            color: Colors.grey[900],
            fontSize: 15,
            fontWeight: FontWeight.w500)),
    textColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  );
}

InputDecoration inputDecoration(String hint) {
  return InputDecoration(
    counterStyle: TextStyle(color: Colors.transparent),
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey[800], fontSize: 15),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey[100],
        width: 0.2,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey[600],
        width: 0.2,
      ),
    ),
  );
}

void showSomeAlerts(String text, BuildContext context) {
  showModalBottomSheet(
      enableDrag: true,
      context: context,
      builder: (BuildContext ctx) {
        return BottomSheet(
            backgroundColor: Colors.grey[100],
            onClosing: () {},
            builder: (ctx) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(text, style: TextStyle(color: Colors.grey[900])),
              );
            });
      });
}

void showProgressBar(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: Center(
            child: RefreshProgressIndicator(),
          ),
        );
      });
}

Future<void> showPromisedSomeAlerts(String text, BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Colors.grey[100],
          titleTextStyle: TextStyle(color: Colors.grey[900]),
          contentTextStyle: TextStyle(color: Colors.grey[900]),
          title: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        );
      });
}

Widget centerLoading() {
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

Widget linearProgressbar() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      LinearProgressIndicator(
        backgroundColor: Colors.white,
      )
    ],
  );
}

String giveMePMAM(String time) {
  int hrs = int.parse(time.substring(0, 2));
  String minutes = (time.substring(3, 5));
  // print(time);
  // print(hrs.toString() + " " + minutes.toString());
  String meridian = "AM";
  if (hrs > 12) {
    hrs = hrs - 12;
    meridian = "PM";
  }
  String meridian2 = hrs.toString() + ":" + minutes + " " + meridian;
  // print(meridian2);
  return meridian2;
}
