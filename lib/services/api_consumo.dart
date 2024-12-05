import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiConsumo with ChangeNotifier {
  List<Map<String, dynamic>> _consumos = [];

  List<Map<String, dynamic>> get consumos => _consumos;

  // Método para obtener consumos de un cliente por ID
  Future<void> obtenerConsumos(int clienteId, String token) async {
    final url = Uri.parse('http://192.168.56.59:8000/api/consumos/$clienteId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _consumos = data.map((e) => e as Map<String, dynamic>).toList();
        notifyListeners();
      } else {
        throw Exception('Error al obtener los consumos del cliente.');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }
}
