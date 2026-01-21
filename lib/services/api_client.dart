import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'storage_service.dart';

class ApiClient {
  static String get _baseUrl => baseUrl;

  static Future<dynamic> get(String path) async {
    final token = await StorageService.getToken();
    final url = Uri.parse("$_baseUrl$path");

    final res = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty)
          "Authorization": "Bearer $token",
      },
    );

    return _handleResponse(res);
  }

  static Future<dynamic> post(String path, Map body) async {
    final token = await StorageService.getToken();
    final url = Uri.parse("$_baseUrl$path");

    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty)
          "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    return _handleResponse(res);
  }

  static dynamic _handleResponse(http.Response res) {
    if (res.body.isEmpty) {
      throw Exception("Empty response (${res.statusCode})");
    }

    final decoded = jsonDecode(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded;
    }

    throw Exception(decoded["message"] ?? "API Error ${res.statusCode}");
  }
}
