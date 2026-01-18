import 'package:app_lecturador/domain/reporsitories/consumo_repository.dart';
import 'package:app_lecturador/presentation/providers/consumo/consumo_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsumoNotifier extends StateNotifier<ConsumoState> {
  final ConsumosRepository repository;

  ConsumoNotifier(this.repository) : super(ConsumoState.initial());

  Future<void> loadConsumos({
    required String year,
    required String month,
    required String direccionId,
  }) async {
    final formattedMonth = '$year-${month.padLeft(2, '0')}';

    state = state.copyWith(
      isLoading: true,
      error: null,
      month: formattedMonth,
    );

    try {
      final result = await repository.getConexiones(
        month: formattedMonth,
        direccionId: direccionId,
      );

      state = state.copyWith(
        isLoading: false,
        data: result,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
