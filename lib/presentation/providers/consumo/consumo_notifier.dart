import 'package:app_lecturador/domain/reporsitories/consumo_repository.dart';
import 'package:app_lecturador/presentation/providers/consumo/consumo_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsumoNotifier extends StateNotifier<ConsumoState> {
  final ConsumosRepository repository;

  ConsumoNotifier(this.repository) : super(ConsumoState.initial());

  Future<void> loadConsumos({
    required String year,
    required String month,
    String? direccionId,
  }) async {
    final formattedMonth = '$year-${month.padLeft(2, '0')}';

    state = state.copyWith(
      isLoading: true,
      error: null,
      month: formattedMonth,
      direccionId: direccionId,
    );

    try {
      final result = await repository.getConexiones(
        month: formattedMonth,
        direccionId: direccionId,
      );

      state = state.copyWith(
        isLoading: false,
        data: result.conexiones,
        direcciones: result.direcciones,
        totalConexiones: result.total,
        lecturasRegistradas: result.conLectura,
        lecturasFaltantes: result.sinLectura,
        month: result.month.isNotEmpty ? result.month : formattedMonth,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> buscarPorDni(String dni) async {
    state = state.copyWith(
      isSearching: true,
      clearSearchError: true,
      clearSearchResult: true,
    );

    try {
      final result = await repository.buscarPorDni(dni);
      state = state.copyWith(
        isSearching: false,
        searchResult: result,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        searchError: e.toString(),
      );
    }
  }

  void clearSearch() {
    state = state.copyWith(
      clearSearchError: true,
      clearSearchResult: true,
      isSearching: false,
    );
  }
}
