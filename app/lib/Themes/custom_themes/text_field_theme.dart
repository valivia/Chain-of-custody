import 'package:flutter/material.dart';

class TTextFormField {
  TTextFormField._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: const TextStyle().copyWith(fontSize: 14, color: const Color(0xFF282C2F)),
  );
}