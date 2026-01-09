class Conexion {
  final String nombres;
  final String apellidos;
  final String direccion;
  final List<Consumo> consumos;

  Conexion({
    required this.nombres,
    required this.apellidos,
    required this.direccion,
    required this.consumos,
  });

  factory Conexion.fromJson(Map<String, dynamic> json) {
    return Conexion(
      nombres: json['cliente']?['nombres'] ?? '',
      apellidos: json['cliente']?['apellidos'] ?? '',
      direccion: json['direccion']?['nombre'] ?? '',
      consumos:
          (json['consumos'] as List).map((e) => Consumo.fromJson(e)).toList(),
    );
  }

  String get nombreCompleto => '$nombres $apellidos';
}

class Consumo {
  final String mes;
  final int consumoActual;
  final String estado;

  Consumo({
    required this.mes,
    required this.consumoActual,
    required this.estado,
  });

  factory Consumo.fromJson(Map<String, dynamic> json) {
    return Consumo(
      mes: json['mes'],
      consumoActual: json['consumo_actual'],
      estado: json['estado_consumo'],
    );
  }
}
