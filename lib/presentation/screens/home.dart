import 'package:app_lecturador/presentation/providers/consumo/consumo_provider.dart';
import 'package:app_lecturador/presentation/providers/home/home_provider.dart';
import 'package:app_lecturador/presentation/providers/home/home_tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
    this.onOpenConsumos,
    this.onOpenPendingConsumos,
  });

  final VoidCallback? onOpenConsumos;
  final Future<void> Function(String month)? onOpenPendingConsumos;

  static const String title = 'Sistema JASS Capachica';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reporteHome = ref.watch(reporteHomeProvider);
    final consumoState = ref.watch(consumoNotifierProvider);
    final tracking = ref.watch(homeTrackingProvider);
    final hasError = reporteHome.error != null;
    final trackingData = tracking.valueOrNull;
    final theme = Theme.of(context);

    return Container(
      color: const Color(0xFFF4F8FB),
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0F4C81),
                  Color(0xFF0E5A74),
                  Color(0xFF2F80ED),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F4C81).withAlpha(44),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(34),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Seguimiento',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _HeroStatusPill(
                      icon: trackingData?.isUpToDate == true
                          ? Icons.verified_rounded
                          : Icons.pending_actions_rounded,
                      label: trackingData == null
                          ? 'Cargando'
                          : trackingData.isUpToDate
                              ? 'Estas al dia'
                              : '${trackingData.totalPending} pendientes',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Panel de control de lecturas',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  trackingData == null
                      ? 'Revisando los ultimos tres meses.'
                      : trackingData.isUpToDate
                          ? 'No hay lecturas pendientes en los ultimos tres meses.'
                          : 'Hay meses con faltantes. Entra para regularizar los registros pendientes.',
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.4,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _HeroMiniStat(
                      label: 'Conexiones',
                      value: reporteHome.isLoading
                          ? '...'
                          : reporteHome.cantidadConexiones.toString(),
                    ),
                    _HeroMiniStat(
                      label: 'Mes actual',
                      value: '${consumoState.lecturasFaltantes} faltan',
                    ),
                    _HeroMiniStat(
                      label: '3 meses',
                      value: trackingData == null
                          ? '...'
                          : trackingData.isUpToDate
                              ? 'OK'
                              : '${trackingData.totalPending} pendientes',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: onOpenConsumos,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0F4C81),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.receipt_long_rounded, size: 18),
                      label: const Text('Ir a consumos'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        ref.read(reporteHomeProvider.notifier).loadReporte();
                        ref.invalidate(homeTrackingProvider);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Actualizar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _MetricCard(
                title: 'Conexiones activas',
                subtitle: 'Total consultado desde la API principal',
                icon: Icons.people_alt_rounded,
                accentColor: const Color(0xFF0F4C81),
                value: reporteHome.isLoading
                    ? '...'
                    : reporteHome.cantidadConexiones.toString(),
              ),
              _MetricCard(
                title: 'Mes actual registradas',
                subtitle: 'Avance confirmado del periodo abierto',
                icon: Icons.edit_note_rounded,
                accentColor: const Color(0xFF1F9D68),
                value: consumoState.lecturasRegistradas.toString(),
              ),
              _MetricCard(
                title: 'Mes actual faltantes',
                subtitle: 'Lecturas pendientes del mes cargado',
                icon: Icons.pending_actions_rounded,
                accentColor: const Color(0xFFC44536),
                value: consumoState.lecturasFaltantes.toString(),
              ),
              _MetricCard(
                title: 'Revision 3 meses',
                subtitle: trackingData == null
                    ? 'Cargando estado de seguimiento'
                    : trackingData.isUpToDate
                        ? 'Sin pendientes acumulados'
                        : 'Requiere regularizar registros',
                icon: trackingData?.isUpToDate == true
                    ? Icons.verified_outlined
                    : Icons.rule_folder_outlined,
                accentColor: trackingData?.isUpToDate == true
                    ? const Color(0xFF1F9D68)
                    : const Color(0xFFE67E22),
                value: trackingData == null
                    ? '...'
                    : trackingData.isUpToDate
                        ? 'OK'
                        : trackingData.totalPending.toString(),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _TrackingSection(
            tracking: tracking,
            onOpenPendingMonth: onOpenPendingConsumos,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              const _ActionCard(
                title: 'Como usarlo',
                description:
                    'Si un mes aparece con faltantes, entra desde esa tarjeta y el sistema te llevara a la lista de clientes pendientes.',
                icon: Icons.timeline_rounded,
                accentColor: Color(0xFF0E5A74),
              ),
              const _ActionCard(
                title: 'Busqueda por cliente',
                description:
                    'Usa el modulo de busqueda para revisar conexiones e historial por DNI sin recorrer toda la lista.',
                icon: Icons.manage_search_rounded,
                accentColor: Color(0xFFE67E22),
              ),
              _ActionCard(
                title: hasError ? 'Atencion requerida' : 'Estado del sistema',
                description: hasError
                    ? 'Se detecto un problema en la carga del dashboard. Revisa token o respuesta del endpoint.'
                    : 'La vista principal ya esta orientada a seguimiento mensual y derivacion directa a pendientes.',
                icon: hasError
                    ? Icons.warning_amber_rounded
                    : Icons.verified_outlined,
                accentColor: hasError
                    ? const Color(0xFFC44536)
                    : const Color(0xFF1F9D68),
              ),
            ],
          ),
          if (hasError) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4F2),
                borderRadius: BorderRadius.circular(22),
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
                        height: 1.45,
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

class _TrackingSection extends StatelessWidget {
  const _TrackingSection({
    required this.tracking,
    required this.onOpenPendingMonth,
  });

  final AsyncValue<HomeTrackingSummary> tracking;
  final Future<void> Function(String month)? onOpenPendingMonth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE3EBF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: tracking.when(
        data: (data) => _TrackingContent(
          summary: data,
          onOpenPendingMonth: onOpenPendingMonth,
        ),
        error: (error, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seguimiento de los ultimos 3 meses',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              error.toString(),
              style: const TextStyle(
                color: Color(0xFFC44536),
                height: 1.45,
              ),
            ),
          ],
        ),
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 36),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _TrackingContent extends StatelessWidget {
  const _TrackingContent({
    required this.summary,
    required this.onOpenPendingMonth,
  });

  final HomeTrackingSummary summary;
  final Future<void> Function(String month)? onOpenPendingMonth;

  @override
  Widget build(BuildContext context) {
    final monthsWithPending =
        summary.months.where((month) => month.pendingCount > 0).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seguimiento de los ultimos 3 meses',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          summary.isUpToDate
              ? 'Estas al dia. Todas las lecturas de los tres ultimos meses estan completas.'
              : 'Te falta realizar el registro en $monthsWithPending mes${monthsWithPending == 1 ? '' : 'es'}. Toca una tarjeta para abrir los clientes pendientes.',
          style: const TextStyle(
            color: Color(0xFF526074),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: summary.isUpToDate
                ? const Color(0xFFE9F8EF)
                : const Color(0xFFFFF4E8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: summary.isUpToDate
                  ? const Color(0xFFBFE3CD)
                  : const Color(0xFFF4D3A6),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                summary.isUpToDate
                    ? Icons.verified_rounded
                    : Icons.assignment_late_rounded,
                color: summary.isUpToDate
                    ? const Color(0xFF1F9D68)
                    : const Color(0xFFE67E22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  summary.isUpToDate
                      ? 'Estas al dia'
                      : 'Hay ${summary.totalPending} lecturas por regularizar entre los tres meses revisados.',
                  style: TextStyle(
                    color: summary.isUpToDate
                        ? const Color(0xFF1F6E4C)
                        : const Color(0xFF9A5A07),
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: summary.months
              .map(
                (month) => _MonthTrackingCard(
                  month: month,
                  onTap: month.pendingCount > 0 && onOpenPendingMonth != null
                      ? () => onOpenPendingMonth!(month.monthKey)
                      : null,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _MonthTrackingCard extends StatelessWidget {
  const _MonthTrackingCard({
    required this.month,
    this.onTap,
  });

  final MonthTrackingStatus month;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasPending = month.pendingCount > 0;
    final borderColor =
        hasPending ? const Color(0xFFF4D3A6) : const Color(0xFFCDE7D7);
    final backgroundColor =
        hasPending ? const Color(0xFFFFFBF5) : const Color(0xFFF7FCF8);
    final accentColor =
        hasPending ? const Color(0xFFE67E22) : const Color(0xFF1F9D68);

    return SizedBox(
      width: 320,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withAlpha(22),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      month.monthLabel,
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${month.totalCount} conexiones',
                    style: const TextStyle(
                      color: Color(0xFF6B7A90),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                hasPending ? 'Te falta realizar el registro' : 'Estas al dia',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                hasPending
                    ? '${month.pendingCount} cliente${month.pendingCount == 1 ? '' : 's'} pendientes en este mes.'
                    : 'No hay clientes con lectura pendiente en este periodo.',
                style: const TextStyle(
                  color: Color(0xFF526074),
                  height: 1.45,
                ),
              ),
              if (hasPending) ...[
                const SizedBox(height: 12),
                ...month.pendingConnections.take(3).map(
                      (conexion) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Icon(
                                Icons.radio_button_checked_rounded,
                                size: 10,
                                color: Color(0xFFE67E22),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${conexion.cliente.nombreCompleto} - ${conexion.direccion.descripcionCorta}',
                                style: const TextStyle(
                                  color: Color(0xFF243447),
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    hasPending ? 'Ver clientes pendientes' : 'Periodo completo',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    hasPending
                        ? Icons.arrow_forward_rounded
                        : Icons.check_circle_rounded,
                    color: accentColor,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroStatusPill extends StatelessWidget {
  const _HeroStatusPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMiniStat extends StatelessWidget {
  const _HeroMiniStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
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
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0xFFE3EBF3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: accentColor.withAlpha(28),
              child: Icon(icon, color: accentColor),
            ),
            const SizedBox(height: 18),
            Text(
              value,
              style: const TextStyle(
                fontSize: 30,
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

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 420),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE3EBF3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: accentColor.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: accentColor),
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
