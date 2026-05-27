import 'worksheet_models.dart';

class WorksheetResponse {
  WorksheetResponse({
    required this.type,
    required this.rows,
    required this.columns,
    this.questions,
    this.promptQuestions,
  });

  final String type;
  final int rows;
  final int columns;
  final List<List<int>>? questions;
  final List<WorksheetQuestion>? promptQuestions;

  factory WorksheetResponse.fromJson(Map<String, dynamic> json) {
    return WorksheetResponse(
      type: json['type'] as String,
      rows: json['rows'] as int,
      columns: json['columns'] as int,
      questions: json['questions'] != null
          ? (json['questions'] as List<dynamic>)
              .map((r) => (r as List<dynamic>).map((i) => (i as num).toInt()).toList())
              .toList()
          : null,
      promptQuestions: json['promptQuestions'] != null
          ? (json['promptQuestions'] as List<dynamic>)
              .map((item) => WorksheetQuestion.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}
