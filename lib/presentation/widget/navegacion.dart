import 'package:app_lecturador/presentation/screens/consumos/lista_consumo.dart';
import 'package:app_lecturador/presentation/screens/home.dart';
import 'package:flutter/material.dart';

Drawer navegacion(BuildContext context) {
  return Drawer(
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
          title: Text('Inicio', style: TextStyle(color: HomeScreen.colorazul)),
        ),
        ListTile(
          leading:
              const Icon(Icons.app_registration, color: HomeScreen.colorazul),
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
          title: Text('Perfil', style: TextStyle(color: HomeScreen.colorazul)),
        ),
        const ListTile(
          leading: Icon(Icons.settings, color: HomeScreen.colorazul),
          title: Text('Configuración',
              style: TextStyle(color: HomeScreen.colorazul)),
        ),
      ],
    ),
  );
}
