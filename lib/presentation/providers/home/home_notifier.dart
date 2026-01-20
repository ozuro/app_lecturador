import 'package:app_lecturador/presentation/providers/home/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lecturador/domain/reporsitories/reporte_home_repository.dart';

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
