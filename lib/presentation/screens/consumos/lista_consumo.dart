import 'package:app_lecturador/presentation/providers/consumo/consumo_provider.dart';
import 'package:app_lecturador/presentation/providers/consumo/consumo_state.dart';
import 'package:app_lecturador/presentation/screens/consumos/editar_consumo.dart';
import 'package:app_lecturador/presentation/screens/consumos/registro_consumo.dart';
import 'package:app_lecturador/domain/entities/conexion_entities.dart';
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
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final state = ref.read(consumoNotifierProvider);
      if (state.data.isEmpty && !state.isLoading) {
        final parts = state.month.split('-');
        ref.read(consumoNotifierProvider.notifier).loadConsumos(
              year: parts.first,
              month: parts.last,
              direccionId: state.direccionId,
            );
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
                            'Consulta el periodo, filtra por dirección y revisa el estado de lectura y recibo.',
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
                    hintText: 'Seleccione una dirección',
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
                    hintText: 'Buscar cliente o dirección',
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
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
                        icon: Icons.check_circle_outline_rounded,
                        label: '${state.lecturasRegistradas} hechas',
                      ),
                      _StatusChip(
                        icon: Icons.pending_actions_rounded,
                        label: '${state.lecturasFaltantes} faltan',
                      ),
                      _StatusChip(
                        icon: state.error == null
                            ? Icons.cloud_done_rounded
                            : Icons.warning_amber_rounded,
                        label: state.error == null
                            ? 'API conectada'
                            : 'Revisar conexión',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _SummaryCard(
                color: const Color(0xFF1F9D68),
                title: 'Lecturas registradas',
                value: state.lecturasRegistradas.toString(),
              ),
              _SummaryCard(
                color: const Color(0xFFC44536),
                title: 'Lecturas faltantes',
                value: state.lecturasFaltantes.toString(),
              ),
              _SummaryCard(
                color: const Color(0xFF2F80ED),
                title: 'Conexiones evaluadas',
                value: state.totalConexiones.toString(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.62,
            child: _Content(state: state, filteredData: filteredData),
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
  });

  final ConsumoState state;
  final List<Conexion> filteredData;

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

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF2FF),
                        shape: BoxShape.circle,
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'DNI: ${conexion.cliente.dni ?? '-'}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Chip(
                      backgroundColor: conexion.tieneLecturaRegistrada
                          ? const Color(0xFF1F9D68)
                          : const Color(0xFFC44536),
                      label: Text(
                        conexion.estadoLecturaLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        conexion.direccion.descripcionCorta,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Wrap(
                  spacing: 18,
                  runSpacing: 12,
                  children: [
                    _InfoItem(
                      label: 'Código',
                      value: conexion.codigo ?? '${conexion.id}',
                    ),
                    _InfoItem(
                      label: 'Estado lectura',
                      value: conexion.estadoLecturaLabel,
                    ),
                    _InfoItem(
                      label: 'Estado recibo',
                      value: conexion.estadoReciboLabel,
                    ),
                    _InfoItem(
                      label: 'Consumo del mes',
                      value: lectura?.consumoActual?.toString() ?? 'Sin lectura',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ActionButton(
                      icon: Icons.visibility_outlined,
                      label: 'Ver',
                      color: const Color(0xFF1F9D68),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Detalle ${conexion.codigo ?? conexion.id}'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cliente: ${conexion.cliente.nombreCompleto}'),
                                Text('DNI: ${conexion.cliente.dni ?? '-'}'),
                                Text('Dirección: ${conexion.direccion.descripcionCorta}'),
                                Text('Estado conexión: ${conexion.estado ?? '-'}'),
                                Text('Estado lectura: ${conexion.estadoLecturaLabel}'),
                                Text('Estado recibo: ${conexion.estadoReciboLabel}'),
                                Text('Periodo: ${lectura?.mes ?? state.month}'),
                                Text('Consumo actual: ${lectura?.consumoActual ?? 0}'),
                                Text('Consumo anterior: ${lectura?.consumoAnterior ?? conexion.consumoAnteriorSugerido}'),
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
                      },
                    ),
                    if (!conexion.tieneLecturaRegistrada)
                      _ActionButton(
                        icon: Icons.add_rounded,
                        label: 'Registrar',
                        color: const Color(0xFF2F80ED),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegistroConsumoPage(
                                conexionId: conexion.id,
                              ),
                            ),
                          );
                        },
                      )
                    else
                      _ActionButton(
                        icon: Icons.edit_outlined,
                        label: 'Editar',
                        color: const Color(0xFFE67E22),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditConsumoPage(
                                consumoId: lectura!.id!,
                                conexionId: conexion.id,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
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
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0F4C81)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0F4C81),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.color,
    required this.title,
    required this.value,
  });

  final Color color;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 180, maxWidth: 240),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
