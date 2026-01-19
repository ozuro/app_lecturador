class Consumo {
  final int? consumoActual;
  final String? fecha;
  final String? estadoConsumo;

  Consumo({
    this.consumoActual,
    this.fecha,
    this.estadoConsumo,
  });

  factory Consumo.fromJson(Map<String, dynamic> json) {
    return Consumo(
      consumoActual: json['consumo_actual'],
      fecha: json['fecha'],
      estadoConsumo: json['estado_consumo'],
    );
  }
}
