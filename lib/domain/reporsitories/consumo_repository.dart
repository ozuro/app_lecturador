import 'package:app_lecturador/domain/entities/busqueda_cliente_entity.dart';
import 'package:app_lecturador/domain/entities/consumo_entities.dart';
import 'package:app_lecturador/domain/entities/lecturas_resumen_entity.dart';

abstract class ConsumosRepository {
  Future<LecturasResumenEntity> getConexiones({
    required String month,
    String? direccionId,
  });

  Future<BusquedaClienteEntity> buscarPorDni(String dni);

  Future<List<Consumo>> getLecturasPorConexion(int conexionId);
}
