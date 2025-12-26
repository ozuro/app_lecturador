class Consumo {
  final String cliente;
  final String direccion;
  final String codigoConexion;
  final double consumoActual;
  final bool registrado;

  Consumo({
    required this.cliente,
    required this.direccion,
    required this.codigoConexion,
    required this.consumoActual,
    required this.registrado,
  });

  factory Consumo.fromJson(Map<String, dynamic> json) {
    return Consumo(
      cliente: json['cliente'],
      direccion: json['direccion'],
      codigoConexion: json['codigo_conexion'],
      consumoActual: (json['consumo_actual'] ?? 0).toDouble(),
      registrado: json['registrado'] ?? false,
    );
  }
}
