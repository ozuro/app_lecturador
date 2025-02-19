import 'package:flutter/material.dart';

class ConsumoLista extends StatefulWidget {
  final int id;
  const ConsumoLista(this.id, {super.key});

  @override
  State<ConsumoLista> createState() => _ConsumoListaState();
}

class _ConsumoListaState extends State<ConsumoLista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(" consumos de id"), backgroundColor: Color(0xFF37AFE1)),
        body: Center(
          child: Text(""),
        ));
  }
}
