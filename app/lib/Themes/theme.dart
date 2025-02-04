import 'package:flutter/material.dart';
import 'package:coc/Themes/custom_themes/text_theme.dart';
import 'package:coc/Themes/custom_themes/eleveted_button_theme.dart';
import 'package:coc/Themes/custom_themes/appbar_theme.dart';
import 'package:coc/Themes/custom_themes/snackbar_theme.dart';
import 'package:coc/Themes/custom_themes/icon_theme.dart';

class TAppTheme{
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary:  Color(0xFF416671),
      onPrimary:  Color(0xFFE7E7E7),  
      secondary:  Color(0xFFBFBFBF),
      onSecondary: Color(0xFFE7E7E7), 
      error: Colors.red, 
      onError: Colors.white,
      surface: Color(0xFFE7E7E7),
      onSurface: Color(0xFF282C2F),
      onSecondaryContainer: Color(0xCC282C2F),
      tertiary: Color.fromARGB(255, 16, 61, 75),
      ),
    scaffoldBackgroundColor: const Color(0xFFE7E7E7),
    appBarTheme: TAppBarThema.lightAppBarTheme,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevetedButtonTheme.lightElevatedButtonTheme,
    snackBarTheme: TSnackbarTheme.lightSnackBarTheme,
    iconButtonTheme: TIconTheme.iconButtonTheme,
    iconTheme: TIconTheme.iconTheme,
    
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary:  Color(0xFF446F7B),
      onPrimary:  Color(0xFFE7E7E7),  
      secondary:  Color(0xFF211F1F),
      onSecondary: Color(0xFFE7E7E7), 
      error: Colors.red, 
      onError: Colors.white,
      surface: Color(0xFF282C2F),
      onSurface: Color(0xFFE7E7E7),
      tertiary: Color.fromARGB(255, 12, 84, 105),
      onSecondaryContainer: Color(0xFFE7E7E7),
      ),
    scaffoldBackgroundColor: const Color(0xFF282C2F),
    appBarTheme: TAppBarThema.darkAppBarTheme,
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevetedButtonTheme.darkElevatedButtonTheme,
    snackBarTheme: TSnackbarTheme.darkSnackBarTheme,
    iconButtonTheme: TIconTheme.iconButtonTheme,
  );
}