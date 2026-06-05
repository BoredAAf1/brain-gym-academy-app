import 'package:flutter/material.dart';

import 'package:brain_gym_academy_app/widgets/abacus_visual.dart';
import 'package:brain_gym_academy_app/widgets/app_page.dart';
import 'package:brain_gym_academy_app/widgets/badge.dart';

class SorobanRepresentationPage extends StatelessWidget {
  const SorobanRepresentationPage({super.key});

  static final List<AbacusRepresentation> numbers = List.generate(
    100,
    (index) => AbacusRepresentation(value: index, tens: index ~/ 10, ones: index % 10),
  );

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '0 to 99 Representation',
      subtitle: 'Every number is shown using tens and ones on the Abacus.',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: numbers
            .map(
              (item) => SizedBox(
                width: 220,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${item.value}',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            AppBadge('${item.tens}T ${item.ones}O'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Center(child: AbacusVisual(tens: item.tens, ones: item.ones)),
                        const SizedBox(height: 14),
                        Text('Tens: ${item.tens}'),
                        Text('Ones: ${item.ones}'),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class AbacusRepresentation {
  const AbacusRepresentation({required this.value, required this.tens, required this.ones});

  final int value;
  final int tens;
  final int ones;
}
