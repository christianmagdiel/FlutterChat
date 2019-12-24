import 'package:flutter/material.dart';
import 'package:secret_chat/pages/login.dart';
import 'package:secret_chat/pages/sign_up.dart';
 
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
      home: LoginPage(),
      routes: {
        "login"   : (BuildContext context) => LoginPage(),
        "signup"  : (BuildContext context) => SignUpPage(),
      },
    );
  }
}