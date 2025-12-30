import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetalleConsumoPage extends ConsumerWidget {
  final int consumoId;

  const DetalleConsumoPage({super.key, required this.consumoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consumoAsync = ref.watch(consumoDetalleProvider(consumoId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Consumo'),
      ),
      body: consumoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (consumo) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _item('Cliente', consumo.cliente),
                _item('Código Conexión', consumo.codigoConexion),
                _item('Dirección', consumo.direccion),
                const Divider(),
                _item(
                  'Consumo actual',
                  consumo.consumoActual.toString(),
                ),
                _item(
                  'Estado',
                  consumo.registrado ? 'Registrado' : 'Pendiente',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _item(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
