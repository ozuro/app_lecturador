import 'conexion_entities.dart';
import 'direccion_entites.dart';

class LecturasResumenEntity {
  final String month;
  final int total;
  final int conLectura;
  final int sinLectura;
  final List<Direccion> direcciones;
  final List<Conexion> conexiones;

  const LecturasResumenEntity({
    required this.month,
    required this.total,
    required this.conLectura,
    required this.sinLectura,
    required this.direcciones,
    required this.conexiones,
  });

  factory LecturasResumenEntity.fromJson(Map<String, dynamic> json) {
    final meta = (json['meta'] as Map<String, dynamic>? ?? <String, dynamic>{});
    final filters =
        (json['filters'] as Map<String, dynamic>? ?? <String, dynamic>{});
    final direccionesJson = json['direcciones'] as List? ?? const [];
    final dataJson = json['data'] as List? ?? const [];

    return LecturasResumenEntity(
      month: filters['month']?.toString() ?? '',
      total: (meta['total'] ?? 0) as int,
      conLectura: (meta['con_lectura'] ?? 0) as int,
      sinLectura: (meta['sin_lectura'] ?? 0) as int,
      direcciones: direccionesJson
          .whereType<Map<String, dynamic>>()
          .map(Direccion.fromJson)
          .toList(),
      conexiones: dataJson
          .whereType<Map<String, dynamic>>()
          .map(Conexion.fromJson)
          .toList(),
    );
  }
}
