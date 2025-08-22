import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rick_and_morty_flutter_challenge/core/app_constants.dart';

class ApiService {
  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse(
      '${AppConstants.baseUrl}$path',
    ).replace(queryParameters: query);

    final res = await _client.get(uri);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('HTTP ${res.statusCode}: ${res.body}');
  }
}
