import 'package:http/http.dart' as http;

import 'api_config.dart';

Future<bool> warmUpBackend() async {
  final uri = ApiConfig.freshUri('/api/health');
  try {
    final response = await http
        .get(
          uri,
          headers: ApiConfig.noCacheHeaders(),
        )
        .timeout(ApiConfig.requestTimeout);

    return response.statusCode >= 200 && response.statusCode < 300;
  } catch (_) {
    return false;
  }
}
