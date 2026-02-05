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
    final state = ref.watch(consumoNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Consumos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 📅 SELECTOR DE MES
            _MonthSelector(
              selectedMonth: state.month,
              onChanged: (year, month) {
                ref.read(consumoNotifierProvider.notifier).loadConsumos(
                      year: year,
                      month: month,
                      direccionId: '1',
                    );
              },
            ),

            const SizedBox(height: 12),

            /// 🔍 BUSCADOR
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar cliente o dirección',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                ref.read(consumoSearchProvider.notifier).state = value;
              },
            ),

            const SizedBox(height: 16),

            /// 📋 CONTENIDO
            _Content(state),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// 📅 SELECTOR DE MES
/// =======================
class _MonthSelector extends StatelessWidget {
  final String selectedMonth;
  final void Function(String year, String month) onChanged;

  const _MonthSelector({
    required this.selectedMonth,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final year = selectedMonth.substring(0, 4);
    final month = selectedMonth.substring(5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.lightBlue.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month, color: Colors.lightBlue),

          const SizedBox(width: 12),

          /// AÑO
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: year,
              icon: const Icon(Icons.keyboard_arrow_down),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              items: ['2024', '2025', '2026']
                  .map(
                    (y) => DropdownMenuItem(
                      value: y,
                      child: Text(y),
                    ),
                  )
                  .toList(),
              onChanged: (y) {
                if (y != null) onChanged(y, month);
              },
            ),
          ),

          const SizedBox(width: 12),

          /// MES
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: month,
              icon: const Icon(Icons.keyboard_arrow_down),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              items: List.generate(12, (i) {
                final m = (i + 1).toString().padLeft(2, '0');
                final nombreMes = _nombreMes(m);
                return DropdownMenuItem(
                  value: m,
                  child: Text(nombreMes),
                );
              }),
              onChanged: (m) {
                if (m != null) onChanged(year, m);
              },
            ),
          ),

          const Spacer(),

          /// MES ACTUAL VISIBLE
          Chip(
            backgroundColor: Colors.lightBlue,
            label: Text(
              '${_nombreMes(month)} $year',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _nombreMes(String mes) {
    const meses = [
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
    return meses[int.parse(mes) - 1];
  }
}

/// =======================
/// 📋 LISTA DE CONSUMOS
/// =======================
class _Content extends ConsumerWidget {
  final ConsumoState state;

  const _Content(this.state);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return Expanded(
        child: Center(
          child: Text(
            state.error!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final search = ref.watch(consumoSearchProvider).toLowerCase();

    final filteredData = state.data.where((conexion) {
      final cliente = conexion.cliente.nombreCompleto.toLowerCase();
      final direccion = conexion.direccion.nombre.toLowerCase();
      return cliente.contains(search) || direccion.contains(search);
    }).toList();

    if (filteredData.isEmpty) {
      return const Expanded(
        child: Center(child: Text('No se encontraron resultados')),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (_, index) {
          final conexion = filteredData[index];
          final consumo = conexion.consumos;

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 👤 CLIENTE
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.lightBlue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          conexion.cliente.nombreCompleto,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      /// 🟢 / 🔴 ESTADO
                      Chip(
                        backgroundColor:
                            consumo.isNotEmpty ? Colors.green : Colors.red,
                        avatar: Icon(
                          consumo.isNotEmpty
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(
                          consumo.isNotEmpty ? 'Con lectura' : 'Sin lectura',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// 📍 DIRECCIÓN
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          conexion.direccion.nombre,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 20),

                  /// 📊 DATOS DE CONSUMO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoItem(
                        label: 'Consumo',
                        value: conexion.consumoActualTexto,
                      ),
                      _InfoItem(
                        label: 'ID',
                        value: consumo.isNotEmpty
                            ? consumo.last.id.toString()
                            : '--',
                      ),
                      _InfoItem(
                        label: 'Estadoss',
                        value: consumo.isNotEmpty
                            ? consumo.last.estadoConsumo ?? 'Sin lectura'
                            : 'Sin lectura',
                        icon: consumo.isNotEmpty
                            ? Icons.check_circle
                            : Icons.cancel,
                        iconColor:
                            consumo.isNotEmpty ? Colors.green : Colors.red,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// 👉 ACCIONES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (consumo.isEmpty)
                        _ActionButton(
                          icon: Icons.add,
                          label: 'Registrar',
                          color: Colors.lightBlue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegistroConsumoPage(
                                    conexionId: conexion.id),
                              ),
                            );
                          },
                        )
                      else ...[
                        _ActionButton(
                          icon: Icons.visibility,
                          label: 'Ver',
                          color: Colors.green,
                          onTap: () {
                            // TODO: navegar a vista detalle
                          },
                        ),
                        _ActionButton(
                          icon: Icons.edit,
                          label: 'Editar',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditConsumoPage(
                                  consumoId: consumo.last.id!,
                                  conexionId: conexion.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  const _InfoItem({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
  });

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
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          icon: Icon(icon, size: 18),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}
