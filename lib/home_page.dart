import 'package:app_lecturador/login_page.dart';
import 'package:app_lecturador/services/auth.dart';
import 'package:flutter/material.dart';
// import 'auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido ${user?['name'] ?? ''}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¡Has iniciado sesión exitosamente!'),
            SizedBox(height: 20),
            Text('Nombre: ${user?['name']}'),
            Text('Email: ${user?['email']}'),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () async {
            //     // Realiza el logout
            //     await authService.logout();
            //     // Regresa al login después de cerrar sesión
            //     Navigator.pushReplacementNamed(context, '/login');
            //   },
            //   child: Text('Cerrar sesión'),
            // ),
            ElevatedButton(
              onPressed: () async {
                // Realiza el logout
                await authService.logout();

                // Redirige directamente al login y elimina la pila de navegación previa
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
