class StudentProfile {
  const StudentProfile({
    required this.id,
    required this.parentUserId,
    required this.name,
    required this.age,
    required this.level,
  });

  final int id;
  final int parentUserId;
  final String name;
  final int age;
  final String level;

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as int,
      parentUserId: json['parentUserId'] as int,
      name: json['name'] as String,
      age: json['age'] as int,
      level: json['level'] as String,
    );
  }
}
