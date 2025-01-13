import 'package:flutter/material.dart';

class TIconTheme{
  TIconTheme._();

  static const iconButtonTheme = IconButtonThemeData(
    style: ButtonStyle(iconColor: WidgetStatePropertyAll(Color(0xFFE7E7E7)))
    );

  static const iconTheme = IconThemeData(
    color: Color(0xFFE7E7E7),
  );
}