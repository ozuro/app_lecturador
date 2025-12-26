import 'package:app_lecturador/models/conexiones.dart';

List<ConsumoItem> mapConsumosFromApi(List conexiones) {
  final List<ConsumoItem> lista = [];

  for (final conexion in conexiones) {
    final cliente =
        '${conexion['cliente']['nombres']} ${conexion['cliente']['apellidos']}';
    final direccion = conexion['direccion']['nombre'];

    final consumos = conexion['consumos'] as List;

    // Si NO tiene consumo, igual lo mostramos como pendiente
    if (consumos.isEmpty) {
      lista.add(
        ConsumoItem(
          conexionId: conexion['id'],
          codigoConexion: conexion['codigo'],
          cliente: cliente,
          direccion: direccion,
          mes: '',
          consumoAnterior: 0,
          consumoActual: 0,
          estadoConsumo: 'pendiente',
          registrado: false,
        ),
      );
    } else {
      final c = consumos.first;

      lista.add(
        ConsumoItem(
          conexionId: conexion['id'],
          codigoConexion: conexion['codigo'],
          cliente: cliente,
          direccion: direccion,
          mes: c['mes'],
          consumoAnterior: c['consumo_anterior'],
          consumoActual: c['consumo_actual'],
          estadoConsumo: c['estado_consumo'],
          registrado: true,
        ),
      );
    }
  }

  return lista;
}
