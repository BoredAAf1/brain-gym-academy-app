import 'package:flutter/material.dart';

import '../../models/auth_models.dart';
import '../../models/practice_models.dart';
import '../../models/student_models.dart';
import '../../services/practice_service.dart';
import '../../services/student_tracker_service.dart';
import 'badge.dart';

class PracticeSessionCard extends StatefulWidget {
  const PracticeSessionCard({
    super.key,
    required this.title,
    required this.description,
    required this.questions,
    this.parentUser,
    this.selectedStudent,
    this.progressArea,
  });

  final String title;
  final String description;
  final List<PracticeQuestion> questions;
  final ParentUser? parentUser;
  final StudentProfile? selectedStudent;
  final String? progressArea;

  @override
  State<PracticeSessionCard> createState() => _PracticeSessionCardState();
}

class _PracticeSessionCardState extends State<PracticeSessionCard> {
  final TextEditingController answerController = TextEditingController();
  int currentIndex = 0;
  int attempted = 0;
  int correct = 0;
  bool answeredCurrent = false;
  bool revealed = false;
  String? feedback;

  PracticeQuestion get currentQuestion => widget.questions[currentIndex];

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  void checkAnswer() {
    final parsed = int.tryParse(answerController.text.trim());
    if (parsed == null) {
      setState(() => feedback = 'Enter a number first.');
      return;
    }
    if (answeredCurrent) {
      setState(() => feedback = 'This question is already checked. Press Next Question.');
      return;
    }
    final expected = solvePrompt(currentQuestion.prompt);
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

    if (isCorrect) {
      if (widget.parentUser != null && widget.selectedStudent != null && widget.progressArea != null) {
        StudentTrackerService.recordPractice(
          widget.parentUser!.id,
          widget.selectedStudent!.id,
          widget.progressArea!,
        );
      }
      markProgressComplete();
    }
  }

  Future<void> markProgressComplete() async {
    final parentUser = widget.parentUser;
    final progressArea = widget.progressArea;
    if (parentUser == null || progressArea == null) {
      return;
    }

    try {
      await completeProgress(parentUser, progressArea);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        feedback = 'Correct. Server is waking up. This can take up to 60 seconds.';
      });
    }
  }

  void revealAnswer() {
    setState(() {
      revealed = true;
      feedback = 'Answer revealed: ${solvePrompt(currentQuestion.prompt)}';
    });
  }

  void nextQuestion() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.questions.length;
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
    final progress = (currentIndex + 1) / widget.questions.length;
    final scorePercent = attempted == 0 ? 0 : ((correct / attempted) * 100).round();
    final verticalPrompt = formatVerticalPrompt(currentQuestion.prompt);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (widget.selectedStudent != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Active learner: ${widget.selectedStudent!.name}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
                        ),
                      ],
                    ],
                  ),
                ),
                AppBadge('${widget.questions.length} sums'),
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.description),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AppBadge('Question ${currentIndex + 1}/${widget.questions.length}'),
                AppBadge('Attempted $attempted'),
                AppBadge('Correct $correct'),
                AppBadge('Score $scorePercent%'),
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
                  const SizedBox(height: 10),
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
                        Text(verticalPrompt.top, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
                        Text('${verticalPrompt.operator}${verticalPrompt.bottom}', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Container(width: 100, height: 3, color: const Color(0xFF5C4434)),
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
                      FilledButton(onPressed: checkAnswer, child: const Text('Check')),
                      OutlinedButton(onPressed: revealAnswer, child: const Text('Reveal')),
                      OutlinedButton(onPressed: nextQuestion, child: const Text('Next Question')),
                      TextButton(onPressed: resetSession, child: const Text('Reset Session')),
                    ],
                  ),
                  if (feedback != null) ...[
                    const SizedBox(height: 14),
                    Text(feedback!, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
