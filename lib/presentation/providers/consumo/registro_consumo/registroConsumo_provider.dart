import 'package:app_lecturador/presentation/providers/consumo/registro_consumo/registroConsumo_notifier.dart';
import 'package:app_lecturador/presentation/providers/consumo/registro_consumo/registroConsumo_repository.dart';

import 'package:app_lecturador/presentation/providers/consumo/registro_consumo/registroConsumo_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registroConsumoNotifierProvider =
    StateNotifierProvider<RegistroconsumoNotifier, RegistroconsumoState>((ref) {
  final repository = ref.watch(registroconsumosRepositoryProvider);
  return RegistroconsumoNotifier(repository);
});
