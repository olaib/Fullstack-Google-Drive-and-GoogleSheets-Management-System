import 'package:flutter/material.dart';

class CustomGestureDetector extends StatelessWidget {
  const CustomGestureDetector({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
    );
  }
}
