import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  String _currentPage = "home";

  String get currentPage => _currentPage;

  void setCurrentPage(String page) {
    _currentPage = page;
    notifyListeners();
  }
}
