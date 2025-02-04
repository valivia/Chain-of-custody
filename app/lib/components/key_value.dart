// Flutter imports:
import 'package:flutter/material.dart';

class KeyValue extends StatelessWidget {
  final String keyText;
  final String value;

  const KeyValue({super.key, required this.value, required this.keyText});

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        Text(
          "$keyText: ",
          style: aTextTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          value,
          style: aTextTheme.displaySmall,
        ),
      ],
    );
  }
}
