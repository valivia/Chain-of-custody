import 'package:flutter/material.dart';

class SettingManager with ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;

  get theme => _theme;

  setTheme(ThemeMode themeMode) {
    _theme = themeMode;
    notifyListeners();
  }
}
