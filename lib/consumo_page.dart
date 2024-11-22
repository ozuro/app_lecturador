import 'package:flutter/material.dart';

class ConsumoPage extends StatefulWidget {
  @override
  _ConsumoPageState createState() => _ConsumoPageState();
}

class _ConsumoPageState extends State<ConsumoPage> {
  final TextEditingController dniController = TextEditingController();

  void buscarDni() {
    final dni = dniController.text;
    if (dni.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa un DNI válido')),
      );
    } else {
      // Lógica para buscar el DNI
      print('Buscando DNI: $dni');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumo'),
        backgroundColor: Color(0xFF37AFE1),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF37AFE1)),
              child: Text(
                'Opciones',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                Navigator.pop(context); // Regresa al HomePage
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar sesión'),
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/login'));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Buscar Consumo por DNI',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37AFE1),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: dniController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'DNI del cliente',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Color(0xFF37AFE1)),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: buscarDni,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF37AFE1),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Buscar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
