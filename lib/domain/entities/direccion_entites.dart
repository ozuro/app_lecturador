class Direccion {
  final int? id;
  final String nombre;
  final String? barrio;
  final String? distrito;
  final double? latitud;
  final double? longitud;

  Direccion({
    this.id,
    required this.nombre,
    this.barrio,
    this.distrito,
    this.latitud,
    this.longitud,
  });

  String get descripcionCorta {
    final parts = [nombre, distrito]
        .where((value) => value != null && value.trim().isNotEmpty)
        .toList();
    return parts.join(' - ');
  }

  bool get tieneCoordenadas => latitud != null && longitud != null;

  factory Direccion.fromJson(Map<String, dynamic> json) {
    final ubicacion = _parseUbicacion(
      json['ubicacion'] ?? json['location'] ?? json['coordenadas'],
    );

    return Direccion(
      id: json['id'] as int?,
      nombre: json['nombre']?.toString() ?? 'Sin direccion',
      barrio: json['barrio']?.toString(),
      distrito: json['distrito']?.toString(),
      latitud: _toDouble(
            json['latitud'] ??
                json['latitude'] ??
                json['lat'] ??
                json['coordenada_lat'],
          ) ??
          ubicacion?.latitud,
      longitud: _toDouble(
            json['longitud'] ??
                json['longitude'] ??
                json['lng'] ??
                json['lon'] ??
                json['coordenada_lng'],
          ) ??
          ubicacion?.longitud,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  static _Coordenadas? _parseUbicacion(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Map<String, dynamic>) {
      return _fromPair(
        _toDouble(
          value['latitud'] ?? value['latitude'] ?? value['lat'],
        ),
        _toDouble(
          value['longitud'] ??
              value['longitude'] ??
              value['lng'] ??
              value['lon'],
        ),
      );
    }

    if (value is Iterable) {
      final items = value.toList();
      if (items.length < 2) {
        return null;
      }
      return _fromPair(_toDouble(items[0]), _toDouble(items[1]));
    }

    final text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') {
      return null;
    }

    final parts = text
        .replaceAll(RegExp(r'[\[\]\(\)]'), '')
        .replaceAll(';', ',')
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.length < 2) {
      return null;
    }

    return _fromPair(_toDouble(parts[0]), _toDouble(parts[1]));
  }

  static _Coordenadas? _fromPair(double? latitud, double? longitud) {
    if (latitud == null || longitud == null) {
      return null;
    }
    return _Coordenadas(latitud, longitud);
  }
}

class _Coordenadas {
  const _Coordenadas(this.latitud, this.longitud);

  final double latitud;
  final double longitud;
}
