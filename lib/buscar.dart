import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_buscar.dart'; // Asegúrate de que esta clase sea correcta
import 'package:shared_preferences/shared_preferences.dart';

class BuscarPage extends StatefulWidget {
  @override
  _BuscarPageState createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  final TextEditingController dniController = TextEditingController();
  String? errorMessage;
  bool isLoading = false;

  void buscarCliente() async {
    if (dniController.text.isEmpty) {
      setState(() {
        errorMessage = "Por favor, ingrese un DNI válido.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Obtener el token antes de hacer la solicitud
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // Cambia a 'auth_token'

      if (token == null) {
        setState(() {
          errorMessage = "No se ha encontrado un token de autenticación.";
        });
        return;
      }

      // Buscar cliente utilizando ApiBuscar
      final cliente = await Provider.of<ApiBuscar>(context, listen: false)
          .buscarCliente(dniController.text, token);

      print('Cliente encontrado: $cliente'); // Imprime el cliente

      if (cliente != null) {
        Navigator.pushNamed(
          context,
          '/lista_cliente',
          arguments: cliente, // Pasamos los datos del cliente a la nueva página
        );
      } else {
        setState(() {
          errorMessage = "Cliente no encontrado.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Cliente'),
        backgroundColor: Color(0xFF37AFE1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: dniController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'DNI del Cliente',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_search, color: Color(0xFF37AFE1)),
              ),
            ),
            SizedBox(height: 20),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: buscarCliente,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF37AFE1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('Buscar', style: TextStyle(fontSize: 16)),
                  ),
          ],
        ),
      ),
    );
  }
}
