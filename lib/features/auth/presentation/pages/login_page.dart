import 'package:app_lecturador/app/app_shell.dart';
import 'package:app_lecturador/features/auth/presentation/providers/auth_providers.dart';
import 'package:app_lecturador/features/auth/presentation/providers/auth_state.dart';
import 'package:app_lecturador/features/auth/presentation/widgets/login_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(AuthState authState) {
    if (authState.status == AuthStatus.loading) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const AppShell(),
          ),
        );
      }

      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Error de autenticacion'),
          ),
        );
      }
    });

    final authState = ref.watch(authProvider);
    final isWide = MediaQuery.of(context).size.width >= 980;

    return Scaffold(
      body: Stack(
        children: [
          const LoginBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isWide ? 32 : 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: isWide
                      ? Row(
                          children: [
                            const Expanded(child: LoginBrandPanel()),
                            const SizedBox(width: 28),
                            SizedBox(
                              width: 430,
                              child: LoginForm(
                                formKey: _formKey,
                                emailController: _emailController,
                                passwordController: _passwordController,
                                obscurePassword: _obscurePassword,
                                authState: authState,
                                onTogglePassword: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                onSubmit: () => _submit(authState),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const LoginMobileHeader(),
                            const SizedBox(height: 24),
                            LoginForm(
                              formKey: _formKey,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              obscurePassword: _obscurePassword,
                              authState: authState,
                              onTogglePassword: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              onSubmit: () => _submit(authState),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
