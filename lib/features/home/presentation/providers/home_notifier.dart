import 'package:app_lecturador/features/home/domain/repositories/reporte_home_repository.dart';
import 'package:app_lecturador/features/home/presentation/providers/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReporteHomeNotifier extends StateNotifier<ReporteHomeState> {
  final ReporteHomeRepository repository;

  ReporteHomeNotifier(this.repository)
      : super(const ReporteHomeState(isLoading: true)) {
    loadReporte();
  }

  Future<void> loadReporte() async {
    try {
      final reporte = await repository.getReporteHome();

      state = state.copyWith(
        isLoading: false,
        cantidadConexiones: reporte.cantidadConexiones,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
