import 'package:app_lecturador/services/login/prueba_riverpod/notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    final success = await AuthService().login(email, password);

    if (success) {
      state = state.copyWith(status: AuthStatus.authenticated);
    } else {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Credenciales incorrectas',
      );
    }
  }

  void logout() {
    state = AuthState.initial();
  }
}
