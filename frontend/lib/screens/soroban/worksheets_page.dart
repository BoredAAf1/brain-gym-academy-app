import 'package:flutter/material.dart';

import '../../models/student_models.dart';
import '../../models/worksheet_response.dart';
import '../../services/practice_service.dart';
import '../../widgets/app_page.dart';
import '../../widgets/info_banner.dart';

class WorksheetType {
  const WorksheetType({
    required this.category,
    required this.type,
    required this.title,
    required this.description,
  });

  final String category;
  final String type;
  final String title;
  final String description;
}

const List<WorksheetType> worksheetTypes = [
  WorksheetType(
    category: 'abacus',
    type: '1digit-5rows-100',
    title: '1 Digit • 5 Rows',
    description: '5 vertical one-digit values with plus/minus signs.',
  ),
  WorksheetType(
    category: 'abacus',
    type: '1digit-10rows-100',
    title: '1 Digit • 10 Rows',
    description: '10 vertical one-digit values with signed totals.',
  ),
  WorksheetType(
    category: 'abacus',
    type: '2digit-5values-100',
    title: '2 Digit • 5 Values',
    description: '5 vertical two-digit values with signed addition/subtraction.',
  ),
  WorksheetType(
    category: 'abacus',
    type: '3digit-3values-100',
    title: '3 Digit • 3 Values',
    description: '3 vertical three-digit values with signed totals.',
  ),
  WorksheetType(
    category: 'arithmetic',
    type: 'multiply-2digit-1digit-100',
    title: 'Multiply 2×1',
    description: 'Horizontal 2-digit × 1-digit multiplication questions.',
  ),
  WorksheetType(
    category: 'arithmetic',
    type: 'multiply-2digit-2digit-100',
    title: 'Multiply 2×2',
    description: 'Horizontal 2-digit × 2-digit multiplication questions.',
  ),
  WorksheetType(
    category: 'arithmetic',
    type: 'divide-3digit-1digit-100',
    title: 'Divide 3÷1',
    description: 'Horizontal 3-digit ÷ 1-digit division questions.',
  ),
  WorksheetType(
    category: 'arithmetic',
    type: 'divide-4digit-2digit-100',
    title: 'Divide 4÷2',
    description: 'Horizontal 4-digit ÷ 2-digit division questions.',
  ),
];

class WorksheetsPage extends StatefulWidget {
  const WorksheetsPage({super.key, this.selectedStudent});

  final StudentProfile? selectedStudent;

  @override
  State<WorksheetsPage> createState() => _WorksheetsPageState();
}

class _WorksheetsPageState extends State<WorksheetsPage> {
  late WorksheetType selectedType;
  late WorksheetResponse worksheet;
  bool isRemoteSyncing = false;
  bool remoteSyncFailed = false;
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
    selectedType = worksheetTypes.first;
    worksheet = generateLocalWorksheet(selectedType.category, selectedType.type);
    _syncRemoteWorksheet(selectedType);
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  void loadType(WorksheetType type) {
    if (type.type == selectedType.type) return;
    setState(() {
      selectedType = type;
      worksheet = generateLocalWorksheet(type.category, type.type);
      isRemoteSyncing = false;
      remoteSyncFailed = false;
      currentIndex = 0;
      attempted = 0;
      correct = 0;
      answeredCurrent = false;
      revealed = false;
      feedback = null;
      answerController.clear();
    });
    _syncRemoteWorksheet(type);
  }

  void retry() {
    _syncRemoteWorksheet(selectedType);
  }

  Future<void> _syncRemoteWorksheet(WorksheetType type) async {
    setState(() {
      isRemoteSyncing = true;
      remoteSyncFailed = false;
    });

    try {
      final remoteWorksheet = await fetchWorksheet(type.category, type.type);
      if (!mounted) {
        return;
      }
      setState(() {
        worksheet = remoteWorksheet;
        isRemoteSyncing = false;
        remoteSyncFailed = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isRemoteSyncing = false;
        remoteSyncFailed = true;
      });
    }
  }

  void checkAnswer(WorksheetResponse worksheet) {
    final parsed = int.tryParse(answerController.text.trim());
    if (parsed == null) {
      setState(() => feedback = 'Enter a number first.');
      return;
    }

    if (answeredCurrent) {
      setState(() => feedback = 'This question is already checked. Press Next Question.');
      return;
    }

    final expected = worksheet.promptQuestions != null
        ? worksheet.promptQuestions![currentIndex].answer
        : worksheet.questions![currentIndex].fold(0, (sum, value) => sum + value);

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

  void revealAnswer(WorksheetResponse worksheet) {
    final expected = worksheet.promptQuestions != null
        ? worksheet.promptQuestions![currentIndex].answer
        : worksheet.questions![currentIndex].fold(0, (sum, value) => sum + value);
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
      title: 'Worksheet Practice',
      subtitle: widget.selectedStudent != null
          ? 'Hands-on worksheet practice for ${widget.selectedStudent!.name}.'
          : 'Choose a worksheet type and practice with check, reveal, and next controls.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoBanner(
            lines: [
              'Select a worksheet type to practice abacus-style sums, multiplication, or division.',
              'One question at a time: answer it, then Check, Reveal, or move on.',
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: worksheetTypes.map((type) {
              final selected = type.type == selectedType.type;
              return ChoiceChip(
                label: Text(type.title),
                selected: selected,
                onSelected: (_) => loadType(type),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Text(
            selectedType.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 18),
          if (isRemoteSyncing || remoteSyncFailed)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                isRemoteSyncing
                    ? 'Loading latest worksheet content from the server…'
                    : 'Using local worksheet content while the server wakes up.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF2F7D6E),
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
          Builder(
            builder: (context) {
              final questionCount = worksheet.rows;
              final progress = (currentIndex + 1) / questionCount;
              final scorePercent = attempted == 0 ? 0 : ((correct / attempted) * 100).round();
              final promptQuestion = worksheet.promptQuestions != null ? worksheet.promptQuestions![currentIndex] : null;

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
                            if (promptQuestion != null) ...[
                              Text(
                                '${promptQuestion.top} ${promptQuestion.operator} ${promptQuestion.bottom} =',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ] else ...[
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
                                    ...worksheet.questions![currentIndex].asMap().entries.map((entry) {
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
                            ],
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
                                FilledButton(onPressed: () => checkAnswer(worksheet), child: const Text('Check')),
                                OutlinedButton(onPressed: () => revealAnswer(worksheet), child: const Text('Reveal')),
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
