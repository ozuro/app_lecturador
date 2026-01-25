class ConsumoState {
  final bool isLoading;
  final String? error;

  const ConsumoState({
    this.isLoading = false,
    this.error,
  });

  ConsumoState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return ConsumoState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
