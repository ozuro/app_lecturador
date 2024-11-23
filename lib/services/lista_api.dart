import 'dart:convert';
import 'package:http/http.dart' as http;

class ListaAPI {
  static const String baseUrl =
      'http://localhost/sis_jass/public/api'; // Cambia esto si tienes otra URL base

  /// Obtiene la lista de consumos de un cliente por su ID.
  static Future<List<dynamic>> obtenerConsumos(int clienteId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/consumos?cliente_id=$clienteId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['consumos']; // Ajusta según la estructura de tu API
      } else {
        throw Exception(
            'Error al obtener los consumos. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en obtenerConsumos: $e');
      rethrow;
    }
  }

  /// Elimina un consumo por su ID.
  static Future<bool> eliminarConsumo(int consumoId) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/consumos/$consumoId'));

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error al eliminar el consumo. Código: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error en eliminarConsumo: $e');
      return false;
    }
  }

  /// Crea un nuevo consumo.
  static Future<bool> crearConsumo(Map<String, dynamic> consumoData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/consumos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(consumoData),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Error al crear el consumo. Código: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error en crearConsumo: $e');
      return false;
    }
  }

  /// Edita un consumo existente.
  static Future<bool> editarConsumo(
      int consumoId, Map<String, dynamic> consumoData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/consumos/$consumoId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(consumoData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error al editar el consumo. Código: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error en editarConsumo: $e');
      return false;
    }
  }
}
