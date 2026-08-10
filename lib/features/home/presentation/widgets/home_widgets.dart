import 'package:app_lecturador/features/home/presentation/providers/home_tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeSectionIntro extends StatelessWidget {
  const HomeSectionIntro({
    super.key,
    required this.badge,
    required this.title,
    required this.subtitle,
  });

  final String badge;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE9F2FF),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFD4E4FF)),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              color: Color(0xFF0F4C81),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF102A43),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            height: 1.35,
            color: Color(0xFF526074),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF102A43),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            height: 1.35,
            color: Color(0xFF526074),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class HomeTrackingSection extends StatelessWidget {
  const HomeTrackingSection({
    super.key,
    required this.tracking,
    required this.onOpenPendingMonth,
  });

  final AsyncValue<HomeTrackingSummary> tracking;
  final Future<void> Function(String month)? onOpenPendingMonth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            const _SectionTitle(
              title: 'Seguimiento de los ultimos 3 meses',
              subtitle: 'Revision rapida del estado mensual.',
            ),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _SectionTitle(
          title: 'Seguimiento de los ultimos 3 meses',
          subtitle: 'Abre un mes para revisar clientes pendientes.',
        ),
        Text(
          summary.isUpToDate
              ? 'Estas al dia. Todas las lecturas de los tres ultimos meses estan completas.'
              : 'Te falta realizar el registro en $monthsWithPending mes${monthsWithPending == 1 ? '' : 'es'}. Toca una tarjeta para abrir los clientes pendientes.',
          textAlign: TextAlign.center,
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
                  textAlign: TextAlign.center,
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
          alignment: WrapAlignment.center,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                textAlign: TextAlign.center,
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
                textAlign: TextAlign.center,
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
                mainAxisAlignment: MainAxisAlignment.center,
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

class HomeMetricCard extends StatelessWidget {
  const HomeMetricCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.value,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cardChild = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withAlpha(18),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withAlpha(52)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withAlpha(14),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey.shade600,
              fontSize: 12,
              height: 1.25,
            ),
          ),
        ],
      ),
    );

    final decoratedCard = onTap == null
        ? cardChild
        : Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: Ink(child: cardChild),
            ),
          );

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 146, maxWidth: 180),
      child: decoratedCard,
    );
  }
}

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({
    super.key,
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
