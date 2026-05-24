import 'package:flutter/material.dart';

class RodControlCard extends StatelessWidget {
  const RodControlCard({
    super.key,
    required this.title,
    required this.value,
    required this.minorIncrementLabel,
    required this.minorDecrementLabel,
    required this.majorIncrementLabel,
    required this.majorDecrementLabel,
    required this.onMinorIncrement,
    required this.onMinorDecrement,
    required this.onMajorIncrement,
    required this.onMajorDecrement,
  });

  final String title;
  final int value;
  final String minorIncrementLabel;
  final String minorDecrementLabel;
  final String majorIncrementLabel;
  final String majorDecrementLabel;
  final VoidCallback onMinorIncrement;
  final VoidCallback onMinorDecrement;
  final VoidCallback onMajorIncrement;
  final VoidCallback onMajorDecrement;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                '$value',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  OutlinedButton(onPressed: onMinorDecrement, child: Text(minorDecrementLabel)),
                  FilledButton.tonal(onPressed: onMinorIncrement, child: Text(minorIncrementLabel)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(onPressed: onMajorDecrement, child: Text(majorDecrementLabel)),
                  const SizedBox(width: 10),
                  FilledButton(onPressed: onMajorIncrement, child: Text(majorIncrementLabel)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
