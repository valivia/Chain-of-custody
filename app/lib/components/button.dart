import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const Button({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(23, 23, 23, 1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Icon(icon, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
