class RegistroConsumo {
  final int? idConsumo;
  final int conexionId;
  final String mes;
  final int consumoActual;
  final int? consumoAnterior;
  final String? foto;
  final bool habilitarLecturaAnterior;

  RegistroConsumo({
    this.idConsumo,
    required this.conexionId,
    required this.mes,
    required this.consumoActual,
    required this.consumoAnterior,
    this.foto,
    required this.habilitarLecturaAnterior,
  });

  factory RegistroConsumo.fromJson(Map<String, dynamic> json) {
    return RegistroConsumo(
      idConsumo: json['id'] ?? 0,
      conexionId: json['conexionId'] ?? 0,
      mes: json['mes'] ?? '',
      consumoActual: json['consumo_actual'] ?? 0,
      consumoAnterior: json['consumo_anterior'] ?? 0,
      foto: json['foto'],
      habilitarLecturaAnterior: json['habilitarLecturaAnterior'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conexionId': conexionId,
      'mes': mes,
      'consumo_actual': consumoActual,
      'consumo_anterior': consumoAnterior,
      'foto': foto,
      'habilitarLecturaAnterior': habilitarLecturaAnterior,
    };
  }
}
// class RegistroConsumo {
//   final int id;
//   final int conexionId;
//   final String mes;
//   final int consumoActual;
//   final int consumoAnterior;
//   final bool reciboGenerado;

//   RegistroConsumo({
//     required this.id,
//     required this.conexionId,
//     required this.mes,
//     required this.consumoActual,
//     required this.consumoAnterior,
//     required this.reciboGenerado,
//   });

//   factory RegistroConsumo.fromJson(Map<String, dynamic> json) {
//     return RegistroConsumo(
//       id: json['id'],
//       conexionId: json['conexion_id'],
//       mes: json['mes'],
//       consumoActual: json['consumo_actual'],
//       consumoAnterior: json['consumo_anterior'],
//       reciboGenerado: json['recibo_generado'],
//     );
//   }
// }
