import 'package:flutter/material.dart';

import '../models/auth_models.dart';
import '../models/student_models.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    super.key,
    required this.user,
    required this.onLogout,
    this.activeStudent,
  });

  final ParentUser user;
  final VoidCallback onLogout;
  final StudentProfile? activeStudent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: const Color(0xFF3D2B1F),
      child: Row(
        children: [
          const Icon(Icons.account_circle, color: Colors.white, size: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.name} • ${user.email} • ${formatRole(user.role)}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                if (activeStudent != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.school, color: Colors.white70, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Active learner: ${activeStudent!.name}',
                        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Log out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

String formatRole(String role) {
  return switch (role) {
    'ADMIN' => 'Admin',
    'TEACHER' => 'Teacher',
    'STUDENT' => 'Student',
    _ => 'Student',
  };
}
