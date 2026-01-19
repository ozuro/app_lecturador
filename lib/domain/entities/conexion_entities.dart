import 'package:app_lecturador/domain/entities/direccion_entites.dart';

import 'cliente_entities.dart';

import 'consumo_entities.dart';

class Conexion {
  final int id;
  final String? codigo;
  final String? tipoServicio;
  final String? estado;
  final int medidor;

  final Cliente cliente;
  final Direccion direccion;
  final List<Consumo> consumos;

  Conexion({
    required this.id,
    this.codigo,
    this.tipoServicio,
    this.estado,
    required this.medidor,
    required this.cliente,
    required this.direccion,
    required this.consumos,
  });

  // ===== GETTERS DE DOMINIO PARA LA UI =====

  String get nombreCompleto => cliente.nombreCompleto;

  // String get direccionCompleta => direccion.direccionCompleta;

  Consumo? get ultimoConsumo => consumos.isNotEmpty ? consumos.last : null;

  String get consumoActualTexto =>
      ultimoConsumo?.consumoActual?.toString() ?? 'Sin lectura';

  // String get estadoConsumo => consumos.estadoConsumo ?? 'Desconocido';

  factory Conexion.fromJson(Map<String, dynamic> json) {
    return Conexion(
      id: json['id'],
      codigo: json['codigo'],
      tipoServicio: json['tipo_servicio'],
      estado: json['estado'],
      medidor: json['medidor'],
      cliente: Cliente.fromJson(json['cliente']),
      direccion: Direccion.fromJson(json['direccion']),
      consumos:
          (json['consumos'] as List).map((e) => Consumo.fromJson(e)).toList(),
    );
  }
}
