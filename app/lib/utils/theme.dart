import 'package:flutter/material.dart';
import 'package:coc/utils/text_theme.dart';

class TAppTheme{
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Color(0xFFE7E7E7),
    scaffoldBackgroundColor: Color(0xFFE7E7E7),
    appBarTheme: AppBarTheme(color: Color(0xFF416671)),
    textTheme: TTextTheme.lightTextTheme,
    
  );
  static ThemeData darkTheme = ThemeData();
}