import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final String loginUrl = "http://10.147.38.151:8000/api/api_login";

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Credenciales incorrectas');
    }

    final data = jsonDecode(response.body);
    return data['data']['token'];
  }
}
