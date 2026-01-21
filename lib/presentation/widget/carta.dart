import 'package:app_lecturador/presentation/providers/home/home_state.dart';
import 'package:flutter/material.dart';

Card cartas(ReporteHomeState reporteHome) {
  return Card(
    elevation: 4,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people, size: 50, color: Colors.blue),
          const SizedBox(height: 12),
          const Text(
            'Conexiones activas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          // Aquí mostramos la cantidad de conexiones

          if (reporteHome.isLoading)
            const CircularProgressIndicator()
          else
            Text(
              reporteHome.cantidadConexiones.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            )
        ],
      ),
    ),
  );
}
