class AbacusRepresentation {
  const AbacusRepresentation({required this.value, required this.tens, required this.ones});

  final int value;
  final int tens;
  final int ones;
}

class PracticeSet {
  const PracticeSet({
    required this.title,
    required this.description,
    required this.questions,
  });

  final String title;
  final String description;
  final List<PracticeQuestion> questions;

  factory PracticeSet.fromJson(Map<String, dynamic> json) {
    return PracticeSet(
      title: json['title'] as String,
      description: json['description'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((item) => PracticeQuestion.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PracticeQuestion {
  const PracticeQuestion(this.prompt);

  final String prompt;

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeQuestion(json['prompt'] as String);
  }
}

class VerticalPrompt {
  const VerticalPrompt({
    required this.top,
    required this.operator,
    required this.bottom,
  });

  final String top;
  final String operator;
  final String bottom;
}
