class Direccion {
  final int id;
  final String nombre;
  final String barrio;
  final String distrito;

  Direccion({
    required this.id,
    required this.nombre,
    required this.barrio,
    required this.distrito,
  });

  factory Direccion.fromJson(Map<String, dynamic> json) {
    return Direccion(
      id: json['id'],
      nombre: json['nombre'],
      barrio: json['barrio'],
      distrito: json['distrito'],
    );
  }
}
