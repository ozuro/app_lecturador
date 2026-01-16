import 'package:flutter/material.dart';

class ListaConsumo extends StatefulWidget {
  const ListaConsumo({super.key});

  @override
  State<ListaConsumo> createState() => _ListaConsumoState();
}

class _ListaConsumoState extends State<ListaConsumo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Consumo'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.water_damage),
            title: Text('Consumo ${index + 1}'),
            subtitle: Text('Detalle del consumo ${index + 1}'),
          );
        },
      ),
    );
  }
}
