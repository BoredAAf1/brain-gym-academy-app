import 'package:flutter/material.dart';

import '../../models/worksheet_models.dart';

class WorksheetSection extends StatefulWidget {
  const WorksheetSection({
    super.key,
    required this.title,
    required this.questions,
  });

  final String title;
  final List<WorksheetQuestion> questions;

  @override
  State<WorksheetSection> createState() => _WorksheetSectionState();
}

class _WorksheetSectionState extends State<WorksheetSection> {
  bool showAnswers = false;

  @override
  Widget build(BuildContext context) {
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
                    widget.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Tooltip(
                  message: showAnswers ? 'Hide answers' : 'Show answers',
                  child: IconButton.filledTonal(
                    onPressed: () {
                      setState(() {
                        showAnswers = !showAnswers;
                      });
                    },
                    icon: Icon(showAnswers ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                widget.questions.length,
                (index) => WorksheetQuestionCard(
                  number: index + 1,
                  question: widget.questions[index],
                  showAnswer: showAnswers,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorksheetQuestionCard extends StatelessWidget {
  const WorksheetQuestionCard({
    super.key,
    required this.number,
    required this.question,
    required this.showAnswer,
  });

  final int number;
  final WorksheetQuestion question;
  final bool showAnswer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFF2D0A4)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$number',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${question.top}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    '${question.operator}${question.bottom}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 70,
                    height: 2,
                    color: const Color(0xFF5C4434),
                  ),
                  const SizedBox(height: 26),
                ],
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: showAnswer ? 1 : 0,
              child: Text(
                'Ans: ${question.answer}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF2F7D6E),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
