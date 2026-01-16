import 'package:app_lecturador/presentation/screens/consumos/lista_consumo.dart'
    show ListaConsumo;
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String title = 'Sistema Jass Capachica';
  static const Color colorazul = Color.fromARGB(255, 68, 128, 219);
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      drawer: Drawer(
          // backgroundColor: Color.fromARGB(255, 91, 190, 240),
          child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 84, 163, 219),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.home, color: colorazul),
            title: Text('Inicio', style: TextStyle(color: colorazul)),
          ),
          ListTile(
            leading: Icon(Icons.app_registration, color: colorazul),
            title: Text('Consumo', style: TextStyle(color: colorazul)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ListaConsumo()));
            },
          ),
          const ListTile(
            leading: Icon(Icons.person, color: colorazul),
            title: Text('Perfil', style: TextStyle(color: colorazul)),
          ),
          const ListTile(
            leading: Icon(Icons.settings, color: colorazul),
            title: Text('Configuración', style: TextStyle(color: colorazul)),
          ),
        ],
      )),
      body: const Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
