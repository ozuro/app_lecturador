import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lecturador/services/login/prueba_riverpod/provider_consumo.dart';

class ConsumosScreen extends ConsumerWidget {
  const ConsumosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consumosAsync = ref.watch(consumosProvider);

    // 👉 Mes que se quiere controlar
    const mesSeleccionado = '2025-12';

    return Scaffold(
      appBar: AppBar(title: const Text('Control de Lecturación')),
      body: consumosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (conexiones) {
          if (conexiones.isEmpty) {
            return const Center(child: Text('No hay conexiones'));
          }

          // ===============================
          //  RESUMEN GENERAL
          // ===============================
          final totalConexiones = conexiones.length;

          final registradas = conexiones.where((conexion) {
            return conexion.consumos.any(
              (c) => c.mes == mesSeleccionado,
            );
          }).length;

          final pendientes = totalConexiones - registradas;

          return Column(
            children: [
              // ===============================
              //  TARJETA RESUMEN
              // ===============================
              Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mes: $mesSeleccionado',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('Total conexiones: $totalConexiones'),
                      Text(
                        'Registradas: $registradas',
                        style: const TextStyle(color: Colors.green),
                      ),
                      Text(
                        'Pendientes: $pendientes',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),

              // ===============================
              //  LISTA DE CONEXIONES
              // ===============================
              Expanded(
                child: ListView.builder(
                  itemCount: conexiones.length,
                  itemBuilder: (context, index) {
                    final conexion = conexiones[index];

                    final tieneConsumoMes = conexion.consumos.any(
                      (c) => c.mes == mesSeleccionado,
                    );

                    final consumosMes = conexion.consumos.where(
                      (c) => c.mes == mesSeleccionado,
                    );

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ===============================
                            //  NOMBRE
                            // ===============================
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

                            const SizedBox(height: 8),

                            // ===============================
                            //  ESTADO
                            // ===============================
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: tieneConsumoMes
                                    ? Colors.green[100]
                                    : Colors.red[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tieneConsumoMes ? 'REGISTRADO' : 'PENDIENTE',
                                style: TextStyle(
                                  color: tieneConsumoMes
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const Divider(),

                            // ===============================
                            //  DETALLE CONSUMO
                            // ===============================
                            if (tieneConsumoMes)
                              ...consumosMes.map(
                                (c) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Mes: ${c.mes}'),
                                    Text(
                                      '${c.consumoActual} m³',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              const Text(
                                '⚠ Consumo no registrado',
                                style: TextStyle(color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
