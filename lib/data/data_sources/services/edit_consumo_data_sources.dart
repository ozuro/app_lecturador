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

    final payload = {
      "conexion_id": conexionId,
      "mes": mes,
      "consumo_actual": consumoActual,
      "consumo_anterior": consumoAnterior,
      "foto": foto,
      "habilitar_lectura_anterior": habilitarLecturaAnterior,
    };

    final response = await http.put(
      Uri.parse('$url/$idConsumo'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(_buildErrorMessage(response));
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return RegistroConsumo.fromJson(
      decoded['data'] as Map<String, dynamic>,
    );
  }

  String _buildErrorMessage(http.Response response) {
    final rawBody = response.body.trim();

    try {
      final body = jsonDecode(rawBody);
      if (body is Map<String, dynamic>) {
        final mensaje = body['mensaje']?.toString();
        if (mensaje != null && mensaje.isNotEmpty) {
          final normalized = _normalizeBackendMessage(mensaje);
          if (normalized != null) return normalized;
          return mensaje;
        }

        final error = body['error']?.toString();
        if (error != null && error.isNotEmpty) {
          final normalized = _normalizeBackendMessage(error);
          if (normalized != null) return normalized;
          return error;
        }

        final errors = body['errors'];
        if (errors is Map<String, dynamic> && errors.isNotEmpty) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) {
            return first.first.toString();
          }
          return first.toString();
        }
      }
    } catch (_) {
      // The backend may return HTML/plain text on large payloads or 500s.
    }

    if (response.statusCode == 413) {
      return 'La foto es demasiado pesada. Toma otra foto con menor tamano.';
    }

    final normalized = _normalizeBackendMessage(rawBody);
    if (normalized != null) {
      return normalized;
    }

    if (rawBody.isNotEmpty) {
      final bodyPreview = rawBody;
      final shortBody = bodyPreview.length > 140
          ? '${bodyPreview.substring(0, 140)}...'
          : bodyPreview;
      return 'Error ${response.statusCode}: $shortBody';
    }

    return 'Error ${response.statusCode} al actualizar consumo';
  }

  String? _normalizeBackendMessage(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('sqlstate[22001]') && lower.contains("'foto'")) {
      return 'No se pudo guardar la foto porque el servidor no admite imagenes en este formato todavia. Puedes actualizar la lectura sin foto o ajustar el backend para guardar la imagen en una columna TEXT/LONGTEXT o por archivo.';
    }

    return null;
  }
}
