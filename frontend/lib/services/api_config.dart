class ApiConfig {
  static const bool useLocal = false;

  static const String localBaseUrl = 'http://localhost:8080';
  static const String prodBaseUrl = 'https://brain-gym-academy-app.onrender.com';

  static String get baseUrl => useLocal ? localBaseUrl : prodBaseUrl;
}
