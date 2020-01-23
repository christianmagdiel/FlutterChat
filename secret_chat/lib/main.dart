import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secret_chat/pages/home.dart';
import 'package:secret_chat/pages/login.dart';
import 'package:secret_chat/pages/sign_up.dart';
import 'package:secret_chat/pages/splash.dart';
import 'package:secret_chat/providers/chat_provider.dart';
import 'package:secret_chat/providers/me.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Me(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashPage(),
        routes: {
          "login": (BuildContext context) => LoginPage(),
          "splash": (BuildContext context) => SplashPage(),
          "signup": (BuildContext context) => SignUpPage(),
          "home": (BuildContext context) => HomePage()
        },
      ),
    );
  }
}
