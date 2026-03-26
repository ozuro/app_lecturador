import 'package:app_lecturador/domain/entities/conexion_entities.dart';
import 'package:app_lecturador/presentation/providers/consumo/consumo_provider.dart';
import 'package:app_lecturador/presentation/providers/consumo/consumo_state.dart';
import 'package:app_lecturador/presentation/screens/consumos/editar_consumo.dart';
import 'package:app_lecturador/presentation/screens/consumos/registro_consumo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsumosPage extends ConsumerWidget {
  const ConsumosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consumos')),
      body: const ConsumosView(),
    );
  }
}

class ConsumosView extends ConsumerStatefulWidget {
  const ConsumosView({super.key});

  @override
  ConsumerState<ConsumosView> createState() => _ConsumosViewState();
}

class _ConsumosViewState extends ConsumerState<ConsumosView> {
  Future<void> _reloadCurrentMonth() async {
    final state = ref.read(consumoNotifierProvider);
    final parts = state.month.split('-');
    await ref.read(consumoNotifierProvider.notifier).loadConsumos(
          year: parts.first,
          month: parts.last,
          direccionId: state.direccionId,
        );
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final state = ref.read(consumoNotifierProvider);
      if (state.data.isEmpty && !state.isLoading) {
        _reloadCurrentMonth();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(consumoNotifierProvider);
    final search = ref.watch(consumoSearchProvider).toLowerCase();
    final filteredData = state.data.where((conexion) {
      final cliente = conexion.cliente.nombreCompleto.toLowerCase();
      final direccion = conexion.direccion.nombre.toLowerCase();
      return cliente.contains(search) || direccion.contains(search);
    }).toList();

    return Container(
      color: const Color(0xFFF4F7FB),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF2FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: Color(0xFF0F4C81),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Control de lecturas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Consulta el periodo, filtra por direccion y revisa el avance de lecturas.',
                            style: TextStyle(height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _MonthSelector(
                  selectedMonth: state.month,
                  onChanged: (year, month) {
                    ref.read(consumoNotifierProvider.notifier).loadConsumos(
                          year: year,
                          month: month,
                          direccionId: state.direccionId,
                        );
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  value: state.direccionId,
                  decoration: const InputDecoration(
                    hintText: 'Seleccione una direccion',
                    prefixIcon: Icon(Icons.location_city_outlined),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Todas las direcciones'),
                    ),
                    ...state.direcciones.map(
                      (direccion) => DropdownMenuItem<String?>(
                        value: direccion.id?.toString(),
                        child: Text(direccion.descripcionCorta),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    final parts = state.month.split('-');
                    ref.read(consumoNotifierProvider.notifier).loadConsumos(
                          year: parts.first,
                          month: parts.last,
                          direccionId: value,
                        );
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar cliente o direccion',
                    prefixIcon: const Icon(Icons.search),
                    fillColor: const Color(0xFFF7FAFD),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(consumoSearchProvider.notifier).state = value;
                  },
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _StatusChip(
                      icon: Icons.calendar_today_rounded,
                      label: 'Periodo ${state.month}',
                    ),
                    _StatusChip(
                      icon: Icons.list_alt_rounded,
                      label: '${filteredData.length} visibles',
                    ),
                    _StatusChip(
                      icon: state.error == null
                          ? Icons.cloud_done_rounded
                          : Icons.warning_amber_rounded,
                      label: state.error == null
                          ? 'API conectada'
                          : 'Revisar conexion',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _CompactSummaryCard(
                color: const Color(0xFFE8F7EF),
                accentColor: const Color(0xFF1F9D68),
                title: 'Registradas',
                value: state.lecturasRegistradas.toString(),
              ),
              _CompactSummaryCard(
                color: const Color(0xFFFFECE9),
                accentColor: const Color(0xFFC44536),
                title: 'Faltantes',
                value: state.lecturasFaltantes.toString(),
              ),
              _CompactSummaryCard(
                color: const Color(0xFFEAF2FF),
                accentColor: const Color(0xFF2F80ED),
                title: 'Conexiones',
                value: state.totalConexiones.toString(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.62,
            child: _Content(
              state: state,
              filteredData: filteredData,
              onRefresh: _reloadCurrentMonth,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.selectedMonth,
    required this.onChanged,
  });

  final String selectedMonth;
  final void Function(String year, String month) onChanged;

  @override
  Widget build(BuildContext context) {
    final year = selectedMonth.substring(0, 4);
    final month = selectedMonth.substring(5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD6E6FF)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(Icons.calendar_month_rounded, color: Color(0xFF2F80ED)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: year,
              items: ['2024', '2025', '2026']
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value, month);
                }
              },
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: month,
              items: List.generate(12, (index) {
                final value = (index + 1).toString().padLeft(2, '0');
                return DropdownMenuItem(
                  value: value,
                  child: Text(_monthName(value)),
                );
              }),
              onChanged: (value) {
                if (value != null) {
                  onChanged(year, value);
                }
              },
            ),
          ),
          Chip(
            backgroundColor: const Color(0xFF2F80ED),
            label: Text(
              '${_monthName(month)} $year',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(String month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return months[int.parse(month) - 1];
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.state,
    required this.filteredData,
    required this.onRefresh,
  });

  final ConsumoState state;
  final List<Conexion> filteredData;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Text(
          state.error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (filteredData.isEmpty) {
      return const Center(child: Text('No se encontraron resultados'));
    }

    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (_, index) {
        final conexion = filteredData[index];
        final lectura = conexion.lectura;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE6EDF5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFF0F4C81),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conexion.cliente.nombreCompleto,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${conexion.cliente.documentoLabel}: ${conexion.cliente.documentoPrincipal}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        _SoftLabel(
                          icon: Icons.badge_outlined,
                          label: conexion.cliente.tipoPersonaLabel,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ReadingStatusBadge(
                    isRegistered: conexion.tieneLecturaRegistrada,
                    label: conexion.estadoLecturaLabel,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        conexion.direccion.descripcionCorta,
                        style: const TextStyle(
                          color: Color(0xFF4B5563),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _InfoPanel(
                    label: 'Codigo',
                    value: conexion.codigo ?? '${conexion.id}',
                    icon: Icons.pin_outlined,
                  ),
                  _InfoPanel(
                    label: 'Estado recibo',
                    value: conexion.estadoReciboLabel,
                    icon: Icons.receipt_long_outlined,
                  ),
                  _InfoPanel(
                    label: 'Periodo',
                    value: lectura?.mes ?? state.month,
                    icon: Icons.calendar_today_outlined,
                  ),
                  _InfoPanel(
                    label: 'Consumo actual',
                    value: lectura?.consumoActual?.toString() ?? 'Sin lectura',
                    icon: Icons.speed_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showDetailDialog(context, conexion, lectura),
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('Ver detalle'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0F4C81),
                        side: const BorderSide(color: Color(0xFFD7E3F3)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _PrimaryActionButton(
                      icon: !conexion.tieneLecturaRegistrada
                          ? Icons.add_rounded
                          : Icons.edit_outlined,
                      label: !conexion.tieneLecturaRegistrada
                          ? 'Registrar lectura'
                          : 'Editar lectura',
                      color: !conexion.tieneLecturaRegistrada
                          ? const Color(0xFF2F80ED)
                          : const Color(0xFFE67E22),
                      onTap: !conexion.tieneLecturaRegistrada
                          ? () async {
                              final saved = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RegistroConsumoPage(
                                    conexionId: conexion.id,
                                    initialMonth: state.month,
                                    conexion: conexion,
                                  ),
                                ),
                              );
                              if (saved == true && context.mounted) {
                                await onRefresh();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'La lista de consumos se actualizo correctamente.',
                                    ),
                                  ),
                                );
                              }
                            }
                          : () {
                              Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditConsumoPage(
                                    consumoId: lectura!.id!,
                                    conexionId: conexion.id,
                                    initialMonth: lectura.mes ?? state.month,
                                    conexion: conexion,
                                  ),
                                ),
                              ).then((saved) async {
                                if (saved == true && context.mounted) {
                                  await onRefresh();
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'La lectura editada se actualizo correctamente.',
                                      ),
                                    ),
                                  );
                                }
                              });
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDetailDialog(
    BuildContext context,
    Conexion conexion,
    dynamic lectura,
  ) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Detalle ${conexion.codigo ?? conexion.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: ${conexion.cliente.nombreCompleto}'),
            Text(
              '${conexion.cliente.documentoLabel}: ${conexion.cliente.documentoPrincipal}',
            ),
            Text('Tipo: ${conexion.cliente.tipoPersonaLabel}'),
            Text('Direccion: ${conexion.direccion.descripcionCorta}'),
            Text('Estado conexion: ${conexion.estado ?? '-'}'),
            Text('Estado lectura: ${conexion.estadoLecturaLabel}'),
            Text('Estado recibo: ${conexion.estadoReciboLabel}'),
            Text('Periodo: ${lectura?.mes ?? state.month}'),
            Text('Consumo actual: ${lectura?.consumoActual ?? 0}'),
            Text(
              'Consumo anterior: ${lectura?.consumoAnterior ?? conexion.consumoAnteriorSugerido}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6B7280)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, textAlign: TextAlign.center),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF0F4C81)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0F4C81),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactSummaryCard extends StatelessWidget {
  const _CompactSummaryCard({
    required this.color,
    required this.accentColor,
    required this.title,
    required this.value,
  });

  final Color color;
  final Color accentColor;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 140, maxWidth: 180),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor.withAlpha(28),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF243447),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadingStatusBadge extends StatelessWidget {
  const _ReadingStatusBadge({
    required this.isRegistered,
    required this.label,
  });

  final bool isRegistered;
  final String label;

  @override
  Widget build(BuildContext context) {
    final background = isRegistered
        ? const Color(0xFFE8F7EF)
        : const Color(0xFFFFECE9);
    final foreground = isRegistered
        ? const Color(0xFF1F9D68)
        : const Color(0xFFC44536);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRegistered ? Icons.check_circle_rounded : Icons.schedule_rounded,
            size: 16,
            color: foreground,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftLabel extends StatelessWidget {
  const _SoftLabel({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF0F4C81)),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0F4C81),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
