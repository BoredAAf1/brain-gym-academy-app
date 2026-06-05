import 'package:flutter/material.dart';

import 'package:brain_gym_academy_app/models/app_section.dart';
import 'package:brain_gym_academy_app/models/auth_models.dart';
import 'package:brain_gym_academy_app/models/student_models.dart';
import 'package:brain_gym_academy_app/widgets/user_header.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.user,
    required this.selectedSection,
    required this.activeStudent,
    required this.onNavigate,
    required this.currentPage,
    required this.onLogout,
  });

  final ParentUser user;
  final StudentProfile? activeStudent;
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
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: const Text('Brain Gym Academy'),
            backgroundColor: const Color(0xFFCE6A3B),
            foregroundColor: Colors.white,
          ),
          drawer: Drawer(
            backgroundColor: const Color(0xFFFFE3B8),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFFCE6A3B),
                  ),
                  child: Text(
                    'Menu',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ..._buildDrawerItems(context),
              ],
            ),
          ),
          body: Column(
            children: [
              UserHeader(user: user, onLogout: onLogout, activeStudent: activeStudent),
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
                            label: Text('Abacus'),
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
                            icon: Icon(Icons.calculate_outlined),
                            selectedIcon: Icon(Icons.calculate),
                            label: Text('Worksheets'),
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
                      label: 'Abacus',
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

  List<Widget> _buildDrawerItems(BuildContext context) {
    final items = [
      ('Home', Icons.home, AppSection.home),
      ('Students', Icons.people, AppSection.students),
      ('0-99', Icons.looks_one, AppSection.sorobanRepresentation),
      ('Abacus', Icons.tune, AppSection.sorobanRepresentation),
      ('Formula', Icons.auto_awesome, AppSection.sorobanFormula),
      ('Direct', Icons.quiz, AppSection.sorobanDirect),
      ('Worksheets', Icons.calculate, AppSection.worksheets),
      ('Phonics', Icons.menu_book, AppSection.phonics),
      ('Progress', Icons.insights, AppSection.progress),
    ];

    return items.map((item) {
      final isSelected = selectedSection == item.$3;
      return ListTile(
        leading: Icon(item.$2, color: isSelected ? const Color(0xFFCE6A3B) : null),
        title: Text(item.$1, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        selected: isSelected,
        onTap: () {
          onNavigate(item.$3);
          Navigator.pop(context);
        },
      );
    }).toList();
  }

  int _mobileIndex(AppSection section) {
    return switch (section) {
      AppSection.home => 0,
      AppSection.students => 1,
      AppSection.sorobanRepresentation ||
      AppSection.sorobanPlay ||
      AppSection.sorobanFormula ||
      AppSection.sorobanDirect ||
      AppSection.worksheets => 2,
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
