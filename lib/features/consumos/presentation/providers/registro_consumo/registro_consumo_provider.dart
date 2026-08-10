import 'package:app_lecturador/features/consumos/presentation/providers/registro_consumo/registro_consumo_notifier.dart';
import 'package:app_lecturador/features/consumos/presentation/providers/registro_consumo/registro_consumo_repository_provider.dart';

import 'package:app_lecturador/features/consumos/presentation/providers/registro_consumo/registro_consumo_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registroConsumoNotifierProvider =
    StateNotifierProvider<RegistroconsumoNotifier, RegistroconsumoState>((ref) {
  final repository = ref.watch(registroconsumosRepositoryProvider);
  return RegistroconsumoNotifier(repository);
});
