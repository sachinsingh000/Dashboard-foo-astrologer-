import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
      String email,
      String password,
      ) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final res = await http.post(
      url,
      headers: const {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final body = jsonDecode(res.body);

    return {
      "status": res.statusCode,
      "data": body,
    };
  }
}
