class UserProgressSummary {
  const UserProgressSummary({
    required this.area,
    required this.title,
    required this.completed,
    required this.total,
  });

  final String area;
  final String title;
  final int completed;
  final int total;

  factory UserProgressSummary.fromJson(Map<String, dynamic> json) {
    return UserProgressSummary(
      area: json['area'] as String,
      title: json['title'] as String,
      completed: json['completed'] as int,
      total: json['total'] as int,
    );
  }
}
