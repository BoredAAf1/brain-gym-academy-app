import 'package:flutter/material.dart';

import '../../models/auth_models.dart';
import '../../models/progress_models.dart';
import '../../models/student_models.dart';
import '../../services/practice_service.dart';
import '../../services/student_tracker_service.dart';
import '../../widgets/app_page.dart';
import '../../widgets/load_error_card.dart';
import '../../widgets/progress_card.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key, required this.parentUser, this.selectedStudent});

  final ParentUser parentUser;
  final StudentProfile? selectedStudent;

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late Future<List<UserProgressSummary>> progressFuture;

  @override
  void initState() {
    super.initState();
    progressFuture = fetchProgress(widget.parentUser);
  }

  void retry() {
    setState(() {
      progressFuture = fetchProgress(widget.parentUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Progress',
      subtitle: 'Track completed practice across Abacus and phonics.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.selectedStudent != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active learner: ${widget.selectedStudent!.name}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Age ${widget.selectedStudent!.age}, Level ${widget.selectedStudent!.level}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tracked sessions: ${StudentTrackerService.snapshot(widget.parentUser.id, widget.selectedStudent!.id).totalSessions}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
          FutureBuilder<List<UserProgressSummary>>(
            future: progressFuture,
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
                  message: 'Could not load progress.',
                  onRetry: retry,
                );
              }

              final colors = {
                'SOROBAN_REPRESENTATION': const Color(0xFFCE6A3B),
                'FORMULA_PRACTICE': const Color(0xFF2F7D6E),
                'DIRECT_SUMS': const Color(0xFFF4A261),
                'PHONICS': const Color(0xFF457B9D),
              };

              return Column(
                children: snapshot.data!
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ProgressCard(
                          title: item.title,
                          completed: item.completed,
                          total: item.total,
                          color: colors[item.area] ?? const Color(0xFF2F7D6E),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
