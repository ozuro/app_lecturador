import 'cliente.dart';
import 'conexion.dart';

class BusquedaClienteEntity {
  final Cliente cliente;
  final List<Conexion> conexiones;

  const BusquedaClienteEntity({
    required this.cliente,
    required this.conexiones,
  });
}
