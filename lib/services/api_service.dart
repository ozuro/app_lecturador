import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://localhost/api";

  Future<Map<String, dynamic>?> buscarCliente(String dni) async {
    final response = await http.post(
      Uri.parse('$baseUrl/consumos/buscar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'dni': dni}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<List<dynamic>> obtenerConsumos(int clienteId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/consumos/$clienteId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Error al obtener consumos");
  }

  Future<void> eliminarConsumo(int consumoId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/consumos/$consumoId'),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar consumo");
    }
  }
}
