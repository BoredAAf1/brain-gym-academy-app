import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:brain_gym_academy_app/services/api_config.dart';
import 'enter_otp_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final tokenController = TextEditingController();
  final passwordController = TextEditingController();

  bool isRequesting = false;
  bool isResetting = false;
  String? message;
  String? error;

  @override
  void dispose() {
    emailController.dispose();
    tokenController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> requestReset() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(email)) {
      setState(() {
        error = 'Enter a valid email address.';
        message = null;
      });
      return;
    }

    setState(() {
      isRequesting = true;
      error = null;
      message = null;
    });

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/forgot-password');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final body = resp.body.isNotEmpty ? resp.body : '';

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        // Navigate to OTP entry screen; do not rely on magic link routing
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EnterOtpPage(email: email),
            ),
          );
        }
      } else {
        setState(() {
          error = body.isNotEmpty ? body : 'Could not request password reset.';
        });
      }
    } catch (_) {
      setState(() {
        error = 'Network error. Please try again.';
      });
    } finally {
      if (mounted) setState(() => isRequesting = false);
    }
  }

  Future<void> performReset() async {
    final token = tokenController.text.trim();
    final password = passwordController.text.trim();

    if (token.isEmpty || password.length < 6) {
      setState(() {
        error = 'Token is required and password must be at least 6 characters.';
        message = null;
      });
      return;
    }

    setState(() {
      isResetting = true;
      error = null;
      message = null;
    });

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/reset-password');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'password': password}),
      );

      final body = resp.body.isNotEmpty ? resp.body : '';

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        setState(() {
          message = body.isNotEmpty ? body : 'Password has been reset successfully.';
          error = null;
        });
      } else {
        setState(() {
          error = body.isNotEmpty ? body : 'Could not reset password.';
        });
      }
    } catch (_) {
      setState(() {
        error = 'Network error. Please try again.';
      });
    } finally {
      if (mounted) setState(() => isResetting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Request a password reset or use a token to set a new password.',
              ),
              const SizedBox(height: 18),

              // Request token section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Request reset token', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSubmitted: (_) => requestReset(),
                      ),
                      const SizedBox(height: 10),
                      if (error != null) ...[
                        Text(error!, style: const TextStyle(color: Color(0xFFB3261E))),
                        const SizedBox(height: 8),
                      ],
                      if (message != null) ...[
                        Text(message!, style: const TextStyle(color: Color(0xFF2F7D6E))),
                        const SizedBox(height: 8),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isRequesting ? null : requestReset,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(isRequesting ? 'Requesting...' : 'Request Reset Token'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Perform reset section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Reset password with token', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: tokenController,
                        decoration: const InputDecoration(labelText: 'Reset token', border: OutlineInputBorder()),
                        onSubmitted: (_) => performReset(),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: 'New password', border: OutlineInputBorder()),
                        obscureText: true,
                        onSubmitted: (_) => performReset(),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isResetting ? null : performReset,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(isResetting ? 'Resetting...' : 'Reset Password'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to sign in'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
