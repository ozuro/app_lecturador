import 'dart:convert';
import 'package:app_lecturador/services/login/prueba_riverpod/model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// tu modelo de consumo

class ConsumosRemoteDataSource {
  final String baseUrl = 'http://10.226.193.191:8000/api/consumos/index';

  Future<List<Consumo>> getConsumos({
    String month = "2025-12",
    String direccionId = "1",
  }) async {
    // 1️⃣ Obtener token guardado en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Usuario no autenticado. Token no encontrado.');
    }

    // 2️⃣ Construir URL con parámetros
    final uri = Uri.parse('$baseUrl?month=$month&direccion_id=$direccionId');

    // 3️⃣ Petición GET con token en Authorization
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // ✅ Token aquí
      },
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    // 4️⃣ Manejo de errores
    if (response.statusCode != 200) {
      throw Exception('Error al obtener consumos: ${response.statusCode}');
    }

    // 5️⃣ Decodificar JSON
    final decoded = jsonDecode(response.body);
    if (decoded['data'] == null) {
      throw Exception('No se encontraron datos de consumos.');
    }

    final List list = decoded['data'];

    // 6️⃣ Convertir a lista de Consumo
    return list.map((json) => Consumo.fromJson(json)).toList();
  }
}
