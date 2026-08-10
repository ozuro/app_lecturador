import 'package:app_lecturador/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF4F8FC), Color(0xFFE8F1F7), Color(0xFFF7FBFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -90,
            left: -40,
            child: _GlowCircle(
              size: 280,
              color: const Color(0xFF8FC8E0).withAlpha(90),
            ),
          ),
          Positioned(
            bottom: -70,
            right: -10,
            child: _GlowCircle(
              size: 240,
              color: const Color(0xFF2F80ED).withAlpha(45),
            ),
          ),
          Positioned(
            top: 150,
            right: 120,
            child: _GlowCircle(
              size: 120,
              color: const Color(0xFFF3D6A4).withAlpha(70),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class LoginBrandPanel extends StatelessWidget {
  const LoginBrandPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F4C81), Color(0xFF0E5A74), Color(0xFF2F80ED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C81).withAlpha(46),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(34),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Plataforma operativa JASS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(28),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Lecturador JASS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            'Gestiona lecturas, seguimiento de consumos y consulta por cliente desde una experiencia mas limpia y confiable.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withAlpha(225),
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 28),
          const _FeatureTile(
            icon: Icons.dashboard_customize_rounded,
            title: 'Dashboard ejecutivo',
            description:
                'Resumen del avance mensual, conexiones y accesos rapidos.',
          ),
          const SizedBox(height: 14),
          const _FeatureTile(
            icon: Icons.history_toggle_off_rounded,
            title: 'Registro con contexto',
            description:
                'Consulta, registra y edita lecturas con mejor jerarquia visual.',
          ),
          const SizedBox(height: 14),
          const _FeatureTile(
            icon: Icons.verified_user_outlined,
            title: 'Acceso seguro',
            description:
                'Ingreso centralizado para operar con tus endpoints de Laravel.',
          ),
        ],
      ),
    );
  }
}

class LoginMobileHeader extends StatelessWidget {
  const LoginMobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF0E5A74),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0E5A74).withAlpha(50),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            Icons.water_drop_rounded,
            color: Colors.white,
            size: 38,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Lecturador JASS',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Accede al panel de lecturas y consumos con una interfaz mas clara.',
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.5,
            color: Color(0xFF526074),
          ),
        ),
      ],
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withAlpha(18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(22),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.authState,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final AuthState authState;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(236),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withAlpha(170)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F4FA),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Acceso interno',
                style: TextStyle(
                  color: Color(0xFF0E5A74),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Iniciar sesion',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 24),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Correo electronico',
                hintText: 'usuario@empresa.com',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) {
                  return 'Ingresa tu correo.';
                }
                if (!email.contains('@')) {
                  return 'Revisa el formato del correo.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => onSubmit(),
              decoration: InputDecoration(
                labelText: 'Contrasena',
                hintText: 'Tu contrasena',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: onTogglePassword,
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if ((value?.trim() ?? '').isEmpty) {
                  return 'Ingresa tu contrasena.';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF6FAFD),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE1EBF3)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: onSubmit,
                child: authState.status == AuthStatus.loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.6,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Entrar al sistema'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
