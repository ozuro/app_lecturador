class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final String? token;
  final Map<String, dynamic>? user;

  AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.token,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? token,
    Map<String, dynamic>? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}
