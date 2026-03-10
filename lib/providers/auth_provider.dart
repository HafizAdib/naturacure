import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? token;
  String? role;

  void login(String t, String r) {
    token = t;
    role = r;
    notifyListeners();
  }

  void logout() {
    token = null;
    role = null;
    notifyListeners();
  }
}