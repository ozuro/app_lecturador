import 'package:app_lecturador/data/data_sources/services/consumo_remote_data_sources.dart';
import 'package:app_lecturador/domain/entities/busqueda_cliente_entity.dart';
import 'package:app_lecturador/domain/entities/consumo_entities.dart';
import 'package:app_lecturador/domain/entities/lecturas_resumen_entity.dart';
import 'package:app_lecturador/domain/reporsitories/consumo_repository.dart';

class ConsumosRepositoryImpl implements ConsumosRepository {
  final ConsumosRemoteDataSource remote;

  ConsumosRepositoryImpl(this.remote);

  @override
  Future<LecturasResumenEntity> getConexiones({
    required String month,
    String? direccionId,
  }) {
    return remote.getConexiones(
      month: month,
      direccionId: direccionId,
    );
  }

  @override
  Future<BusquedaClienteEntity> buscarPorDni(String dni) {
    return remote.buscarPorDni(dni);
  }

  @override
  Future<List<Consumo>> getLecturasPorConexion(int conexionId) {
    return remote.getLecturasPorConexion(conexionId);
  }
}
