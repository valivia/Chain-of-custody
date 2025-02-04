import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class SettingManager with ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;

  get theme => _theme;

  SettingManager();

  static SettingManager initialize() {
    final settings = localStorage.getItem("settings");
    if (settings == null) {
      return SettingManager();
    }

    try {
      return SettingManager.fromJson(jsonDecode(settings));
    } catch (e) {
      log("Error loading settings: $e");
      return SettingManager();
    }
  }

  setTheme(ThemeMode themeMode) {
    _theme = themeMode;
    savePreferencesToLocalStorage();
  }

  savePreferencesToLocalStorage() {
    localStorage.setItem("settings", jsonEncode(toJson()));
    notifyListeners();
  }

  SettingManager.fromJson(Map<String, dynamic> json) {
    _theme = ThemeMode.values.firstWhere(
      (e) => e.toString() == json["theme"],
      orElse: () => ThemeMode.system,
    );
  }

  toJson() {
    return {
      "theme": _theme.toString(),
    };
  }
}
