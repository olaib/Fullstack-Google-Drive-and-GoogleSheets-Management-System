import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _user = {
      'email': 'guest',
      'name': 'guest',
    };
  }

  Map<String, dynamic>? _user;

  Map<String, dynamic>? get user => _user;

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  Future<void> signOut() async {}
}
