import 'package:app_lecturador/features/consumos/data/datasources/registro_consumo_remote_datasource.dart';

import 'package:app_lecturador/features/consumos/domain/repositories/registro_consumo_repository.dart';

class RegistroConsumoRepositoryImpl implements RegistroConsumoRepository {
  final RegistroConsumoRemoteDataSource remote;

  RegistroConsumoRepositoryImpl(this.remote);

  @override
  Future<void> registroConsumo(int idConexion, String mes, int consumoActual,
      int consumoAnterior, String? foto, bool habilitarLecturaAnterior) async {
    await remote.registrarConsumo(
      conexionId: idConexion,
      mes: mes,
      consumoActual: consumoActual,
      consumoAnterior: consumoAnterior,
      foto: foto,
      habilitarLecturaAnterior: habilitarLecturaAnterior,
    );
  }
}
