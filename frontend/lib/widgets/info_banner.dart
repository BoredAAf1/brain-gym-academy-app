import 'package:flutter/material.dart';

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key, required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines
            .map((line) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('• $line'),
                ))
            .toList(),
      ),
    );
  }
}
