import 'cliente_entities.dart';
import 'conexion_entities.dart';

class BusquedaClienteEntity {
  final Cliente cliente;
  final List<Conexion> conexiones;

  const BusquedaClienteEntity({
    required this.cliente,
    required this.conexiones,
  });
}
