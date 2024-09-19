import 'package:flutter/material.dart';

class AuthStateProvider with ChangeNotifier {
  String? _emailErrorText;
  String _completePhoneNumber = "";
  String _password = "";

  String get emailErrorText => _emailErrorText!;
  String get completePhoneNumber => _completePhoneNumber;
  String get password => _password;

  void validateEmail(String value) {
    if (value.isEmpty) {
      _emailErrorText = 'Email is required';
    } else if (!isEmailValid(value)) {
      _emailErrorText = 'Enter a valid email address';
    } else {
      _emailErrorText = null;
    }

    notifyListeners();
  }

  void resetTexts() {
    _emailErrorText = null;
    _completePhoneNumber = "";
    _password = '';
    notifyListeners();
  }

  bool isEmailValid(String email) {
    // Basic email validation using regex
    // You can implement more complex validation if needed
    return RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  void onPhoneChanged(String v) {
    _completePhoneNumber = v;

    notifyListeners();
  }

  void onPasswordChanged(String v) {
    _password = v;

    notifyListeners();
  }
}
