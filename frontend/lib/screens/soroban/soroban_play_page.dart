import 'package:flutter/material.dart';

import '../../models/student_models.dart';
import '../../widgets/app_page.dart';
import '../../widgets/abacus_visual.dart';
import '../../widgets/metric_widgets.dart';
import '../../widgets/rod_control_card.dart';

class SorobanPlayPage extends StatefulWidget {
  const SorobanPlayPage({super.key, this.selectedStudent});

  final StudentProfile? selectedStudent;

  @override
  State<SorobanPlayPage> createState() => _SorobanPlayPageState();
}

class _SorobanPlayPageState extends State<SorobanPlayPage> {
  int tens = 0;
  int ones = 0;

  int get total => (tens * 10) + ones;

  void setTens(int value) => setState(() => tens = value.clamp(0, 9));

  void setOnes(int value) => setState(() => ones = value.clamp(0, 9));

  void setFromNumber(int value) {
    final safe = value.clamp(0, 99);
    setState(() {
      tens = safe ~/ 10;
      ones = safe % 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Virtual Abacus',
      subtitle: widget.selectedStudent != null
          ? 'Free-play for ${widget.selectedStudent!.name} on the traditional Japanese abacus.'
          : 'Free-play the traditional Japanese abacus with tens and ones rods.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: BigMetric(label: 'Total', value: '$total')),
                      Expanded(child: BigMetric(label: 'Tens', value: '$tens')),
                      Expanded(child: BigMetric(label: 'Ones', value: '$ones')),
                    ],
                  ),
                  const SizedBox(height: 18),
                  AbacusVisual(tens: tens, ones: ones),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: [
                      RodControlCard(
                        title: 'Tens Rod',
                        value: tens,
                        minorIncrementLabel: '+10',
                        minorDecrementLabel: '-10',
                        majorIncrementLabel: '+50',
                        majorDecrementLabel: '-50',
                        onMinorIncrement: () => setTens(tens + 1),
                        onMinorDecrement: () => setTens(tens - 1),
                        onMajorIncrement: () => setTens(tens + 5),
                        onMajorDecrement: () => setTens(tens - 5),
                      ),
                      RodControlCard(
                        title: 'Ones Rod',
                        value: ones,
                        minorIncrementLabel: '+1',
                        minorDecrementLabel: '-1',
                        majorIncrementLabel: '+5',
                        majorDecrementLabel: '-5',
                        onMinorIncrement: () => setOnes(ones + 1),
                        onMinorDecrement: () => setOnes(ones - 1),
                        onMajorIncrement: () => setOnes(ones + 5),
                        onMajorDecrement: () => setOnes(ones - 5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle('Quick Numbers'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              20,
              (index) => OutlinedButton(
                onPressed: () => setFromNumber(index * 5),
                child: Text('${index * 5}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
