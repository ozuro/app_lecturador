import 'package:app_lecturador/services/login/prueba_riverpod/model.dart';
import 'package:app_lecturador/services/login/prueba_riverpod/servicio_consumo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsumosNotifier extends StateNotifier<AsyncValue<List<Consumo>>> {
  ConsumosNotifier() : super(const AsyncValue.loading()) {
    fetchConsumos();
  }

  Future<void> fetchConsumos() async {
    try {
      final data = await ConsumosRemoteDataSource().getConsumos();
      state = AsyncValue.data(data);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final consumosProvider =
    StateNotifierProvider<ConsumosNotifier, AsyncValue<List<Consumo>>>(
  (ref) => ConsumosNotifier(),
);
