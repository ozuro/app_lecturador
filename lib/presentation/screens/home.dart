import 'package:app_lecturador/presentation/providers/home/home_notifier.dart';
import 'package:app_lecturador/presentation/providers/home/home_provider.dart';
import 'package:app_lecturador/presentation/screens/consumos/lista_consumo.dart';
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
            Card(
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    // Aquí mostramos la cantidad de conexiones
                    Text(
                      reporteHome?.cantidadConexiones.toString() ??
                          'Cargando...',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Card de bienvenida
            Card(
              child: ListTile(
                leading: const Icon(Icons.water, color: colorazul, size: 50),
                title: const Text(
                  'Bienvenido al Sistema Jass Capachica',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Gestiona y monitorea el consumo de agua de manera eficiente.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
