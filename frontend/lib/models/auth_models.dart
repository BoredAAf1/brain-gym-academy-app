class ParentUser {
  const ParentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.role,
  });

  final int id;
  final String name;
  final String email;
  final String token;
  final String role;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'role': role,
    };
  }

  factory ParentUser.fromJson(Map<String, dynamic> json) {
    return ParentUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
      role: json['role'] as String? ?? 'STUDENT',
    );
  }
}
