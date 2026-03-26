class Direccion {
  final int? id;
  final String nombre;
  final String? barrio;
  final String? distrito;

  Direccion({
    this.id,
    required this.nombre,
    this.barrio,
    this.distrito,
  });

  String get descripcionCorta {
    final parts = [nombre, distrito]
        .where((value) => value != null && value.trim().isNotEmpty)
        .toList();
    return parts.join(' - ');
  }

  factory Direccion.fromJson(Map<String, dynamic> json) {
    return Direccion(
      id: json['id'] as int?,
      nombre: json['nombre']?.toString() ?? 'Sin dirección',
      barrio: json['barrio']?.toString(),
      distrito: json['distrito']?.toString(),
    );
  }
}
