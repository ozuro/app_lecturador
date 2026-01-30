enum RegistroStatus {
  noRegistrado,
  loading,
  registrado,
  error,
}

class RegistroconsumoState {
  final RegistroStatus status;
  final String? errorMessage;

  const RegistroconsumoState({
    required this.status,
    this.errorMessage,
  });

  factory RegistroconsumoState.initial() {
    return const RegistroconsumoState(
      status: RegistroStatus.noRegistrado,
    );
  }

  RegistroconsumoState copyWith({
    RegistroStatus? status,
    String? errorMessage,
  }) {
    return RegistroconsumoState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
