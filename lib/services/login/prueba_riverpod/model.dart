class Consumo {
  final String cliente;

  Consumo({required this.cliente});

  factory Consumo.fromJson(Map<String, dynamic> json) {
    return Consumo(
      cliente: '${json['cliente']['nombres']} ${json['cliente']['apellidos']}',
    );
  }
}

class Direccions {
  final String direccion;

  Direccions({required this.direccion});

  factory Direccions.fromJson(Map<String, dynamic> json) {
    return Direccions(
      direccion: '${json['direccion']['nombre']}',
    );
  }
}
