
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:secret_chat/models/user.dart';

class Me extends ChangeNotifier{
  User _data;

  User get data => _data;

  set data(User user){
    this._data = user;
    notifyListeners();
  }

  static Me of(BuildContext context) => Provider.of<Me>(context);
}