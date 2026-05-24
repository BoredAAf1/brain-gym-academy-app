import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:brain_gym_academy_app/services/api_config.dart';

class EnterOtpPage extends StatefulWidget {
  const EnterOtpPage({super.key, required this.email});

  final String email;

  @override
  State<EnterOtpPage> createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage> {
  final codeController = TextEditingController();
  final passwordController = TextEditingController();

  bool isSubmitting = false;
  String? error;

  @override
  void dispose() {
    codeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submitReset() async {
    final code = codeController.text.trim();
    final password = passwordController.text.trim();

    if (code.length != 6 || password.length < 6) {
      setState(() {
        error = 'Enter the 6-digit code and a password (min 6 chars).';
      });
      return;
    }

    setState(() {
      isSubmitting = true;
      error = null;
    });

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/reset-password');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': code, 'password': password}),
      );

      final body = resp.body.isNotEmpty ? resp.body : '';

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        // Ensure widget still mounted before using context (avoid async gap)
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Password changed'),
            content: Text(body.isNotEmpty ? body : 'Your password has been updated.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        if (!mounted) return;
        Navigator.of(context).pop();
      } else {
        setState(() {
          error = body.isNotEmpty ? body : 'Could not reset password. Check code and try again.';
        });
      }
    } catch (_) {
      setState(() {
        error = 'Network error. Please try again.';
      });
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter 6-digit code')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter the 6-digit code we emailed to ${widget.email}.'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: codeController,
                    decoration: const InputDecoration(labelText: '6-digit code', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    onSubmitted: (_) => submitReset(),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'New password', border: OutlineInputBorder()),
                    obscureText: true,
                    onSubmitted: (_) => submitReset(),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 10),
                    Text(error!, style: const TextStyle(color: Color(0xFFB3261E))),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isSubmitting ? null : submitReset,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(isSubmitting ? 'Resetting...' : 'Reset Password'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
