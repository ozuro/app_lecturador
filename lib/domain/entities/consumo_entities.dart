import 'cliente_entities.dart';
import 'direccion_entites.dart';

class Consumo {
  final int? id;
  final int? conexionId;
  final String? mes;
  final int? consumoAnterior;
  final int? consumoActual;
  final int? consumoTotal;
  final String? fecha;
  final String? estadoConsumo;
  final bool? reciboGenerado;
  final String? fotoUrl;
  final Cliente? cliente;
  final Direccion? direccion;

  Consumo({
    this.id,
    this.conexionId,
    this.mes,
    this.consumoAnterior,
    this.consumoActual,
    this.consumoTotal,
    this.fecha,
    this.estadoConsumo,
    this.reciboGenerado,
    this.fotoUrl,
    this.cliente,
    this.direccion,
  });

  String get estadoLecturaLabel {
    if ((estadoConsumo ?? '').isEmpty) {
      return 'Sin lectura';
    }

    switch (estadoConsumo) {
      case 'con_lectura':
        return 'Lectura registrada';
      default:
        return estadoConsumo!.replaceAll('_', ' ');
    }
  }

  String get estadoReciboLabel {
    return reciboGenerado == true ? 'Recibo emitido' : 'Recibo pendiente';
  }

  factory Consumo.fromJson(Map<String, dynamic> json) {
    return Consumo(
      id: json['id'] as int?,
      conexionId: json['conexion_id'] as int?,
      mes: json['mes']?.toString(),
      consumoAnterior: json['consumo_anterior'] as int?,
      consumoActual: json['consumo_actual'] as int?,
      consumoTotal: json['consumo_total'] as int?,
      fecha: json['fecha']?.toString() ?? json['created_at']?.toString(),
      estadoConsumo: json['estado_consumo']?.toString(),
      reciboGenerado: json['recibo_generado'] as bool?,
      fotoUrl: json['foto_url']?.toString(),
      cliente: json['cliente'] is Map<String, dynamic>
          ? Cliente.fromJson(json['cliente'] as Map<String, dynamic>)
          : null,
      direccion: json['direccion'] is Map<String, dynamic>
          ? Direccion.fromJson(json['direccion'] as Map<String, dynamic>)
          : null,
    );
  }
}
