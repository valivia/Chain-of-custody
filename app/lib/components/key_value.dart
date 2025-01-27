// Flutter imports:
import 'package:flutter/material.dart';

class KeyValue extends StatelessWidget {
  final String keyText;
  final String value;

  const KeyValue({super.key, required this.value, required this.keyText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          keyText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value),
      ],
    );
  }
}
