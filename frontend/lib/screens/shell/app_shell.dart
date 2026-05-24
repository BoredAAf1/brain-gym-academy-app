import 'package:flutter/material.dart';

import 'package:brain_gym_academy_app/models/app_section.dart';
import 'package:brain_gym_academy_app/models/auth_models.dart';
import 'package:brain_gym_academy_app/widgets/user_header.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.user,
    required this.selectedSection,
    required this.onNavigate,
    required this.currentPage,
    required this.onLogout,
  });

  final ParentUser user;
  final AppSection selectedSection;
  final ValueChanged<AppSection> onNavigate;
  final Widget currentPage;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 980;

        return Scaffold(
          body: Column(
            children: [
              UserHeader(user: user, onLogout: onLogout),
              Expanded(
                child: Row(
                  children: [
                    if (useRail)
                      NavigationRail(
                        backgroundColor: const Color(0xFFFFE3B8),
                        selectedIndex: AppSection.values.indexOf(selectedSection),
                        onDestinationSelected: (index) => onNavigate(AppSection.values[index]),
                        labelType: NavigationRailLabelType.all,
                        destinations: const [
                          NavigationRailDestination(
                            icon: Icon(Icons.home_outlined),
                            selectedIcon: Icon(Icons.home),
                            label: Text('Home'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.people_outline),
                            selectedIcon: Icon(Icons.people),
                            label: Text('Students'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.looks_one_outlined),
                            selectedIcon: Icon(Icons.looks_one),
                            label: Text('0-99'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.tune_outlined),
                            selectedIcon: Icon(Icons.tune),
                            label: Text('Soroban'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.auto_awesome_outlined),
                            selectedIcon: Icon(Icons.auto_awesome),
                            label: Text('Formula'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.quiz_outlined),
                            selectedIcon: Icon(Icons.quiz),
                            label: Text('Direct'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.menu_book_outlined),
                            selectedIcon: Icon(Icons.menu_book),
                            label: Text('Phonics'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.insights_outlined),
                            selectedIcon: Icon(Icons.insights),
                            label: Text('Progress'),
                          ),
                        ],
                      ),
                    Expanded(child: currentPage),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: useRail
              ? null
              : NavigationBar(
                  selectedIndex: _mobileIndex(selectedSection),
                  onDestinationSelected: (index) => onNavigate(_mobileSection(index)),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.people_outline),
                      selectedIcon: Icon(Icons.people),
                      label: 'Students',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.tune_outlined),
                      selectedIcon: Icon(Icons.tune),
                      label: 'Soroban',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book),
                      label: 'Phonics',
                    ),
                  ],
                ),
        );
      },
    );
  }

  int _mobileIndex(AppSection section) {
    return switch (section) {
      AppSection.home => 0,
      AppSection.students => 1,
      AppSection.sorobanRepresentation ||
      AppSection.sorobanPlay ||
      AppSection.sorobanFormula ||
      AppSection.sorobanDirect => 2,
      AppSection.phonics || AppSection.progress => 3,
    };
  }

  AppSection _mobileSection(int index) {
    return switch (index) {
      0 => AppSection.home,
      1 => AppSection.students,
      2 => AppSection.sorobanPlay,
      3 => AppSection.phonics,
      _ => AppSection.home,
    };
  }
}
