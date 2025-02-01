// import 'package:coc/Themes/theme.dart';
import 'dart:math';
import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {

  // ThemeData _themeData = TAppTheme.lightTheme;
  ThemeMode _themeMode = ThemeMode.light;

  // get themeData => _themeData;
  get themeMode => _themeMode;

  toggleTheme(bool isDark){
    _themeMode = isDark?ThemeMode.dark:ThemeMode.light;
    // _themeMode = ThemeMode.system;
    notifyListeners();
  }
}