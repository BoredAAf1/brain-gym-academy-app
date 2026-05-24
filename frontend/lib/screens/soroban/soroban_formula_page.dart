import 'package:flutter/material.dart';

import '../../models/auth_models.dart';
import '../../models/practice_models.dart';
import '../../services/practice_service.dart';
import '../../widgets/app_page.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/load_error_card.dart';
import '../../widgets/practice_session_card.dart';

class FormulaPracticePage extends StatefulWidget {
  const FormulaPracticePage({super.key, required this.parentUser});

  final ParentUser parentUser;

  @override
  State<FormulaPracticePage> createState() => _FormulaPracticePageState();
}

class _FormulaPracticePageState extends State<FormulaPracticePage> {
  late Future<List<PracticeSet>> setsFuture;

  @override
  void initState() {
    super.initState();
    setsFuture = fetchFormulaPracticeSets();
  }

  void retry() {
    setState(() {
      setsFuture = fetchFormulaPracticeSets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Formula Practice',
      subtitle: 'One question at a time with vertical display and session score.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoBanner(
            lines: [
              'Questions are shown vertically like worksheet sums.',
              'Use Check, Reveal, Next Question, and Reset Session while practicing.',
            ],
          ),
          const SizedBox(height: 18),
          FutureBuilder<List<PracticeSet>>(
            future: setsFuture,
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
                  message: 'Could not load formula questions.',
                  onRetry: retry,
                );
              }

              return Column(
                children: snapshot.data!
                    .map(
                      (set) => Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: PracticeSessionCard(
                          title: set.title,
                          description: set.description,
                          questions: set.questions,
                          parentUser: widget.parentUser,
                          progressArea: 'FORMULA_PRACTICE',
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
