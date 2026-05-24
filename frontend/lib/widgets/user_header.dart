import 'package:flutter/material.dart';

import '../models/auth_models.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    super.key,
    required this.user,
    required this.onLogout,
  });

  final ParentUser user;
  final VoidCallback onLogout;

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
            child: Text(
              '${user.name} • ${user.email} • ${formatRole(user.role)}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
