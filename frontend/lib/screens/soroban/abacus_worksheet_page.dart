import 'package:flutter/material.dart';

import '../../models/abacus_worksheet_models.dart';
import '../../services/practice_service.dart';
import '../../widgets/app_page.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/load_error_card.dart';

class AbacusWorksheetPage extends StatefulWidget {
  const AbacusWorksheetPage({super.key});

  @override
  State<AbacusWorksheetPage> createState() => _AbacusWorksheetPageState();
}

class _AbacusWorksheetPageState extends State<AbacusWorksheetPage> {
  late Future<AbacusWorksheet> worksheetFuture;
  int currentIndex = 0;
  int attempted = 0;
  int correct = 0;
  bool answeredCurrent = false;
  bool revealed = false;
  String? feedback;
  final TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    worksheetFuture = fetchAbacusWorksheet();
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  void retry() {
    setState(() {
      worksheetFuture = fetchAbacusWorksheet();
      currentIndex = 0;
      attempted = 0;
      correct = 0;
      answeredCurrent = false;
      revealed = false;
      feedback = null;
      answerController.clear();
    });
  }

  void checkAnswer(List<int> question) {
    final parsed = int.tryParse(answerController.text.trim());
    if (parsed == null) {
      setState(() => feedback = 'Enter a number first.');
      return;
    }
    if (answeredCurrent) {
      setState(() => feedback = 'This question is already checked. Press Next Question.');
      return;
    }

    final expected = question.fold(0, (sum, value) => sum + value);
    final isCorrect = parsed == expected;

    setState(() {
      attempted += 1;
      answeredCurrent = true;
      if (isCorrect) {
        correct += 1;
        feedback = 'Correct. Nice work.';
      } else {
        feedback = 'Not quite. Correct answer: $expected';
      }
    });
  }

  void revealAnswer(List<int> question) {
    final expected = question.fold(0, (sum, value) => sum + value);
    setState(() {
      revealed = true;
      feedback = 'Answer revealed: $expected';
    });
  }

  void nextQuestion(int questionCount) {
    setState(() {
      currentIndex = (currentIndex + 1) % questionCount;
      answeredCurrent = false;
      revealed = false;
      feedback = null;
      answerController.clear();
    });
  }

  void resetSession() {
    setState(() {
      currentIndex = 0;
      attempted = 0;
      correct = 0;
      answeredCurrent = false;
      revealed = false;
      feedback = null;
      answerController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Abacus Worksheet',
      subtitle: 'Practice 100 vertical 5-row questions, one at a time.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoBanner(
            lines: [
              'Solve 5 one-digit rows as a single vertical total.',
              'Check your answer, reveal it, or move to the next question.',
            ],
          ),
          const SizedBox(height: 18),
          FutureBuilder<AbacusWorksheet>(
            future: worksheetFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return LoadErrorCard(
                  message: 'Could not load abacus worksheet.',
                  onRetry: retry,
                );
              }

              final worksheet = snapshot.data!;
              final question = worksheet.questions[currentIndex];
              final questionCount = worksheet.questions.length;
              final progress = (currentIndex + 1) / questionCount;
              final scorePercent = attempted == 0 ? 0 : ((correct / attempted) * 100).round();

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
                              'Question ${currentIndex + 1} of $questionCount',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Chip(label: Text('Score $scorePercent%')),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          minHeight: 12,
                          value: progress,
                          color: const Color(0xFF2A9D8F),
                          backgroundColor: const Color(0xFF2A9D8F).withOpacity(0.16),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8EE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Solve this',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFF2D0A4)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ...question.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final value = entry.value;
                                    final label = index == 0
                                        ? '${value.abs()}'
                                        : '${value >= 0 ? '+' : '-'}${value.abs()}';
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text(
                                        label,
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 6),
                                  Container(width: 120, height: 3, color: const Color(0xFF5C4434)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: 220,
                              child: TextField(
                                controller: answerController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Your answer',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                FilledButton(onPressed: () => checkAnswer(question), child: const Text('Check')),
                                OutlinedButton(onPressed: () => revealAnswer(question), child: const Text('Reveal')),
                                OutlinedButton(onPressed: () => nextQuestion(questionCount), child: const Text('Next Question')),
                                TextButton(onPressed: resetSession, child: const Text('Reset Session')),
                              ],
                            ),
                            if (feedback != null) ...[
                              const SizedBox(height: 14),
                              Text(
                                feedback!,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
