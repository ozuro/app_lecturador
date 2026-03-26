import 'package:app_lecturador/presentation/providers/home/home_provider.dart';
import 'package:app_lecturador/presentation/providers/consumo/consumo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
    this.onOpenConsumos,
  });

  final VoidCallback? onOpenConsumos;

  static const String title = 'Sistema Jass Capachica';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reporteHome = ref.watch(reporteHomeProvider);
    final consumoState = ref.watch(consumoNotifierProvider);
    final hasError = reporteHome.error != null;
    final theme = Theme.of(context);

    return Container(
      color: const Color(0xFFF4F7FB),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                colors: [Color(0xFF0F4C81), Color(0xFF2F80ED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withAlpha(46),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Wrap(
              spacing: 24,
              runSpacing: 20,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(38),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Panel principal',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Visualiza lecturas y conexiones con una experiencia más clara y profesional.',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Este dashboard resume el estado actual de tu operación y te permite entrar rápido al módulo de consumos.',
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          FilledButton.icon(
                            onPressed: onOpenConsumos,
                            icon: const Icon(Icons.receipt_long_rounded),
                            label: const Text('Ir a consumos'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () =>
                                ref.read(reporteHomeProvider.notifier).loadReporte(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white38),
                            ),
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Actualizar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _DashboardHighlight(
                  isLoading: reporteHome.isLoading,
                  value: reporteHome.cantidadConexiones.toString(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _MetricCard(
                title: 'Conexiones activas',
                subtitle: 'Total general desde Laravel',
                icon: Icons.people_alt_rounded,
                accentColor: const Color(0xFF0F4C81),
                value: reporteHome.isLoading
                    ? '...'
                    : reporteHome.cantidadConexiones.toString(),
              ),
              _MetricCard(
                title: 'Consumos registrados',
                subtitle: 'Lecturas registradas del mes',
                icon: Icons.edit_note_rounded,
                accentColor: const Color(0xFF1F9D68),
                value: consumoState.lecturasRegistradas.toString(),
              ),
              _MetricCard(
                title: 'Lecturas faltantes',
                subtitle: 'Pendientes para el periodo',
                icon: Icons.pending_actions_rounded,
                accentColor: const Color(0xFFC44536),
                value: consumoState.lecturasFaltantes.toString(),
              ),
              _MetricCard(
                title: 'Conexiones evaluadas',
                subtitle: 'Total listado en consumos',
                icon: Icons.fact_check_outlined,
                accentColor: const Color(0xFF2F80ED),
                value: consumoState.totalConexiones.toString(),
              ),
              const _MetricCard(
                title: 'Búsqueda por DNI',
                subtitle: 'Acceso a conexiones e historial',
                icon: Icons.search_rounded,
                accentColor: Color(0xFFE67E22),
                value: 'Disponible',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              const _InsightCard(
                title: 'Arquitectura mejorada',
                description:
                    'La navegación principal ahora está separada del contenido. Eso hace más fácil mantener la app y agregar nuevas vistas sin mezclar lógica de UI.',
                icon: Icons.account_tree_outlined,
              ),
              _InsightCard(
                title: 'Uso recomendado',
                description: hasError
                    ? 'Revisa el token o la respuesta del endpoint del home. El panel ya refleja ese problema.'
                    : 'Usa el dashboard como resumen y entra a consumos para registrar, buscar y editar lecturas.',
                icon: Icons.lightbulb_outline_rounded,
              ),
            ],
          ),
          if (hasError) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4F2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF2C1BA)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFC44536),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      reporteHome.error!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF7A271A),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DashboardHighlight extends StatelessWidget {
  const _DashboardHighlight({
    required this.isLoading,
    required this.value,
  });

  final bool isLoading;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(28),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.stacked_bar_chart_rounded,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(height: 22),
          const Text(
            'Total actual',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          if (isLoading)
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.8,
                color: Colors.white,
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 44,
                fontWeight: FontWeight.w800,
              ),
            ),
          const SizedBox(height: 8),
          const Text(
            'Conexiones registradas como activas.',
            style: TextStyle(
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.value,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 240, maxWidth: 320),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: accentColor.withAlpha(30),
              child: Icon(icon, color: accentColor),
            ),
            const SizedBox(height: 18),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.blueGrey.shade600,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 520),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE5ECF4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFEAF2FF),
              child: Icon(icon, color: const Color(0xFF0F4C81)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
