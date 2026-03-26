import 'dart:convert';

import 'package:app_lecturador/core/storage/config/api_config.dart';
import 'package:app_lecturador/domain/entities/busqueda_cliente_entity.dart';
import 'package:app_lecturador/domain/entities/cliente_entities.dart';
import 'package:app_lecturador/domain/entities/conexion_entities.dart';
import 'package:app_lecturador/domain/entities/consumo_entities.dart';
import 'package:app_lecturador/domain/entities/lecturas_resumen_entity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConsumosRemoteDataSource {
  final String baseUrl = '${ApiConfig.baseUrl}/api/consumos';

  Future<LecturasResumenEntity> getConexiones({
    required String month,
    String? direccionId,
  }) async {
    final token = await _token();

    final query = <String, String>{
      'month': month,
      if (direccionId != null && direccionId.isNotEmpty) 'direccion_id': direccionId,
    };

    final uri = Uri.parse('$baseUrl/index').replace(queryParameters: query);

    final response = await http.get(
      uri,
      headers: _headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception(_extractError(response.body, 'Error al obtener lecturas'));
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return LecturasResumenEntity.fromJson(decoded);
  }

  Future<BusquedaClienteEntity> buscarPorDni(String dni) async {
    final token = await _token();
    final response = await http.post(
      Uri.parse('$baseUrl/buscar'),
      headers: _headers(token),
      body: jsonEncode({'dni': dni}),
    );

    if (response.statusCode != 200) {
      throw Exception(_extractError(response.body, 'No se pudo buscar el cliente'));
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final clienteJson = data['cliente'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final conexionesJson = (clienteJson['conexion'] ?? clienteJson['conexiones']) as List? ?? const [];

    final conexionesBase = conexionesJson
        .whereType<Map<String, dynamic>>()
        .map((json) => Conexion.fromJson({
              'conexion_id': json['id'],
              'codigo': json['codigo'],
              'estado': json['estado'],
              'medidor': json['medidor'],
              'cliente': clienteJson,
              'direccion': json['direccion'] ?? <String, dynamic>{},
              'consumos': const [],
              'tiene_lectura_registrada': false,
            }))
        .toList();

    final conexionesConLecturas = <Conexion>[];
    for (final conexion in conexionesBase) {
      final lecturas = await getLecturasPorConexion(conexion.id);
      conexionesConLecturas.add(
        Conexion(
          id: conexion.id,
          codigo: conexion.codigo,
          tipoServicio: conexion.tipoServicio,
          estado: conexion.estado,
          medidor: conexion.medidor,
          cliente: conexion.cliente,
          direccion: conexion.direccion,
          lectura: lecturas.isNotEmpty ? lecturas.first : null,
          consumos: lecturas,
          consumoAnteriorSugerido: conexion.consumoAnteriorSugerido,
          tieneLecturaRegistrada: lecturas.isNotEmpty,
        ),
      );
    }

    return BusquedaClienteEntity(
      cliente: Cliente.fromJson(clienteJson),
      conexiones: conexionesConLecturas,
    );
  }

  Future<List<Consumo>> getLecturasPorConexion(int conexionId) async {
    final token = await _token();
    final uri = Uri.parse('$baseUrl/lista').replace(
      queryParameters: {'conexion_id': '$conexionId'},
    );

    final response = await http.get(
      uri,
      headers: _headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception(_extractError(response.body, 'No se pudo obtener el historial'));
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as List? ?? const [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(Consumo.fromJson)
        .toList();
  }

  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Usuario no autenticado. Token no encontrado.');
    }

    return token;
  }

  Map<String, String> _headers(String token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  String _extractError(String body, String fallback) {
    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      return decoded['message']?.toString() ??
          decoded['mensaje']?.toString() ??
          fallback;
    } catch (_) {
      return fallback;
    }
  }
}
