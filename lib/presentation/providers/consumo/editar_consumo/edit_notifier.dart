import 'package:app_lecturador/domain/reporsitories/edit_consumo_repository.dart';
import 'package:app_lecturador/domain/reporsitories/registro_consumo_repository.dart';
import 'package:app_lecturador/presentation/providers/consumo/editar_consumo/edit_state.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditConsumoNotifier extends StateNotifier<EditconsumoState> {
  final EditConsumoRepository repository;

  EditConsumoNotifier(this.repository) : super(EditconsumoState.initial());

  Future<void> editConsumo(
    int? idConsumo,
    int idConexion,
    String mes,
    int consumoActual,
    int consumoAnterior,
    String? foto,
    bool habilitarLecturaAnterior,
  ) async {
    state = state.copyWith(status: EditStatus.loading);

    try {
      await repository.editConsumo(idConsumo, idConexion, mes, consumoActual,
          consumoAnterior, foto, habilitarLecturaAnterior);
      state = state.copyWith(status: EditStatus.actualizado);
    } catch (e) {
      state = state.copyWith(
        status: EditStatus.error,
        errorMessage: e.toString(),
      );
      print('Error al registrar el consumo: $e');
    }
  }

  void logout() {
    state = EditconsumoState.initial();
  }
}
