class ApiConfig {
  static const Duration requestTimeout = Duration(seconds: 10);

  static const String localBaseUrl = 'http://localhost:8080';
  static const String prodBaseUrl = 'https://brain-gym-academy-app.onrender.com';

  static String get baseUrl {
    final host = Uri.base.host;
    final isLocalFrontend = host == 'localhost' || host == '127.0.0.1' || host.isEmpty;
    return isLocalFrontend ? localBaseUrl : prodBaseUrl;
  }

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
