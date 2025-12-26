import 'package:app_lecturador/presentacion/providers/consumo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsumosScreen extends ConsumerWidget {
  const ConsumosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtros = {
      'month': '2025-12',
      'estado': 'todos',
      'con_medidor': 'todos',
      'direccion_id': '1',
    };

    final consumosAsync = ref.watch(consumosProvider(filtros));

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Consumos')),
      body: consumosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (consumos) {
          if (consumos.isEmpty) {
            return const Center(child: Text('No hay registros'));
          }

          return ListView.builder(
            itemCount: consumos.length,
            itemBuilder: (_, i) {
              final c = consumos[i];

              return ListTile(
                leading: Icon(
                  c.registrado ? Icons.check_circle : Icons.warning,
                  color: c.registrado ? Colors.green : Colors.orange,
                ),
                title: Text(c.cliente),
                subtitle: Text(
                  'Conexión ${c.codigoConexion} • ${c.direccion}',
                ),
                trailing: Text(
                  c.registrado ? 'Consumo: ${c.consumoActual}' : 'Pendiente',
                ),
                onTap: () {
                  // aquí luego vas a la pantalla de registrar consumo
                },
              );
            },
          );
        },
      ),
    );
  }
}
