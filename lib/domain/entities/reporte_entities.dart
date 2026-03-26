class ReporteHomeEntity {
  final int cantidadConexiones;

  ReporteHomeEntity({
    required this.cantidadConexiones,
  });

  factory ReporteHomeEntity.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return ReporteHomeEntity(
      cantidadConexiones: (data['total_conexiones_activas'] ?? 0) as int,
    );
  }
}
