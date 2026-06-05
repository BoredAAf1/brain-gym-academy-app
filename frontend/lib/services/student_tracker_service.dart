import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../models/student_models.dart';

class StudentPracticeSnapshot {
  StudentPracticeSnapshot({
    required this.studentId,
    required this.areaCounts,
    required this.lastUpdated,
  });

  final int studentId;
  final Map<String, int> areaCounts;
  final DateTime? lastUpdated;

  int get totalSessions => areaCounts.values.fold(0, (sum, count) => sum + count);

  String get topArea {
    if (areaCounts.isEmpty) {
      return 'No history yet';
    }
    final ordered = areaCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return ordered.first.key.replaceAll('_', ' ').toLowerCase();
  }

  static StudentPracticeSnapshot empty(int studentId) {
    return StudentPracticeSnapshot(studentId: studentId, areaCounts: {}, lastUpdated: null);
  }
}

class StudentTrackerService {
  static String activeStudentKey(int parentId) => 'active_student_parent_$parentId';
  static String practiceCountsKey(int parentId) => 'student_practice_counts_parent_$parentId';

  static int? restoreActiveStudentId(int parentId) {
    final raw = html.window.localStorage[activeStudentKey(parentId)];
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded['id'] as int?;
      }
    } catch (_) {
      // not JSON, continue to parse as plain int
    }

    return int.tryParse(raw);
  }

  static StudentProfile? restoreActiveStudentProfile(int parentId) {
    final raw = html.window.localStorage[activeStudentKey(parentId)];
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return StudentProfile.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  static void saveActiveStudent(int parentId, StudentProfile student) {
    html.window.localStorage[activeStudentKey(parentId)] = jsonEncode(student.toJson());
  }

  static void clearActiveStudentId(int parentId) {
    html.window.localStorage.remove(activeStudentKey(parentId));
  }

  static Map<String, dynamic> _loadPracticeStore(int parentId) {
    final raw = html.window.localStorage[practiceCountsKey(parentId)];
    if (raw == null || raw.isEmpty) {
      return <String, dynamic>{};
    }

    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      html.window.localStorage.remove(practiceCountsKey(parentId));
      return <String, dynamic>{};
    }
  }

  static void _savePracticeStore(int parentId, Map<String, dynamic> value) {
    html.window.localStorage[practiceCountsKey(parentId)] = jsonEncode(value);
  }

  static StudentPracticeSnapshot snapshot(int parentId, int studentId) {
    final store = _loadPracticeStore(parentId);
    final studentData = store[studentId.toString()] as Map<String, dynamic>?;
    if (studentData == null) {
      return StudentPracticeSnapshot.empty(studentId);
    }
    final counts = (studentData['counts'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(key, value as int),
        ) ??
        <String, int>{};
    final lastUpdatedRaw = studentData['lastUpdated'] as String?;
    return StudentPracticeSnapshot(
      studentId: studentId,
      areaCounts: counts,
      lastUpdated: lastUpdatedRaw != null ? DateTime.tryParse(lastUpdatedRaw) : null,
    );
  }

  static void recordPractice(int parentId, int studentId, String area) {
    final store = _loadPracticeStore(parentId);
    final studentKey = studentId.toString();
    final studentData = Map<String, dynamic>.from(store[studentKey] as Map<String, dynamic>? ?? {});
    final counts = Map<String, dynamic>.from(studentData['counts'] as Map<String, dynamic>? ?? {});
    counts[area] = (counts[area] as int? ?? 0) + 1;
    studentData['counts'] = counts;
    studentData['lastUpdated'] = DateTime.now().toIso8601String();
    store[studentKey] = studentData;
    _savePracticeStore(parentId, store);
  }

  static List<String> recommendationsFor(StudentProfile student, StudentPracticeSnapshot snapshot) {
    final level = student.level.toLowerCase();
    final recommendations = <String>[];

    if (level.contains('beginner')) {
      recommendations.add('Try Direct Abacus practice to build confidence with one-digit moves.');
      recommendations.add('Use 0–99 representation drills to strengthen bead-to-number recall.');
      recommendations.add('Repeat small number formula sets until fast recall feels natural.');
    } else if (level.contains("intermediate")) {
      recommendations.add('Practice Formula worksheets to improve big-friend and small-friend speed.');
      recommendations.add('Add two-digit multiplication and division worksheets for stronger mental math.');
      recommendations.add('Review previous direct sums before moving to larger problems.');
    } else if (level.contains("advanced")) {
      recommendations.add('Challenge with two-digit × two-digit and long division worksheets.');
      recommendations.add('Use phonics practice alongside Abacus work for full learner focus.');
      recommendations.add('Set a weekly goal for consistent practice on the selected active learner.');
    } else {
      recommendations.add('Rotate between Direct, Formula, and Worksheet sessions for balanced practice.');
      recommendations.add('Check progress weekly and tune the next session to the learner’s strongest area.');
    }

    if (snapshot.totalSessions == 0) {
      recommendations.add('Start a short practice session now to begin tracking progress for this learner.');
    } else if (snapshot.totalSessions < 4) {
      recommendations.add('Aim for at least 4 sessions this week for steady skill growth.');
    } else {
      recommendations.add('Keep the momentum going with one session every other day.');
    }

    return recommendations;
  }
}
