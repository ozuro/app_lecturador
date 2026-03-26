class Cliente {
  final int? id;
  final String? dni;
  final String? nombres;
  final String? apellidos;
  final String? nombreCompletoApi;

  Cliente({
    this.id,
    this.dni,
    this.nombres,
    this.apellidos,
    this.nombreCompletoApi,
  });

  String get nombreCompleto {
    final local = [nombres, apellidos]
        .where((value) => value != null && value!.trim().isNotEmpty)
        .join(' ')
        .trim();

    if (local.isNotEmpty) {
      return local;
    }

    return nombreCompletoApi?.trim().isNotEmpty == true
        ? nombreCompletoApi!.trim()
        : 'Cliente sin nombre';
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] as int?,
      dni: json['dni']?.toString(),
      nombres: json['nombres']?.toString(),
      apellidos: json['apellidos']?.toString(),
      nombreCompletoApi: json['nombre_completo']?.toString(),
    );
  }
}
