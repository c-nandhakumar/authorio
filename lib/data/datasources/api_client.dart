import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  ApiClient({required this.client});

  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl$endpoint',
    ).replace(queryParameters: queryParams);

    final response = await client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load data from $endpoint');
    }

    return jsonDecode(response.body);
  }
}
