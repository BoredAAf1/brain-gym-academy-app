class ApiConfig {
  static const bool useLocal = false;

  static const String localBaseUrl = 'http://localhost:8080';
  static const String prodBaseUrl = 'https://brain-gym-academy-app.onrender.com';

  static String get baseUrl => useLocal ? localBaseUrl : prodBaseUrl;

  static Uri freshUri(String path, [Map<String, String>? queryParameters]) {
    final mergedQuery = {
      ...?queryParameters,
      '_': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    return Uri.parse('$baseUrl$path').replace(queryParameters: mergedQuery);
  }

  static Map<String, String> noCacheHeaders([Map<String, String>? additionalHeaders]) {
    return {
      'Cache-Control': 'no-cache',
      'Pragma': 'no-cache',
      ...?additionalHeaders,
    };
  }
}
