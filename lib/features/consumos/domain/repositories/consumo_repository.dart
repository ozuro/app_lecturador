import 'package:app_lecturador/features/consumos/domain/entities/busqueda_cliente.dart';
import 'package:app_lecturador/features/consumos/domain/entities/consumo.dart';
import 'package:app_lecturador/features/consumos/domain/entities/lecturas_resumen.dart';

abstract class ConsumosRepository {
  Future<LecturasResumenEntity> getConexiones({
    required String month,
    String? direccionId,
  });

  Future<BusquedaClienteEntity> buscarPorDni(String dni);

  Future<List<Consumo>> getLecturasPorConexion(int conexionId);
}
