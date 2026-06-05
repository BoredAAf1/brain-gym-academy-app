import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/auth_models.dart';
import '../models/practice_models.dart';
import '../models/worksheet_models.dart';
import '../models/worksheet_response.dart';
import '../models/progress_models.dart';
import 'api_config.dart';

VerticalPrompt formatVerticalPrompt(String prompt) {
  final parts = prompt.split(' ');
  return VerticalPrompt(top: parts[0], operator: parts[1], bottom: parts[2]);
}

Future<WorksheetResponse> fetchWorksheet(String category, String type) async {
  final response = await http.get(
    ApiConfig.freshUri('/api/worksheets/$category/$type'),
    headers: ApiConfig.noCacheHeaders(),
  );
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Worksheet request failed.');
  }

  return WorksheetResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
}

int solvePrompt(String prompt) {
  final parts = prompt.split(' ');
  final left = int.parse(parts[0]);
  final operator = parts[1];
  final right = int.parse(parts[2]);
  return operator == '+' ? left + right : left - right;
}

Future<List<PracticeSet>> fetchFormulaPracticeSets() async {
  final response = await http.get(
    ApiConfig.freshUri('/api/practice/formula'),
    headers: ApiConfig.noCacheHeaders(),
  );
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Formula practice request failed.');
  }

  final data = jsonDecode(response.body) as List<dynamic>;
  return data.map((item) => PracticeSet.fromJson(item as Map<String, dynamic>)).toList();
}

Future<DirectPracticeData> fetchDirectPractice() async {
  final response = await http.get(
    ApiConfig.freshUri('/api/practice/direct'),
    headers: ApiConfig.noCacheHeaders(),
  );
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Direct practice request failed.');
  }

  return DirectPracticeData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
}

Future<List<UserProgressSummary>> fetchProgress(ParentUser parentUser) async {
  final response = await http.get(
    ApiConfig.freshUri('/api/progress'),
    headers: ApiConfig.noCacheHeaders(authHeaders(parentUser)),
  );
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Progress request failed.');
  }

  final data = jsonDecode(response.body) as List<dynamic>;
  return data.map((item) => UserProgressSummary.fromJson(item as Map<String, dynamic>)).toList();
}

Future<void> completeProgress(ParentUser parentUser, String area) async {
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/api/progress/complete'),
    headers: {
      'Content-Type': 'application/json',
      ...authHeaders(parentUser),
    },
    body: jsonEncode({'area': area}),
  );
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Progress update failed.');
  }
}

Map<String, String> authHeaders(ParentUser parentUser) {
  return {
    'Authorization': 'Bearer ${parentUser.token}',
  };
}
