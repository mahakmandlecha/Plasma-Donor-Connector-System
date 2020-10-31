import 'package:flutter/material.dart';
import 'package:plasma_donor/models/authentication.dart';
import 'package:plasma_donor/views/homepage.dart';
import 'package:plasma_donor/views/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:plasma_donor/views/login_screen.dart';

import 'package:plasma_donor/views/signup_screen.dart';
//

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Authentication(),
        )
      ],
      child: MaterialApp(
      title: 'Plasma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "GoogleSans",
        primarySwatch: Colors.amberAccent[600],
      ),
      home: Home(),
      routes: {
         SignupScreen.routeName: (ctx) => SignupScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          HomePage.routeName: (ctx) => HomePage(),
          Home.routeName: (ctx) => Home(),
      },
    ));
  }
}
