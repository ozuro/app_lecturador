// import 'package:app_lecturador/services/login/prueba_riverpod/detalleconsumo.dart';
import 'package:app_lecturador/services/login/prueba_riverpod/provider_consumo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsumosScreen extends ConsumerWidget {
  const ConsumosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consumosAsync = ref.watch(consumosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Consumos')),
      body: consumosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (consumos) {
          if (consumos.isEmpty) {
            return const Center(child: Text('No hay registros'));
          }
          return ListView.builder(
            itemCount: consumos.length,
            itemBuilder: (_, i) {
              final consumo = consumos[i];

              return ListTile(
                title: Text(consumo.cliente),
                trailing: const Icon(Icons.arrow_forward_ios),
              );
            },
          );
        },
      ),
    );
  }
}
