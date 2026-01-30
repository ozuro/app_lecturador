class Consumo {
  final int? id;
  final int? consumoActual;
  final String? fecha;
  final String? estadoConsumo;

  Consumo({
    this.id,
    this.consumoActual,
    this.fecha,
    this.estadoConsumo,
  });

  factory Consumo.fromJson(Map<String, dynamic> json) {
    return Consumo(
      id: json['id'],
      consumoActual: json['consumo_actual'],
      fecha: json['fecha'],
      estadoConsumo: json['estado_consumo'],
    );
  }
}
