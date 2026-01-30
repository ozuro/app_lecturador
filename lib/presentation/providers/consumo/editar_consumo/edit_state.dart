enum EditStatus {
  noActualizado,
  loading,
  actualizado,
  error,
}

class EditconsumoState {
  final EditStatus status;
  final String? errorMessage;

  const EditconsumoState({
    required this.status,
    this.errorMessage,
  });

  factory EditconsumoState.initial() {
    return const EditconsumoState(
      status: EditStatus.noActualizado,
    );
  }

  EditconsumoState copyWith({
    EditStatus? status,
    String? errorMessage,
  }) {
    return EditconsumoState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
