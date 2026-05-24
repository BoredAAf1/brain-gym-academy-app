import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:brain_gym_academy_app/models/auth_models.dart';
import 'package:brain_gym_academy_app/models/student_models.dart';
import 'package:brain_gym_academy_app/services/api_config.dart';
import 'package:brain_gym_academy_app/widgets/app_page.dart';
import 'package:brain_gym_academy_app/widgets/info_banner.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key, required this.parentUser});

  final ParentUser parentUser;

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final levelController = TextEditingController(text: 'Beginner');

  List<StudentProfile> students = const [];
  bool isLoading = true;
  bool isSaving = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    levelController.dispose();
    super.dispose();
  }

  Future<void> fetchStudents() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/students');
      final response = await http.get(uri, headers: _authHeaders());
      final data = response.body.isNotEmpty ? jsonDecode(response.body) : [];

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final list = (data as List<dynamic>)
            .map((item) => StudentProfile.fromJson(item as Map<String, dynamic>))
            .toList();
        setState(() {
          students = list;
        });
      } else {
        setState(() {
          error = 'Could not load students.';
        });
      }
    } catch (_) {
      setState(() {
        error = 'Could not load student profiles. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> createStudent() async {
    final name = nameController.text.trim();
    final age = int.tryParse(ageController.text.trim());
    final level = levelController.text.trim();

    if (name.isEmpty || age == null || level.isEmpty) {
      setState(() {
        error = 'Enter student name, age, and level.';
      });
      return;
    }

    setState(() {
      isSaving = true;
      error = null;
    });

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/students'),
        headers: {
          'Content-Type': 'application/json',
          ..._authHeaders(),
        },
        body: jsonEncode({
          'name': name,
          'age': age,
          'level': level,
        }),
      );

      final data = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          students = [...students, StudentProfile.fromJson(data)]
            ..sort((a, b) => a.name.compareTo(b.name));
          nameController.clear();
          ageController.clear();
          levelController.text = 'Beginner';
        });
      } else {
        setState(() {
          error = data['message'] as String? ?? 'Could not create student.';
        });
      }
    } catch (_) {
      setState(() {
        error = 'Could not create the student profile. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Map<String, String> _authHeaders() {
    return {
      'Authorization': 'Bearer ${widget.parentUser.token}',
    };
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Student Profiles',
      subtitle: 'Each parent account can manage multiple learners.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Student',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: 240,
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Student name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        child: TextField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextField(
                          controller: levelController,
                          decoration: const InputDecoration(
                            labelText: 'Level',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      error!,
                      style: const TextStyle(color: Color(0xFFB3261E)),
                    ),
                  ],
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: isSaving ? null : createStudent,
                    child: Text(isSaving ? 'Saving...' : 'Add Student'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (students.isEmpty)
            const InfoBanner(
              lines: [
                'No student profiles yet.',
                'Add your first learner above to organize Soroban and phonics practice.',
              ],
            )
          else
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: students
                  .map(
                    (student) => SizedBox(
                      width: 280,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text('Age: ${student.age}'),
                              Text('Level: ${student.level}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
