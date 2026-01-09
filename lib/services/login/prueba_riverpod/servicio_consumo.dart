import 'dart:convert';
import 'package:app_lecturador/services/login/prueba_riverpod/model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// tu modelo de consumo

class ConsumosRemoteDataSource {
  final String baseUrl = 'http://10.165.0.160:8000/api/consumos/index';

  Future<List<Conexion>> getConexiones({
    String month = "2025-12",
    String direccionId = "1",
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Usuario no autenticado. Token no encontrado.');
    }

    final uri = Uri.parse('$baseUrl?month=$month&direccion_id=$direccionId');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Error al obtener consumos: ${response.statusCode}');
    }

    // ✅ AQUÍ ESTABA EL ERROR
    final List<dynamic> list = jsonDecode(response.body);

    return list.map((json) => Conexion.fromJson(json)).toList();
  }
}
