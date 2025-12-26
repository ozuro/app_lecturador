import 'dart:convert';
import 'package:app_lecturador/models/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await http.post(
        Uri.parse('http://10.212.35.218:8000/api/api_login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode != 200) {
        throw Exception('Credenciales incorrectas.');
      }

      final data = json.decode(response.body);

      if (data['status'] != 1) {
        throw Exception('Credenciales incorrectas.');
      }

      final token = data['data']['token'];
      final user = data['data']['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('auth_user', json.encode(user));

      state = state.copyWith(
        isLoading: false,
        token: token,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_user');

    state = AuthState();
  }

  Future<void> checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final user = prefs.getString('auth_user');

    if (token != null && user != null) {
      state = state.copyWith(
        token: token,
        user: json.decode(user),
      );
    }
  }
}
