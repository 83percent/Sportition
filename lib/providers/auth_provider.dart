import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _uid;
  String? _name;

  AuthProvider() {
    _loadUserFromPrefs();
  }

  void setUser(String uid, String name) {
    _uid = uid;
    _name = name;
    notifyListeners();
  }

  Future<void> _loadUserFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uid = prefs.getString('userEmail');
    _name = prefs.getString('userName');
    notifyListeners();
  }

  String? get uid => _uid;
  String? get name => _name;

  bool get isLoggedIn => _uid != null && _name != null;
}
