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
    final onlyPending = ref.watch(consumoOnlyPendingProvider);
    final filteredData = state.data.where((conexion) {
      final cliente = conexion.cliente.nombreCompleto.toLowerCase();
      final direccion = conexion.direccion.nombre.toLowerCase();
      final matchesSearch =
          cliente.contains(search) || direccion.contains(search);
      final matchesPending = !onlyPending || !conexion.tieneLecturaRegistrada;
      return matchesSearch && matchesPending;
    }).toList();

    return Container(
      color: const Color(0xFFF4F7FB),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 16,
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
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF2FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: Color(0xFF0F4C81),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Control de lecturas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Filtra y revisa el avance.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.25,
                              color: Color(0xFF526074),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 10),
                DropdownButtonFormField<String?>(
                  key: ValueKey(state.direccionId),
                  initialValue: state.direccionId,
                  isDense: true,
                  decoration: const InputDecoration(
                    hintText: 'Todas las direcciones',
                    prefixIcon: Icon(Icons.location_city_outlined, size: 18),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar cliente o direccion',
                    isDense: true,
                    prefixIcon: const Icon(Icons.search, size: 18),
                    fillColor: const Color(0xFFF7FAFD),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(consumoSearchProvider.notifier).state = value;
                  },
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
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
                    if (onlyPending)
                      GestureDetector(
                        onTap: () {
                          ref.read(consumoOnlyPendingProvider.notifier).state =
                              false;
                        },
                        child: const _StatusChip(
                          icon: Icons.filter_alt_off_rounded,
                          label: 'Solo faltantes',
                        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD6E6FF)),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(
            Icons.calendar_month_rounded,
            color: Color(0xFF2F80ED),
            size: 18,
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: year,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF243447),
              ),
              items: ['2024', '2025', '2026']
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
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
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF243447),
              ),
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
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            label: Text(
              '${_monthName(month)} $year',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
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

    return ListView.separated(
      itemCount: filteredData.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) {
        final conexion = filteredData[index];

        return _ConsumoListItem(
          conexion: conexion,
          currentMonth: state.month,
          onRefresh: onRefresh,
        );
      },
    );
  }
}

class _ConsumoListItem extends StatefulWidget {
  const _ConsumoListItem({
    required this.conexion,
    required this.currentMonth,
    required this.onRefresh,
  });

  final Conexion conexion;
  final String currentMonth;
  final Future<void> Function() onRefresh;

  @override
  State<_ConsumoListItem> createState() => _ConsumoListItemState();
}

class _ConsumoListItemState extends State<_ConsumoListItem> {
  bool _expanded = false;

  Future<void> _openRegistro() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => RegistroConsumoPage(
          conexionId: widget.conexion.id,
          initialMonth: widget.currentMonth,
          conexion: widget.conexion,
        ),
      ),
    );

    if (saved == true && mounted) {
      await widget.onRefresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La lista de consumos se actualizo correctamente.'),
        ),
      );
    }
  }

  Future<void> _openEdicion() async {
    final lectura = widget.conexion.lectura;
    if (lectura?.id == null) {
      return;
    }

    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditConsumoPage(
          consumoId: lectura!.id!,
          conexionId: widget.conexion.id,
          initialMonth: lectura.mes ?? widget.currentMonth,
          conexion: widget.conexion,
        ),
      ),
    );

    if (saved == true && mounted) {
      await widget.onRefresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La lectura editada se actualizo correctamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final conexion = widget.conexion;
    final lectura = conexion.lectura;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE3EBF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(7),
            blurRadius: 12,
            offset: const Offset(0, 5),
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
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFF0F4C81),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conexion.cliente.nombreCompleto,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _ReadingStatusBadge(
                      isRegistered: conexion.tieneLecturaRegistrada,
                      label: conexion.tieneLecturaRegistrada
                          ? 'Lectura registrada'
                          : 'Pendiente de registro',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
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
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (!conexion.tieneLecturaRegistrada) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openRegistro,
                icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                label: const Text('Registrar lectura'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ] else ...[
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _openEdicion,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Editar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE67E22),
                    side: const BorderSide(color: Color(0xFFF1C58F)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Consumo: ${lectura?.consumoActual ?? 0}',
                  style: const TextStyle(
                    color: Color(0xFF526074),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(
                _expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 18,
              ),
              label: Text(_expanded ? 'Ocultar datos' : 'Ver mas'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0F4C81),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _InfoPanel(
                    label: 'Codigo',
                    value: conexion.codigo ?? '${conexion.id}',
                    icon: Icons.pin_outlined,
                  ),
                  _InfoPanel(
                    label: 'Recibo',
                    value: conexion.estadoReciboLabel,
                    icon: Icons.receipt_long_outlined,
                  ),
                  _InfoPanel(
                    label: 'Periodo',
                    value: lectura?.mes ?? widget.currentMonth,
                    icon: Icons.calendar_today_outlined,
                  ),
                  _InfoPanel(
                    label: 'Documento',
                    value: conexion.cliente.documentoPrincipal,
                    icon: Icons.badge_outlined,
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
      width: 132,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6B7280)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF0F4C81)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0F4C81),
              fontWeight: FontWeight.w700,
              fontSize: 11,
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
      constraints: const BoxConstraints(minWidth: 112, maxWidth: 148),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: accentColor.withAlpha(28),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF243447),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
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
    final background =
        isRegistered ? const Color(0xFFE8F7EF) : const Color(0xFFFFECE9);
    final foreground =
        isRegistered ? const Color(0xFF1F9D68) : const Color(0xFFC44536);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRegistered ? Icons.check_circle_rounded : Icons.schedule_rounded,
            size: 14,
            color: foreground,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
