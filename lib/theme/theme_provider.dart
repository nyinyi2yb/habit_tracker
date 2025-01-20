import 'package:flutter/material.dart';
import 'package:my_app/theme/light_mode.dart';
import 'package:my_app/theme/dark_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //initially , light mode
  ThemeData _themeData = lightMode;

  //get current theme data
  ThemeData get themeData => _themeData;

  //is current theme is dark mode
  bool get isDarkMode => _themeData == darkMode;

  //set theme data
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //toogle theme
  void toogleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
