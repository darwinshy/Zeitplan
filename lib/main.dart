import 'package:firebase_core/firebase_core.dart';

import 'components/splashScreen.dart';
import 'root.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'streamproviders.dart';

Future main() async {
  await Firebase.initializeApp();
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
      theme: ThemeData.dark(),
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
      seconds: 3,
      image: Image.asset(
        "asset/icon/logotext.png",
        width: 200,
      ),
      backgroundColor: Colors.black,
      loaderColor: Colors.yellow,
      photoSize: 100.0,
    );
  }
}
