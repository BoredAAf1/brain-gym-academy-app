import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';

import 'models/app_section.dart';
import 'models/auth_models.dart';
import 'models/student_models.dart';
import 'screens/auth/auth.dart';
import 'screens/home/home_page.dart';
import 'screens/phonics/phonics_page.dart';
import 'screens/soroban/soroban_representation_page.dart';
import 'screens/soroban/soroban_play_page.dart';
import 'screens/soroban/soroban_formula_page.dart';
import 'screens/soroban/soroban_direct_page.dart';
import 'screens/progress/progress_page.dart';
import 'screens/shell/app_shell.dart';
import 'screens/soroban/worksheets_page.dart';
import 'screens/students/students_page.dart';
import 'services/student_tracker_service.dart';

void main() {
  runApp(const BrainGymAcademyApp());
}

class BrainGymAcademyApp extends StatelessWidget {
  const BrainGymAcademyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brain Gym Academy App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFCE6A3B),
          primary: const Color(0xFFCE6A3B),
          secondary: const Color(0xFF2F7D6E),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF7EE),
        useMaterial3: true,
      ),
      home: const AppGate(),
    );
  }
}

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  ParentUser? currentUser;
  StudentProfile? activeStudent;
  int? activeStudentId;
  bool isRestoring = true;
  AppSection selectedSection = AppSection.home;

  @override
  void initState() {
    super.initState();
    restoreSession();
  }

  Future<void> restoreSession() async {
    final raw = html.window.localStorage['logged_in_parent_user'];

    if (!mounted) {
      return;
    }

    if (raw == null || raw.isEmpty) {
      setState(() {
        isRestoring = false;
      });
      return;
    }

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final user = ParentUser.fromJson(decoded);
      final restoredStudent = StudentTrackerService.restoreActiveStudentProfile(user.id);
      setState(() {
        currentUser = user;
        activeStudent = restoredStudent;
        activeStudentId = restoredStudent?.id;
        isRestoring = false;
      });
    } catch (_) {
      html.window.localStorage.remove('logged_in_parent_user');
      if (!mounted) {
        return;
      }
      setState(() {
        isRestoring = false;
      });
    }
  }

  Future<void> handleLogin(ParentUser user) async {
    html.window.localStorage['logged_in_parent_user'] = jsonEncode(user.toJson());
    final restoredStudent = StudentTrackerService.restoreActiveStudentProfile(user.id);

    if (!mounted) {
      return;
    }
    setState(() {
      currentUser = user;
      activeStudent = restoredStudent;
      activeStudentId = restoredStudent?.id;
      isRestoring = false;
    });
  }

  Future<void> handleLogout() async {
    html.window.localStorage.remove('logged_in_parent_user');

    if (!mounted) {
      return;
    }
    setState(() {
      currentUser = null;
      activeStudent = null;
      activeStudentId = null;
      isRestoring = false;
    });
  }

  void navigate(AppSection section) {
    setState(() {
      selectedSection = section;
    });
  }

  void updateActiveStudent(StudentProfile? student) {
    if (currentUser == null) {
      return;
    }

    if (student == null) {
      StudentTrackerService.clearActiveStudentId(currentUser!.id);
    } else {
      StudentTrackerService.saveActiveStudent(currentUser!.id, student);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      activeStudent = student;
      activeStudentId = student?.id;
    });
  }

  Widget _buildCurrentPage() {
    return switch (selectedSection) {
      AppSection.home => HomePage(user: currentUser!, onNavigate: navigate),
      AppSection.students => StudentsPage(
          parentUser: currentUser!,
          activeStudentId: activeStudentId,
          activeStudent: activeStudent,
          onSelectedStudentChanged: updateActiveStudent,
        ),
      AppSection.sorobanRepresentation => const SorobanRepresentationPage(),
      AppSection.sorobanPlay => SorobanPlayPage(selectedStudent: activeStudent),
      AppSection.sorobanFormula => FormulaPracticePage(parentUser: currentUser!, selectedStudent: activeStudent),
      AppSection.sorobanDirect => DirectPracticePage(parentUser: currentUser!, selectedStudent: activeStudent),
      AppSection.worksheets => WorksheetsPage(selectedStudent: activeStudent),
      AppSection.phonics => const PhonicsPage(),
      AppSection.progress => ProgressPage(parentUser: currentUser!, selectedStudent: activeStudent),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isRestoring) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (currentUser == null) {
      return LoginPage(onLogin: handleLogin);
    }

    return AppShell(
      user: currentUser!,
      selectedSection: selectedSection,
      activeStudent: activeStudent,
      onNavigate: navigate,
      currentPage: _buildCurrentPage(),
      onLogout: handleLogout,
    );
  }
}
