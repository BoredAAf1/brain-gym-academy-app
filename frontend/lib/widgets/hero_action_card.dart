import 'package:flutter/material.dart';

class HeroActionCard extends StatelessWidget {
  const HeroActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 34, color: const Color(0xFF3E2A1F)),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3E2A1F),
                    ),
              ),
              const SizedBox(height: 8),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}
