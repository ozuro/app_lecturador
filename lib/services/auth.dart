import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;

  // Método para iniciar sesión
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.104.101:8000/api/api_login'), // Tu API
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 1) {
        // Guardar el token y los datos del usuario
        _token = data['data']['token'];
        _user = data['data']['user'];
        await _saveToken(_token!);
        await _saveUser(_user!);
        notifyListeners();
        return true;
      } else {
        // return false;
        throw Exception('Credenciales incorrectas. Inténtalo nuevamente.');
      }
    } else {
      throw Exception('Credenciales incorrectas. Inténtalo nuevamente');
    }
  }

  // Verificar si el usuario está autenticado
  Future<bool> checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _user = prefs.getString('auth_user') != null
        ? json.decode(prefs.getString('auth_user')!)
        : null;
    notifyListeners();
    return _token != null;
  }

  // Guardar el token en SharedPreferences
  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token);
  }

  // Guardar los datos del usuario en SharedPreferences
  Future<void> _saveUser(Map<String, dynamic> user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_user', json.encode(user));
  }

  // Realizar el logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
    prefs.remove('auth_user');
    _token = null;
    _user = null;
    notifyListeners();
  }
}
