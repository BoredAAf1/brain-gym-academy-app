import 'dart:convert';
import 'dart:math';

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
  try {
    final response = await http
        .get(
          ApiConfig.freshUri('/api/worksheets/$category/$type'),
          headers: ApiConfig.noCacheHeaders(),
        )
        .timeout(ApiConfig.requestTimeout);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return WorksheetResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
  } catch (_) {
    // Static worksheets can be generated locally while the backend wakes up.
  }

  return generateLocalWorksheet(category, type);
}

int solvePrompt(String prompt) {
  final parts = prompt.split(' ');
  final left = int.parse(parts[0]);
  final operator = parts[1];
  final right = int.parse(parts[2]);
  return operator == '+' ? left + right : left - right;
}

Future<List<PracticeSet>> fetchFormulaPracticeSets() async {
  try {
    final response = await http
        .get(
          ApiConfig.freshUri('/api/practice/formula'),
          headers: ApiConfig.noCacheHeaders(),
        )
        .timeout(ApiConfig.requestTimeout);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => PracticeSet.fromJson(item as Map<String, dynamic>)).toList();
    }
  } catch (_) {
    // Formula question banks are deterministic learning content.
  }

  return generateLocalFormulaPracticeSets();
}

Future<DirectPracticeData> fetchDirectPractice() async {
  try {
    final response = await http
        .get(
          ApiConfig.freshUri('/api/practice/direct'),
          headers: ApiConfig.noCacheHeaders(),
        )
        .timeout(ApiConfig.requestTimeout);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return DirectPracticeData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
  } catch (_) {
    // Direct practice is deterministic and can run without the backend.
  }

  return generateLocalDirectPractice();
}

Future<List<UserProgressSummary>> fetchProgress(ParentUser parentUser) async {
  final response = await http
      .get(
        ApiConfig.freshUri('/api/progress'),
        headers: ApiConfig.noCacheHeaders(authHeaders(parentUser)),
      )
      .timeout(ApiConfig.requestTimeout);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Progress request failed.');
  }

  final data = jsonDecode(response.body) as List<dynamic>;
  return data.map((item) => UserProgressSummary.fromJson(item as Map<String, dynamic>)).toList();
}

Future<void> completeProgress(ParentUser parentUser, String area) async {
  final response = await http
      .post(
        Uri.parse('${ApiConfig.baseUrl}/api/progress/complete'),
        headers: {
          'Content-Type': 'application/json',
          ...authHeaders(parentUser),
        },
        body: jsonEncode({'area': area}),
      )
      .timeout(ApiConfig.requestTimeout);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Progress update failed.');
  }
}

List<PracticeSet> generateLocalFormulaPracticeSets() {
  return [
    PracticeSet(
      title: 'Small Friend',
      description: 'Worksheet-style practice using the 5-complement idea.',
      questions: _smallFriendQuestions(),
    ),
    PracticeSet(
      title: 'Big Friend',
      description: 'Worksheet-style practice using the 10-complement idea.',
      questions: _bigFriendQuestions(),
    ),
    PracticeSet(
      title: 'Combo Practice',
      description: 'Combo sums like 5 + 9: add 10, then remove the big friend complement.',
      questions: _comboQuestions(),
    ),
  ];
}

DirectPracticeData generateLocalDirectPractice() {
  final warmups = _directWarmupWorksheet();
  final additions = _directAdditionWorksheet();
  final subtractions = _directSubtractionWorksheet();
  final worksheet = [...warmups, ...additions, ...subtractions];

  return DirectPracticeData(
    sections: [
      WorksheetPracticeSection(title: 'Single Rod Warmup', questions: warmups),
      WorksheetPracticeSection(title: 'Two Rod Direct Addition', questions: additions),
      WorksheetPracticeSection(title: 'Two Rod Direct Subtraction', questions: subtractions),
    ],
    practiceBank: List.generate(500, (index) => worksheet[index % worksheet.length].toPracticeQuestion()),
  );
}

WorksheetResponse generateLocalWorksheet(String category, String type) {
  if (category == 'abacus') {
    return switch (type) {
      '1digit-5rows-100' => _abacusWorksheet(type, 5, 1, 100),
      '1digit-10rows-100' => _abacusWorksheet(type, 10, 1, 100),
      '2digit-5values-100' => _abacusWorksheet(type, 5, 2, 100),
      '3digit-3values-100' => _abacusWorksheet(type, 3, 3, 100),
      _ => throw Exception('Worksheet type not found.'),
    };
  }

  return switch (type) {
    'multiply-2digit-1digit-100' => _arithmeticWorksheet(type, _multiplicationQuestions(2, 1, 100)),
    'multiply-2digit-2digit-100' => _arithmeticWorksheet(type, _multiplicationQuestions(2, 2, 100)),
    'divide-3digit-1digit-100' => _arithmeticWorksheet(type, _divisionQuestions(3, 1, 100)),
    'divide-4digit-2digit-100' => _arithmeticWorksheet(type, _divisionQuestions(4, 2, 100)),
    _ => throw Exception('Worksheet type not found.'),
  };
}

List<PracticeQuestion> _smallFriendQuestions() {
  const templates = ['4 + 1', '3 + 2', '2 + 3', '1 + 4', '6 - 1', '7 - 2', '8 - 3', '9 - 4', '5 - 1', '5 - 2'];
  return List.generate(50, (index) => PracticeQuestion(templates[index % templates.length]));
}

List<PracticeQuestion> _bigFriendQuestions() {
  final questions = <PracticeQuestion>[];

  for (var start = 1; start <= 89 && questions.length < 25; start++) {
    for (var add = 6; add <= 9 && questions.length < 25; add++) {
      final ones = start % 10;
      final answer = start + add;
      if (answer <= 99 && ones > 0 && ones + add >= 10) {
        questions.add(PracticeQuestion('$start + $add'));
      }
    }
  }

  for (var start = 10; start <= 99 && questions.length < 50; start++) {
    for (var subtract = 6; subtract <= 9 && questions.length < 50; subtract++) {
      final ones = start % 10;
      final answer = start - subtract;
      if (answer >= 0 && ones < subtract) {
        questions.add(PracticeQuestion('$start - $subtract'));
      }
    }
  }

  return questions;
}

List<PracticeQuestion> _comboQuestions() {
  const additionSeeds = [
    (5, 6), (5, 7), (5, 8), (5, 9),
    (6, 6), (6, 7), (6, 8), (6, 9),
    (7, 6), (7, 7), (7, 8), (7, 9),
    (8, 6), (8, 7), (8, 8), (8, 9),
    (9, 6), (9, 7), (9, 8), (9, 9),
  ];
  const subtractionSeeds = [
    (11, 6), (12, 6), (12, 7),
    (13, 6), (13, 7), (13, 8),
    (14, 6), (14, 7), (14, 8), (14, 9),
    (15, 6), (15, 7), (15, 8), (15, 9),
    (16, 7), (16, 8), (16, 9),
    (17, 8), (17, 9), (18, 9),
  ];
  final seeds = [
    ...additionSeeds.map((seed) => PracticeQuestion('${seed.$1} + ${seed.$2}')),
    ...subtractionSeeds.map((seed) => PracticeQuestion('${seed.$1} - ${seed.$2}')),
  ];

  return List.generate(50, (index) => seeds[index % seeds.length]);
}

List<WorksheetQuestion> _directWarmupWorksheet() {
  const seeds = [
    (0, '+', 1), (1, '+', 2), (2, '+', 2),
    (5, '+', 1), (6, '+', 2),
    (9, '-', 1), (8, '-', 2), (7, '-', 2), (4, '-', 1), (3, '-', 2),
    (0, '+', 5), (1, '+', 5), (2, '+', 5),
    (5, '-', 5), (6, '-', 5), (9, '-', 5),
    (10, '+', 10), (20, '+', 20), (80, '-', 10), (70, '-', 20),
  ];
  return seeds.map((seed) {
    final top = seed.$1;
    final operator = seed.$2;
    final bottom = seed.$3;
    return WorksheetQuestion(top: top, operator: operator, bottom: bottom, answer: operator == '+' ? top + bottom : top - bottom);
  }).toList();
}

List<WorksheetQuestion> _directAdditionWorksheet() {
  const seeds = [
    (11, 11), (11, 12), (12, 11), (12, 12), (13, 11),
    (20, 12), (20, 22), (21, 12), (21, 13), (22, 12),
    (22, 22), (23, 11), (23, 21), (30, 11), (30, 14),
    (31, 12), (31, 13), (32, 11), (32, 12), (33, 11),
    (50, 21), (50, 23), (51, 12), (51, 22), (52, 11),
    (52, 21), (53, 11), (60, 12), (61, 11), (62, 12),
  ];
  return seeds
      .where((seed) => _isDirectTwoDigitMove(seed.$1, seed.$2))
      .map((seed) => WorksheetQuestion(top: seed.$1, operator: '+', bottom: seed.$2, answer: seed.$1 + seed.$2))
      .toList();
}

List<WorksheetQuestion> _directSubtractionWorksheet() {
  final questions = <WorksheetQuestion>[];
  for (var top = 99; top >= 0 && questions.length < 30; top--) {
    for (var bottom = 1; bottom <= 55 && questions.length < 30; bottom++) {
      if (_isDirectTwoDigitMove(top, -bottom)) {
        questions.add(WorksheetQuestion(top: top, operator: '-', bottom: bottom, answer: top - bottom));
      }
    }
  }
  return questions;
}

WorksheetResponse _abacusWorksheet(String type, int columns, int digitLength, int questionCount) {
  final random = Random(type.hashCode);
  final questions = <List<int>>[];
  for (var q = 0; q < questionCount; q++) {
    final row = <int>[];
    var runningTotal = _randomValue(random, digitLength, false);
    row.add(runningTotal);
    for (var c = 1; c < columns; c++) {
      late int value;
      do {
        value = _randomValue(random, digitLength, true);
      } while (runningTotal + value < 0);
      row.add(value);
      runningTotal += value;
    }
    questions.add(row);
  }
  return WorksheetResponse(type: type, rows: questionCount, columns: columns, questions: questions);
}

WorksheetResponse _arithmeticWorksheet(String type, List<WorksheetQuestion> questions) {
  return WorksheetResponse(type: type, rows: questions.length, columns: 1, promptQuestions: questions);
}

List<WorksheetQuestion> _multiplicationQuestions(int topDigits, int bottomDigits, int count) {
  final random = Random((topDigits * 1000) + (bottomDigits * 100) + count);
  return List.generate(count, (_) {
    final top = _randomPositiveDigitValue(random, topDigits);
    final bottom = _randomPositiveDigitValue(random, bottomDigits);
    return WorksheetQuestion(top: top, operator: '×', bottom: bottom, answer: top * bottom);
  });
}

List<WorksheetQuestion> _divisionQuestions(int topDigits, int bottomDigits, int count) {
  final random = Random((topDigits * 2000) + (bottomDigits * 200) + count);
  return List.generate(count, (_) {
    late int top;
    late int bottom;
    late int quotient;
    do {
      bottom = _randomPositiveDigitValue(random, bottomDigits);
      quotient = _randomPositiveDigitValue(random, max(1, topDigits - bottomDigits));
      top = bottom * quotient;
    } while (top.toString().length != topDigits);
    return WorksheetQuestion(top: top, operator: '÷', bottom: bottom, answer: quotient);
  });
}

int _randomValue(Random random, int digitLength, bool allowNegative) {
  final value = _randomPositiveDigitValue(random, digitLength);
  return allowNegative && random.nextBool() ? -value : value;
}

int _randomPositiveDigitValue(Random random, int digits) {
  var min = pow(10, digits - 1).toInt();
  final max = pow(10, digits).toInt() - 1;
  if (digits == 1) {
    min = 1;
  }
  return random.nextInt(max - min + 1) + min;
}

bool _isDirectTwoDigitMove(int start, int delta) {
  final end = start + delta;
  if (end < 0 || end > 99) {
    return false;
  }

  final startTens = start ~/ 10;
  final startOnes = start % 10;
  final deltaMagnitude = delta.abs();
  final deltaTens = deltaMagnitude ~/ 10;
  final deltaOnes = deltaMagnitude % 10;
  final sign = delta >= 0 ? 1 : -1;

  return _isDirectDigitMove(startTens, sign * deltaTens) &&
      _isDirectDigitMove(startOnes, sign * deltaOnes);
}

bool _isDirectDigitMove(int startDigit, int delta) {
  if (delta == 0) {
    return true;
  }

  final lowerBeads = startDigit % 5;
  final topBeadActive = startDigit >= 5;

  if (delta > 0) {
    if (delta == 5) {
      return !topBeadActive;
    }
    if (delta > 5) {
      return false;
    }
    return lowerBeads + delta <= 4;
  }

  final remove = -delta;
  if (remove == 5) {
    return topBeadActive;
  }
  if (remove > 5) {
    return false;
  }
  return lowerBeads >= remove;
}

Map<String, String> authHeaders(ParentUser parentUser) {
  return {
    'Authorization': 'Bearer ${parentUser.token}',
  };
}
