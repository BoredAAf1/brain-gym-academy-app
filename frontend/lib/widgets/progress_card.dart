import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.title,
    required this.completed,
    required this.total,
    required this.color,
  });

  final String title;
  final int completed;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final percent = completed / total;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text('$completed / $total'),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 14,
                value: percent,
                color: color,
                backgroundColor: color.withOpacity(0.18),
              ),
            ),
            const SizedBox(height: 10),
            Text('${(percent * 100).round()}% complete'),
          ],
        ),
      ),
    );
  }
}
