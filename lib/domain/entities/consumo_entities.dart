class Consumo {
  final int? consumoActual;
  final String? fecha;

  Consumo({
    this.consumoActual,
    this.fecha,
  });

  factory Consumo.fromJson(Map<String, dynamic> json) {
    return Consumo(
      consumoActual: json['consumo_actual'],
      fecha: json['fecha'],
    );
  }
}
