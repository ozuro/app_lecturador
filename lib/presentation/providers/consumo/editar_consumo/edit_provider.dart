import 'package:app_lecturador/presentation/providers/consumo/editar_consumo/edit_notifier.dart';
import 'package:app_lecturador/presentation/providers/consumo/editar_consumo/edit_repository.dart';
import 'package:app_lecturador/presentation/providers/consumo/editar_consumo/edit_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editConsumoNotifierProvider =
    StateNotifierProvider<EditConsumoNotifier, EditconsumoState>((ref) {
  final repository = ref.watch(editRepositoryProvider);
  return EditConsumoNotifier(repository);
});
