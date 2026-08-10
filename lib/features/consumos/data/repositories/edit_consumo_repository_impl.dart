import 'package:app_lecturador/features/consumos/data/datasources/edit_consumo_remote_datasource.dart';
import 'package:app_lecturador/features/consumos/domain/repositories/edit_consumo_repository.dart';

class EditConsumoImpl implements EditConsumoRepository {
  final EditConsumoRemoteDataSource remote;

  EditConsumoImpl(this.remote);

  @override
  Future<void> editConsumo(
      int? idConsumo,
      int idConexion,
      String mes,
      int consumoActual,
      int consumoAnterior,
      String? foto,
      bool habilitarLecturaAnterior) async {
    if (idConsumo == null) {
      throw Exception('idConsumo es requerido para editar');
    }
    await remote.editConsumo(
      idConsumo: idConsumo,
      conexionId: idConexion,
      mes: mes,
      consumoActual: consumoActual,
      consumoAnterior: consumoAnterior,
      foto: foto,
      habilitarLecturaAnterior: habilitarLecturaAnterior,
    );
  }
}
