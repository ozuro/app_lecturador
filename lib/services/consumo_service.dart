import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConsumoService with ChangeNotifier {
  final String _baseUrl =
      'http://192.168.57.33:8000/api'; // Cambia la URL según tu API

  // Obtener consumos del cliente por DNI
  Future<List<dynamic>> getConsumosByDni(String dni) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/consumos/$dni'), // Ajusta la URL a la ruta correcta de tu API
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data[
          'consumos']; // Ajusta según la estructura de respuesta de tu API
    } else {
      throw Exception('Error al obtener consumos');
    }
  }

  // Agregar un nuevo consumo
  Future<bool> agregarConsumo(Map<String, dynamic> consumoData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.post(
      Uri.parse('$_baseUrl/consumos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(consumoData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al agregar el consumo');
    }
  }

  // Editar un consumo existente
  Future<bool> editarConsumo(
      int consumoId, Map<String, dynamic> consumoData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.put(
      Uri.parse('$_baseUrl/consumos/$consumoId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(consumoData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al editar el consumo');
    }
  }

  // Eliminar un consumo
  Future<bool> eliminarConsumo(int consumoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.delete(
      Uri.parse('$_baseUrl/consumos/$consumoId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al eliminar el consumo');
    }
  }
}
