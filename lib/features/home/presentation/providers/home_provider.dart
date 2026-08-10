import 'package:app_lecturador/features/home/presentation/providers/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_notifier.dart';

import 'home_repository.dart';

final reporteHomeProvider =
    StateNotifierProvider<ReporteHomeNotifier, ReporteHomeState>((ref) {
  final repository = ref.watch(reporteHomeRepositoryProvider);
  return ReporteHomeNotifier(repository);
});
