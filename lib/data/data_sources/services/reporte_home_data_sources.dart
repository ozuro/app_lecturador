import 'dart:convert';
import 'package:app_lecturador/domain/entities/reporte_entities.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReporteHomeRemoteDataSource {
  Future<ReporteHomeEntity> getReporteHome() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://10.147.38.151:8000/api/consumos/reporte_conexiones'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('API response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return ReporteHomeEntity(
        cantidadConexiones: data['total conexiones activas'],
      );
    } else {
      throw Exception('Error al cargar reporte home');
    }
  }
}
