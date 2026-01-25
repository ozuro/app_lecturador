import 'package:app_lecturador/presentation/providers/consumo/consumo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final consumoNotifierProvider =
    StateNotifierProvider<ConsumoNotifier, ConsumoState>((ref) {
  final repository = ref.watch(consumosRepositoryProvider);
  return ConsumoNotifier(repository);
});
