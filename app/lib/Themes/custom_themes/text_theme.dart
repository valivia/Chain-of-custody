import 'package:flutter/material.dart';

class TTextTheme {
  TTextTheme._();

  static const lightTextColor = Color(0xFFE7E7E7);
  static const darkTextColor = Color(0xFF282C2F);
  static const halfligthTextColor = Color(0x80E7E7E7);
  static const halfdarkTextColor = Color(0xCC282C2F);

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold, color: lightTextColor),
    headlineMedium: const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w600, color: lightTextColor),
    headlineSmall: const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w600, color: lightTextColor),

    displayLarge: const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold, color: darkTextColor), //used on lightbackground colors, same style as headline
    displayMedium: const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.bold, color: halfdarkTextColor),
    displaySmall: const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w600, color: darkTextColor), //used on lightbackground colors, same style as headline

    titleLarge: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w600, color: lightTextColor),
    titleMedium: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: lightTextColor),
    titleSmall: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w400, color: lightTextColor),

    bodyLarge: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: lightTextColor),
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.normal, color: lightTextColor),
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: halfligthTextColor),
    
    labelLarge: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: lightTextColor),
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: halfligthTextColor),
  );
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold, color: lightTextColor),
    headlineMedium: const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w600, color: lightTextColor),
    headlineSmall: const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w600, color: lightTextColor),

    displayLarge: const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold, color: lightTextColor),
    displayMedium: const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.bold, color: lightTextColor),
    displaySmall: const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w600, color: lightTextColor),

    titleLarge: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w600, color: lightTextColor),
    titleMedium: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: lightTextColor),
    titleSmall: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w400, color: lightTextColor),

    bodyLarge: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: lightTextColor),
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.normal, color: lightTextColor),
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: halfligthTextColor),
    
    labelLarge: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: lightTextColor),
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: halfligthTextColor),

  );
}