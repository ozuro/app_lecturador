import 'package:app_lecturador/data/data_sources/services/edit_consumo_data_sources.dart';
import 'package:app_lecturador/domain/reporsitories/edit_consumo_repository.dart';

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
    try {
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
          habilitarLecturaAnterior: habilitarLecturaAnterior);
    } catch (e) {
      throw Exception('Error al actualizar el consumo: $e');
    }
  }
}
