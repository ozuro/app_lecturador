import 'package:app_lecturador/domain/reporsitories/registro_consumo_repository.dart';

import 'package:app_lecturador/presentation/providers/registro_consumo/registroConsumo_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistroconsumoNotifier extends StateNotifier<RegistroconsumoState> {
  final RegistroConsumoRepository repository;

  RegistroconsumoNotifier(this.repository)
      : super(RegistroconsumoState.initial());

  Future<void> registroConsumo(
    int idConexion,
    String mes,
    int consumoActual,
    int consumoAnterior,
    String? foto,
    bool habilitarLecturaAnterior,
  ) async {
    state = state.copyWith(status: RegistroStatus.loading);

    try {
      await repository.registroConsumo(idConexion, mes, consumoActual,
          consumoAnterior, foto, habilitarLecturaAnterior);
      state = state.copyWith(status: RegistroStatus.registrado);
    } catch (e) {
      state = state.copyWith(
        status: RegistroStatus.error,
        errorMessage: e.toString(),
      );
      print('Error al registrar el consumo: $e');
    }
  }

  void logout() {
    state = RegistroconsumoState.initial();
  }
}
