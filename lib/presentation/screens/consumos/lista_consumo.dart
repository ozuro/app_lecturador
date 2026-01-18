import 'package:app_lecturador/presentation/providers/consumo/consumo_provider.dart';
import 'package:app_lecturador/presentation/providers/consumo/consumo_state.dart';
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
            const SizedBox(height: 16),
            _Content(state),
          ],
        ),
      ),
    );
  }
}

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

    return Row(
      children: [
        DropdownButton<String>(
          value: year,
          items: ['2024', '2025', '2026']
              .map((y) => DropdownMenuItem(value: y, child: Text(y)))
              .toList(),
          onChanged: (y) {
            if (y != null) onChanged(y, month);
          },
        ),
        const SizedBox(width: 12),
        DropdownButton<String>(
          value: month,
          items: List.generate(12, (i) {
            final m = (i + 1).toString().padLeft(2, '0');
            return DropdownMenuItem(value: m, child: Text(m));
          }),
          onChanged: (m) {
            if (m != null) onChanged(year, m);
          },
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final ConsumoState state;

  const _Content(this.state);

  @override
  Widget build(BuildContext context) {
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

    if (state.data.isEmpty) {
      return const Expanded(
        child: Center(child: Text('No hay consumos')),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: state.data.length,
        itemBuilder: (_, index) {
          final conexion = state.data[index];

          return Card(
            child: ListTile(
              title: Text(conexion.cliente.nombreCompleto),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(conexion.direccion.nombre),
                  const SizedBox(height: 4),
                  Text('Consumo: ${conexion.consumoActualTexto}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
