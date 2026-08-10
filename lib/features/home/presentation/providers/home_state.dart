class ReporteHomeState {
  final bool isLoading;
  final int cantidadConexiones;
  final String? error;

  const ReporteHomeState({
    this.isLoading = false,
    this.cantidadConexiones = 0,
    this.error,
  });

  ReporteHomeState copyWith({
    bool? isLoading,
    int? cantidadConexiones,
    String? error,
  }) {
    return ReporteHomeState(
      isLoading: isLoading ?? this.isLoading,
      cantidadConexiones: cantidadConexiones ?? this.cantidadConexiones,
      error: error,
    );
  }
}
