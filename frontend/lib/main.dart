import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';

import 'models/app_section.dart';
import 'models/auth_models.dart';
import 'screens/auth/auth.dart';
import 'screens/home/home_page.dart';
import 'screens/phonics/phonics_page.dart';
import 'screens/soroban/soroban_representation_page.dart';
import 'screens/soroban/soroban_play_page.dart';
import 'screens/soroban/soroban_formula_page.dart';
import 'screens/soroban/soroban_direct_page.dart';
import 'screens/progress/progress_page.dart';
import 'screens/shell/app_shell.dart';
import 'screens/students/students_page.dart';
import 'widgets/app_page.dart';
import 'widgets/abacus_visual.dart';
import 'widgets/badge.dart';
import 'widgets/info_banner.dart';

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
      setState(() {
        currentUser = ParentUser.fromJson(decoded);
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

    if (!mounted) {
      return;
    }
    setState(() {
      currentUser = user;
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
      isRestoring = false;
    });
  }

  void navigate(AppSection section) {
    setState(() {
      selectedSection = section;
    });
  }

  Widget _buildCurrentPage() {
    return switch (selectedSection) {
      AppSection.home => HomePage(user: currentUser!, onNavigate: navigate),
      AppSection.students => StudentsPage(parentUser: currentUser!),
      AppSection.sorobanRepresentation => const SorobanRepresentationPage(),
      AppSection.sorobanPlay => const SorobanPlayPage(),
      AppSection.sorobanFormula => FormulaPracticePage(parentUser: currentUser!),
      AppSection.sorobanDirect => DirectPracticePage(parentUser: currentUser!),
      AppSection.phonics => const PhonicsPage(),
      AppSection.progress => ProgressPage(parentUser: currentUser!),
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
      onNavigate: navigate,
      currentPage: _buildCurrentPage(),
      onLogout: handleLogout,
    );
  }
}
