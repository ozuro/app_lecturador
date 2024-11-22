import 'package:app_lecturador/login_page.dart';
import 'package:app_lecturador/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'consumo_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido ${user?['name'] ?? ''}'),
        backgroundColor: Color(0xFF37AFE1),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // DrawerHeader(
            //   decoration: BoxDecoration(color: Color(0xFF37AFE1)),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         user?['name'] ?? 'Usuario',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       Text(
            //         user?['name'] ?? 'Usuario',
            //         style: TextStyle(color: Colors.white70, fontSize: 14),
            //       ),
            //     ],
            //   ),
            // ),
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF37AFE1), // Fondo celeste completo
              ),
              child: Stack(
                children: [
                  Center(
                    child: ClipOval(
                      child: Container(
                        width: 120, // Tamaño del círculo interno
                        height: 120,
                        color:
                            Colors.white.withOpacity(0.2), // Círculo más claro
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user?['name'] ?? 'Usuario'}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   user?['role']?.toString().capitalize() ?? 'Desconocido',
                        //   style: TextStyle(color: Colors.white70, fontSize: 14),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Consumo'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConsumoPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar sesión'),
              onTap: () async {
                await authService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('¡Has iniciado sesión exitosamente!'),
      ),
    );
  }
}
