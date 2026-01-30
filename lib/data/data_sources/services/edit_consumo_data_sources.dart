import 'dart:convert';
import 'package:app_lecturador/core/storage/config/api_config.dart';
import 'package:app_lecturador/domain/entities/registro_consumo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditConsumoRemoteDataSource {
  final String url = "${ApiConfig.baseUrl}/api/consumos/update";

  Future<RegistroConsumo> editConsumo({
    required int idConsumo,
    required int conexionId,
    required String mes,
    required int consumoActual,
    required int? consumoAnterior,
    String? foto,
    required bool habilitarLecturaAnterior,
  }) async {
// token
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Usuario no autenticado');
    }
    // token

    final response = await http.put(
      Uri.parse('$url/$idConsumo'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "conexion_id": conexionId,
        "mes": mes,
        "consumo_actual": consumoActual,
        "consumo_anterior": consumoAnterior,
        "foto": foto,
        "habilitar_lectura_anterior": habilitarLecturaAnterior,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['mensaje'] ?? 'Error al actualizar consumo');
    }

    final decoded = jsonDecode(response.body);
    return RegistroConsumo.fromJson(decoded['consumo']);
  }
}
