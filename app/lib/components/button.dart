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
    final ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(1),
      backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    );

    return ElevatedButton(
      style: style,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Icon(icon, color: Theme.of(context).iconTheme.color),
        ],
      ),
    );
  }
}
