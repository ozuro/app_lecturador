class Cliente {
  final String? nombres;
  final String? apellidos;

  Cliente({
    this.nombres,
    this.apellidos,
  });

  String get nombreCompleto =>
      [nombres, apellidos].where((e) => e != null && e!.isNotEmpty).join(' ');

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      nombres: json['nombres'],
      apellidos: json['apellidos'],
    );
  }
}
