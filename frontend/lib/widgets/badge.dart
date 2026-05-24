import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  const AppBadge(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8C2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}
