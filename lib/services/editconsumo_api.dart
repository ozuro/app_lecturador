// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;

// class ApiConsumoUpdate with ChangeNotifier {
//   // URL base de la API
//   final String baseUrl = 'http://192.168.56.59:8000/api/consumos';

//   // Método para actualizar un consumo
//   Future<Map<String, dynamic>> actualizarConsumo({
//     required int consumoId,
//     required String mes,
//     required double consumoActual,
//     required int clienteId,
//     required double costoMantenimiento,
//     required String token,
//   }) async {
//     try {
//       // Realizando la solicitud PUT a la API
//       final response = await http.put(
//         Uri.parse('$baseUrl/$consumoId'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token', // Enviar el token en el encabezado
//         },
//         body: json.encode({
//           'mes': mes,
//           'consumo_actual': consumoActual,
//           'cliente_id': clienteId,
//           'costo_mantenimiento': costoMantenimiento,
//         }),
//       );

//       if (response.statusCode == 200) {
//         // Si la respuesta es exitosa, retornamos el cuerpo de la respuesta como un Map
//         final responseData = json.decode(response.body);

//         // Notificar a los oyentes de que el consumo se ha actualizado correctamente
//         notifyListeners();

//         return responseData;
//       } else {
//         print('Error al actualizar consumo: ${response.body}');
//         throw Exception('Error al actualizar consumo');
//       }
//     } catch (e) {
//       print("Error al actualizar consumo: $e");
//       throw Exception("Error al actualizar consumo");
//     }
//   }
// }
