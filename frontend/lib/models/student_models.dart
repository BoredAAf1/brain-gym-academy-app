class StudentProfile {
  const StudentProfile({
    required this.id,
    required this.parentUserId,
    required this.name,
    required this.age,
    required this.level,
    required this.recommendations,
  });

  final int id;
  final int parentUserId;
  final String name;
  final int age;
  final String level;
  final List<String> recommendations;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentUserId': parentUserId,
      'name': name,
      'age': age,
      'level': level,
      'recommendations': recommendations,
    };
  }

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    final recommendationData = json['recommendations'];
    return StudentProfile(
      id: json['id'] as int,
      parentUserId: json['parentUserId'] as int,
      name: json['name'] as String,
      age: json['age'] as int,
      level: json['level'] as String,
      recommendations: recommendationData is List ? List<String>.from(recommendationData) : <String>[],
    );
  }
}
