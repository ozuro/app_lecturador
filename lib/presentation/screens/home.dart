import 'package:app_lecturador/presentation/providers/home/home_provider.dart';
import 'package:app_lecturador/presentation/widget/carta.dart';
import 'package:app_lecturador/presentation/widget/navegacion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String title = 'Sistema Jass Capachica';
  static const Color colorazul = Color.fromARGB(255, 68, 128, 219);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el provider que trae los datos del home
    final reporteHome = ref.watch(reporteHomeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(HomeScreen.title),
      ),
      drawer: navegacion(context),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Card dinámico de conexiones activas
            cartas(reporteHome),

            const SizedBox(height: 20),
            cartas(reporteHome),
            // Card de bienvenida
          ],
        ),
      ),
    );
  }
}
