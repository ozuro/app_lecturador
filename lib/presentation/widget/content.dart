import 'package:app_lecturador/presentation/providers/consumo/consumo_state.dart';
import 'package:flutter/material.dart';

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
              // title: Text(conexion.codigo),
              subtitle: Text('Código: ${conexion.codigo}'),
            ),
          );
        },
      ),
    );
  }
}
