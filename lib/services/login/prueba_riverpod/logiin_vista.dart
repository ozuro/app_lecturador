import 'package:app_lecturador/provider/home_riverpod.dart';
import 'package:app_lecturador/services/login/prueba_riverpod/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, bool>((ref) {
  return LoginNotifier();
});

class LoginNotifier extends StateNotifier<bool> {
  LoginNotifier() : super(false);

  Future<void> login(String email, String password) async {
    final success = await AuthService().login(email, password);
    state = success;
  }
}

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(loginProvider);

    return Scaffold(
      body: Center(
        child: loggedIn
            ? const ConsumosScreen()
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        await ref.read(loginProvider.notifier).login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
