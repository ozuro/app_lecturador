import 'package:app_lecturador/domain/entities/conexion_entities.dart';

abstract class ConsumosRepository {
  Future<List<Conexion>> getConexiones({
    required String month,
    required String direccionId,
  });
}
