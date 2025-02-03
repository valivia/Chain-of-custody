// Flutter imports:
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String value;

  const Tag({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(value),
    );
  }
}
