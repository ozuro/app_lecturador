import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/auth.dart';
import '../login/login_page.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/home';
  const HomePage({super.key});
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
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF37AFE1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    user?['name'] ?? 'Usuario',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Consumo'),
              onTap: () {
                Navigator.pushNamed(context, '/buscarConsumo');
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
