import 'package:flutter/foundation.dart';

class AuthModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = 'John Doe';
  String _userEmail = 'john.doe@example.com';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;

  void login(String name, String email) {
    _userName = name.isNotEmpty ? name : 'User';
    _userEmail = email.isNotEmpty ? email : 'user@example.com';
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

final AuthModel auth = AuthModel();
