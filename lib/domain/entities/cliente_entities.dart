class Cliente {
  final int? id;
  final String? tipoPersona;
  final String? dni;
  final String? ruc;
  final String? nombres;
  final String? apellidos;
  final String? razonSocial;
  final String? nombreCompletoApi;

  Cliente({
    this.id,
    this.tipoPersona,
    this.dni,
    this.ruc,
    this.nombres,
    this.apellidos,
    this.razonSocial,
    this.nombreCompletoApi,
  });

  bool get esJuridica => tipoPersona?.toLowerCase() == 'juridica';

  String get tipoPersonaLabel => esJuridica ? 'Persona juridica' : 'Persona natural';

  String get documentoLabel => esJuridica ? 'RUC' : 'DNI';

  String get documentoPrincipal =>
      esJuridica
          ? ((ruc?.trim().isNotEmpty == true) ? ruc!.trim() : '-')
          : ((dni?.trim().isNotEmpty == true) ? dni!.trim() : '-');

  String get nombreCompleto {
    if (esJuridica) {
      if (razonSocial?.trim().isNotEmpty == true) {
        return razonSocial!.trim();
      }

      if (nombreCompletoApi?.trim().isNotEmpty == true) {
        return nombreCompletoApi!.trim();
      }

      return 'Persona juridica';
    }

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
      tipoPersona: json['tipo_persona']?.toString(),
      dni: json['dni']?.toString(),
      ruc: json['ruc']?.toString(),
      nombres: json['nombres']?.toString(),
      apellidos: json['apellidos']?.toString(),
      razonSocial: json['razon_social']?.toString(),
      nombreCompletoApi: json['nombre_completo']?.toString(),
    );
  }
}
