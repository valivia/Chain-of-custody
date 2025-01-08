import 'package:flutter/material.dart';

class TElevetedButtonTheme {
  TElevetedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF416671),
      foregroundColor: const Color(0xFF282C2F),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF466F7B),
      foregroundColor: const Color(0xFFE7E7E7),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
  );
}