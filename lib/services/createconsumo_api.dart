// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiConsumocreate {
//   // URL base de la API
//   final String baseUrl = 'http://192.168.104.101:8000/api/consumos';

//   // Método para crear un consumo
//   Future<Map<String, dynamic>> crearConsumo({
//     required int clienteId,
//     required String mes,
//     required double consumoActual,
//     String? foto,
//     required String estadoMedidor,
//     required String token,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token', // Enviar el token en el encabezado
//         },
//         body: json.encode({
//           'cliente_id': clienteId,
//           'mes': mes,
//           'consumo_actual': consumoActual,
//           'foto': foto ?? null, // Enviar null si no hay foto
//           'estado_medidor': estadoMedidor,
//         }),
//       );

//       if (response.statusCode == 201) {
//         // Si la respuesta es exitosa, retornamos el cuerpo de la respuesta como un Map
//         return json.decode(response.body);
//       } else {
//         print('Error al crear consumo: ${response.body}');
//         throw Exception('Error al crear consumo');
//       }
//     } catch (e) {
//       print("Error al crear consumo: $e");
//       throw Exception("Error al crear consumo");
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiConsumocreate with ChangeNotifier {
  // URL base de la API
  final String baseUrl = 'http://192.168.104.101:8000/api/consumos';

  // Método para crear un consumo
  Future<Map<String, dynamic>> crearConsumo({
    required int clienteId,
    required String mes,
    required double consumoActual,
    String? foto,
    required String estadoMedidor,
    required String token,
  }) async {
    try {
      // Realizando la solicitud POST a la API
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token en el encabezado
        },
        body: json.encode({
          'cliente_id': clienteId,
          'mes': mes,
          'consumo_actual': consumoActual,
          'foto': foto ?? null, // Enviar null si no hay foto
          'estado_medidor': estadoMedidor,
        }),
      );

      if (response.statusCode == 201) {
        // Si la respuesta es exitosa, retornamos el cuerpo de la respuesta como un Map
        final responseData = json.decode(response.body);

        // Notificar a los oyentes de que el consumo se ha creado correctamente
        notifyListeners();

        return responseData;
      } else {
        print('Error al crear consumo: ${response.body}');
        throw Exception('Error al crear consumo');
      }
    } catch (e) {
      print("Error al crear consumo: $e");
      throw Exception("Error al crear consumo");
    }
  }
}
