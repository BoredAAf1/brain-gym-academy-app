class AbacusWorksheet {
  AbacusWorksheet({required this.type, required this.rows, required this.columns, required this.questions});

  final String type;
  final int rows;
  final int columns;
  final List<List<int>> questions;

  factory AbacusWorksheet.fromJson(Map<String, dynamic> json) {
    return AbacusWorksheet(
      type: json['type'] as String,
      rows: json['rows'] as int,
      columns: json['columns'] as int,
      questions: (json['questions'] as List<dynamic>)
          .map((r) => (r as List<dynamic>).map((i) => i as int).toList())
          .toList(),
    );
  }
}
