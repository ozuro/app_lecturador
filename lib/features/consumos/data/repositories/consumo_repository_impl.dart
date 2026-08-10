import 'package:app_lecturador/features/consumos/data/datasources/consumo_remote_datasource.dart';
import 'package:app_lecturador/features/consumos/domain/entities/busqueda_cliente.dart';
import 'package:app_lecturador/features/consumos/domain/entities/consumo.dart';
import 'package:app_lecturador/features/consumos/domain/entities/lecturas_resumen.dart';
import 'package:app_lecturador/features/consumos/domain/repositories/consumo_repository.dart';

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
