import 'practice_models.dart';

class WorksheetQuestion {
  const WorksheetQuestion({
    required this.top,
    required this.operator,
    required this.bottom,
    required this.answer,
  });

  final int top;
  final String operator;
  final int bottom;
  final int answer;

  factory WorksheetQuestion.fromJson(Map<String, dynamic> json) {
    return WorksheetQuestion(
      top: json['top'] as int,
      operator: json['operator'] as String,
      bottom: json['bottom'] as int,
      answer: json['answer'] as int,
    );
  }

  PracticeQuestion toPracticeQuestion() {
    return PracticeQuestion('$top $operator $bottom');
  }
}

class WorksheetPracticeSection {
  const WorksheetPracticeSection({
    required this.title,
    required this.questions,
  });

  final String title;
  final List<WorksheetQuestion> questions;

  factory WorksheetPracticeSection.fromJson(Map<String, dynamic> json) {
    return WorksheetPracticeSection(
      title: json['title'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((item) => WorksheetQuestion.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DirectPracticeData {
  const DirectPracticeData({
    required this.sections,
    required this.practiceBank,
  });

  final List<WorksheetPracticeSection> sections;
  final List<PracticeQuestion> practiceBank;

  factory DirectPracticeData.fromJson(Map<String, dynamic> json) {
    return DirectPracticeData(
      sections: (json['sections'] as List<dynamic>)
          .map((item) => WorksheetPracticeSection.fromJson(item as Map<String, dynamic>))
          .toList(),
      practiceBank: (json['practiceBank'] as List<dynamic>)
          .map((item) => PracticeQuestion.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
