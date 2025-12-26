import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String loginUrl = "http://10.226.193.191:8000/api/api_login";

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // EJEMPLO de respuesta esperada:
        // { "token": "...", "user": {...} }

        // AQUÍ luego guardas el token
        // final token = data['token'];

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
