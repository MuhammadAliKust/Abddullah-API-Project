import 'package:flutter/cupertino.dart';

class TokenProvider extends ChangeNotifier {
  String token = "";

  void setToken(String value) {
    token = value;
    notifyListeners();
  }

  String getToken() => token;
}
