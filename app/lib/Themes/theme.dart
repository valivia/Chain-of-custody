import 'package:flutter/material.dart';
import 'package:coc/Themes/custom_themes/text_theme.dart';
import 'package:coc/Themes/custom_themes/eleveted_button_theme.dart';
import 'package:coc/Themes/custom_themes/appbar_theme.dart';
import 'package:coc/Themes/custom_themes/snackbar_theme.dart';
import 'package:coc/Themes/custom_themes/icon_theme.dart';

class TAppTheme{
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFFE7E7E7),
    scaffoldBackgroundColor: const Color(0xFFE7E7E7),
    appBarTheme: TAppBarThema.lightAppBarTheme,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevetedButtonTheme.lightElevatedButtonTheme,
    snackBarTheme: TSnackbarTheme.lightSnackBarTheme,
    iconButtonTheme: TIconTheme.iconButtonTheme,
    //error: Colors.red,
    //onError: Colors.white,
    
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF282C2F),
    scaffoldBackgroundColor: const Color(0xFF282C2F),
    appBarTheme: TAppBarThema.darkAppBarTheme,
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevetedButtonTheme.darkElevatedButtonTheme,
    snackBarTheme: TSnackbarTheme.darkSnackBarTheme,
    iconButtonTheme: TIconTheme.iconButtonTheme,
  );
}