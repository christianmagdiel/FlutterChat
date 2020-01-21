import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart' show required;
import 'package:secret_chat/utils/dialogs.dart';
import 'package:secret_chat/utils/session.dart';
import '../app_config.dart';

class AuthApi {
  final _session = Session();

  Future<bool> register(BuildContext context,
      {@required String username,
      @required String email,
      @required String password}) async {
    try {
      final url = "${AppConfig.apiHost}/register";

      final response = await http.post(url,
          body: {"username": username, "email": email, "password": password});

      final parsed = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = parsed['token'] as String;
        final expiresIn = parsed['expiresIn'] as int;

        await _registerToken(token);
        await _session.set(token, expiresIn);

        return true;
      } else if (response.statusCode == 500) {
        throw PlatformException(code: "500", message: parsed['message']);
      }
      throw PlatformException(code: "201", message: "Error /register");
    } on PlatformException catch (e) {
      Dialogs.alert(context, title: "Error", message: e.message);
      return false;
    }
  }

  Future<bool> login(BuildContext context,
      {@required String email, @required String password}) async {
    try {
      final url = "${AppConfig.apiHost}/login";

      final response =
          await http.post(url, body: {"email": email, "password": password});

      final parsed = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = parsed['token'] as String;
        final expiresIn = parsed['expiresIn'] as int;

        await _registerToken(token);
        await _session.set(token, expiresIn);

        return true;
      } else if (response.statusCode == 500) {
        throw PlatformException(code: "500", message: parsed['message']);
      }
      throw PlatformException(code: "201", message: "Error /login");
    } on PlatformException catch (e) {
      Dialogs.alert(context, title: "Error", message: e.message);
      return false;
    }
  }

  _registerToken(String token) async {
    try {
      final url = "${AppConfig.apiHost}/tokens/register";

      final response = await http.post(url, headers: {"token": token});

      final parsed = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 500) {
        throw PlatformException(code: "500", message: parsed['message']);
      }
      throw PlatformException(code: "201", message: "Error /tokens/register");
    } on PlatformException catch (e) {
      print('Error ${e.code}:${e.message}');
    }
  }

  Future<dynamic> _refreshToken(String expiredToken) async {
    try {
      final url = "${AppConfig.apiHost}/tokens/refresh";

      final response = await http.post(url, headers: {"token": expiredToken});

      final parsed = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return parsed;
      } else if (response.statusCode == 500) {
        throw PlatformException(code: "500", message: parsed['message']);
      }
      throw PlatformException(code: "201", message: "Error /tokens/refresh");
    } on PlatformException catch (e) {
      print('Error ${e.code}:${e.message}');
      return null;
    }
  }

  Future<String> getAccessToken() async {
    try {
      final result = await _session.get();
      if (result != null) {
        final token = result['token'] as String;
        final expiresIn = result['expiresIn'] as int;
        final createdAt = DateTime.parse(result['createdAt']);
        final currentDate = DateTime.now();

        final diff = currentDate.difference(createdAt).inSeconds;

        if (expiresIn - diff >= 60) {
          print('token is alive');
          return token;
        }

        //refrescar token

        final newData = await _refreshToken(token);
        if (newData != null) {
           print('refresh token');
          final newToken = newData['token'];
          final newExpiredIn = newData['expiresIn'];
          await _session.set(newToken, newExpiredIn);
          return newToken;
        }
        return null;
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      print('Error ${e.code}:${e.message}');
    }
  }
}
