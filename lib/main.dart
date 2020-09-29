import 'root.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'streamproviders.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SharedPreferencesProviders()),
        ChangeNotifierProvider(create: (_) => DatabaseQueries()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zeitplan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      navigateAfterSeconds: Root(),
      seconds: 4,
      image: Image.asset(
        "asset/icon/splash.png",
        width: 100,
      ),
      title: Text(
        "Zeitplan",
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w800)),
      ),
      backgroundColor: Colors.black,
      loadingText: Text(
        "",
        style: TextStyle(fontFamily: "QuickSand", color: Colors.white),
      ),
      photoSize: 100.0,
    );
  }
}
