// Flutter imports:
import 'package:flutter/material.dart';

class TSnackbarTheme {
  TSnackbarTheme._();

  static const lightSnackBarTheme = SnackBarThemeData(
    backgroundColor: Color(0xFF416671),
    contentTextStyle: TextStyle(color: Color(0xFF282C2F)),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
  );

  static const darkSnackBarTheme = SnackBarThemeData(
    backgroundColor: Color(0xFF466F7B),
    contentTextStyle: TextStyle(color: Color(0xFFE7E7E7)),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
  );
}
