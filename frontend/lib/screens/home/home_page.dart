import 'package:flutter/material.dart';

import 'package:brain_gym_academy_app/models/app_section.dart';
import 'package:brain_gym_academy_app/models/auth_models.dart';
import 'package:brain_gym_academy_app/widgets/app_page.dart';
import 'package:brain_gym_academy_app/widgets/hero_action_card.dart';
import 'package:brain_gym_academy_app/screens/about_teacher_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.user,
    required this.onNavigate,
  });

  final ParentUser user;
  final ValueChanged<AppSection> onNavigate;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Brain Gym Academy',
      subtitle: 'Welcome back, ${user.name}. Use this dashboard to manage students and practice sessions.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              HeroActionCard(
                title: 'Student Profiles',
                description: 'Create and manage learners under your parent account.',
                color: const Color(0xFFE3F0D9),
                icon: Icons.people,
                onTap: () => onNavigate(AppSection.students),
              ),
              HeroActionCard(
                title: 'Virtual Abacus',
                description: 'Free-play Abacus with traditional top and bottom bead behavior.',
                color: const Color(0xFFFFE0CC),
                icon: Icons.tune,
                onTap: () => onNavigate(AppSection.sorobanPlay),
              ),
              HeroActionCard(
                title: '0 to 99 Numbers',
                description: 'See Abacus representations for every number from 0 to 99.',
                color: const Color(0xFFFFF0D1),
                icon: Icons.looks_one,
                onTap: () => onNavigate(AppSection.sorobanRepresentation),
              ),
              HeroActionCard(
                title: 'Formula Practice',
                description: 'Small friend, big friend, and combo sums in worksheet style.',
                color: const Color(0xFFEBDCF8),
                icon: Icons.auto_awesome,
                onTap: () => onNavigate(AppSection.sorobanFormula),
              ),
              HeroActionCard(
                title: 'Worksheets',
                description: 'Abacus sums, multiplication, and division practice with the same check/reveal flow.',
                color: const Color(0xFFDFF3FF),
                icon: Icons.grid_view,
                onTap: () => onNavigate(AppSection.worksheets),
              ),
              HeroActionCard(
                title: 'About the Teacher',
                description: 'Learn about our founder and lead instructor.',
                color: const Color(0xFFE8F0FF),
                icon: Icons.school,
                onTap: () => AboutTeacherScreen.open(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
