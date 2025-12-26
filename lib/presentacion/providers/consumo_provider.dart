import 'dart:convert';

import 'package:app_lecturador/models/conexiones.dart';
import 'package:app_lecturador/presentacion/providers/consumo_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final consumosProvider =
    FutureProvider.family<List<ConsumoItem>, Map<String, String>>(
  (ref, filtros) async {
    final uri = Uri.parse(
      'http://10.212.35.218:8000/api/consumos/index'
      '?month=${filtros['month']}'
      '&estado=${filtros['estado']}'
      '&con_medidor=${filtros['con_medidor']}'
      '&direccion_id=${filtros['direccion_id']}',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Error al cargar consumos');
    }

    final data = jsonDecode(response.body);

    return mapConsumosFromApi(data['conexiones']);
  },
);
