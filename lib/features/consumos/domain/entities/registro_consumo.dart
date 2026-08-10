class RegistroConsumo {
  final int? idConsumo;
  final int conexionId;
  final String mes;
  final int consumoActual;
  final int? consumoAnterior;
  final String? foto;
  final bool habilitarLecturaAnterior;
  final bool reciboGenerado;
  final String? estadoConsumo;

  RegistroConsumo({
    this.idConsumo,
    required this.conexionId,
    required this.mes,
    required this.consumoActual,
    required this.consumoAnterior,
    this.foto,
    required this.habilitarLecturaAnterior,
    required this.reciboGenerado,
    this.estadoConsumo,
  });

  factory RegistroConsumo.fromJson(Map<String, dynamic> json) {
    return RegistroConsumo(
      idConsumo: json['id'] as int?,
      conexionId: (json['conexion_id'] ?? 0) as int,
      mes: json['mes']?.toString() ?? '',
      consumoActual: (json['consumo_actual'] ?? 0) as int,
      consumoAnterior: json['consumo_anterior'] as int?,
      foto: json['foto_url']?.toString() ?? json['foto']?.toString(),
      habilitarLecturaAnterior:
          (json['habilitar_lectura_anterior'] ?? false) as bool,
      reciboGenerado: (json['recibo_generado'] ?? false) as bool,
      estadoConsumo: json['estado_consumo']?.toString(),
    );
  }
}
