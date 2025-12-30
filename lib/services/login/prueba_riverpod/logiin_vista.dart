import 'package:app_lecturador/provider/home_riverpod.dart';
import 'package:app_lecturador/services/login/prueba_riverpod/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = AsyncNotifierProvider<LoginNotifier, bool>(() {
  return LoginNotifier();
});

class LoginNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return false; // estado inicial
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await AuthService().login(email, password);
    });
  }
}

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(loginProvider, (previous, next) {
      next.whenOrNull(
        data: (loggedIn) {
          if (loggedIn) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const ConsumosScreen(),
              ),
            );
          }
        },
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.toString())),
          );
        },
      );
    });

    final loginState = ref.watch(loginProvider);

    return Scaffold(
      body: Center(
        child: Padding(
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
              loginState.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        ref.read(loginProvider.notifier).login(
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
