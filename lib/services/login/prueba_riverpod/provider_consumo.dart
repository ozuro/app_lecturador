import 'package:app_lecturador/services/login/prueba_riverpod/model.dart';
import 'package:app_lecturador/services/login/prueba_riverpod/servicio_consumo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsumosNotifier extends StateNotifier<AsyncValue<List<Conexion>>> {
  ConsumosNotifier() : super(const AsyncValue.loading()) {
    fetchConexiones();
  }

  Future<void> fetchConexiones() async {
    try {
      final data = await ConsumosRemoteDataSource().getConexiones();
      state = AsyncValue.data(data);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final consumosProvider =
    StateNotifierProvider<ConsumosNotifier, AsyncValue<List<Conexion>>>(
  (ref) => ConsumosNotifier(),
);
