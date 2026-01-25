import 'dart:convert';
import 'package:app_lecturador/domain/entities/registro_consumo.dart';
import 'package:http/http.dart' as http;

class RegistroConsumoRemoteDataSource {
  final String url = "http://10.147.38.151:8000/api/consumos/store";

  Future<RegistroConsumo> registrarConsumo({
    required int conexionId,
    required String mes,
    required int consumoActual,
    required int consumoAnterior,
    String? foto,
    required bool habilitarLecturaAnterior,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
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
      throw Exception(error['mensaje'] ?? 'Error al registrar consumo');
    }

    final decoded = jsonDecode(response.body);
    return RegistroConsumo.fromJson(decoded['consumo']);
  }
}
