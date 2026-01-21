import 'package:app_lecturador/presentation/providers/home/home_provider.dart';
import 'package:app_lecturador/presentation/providers/home/home_state.dart';
import 'package:app_lecturador/presentation/screens/consumos/lista_consumo.dart';
import 'package:app_lecturador/presentation/widget/carta.dart';
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
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 84, 163, 219),
              ),
              child: Center(
                child: Text(
                  HomeScreen.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.home, color: HomeScreen.colorazul),
              title:
                  Text('Inicio', style: TextStyle(color: HomeScreen.colorazul)),
            ),
            ListTile(
              leading: const Icon(Icons.app_registration,
                  color: HomeScreen.colorazul),
              title: const Text('Consumo',
                  style: TextStyle(color: HomeScreen.colorazul)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConsumosPage()),
                );
              },
            ),
            const ListTile(
              leading: Icon(Icons.person, color: HomeScreen.colorazul),
              title:
                  Text('Perfil', style: TextStyle(color: HomeScreen.colorazul)),
            ),
            const ListTile(
              leading: Icon(Icons.settings, color: HomeScreen.colorazul),
              title: Text('Configuración',
                  style: TextStyle(color: HomeScreen.colorazul)),
            ),
          ],
        ),
      ),
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
