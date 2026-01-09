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
      appBar: AppBar(title: const Text('Lista de Conexiones')),
      body: consumosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (conexiones) {
          if (conexiones.isEmpty) {
            return const Center(child: Text('No hay registros'));
          }
          return ListView.builder(
            itemCount: conexiones.length,
            itemBuilder: (context, index) {
              final conexion = conexiones[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conexion.nombreCompleto,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Dirección: ${conexion.direccion}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Divider(),

                      // Lista de consumos
                      ...conexion.consumos.map((c) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Mes: ${c.mes}'),
                              Text('${c.consumoActual} m³'),
                            ],
                          )),
                    ],
                  ),
                ),
              );
            },
          );
          ;
        },
      ),
    );
  }
}
