import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secret_chat/api/auth_api.dart';
import 'package:secret_chat/api/profile_api.dart';
import 'package:secret_chat/models/user.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _authAPI = AuthApi();
  final _profileAPI = ProfileAPI();
  @override
  void initState() {
    super.initState();
    this.check();
  }

  check() async {
    final token = await _authAPI.getAccessToken();
    if (token != null) {
      final result = await _profileAPI.getUserInfo(context, token);

      final user = User.fromJson(result);

      print("id: ${user.id}");
      print("email: ${user.email}");
      print("user json: ${user.toJson()}");

      Navigator.pushReplacementNamed(context, "home");
    } else {
      Navigator.pushReplacementNamed(context, "login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(radius: 15),
      ),
    );
  }
}
