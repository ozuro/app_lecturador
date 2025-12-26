import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConsumoService with ChangeNotifier {
  String? _authToken; // Para enviar el token si tu API lo requiere
  List<dynamic> _conexiones = [];

  List<dynamic> get conexiones => _conexiones;

  ConsumoService() {
    _loadAuthToken(); // Cargar el token al inicializar el servicio
  }

  Future<void> _loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
    notifyListeners();
  }

  Future<void> fetchConsumos({
    String? month,
    String? estado,
    String? conMedidor,
    int? direccionId,
  }) async {
    final Uri uri = Uri.parse('http://10.23.116.9:8000/api/consumos').replace(
      // Reemplaza con la URL correcta de tu API
      queryParameters: <String, String>{
        if (month != null) 'month': month,
        if (estado != null) 'estado': estado,
        if (conMedidor != null) 'con_medidor': conMedidor,
        if (direccionId != null) 'direccion_id': direccionId.toString(),
      },
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (_authToken != null)
            'Authorization':
                'Bearer $_authToken', // Incluir token si es necesario
        },
      );

      if (response.statusCode == 200) {
        _conexiones = jsonDecode(response.body) as List<dynamic>;
        notifyListeners(); // Notificar a los widgets sobre los nuevos datos
      } else {
        print('Error al cargar consumos: ${response.statusCode}');
        print('Cuerpo del error: ${response.body}');
        throw Exception('Error al cargar los consumos desde la API');
      }
    } catch (e) {
      print('Error de conexión al cargar consumos: $e');
      throw Exception('Error de conexión con la API de consumos');
    }
  }
}
