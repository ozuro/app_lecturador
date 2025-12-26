import 'package:app_lecturador/auth/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  Future<void> checkIfLoggedIn() async {
    // TODO: Implement your login check logic
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

final authInitProvider = FutureProvider<void>((ref) async {
  await ref.read(authProvider.notifier).checkIfLoggedIn();
});
