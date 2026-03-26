import 'cliente_entities.dart';
import 'consumo_entities.dart';
import 'direccion_entites.dart';

class Conexion {
  final int id;
  final String? codigo;
  final String? tipoServicio;
  final String? estado;
  final bool medidor;
  final Cliente cliente;
  final Direccion direccion;
  final Consumo? lectura;
  final List<Consumo> consumos;
  final int consumoAnteriorSugerido;
  final bool tieneLecturaRegistrada;

  Conexion({
    required this.id,
    this.codigo,
    this.tipoServicio,
    this.estado,
    required this.medidor,
    required this.cliente,
    required this.direccion,
    this.lectura,
    this.consumos = const [],
    this.consumoAnteriorSugerido = 0,
    this.tieneLecturaRegistrada = false,
  });

  String get nombreCompleto => cliente.nombreCompleto;

  Consumo? get ultimoConsumo {
    if (lectura != null) {
      return lectura;
    }
    if (consumos.isNotEmpty) {
      return consumos.first;
    }
    return null;
  }

  String get consumoActualTexto =>
      ultimoConsumo?.consumoActual?.toString() ?? 'Sin lectura';

  String get estadoLecturaLabel =>
      tieneLecturaRegistrada ? 'Lectura registrada' : 'Lectura pendiente';

  String get estadoReciboLabel =>
      ultimoConsumo?.estadoReciboLabel ?? 'Sin recibo';

  factory Conexion.fromJson(Map<String, dynamic> json) {
    final lecturasJson = json['consumos'];
    final consumos = lecturasJson is List
        ? lecturasJson
            .whereType<Map<String, dynamic>>()
            .map(Consumo.fromJson)
            .toList()
        : <Consumo>[];

    final lecturaJson = json['lectura'];
    final lectura = lecturaJson is Map<String, dynamic>
        ? Consumo.fromJson(lecturaJson)
        : consumos.isNotEmpty
            ? consumos.first
            : null;

    return Conexion(
      id: (json['conexion_id'] ?? json['id']) as int,
      codigo: json['codigo']?.toString(),
      tipoServicio: json['tipo_servicio']?.toString(),
      estado: json['estado']?.toString(),
      medidor: json['medidor'] == true || json['medidor'] == 1,
      cliente: Cliente.fromJson(json['cliente'] as Map<String, dynamic>),
      direccion: Direccion.fromJson(json['direccion'] as Map<String, dynamic>),
      lectura: lectura,
      consumos: consumos,
      consumoAnteriorSugerido: (json['consumo_anterior_sugerido'] ?? 0) as int,
      tieneLecturaRegistrada: json['tiene_lectura_registrada'] == true ||
          lectura != null ||
          consumos.isNotEmpty,
    );
  }
}
