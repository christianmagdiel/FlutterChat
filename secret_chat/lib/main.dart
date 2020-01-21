import 'package:flutter/material.dart';
import 'package:secret_chat/pages/home.dart';
import 'package:secret_chat/pages/login.dart';
import 'package:secret_chat/pages/sign_up.dart';
import 'package:secret_chat/pages/splash.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      routes: {
        "login"   : (BuildContext context) => LoginPage(),
        "signup"  : (BuildContext context) => SignUpPage(),
        "home"    : (BuildContext context) => HomePage()
      },
    );
  }
}