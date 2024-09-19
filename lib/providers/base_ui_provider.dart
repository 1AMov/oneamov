import 'package:flutter/material.dart';

class BaseUIProvider with ChangeNotifier {
  bool isDrawerShrink = false;

  // BaseUI sections percentage
  double _firstSectionMaxWidth = 250.0;

  // String get selectedDrawerItem => _selectedDrawerItem;

  double get firstSectionMaxWidth => _firstSectionMaxWidth;

  // changeDrawerItem(String value) {
  //   _selectedDrawerItem = value;

  //   notifyListeners();
  // }

  shrinkDrawer(bool value) {
    isDrawerShrink = value;

    if (value) {
      _firstSectionMaxWidth = 60.0;
    } else {
      _firstSectionMaxWidth = 250.0;
    }

    notifyListeners();
  }
}
