import 'package:flutter/material.dart';

class TAppBarThema{
  TAppBarThema._();

  static const lightAppBarTheme = AppBarTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(16),
      ),
    ),
    backgroundColor: Color(0xFF416671),      
  );

  static const darkAppBarTheme = AppBarTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(16),
      ),
    ),
    backgroundColor: Color(0xFF466F7B),      
  );
}