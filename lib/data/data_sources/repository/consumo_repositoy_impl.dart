import 'package:app_lecturador/data/data_sources/services/consumo_remote_data_sources.dart';
import 'package:app_lecturador/domain/entities/conexion_entities.dart';
import 'package:app_lecturador/domain/reporsitories/consumo_repository.dart';

class ConsumosRepositoryImpl implements ConsumosRepository {
  final ConsumosRemoteDataSource remote;

  ConsumosRepositoryImpl(this.remote);

  @override
  Future<List<Conexion>> getConexiones({
    required String month,
    required String direccionId,
  }) {
    return remote.getConexiones(
      month: month,
      direccionId: direccionId,
    );
  }
}
