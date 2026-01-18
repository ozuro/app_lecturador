import 'package:app_lecturador/domain/entities/conexion_entities.dart';

class ConsumoState {
  final bool isLoading;
  final List<Conexion> data;
  final String? error;
  final String month;

  ConsumoState({
    required this.isLoading,
    required this.data,
    this.error,
    required this.month,
  });

  factory ConsumoState.initial() {
    return ConsumoState(
      isLoading: false,
      data: [],
      error: null,
      month: '2025-01',
    );
  }

  ConsumoState copyWith({
    bool? isLoading,
    List<Conexion>? data,
    String? error,
    String? month,
  }) {
    return ConsumoState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
      month: month ?? this.month,
    );
  }
}
