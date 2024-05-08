import 'package:flutter/material.dart';

class User {
  final String name;
  final String email;
  final String password;

  User({required this.name, required this.email, required this.password});
  User copyWith({String? name, String? email, String? password}) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  User.empty() : this(name: '', email: '', password: '');
}

class AuthProvider extends ChangeNotifier {
  User? _user;
  List<User> users = [];

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  void login(String email, String password) {
    _user = users.firstWhere(
      (user) => user.email == email && user.password == password,
    );
    if (_user == null) {
      throw Exception('User not found');
    }
    notifyListeners();
  }

  Future<void> logout() async{
    // signout from the server
    _user = null;
    notifyListeners();
  }

}
