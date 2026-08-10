import 'package:app_lecturador/features/consumos/presentation/providers/consumo_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'consumo_notifier.dart';
import 'consumo_state.dart';

final consumoNotifierProvider =
    StateNotifierProvider<ConsumoNotifier, ConsumoState>((ref) {
  final repository = ref.watch(consumosRepositoryProvider);
  return ConsumoNotifier(repository);
});

// para buscador
final consumoSearchProvider = StateProvider<String>((ref) => '');
final consumoOnlyPendingProvider = StateProvider<bool>((ref) => false);
