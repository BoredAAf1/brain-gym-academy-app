import 'package:flutter/material.dart';

import '../../models/auth_models.dart';
import '../../models/student_models.dart';
import '../../models/worksheet_models.dart';
import '../../services/practice_service.dart';
import '../../widgets/app_page.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/load_error_card.dart';
import '../../widgets/worksheet_section.dart';
import '../../widgets/practice_session_card.dart';

class DirectPracticePage extends StatefulWidget {
  const DirectPracticePage({super.key, required this.parentUser, this.selectedStudent});

  final ParentUser parentUser;
  final StudentProfile? selectedStudent;

  @override
  State<DirectPracticePage> createState() => _DirectPracticePageState();
}

class _DirectPracticePageState extends State<DirectPracticePage> {
  late Future<DirectPracticeData> directPracticeFuture;

  @override
  void initState() {
    super.initState();
    directPracticeFuture = fetchDirectPractice();
  }

  void retry() {
    setState(() {
      directPracticeFuture = fetchDirectPractice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Direct Abacus Practice',
      subtitle: 'Beginner arithmetic for students who know only direct Abacus moves.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoBanner(
            lines: [
              'These problems avoid carry, borrow, small friend, and big friend formulas.',
              'Each digit can be solved by moving available beads directly on its rod.',
            ],
          ),
          const SizedBox(height: 18),
          FutureBuilder<DirectPracticeData>(
            future: directPracticeFuture,
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
                  message: 'Could not load direct worksheet.',
                  onRetry: retry,
                );
              }

              final data = snapshot.data!;
              return Column(
                children: [
                  PracticeSessionCard(
                    title: 'Direct Practice Bank',
                    description: 'Interactive direct-only practice with one active question at a time.',
                    questions: data.practiceBank,
                    parentUser: widget.parentUser,
                    selectedStudent: widget.selectedStudent,
                    progressArea: 'DIRECT_SUMS',
                  ),
                  const SizedBox(height: 18),
                  ...data.sections.map(
                    (section) => Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: WorksheetSection(
                        title: section.title,
                        questions: section.questions,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
