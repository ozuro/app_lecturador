class ConsumoItem {
  final int conexionId;
  final String codigoConexion;
  final String cliente;
  final String direccion;
  final String mes;
  final int consumoAnterior;
  final int consumoActual;
  final String estadoConsumo;
  final bool registrado;

  ConsumoItem({
    required this.conexionId,
    required this.codigoConexion,
    required this.cliente,
    required this.direccion,
    required this.mes,
    required this.consumoAnterior,
    required this.consumoActual,
    required this.estadoConsumo,
    required this.registrado,
  });
}
