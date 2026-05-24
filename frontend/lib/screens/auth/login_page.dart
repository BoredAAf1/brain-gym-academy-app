import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:brain_gym_academy_app/models/auth_models.dart';
import 'package:brain_gym_academy_app/services/api_config.dart';
import 'package:brain_gym_academy_app/screens/auth/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin});

  final ValueChanged<ParentUser> onLogin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isRegisterMode = false;
  bool isLoading = false;
  String? error;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if ((isRegisterMode && name.isEmpty) || email.isEmpty || password.isEmpty) {
      setState(() {
        error = isRegisterMode
            ? 'Enter name, email, and password to continue.'
            : 'Enter email and password to continue.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    final uri = Uri.parse(
      isRegisterMode
          ? '${ApiConfig.baseUrl}/api/auth/register'
          : '${ApiConfig.baseUrl}/api/auth/login',
    );

    final payload = isRegisterMode
        ? {
            'name': name,
            'email': email,
            'password': password,
          }
        : {
            'email': email,
            'password': password,
          };

    try {
      final response = await http.post(
        uri,
        headers: const {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      final data = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        widget.onLogin(
          ParentUser(
            id: data['id'] as int? ?? 0,
            name: data['name'] as String? ?? name,
            email: data['email'] as String? ?? email,
            token: data['token'] as String? ?? '',
            role: data['role'] as String? ?? 'STUDENT',
          ),
        );
      } else {
        setState(() {
          error = data['message'] as String? ?? 'Authentication failed.';
        });
      }
    } catch (_) {
      setState(() {
        error = 'Could not connect. Please try again in a moment.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF0D6), Color(0xFFFFDFC1), Color(0xFFE6F5EE)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Brain Gym Academy',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isRegisterMode
                          ? 'Create a parent account to start student profiles, Soroban practice, and phonics.'
                          : 'Sign in to continue to the parent dashboard.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 22),
                    if (isRegisterMode) ...[
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => submit(),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        error!,
                        style: const TextStyle(color: Color(0xFFB3261E)),
                      ),
                    ],
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isLoading ? null : submit,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            isLoading
                                ? 'Please wait...'
                                : isRegisterMode
                                    ? 'Create Account'
                                    : 'Sign In',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  setState(() {
                                    isRegisterMode = !isRegisterMode;
                                    error = null;
                                  });
                                },
                          child: Text(
                            isRegisterMode
                                ? 'Already have an account? Sign in'
                                : 'Need an account? Register',
                          ),
                        ),
                        if (!isRegisterMode)
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ForgotPasswordPage(),
                                      ),
                                    );
                                  },
                            child: const Text('Forgot password?'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
