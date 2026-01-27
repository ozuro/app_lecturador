import 'package:app_lecturador/data/data_sources/services/registro_consumo_data_sources.dart';

import 'package:app_lecturador/domain/reporsitories/registro_consumo_repository.dart';

class RegistroConsumoRepositoryImpl implements RegistroConsumoRepository {
  final RegistroConsumoRemoteDataSource remote;

  RegistroConsumoRepositoryImpl(this.remote);

  @override
  Future<void> registroConsumo(int idConexion, String mes, int consumoActual,
      int consumoAnterior, String? foto, bool habilitarLecturaAnterior) async {
    try {
      await remote.registrarConsumo(
          conexionId: idConexion,
          mes: mes,
          consumoActual: consumoActual,
          consumoAnterior: consumoAnterior,
          foto: foto,
          habilitarLecturaAnterior: habilitarLecturaAnterior);
    } catch (e) {
      throw Exception('Error al registrar el consumo: $e');
    }
  }
}
