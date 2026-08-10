import 'package:app_lecturador/features/consumos/presentation/providers/consumo_providers.dart';
import 'package:app_lecturador/features/home/presentation/providers/home_provider.dart';
import 'package:app_lecturador/features/home/presentation/providers/home_tracking_provider.dart';
import 'package:app_lecturador/features/home/presentation/widgets/home_widgets.dart';
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
    String? firstPendingMonth;
    if (trackingData != null) {
      for (final month in trackingData.months) {
        if (month.pendingCount > 0) {
          firstPendingMonth = month.monthKey;
          break;
        }
      }
    }
    final theme = Theme.of(context);

    return Container(
      color: const Color(0xFFF4F8FB),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const HomeSectionIntro(
                    badge: 'Resumen',
                    title: 'Vista principal',
                    subtitle:
                        'Todo el estado del sistema en una vista mas limpia.',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      HomeMetricCard(
                        title: 'Conexiones',
                        subtitle: 'API principal',
                        icon: Icons.people_alt_rounded,
                        accentColor: const Color(0xFF0F4C81),
                        value: reporteHome.isLoading
                            ? '...'
                            : reporteHome.cantidadConexiones.toString(),
                        onTap: onOpenConsumos,
                      ),
                      HomeMetricCard(
                        title: 'Registradas',
                        subtitle: 'Mes actual',
                        icon: Icons.edit_note_rounded,
                        accentColor: const Color(0xFF1F9D68),
                        value: consumoState.lecturasRegistradas.toString(),
                        onTap: onOpenConsumos,
                      ),
                      HomeMetricCard(
                        title: 'Faltantes',
                        subtitle: 'Mes actual',
                        icon: Icons.pending_actions_rounded,
                        accentColor: const Color(0xFFC44536),
                        value: consumoState.lecturasFaltantes.toString(),
                        onTap: onOpenPendingConsumos == null
                            ? null
                            : () {
                                onOpenPendingConsumos!(consumoState.month);
                              },
                      ),
                      HomeMetricCard(
                        title: '3 meses',
                        subtitle: trackingData == null
                            ? 'Cargando'
                            : trackingData.isUpToDate
                                ? 'Sin pendientes'
                                : 'Con faltantes',
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
                        onTap: firstPendingMonth == null
                            ? onOpenConsumos
                            : () {
                                onOpenPendingConsumos?.call(firstPendingMonth!);
                              },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  HomeTrackingSection(
                    tracking: tracking,
                    onOpenPendingMonth: onOpenPendingConsumos,
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    children: [
                      const HomeActionCard(
                        title: 'Como usarlo',
                        description:
                            'Si un mes aparece con faltantes, entra desde esa tarjeta y el sistema te llevara a la lista de clientes pendientes.',
                        icon: Icons.timeline_rounded,
                        accentColor: Color(0xFF0E5A74),
                      ),
                      const HomeActionCard(
                        title: 'Busqueda por cliente',
                        description:
                            'Usa el modulo de busqueda para revisar conexiones e historial por DNI sin recorrer toda la lista.',
                        icon: Icons.manage_search_rounded,
                        accentColor: Color(0xFFE67E22),
                      ),
                      HomeActionCard(
                        title: hasError
                            ? 'Atencion requerida'
                            : 'Estado del sistema',
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
            ),
          ),
        ],
      ),
    );
  }
}
