import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiBuscar with ChangeNotifier {
  // Método para buscar cliente
  Future<Map<String, dynamic>?> buscarCliente(String dni, String token) async {
    final response = await http.post(
      Uri.parse('http://10.23.116.9:8000/api/consumos/buscar'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Envía el token en la cabecera
      },
      body: json.encode({'dni': dni}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['cliente'] != null) {
        // print(data['cliente']); // Imprime los datos del cliente para depuración
        return data['cliente']; // Retorna los datos del cliente
      } else {
        throw Exception('Cliente no encontrado.');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Token inválido o expirado.');
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }
}
