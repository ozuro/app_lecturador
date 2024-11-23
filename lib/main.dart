import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth.dart';
import 'services/consumo_service.dart';
import 'services/api_buscar.dart';
import 'services/api_consumo.dart'; // Importar el nuevo servicio
import 'home_page.dart';
import 'login_page.dart';
import 'buscar.dart';
import 'lista_cliente.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ConsumoService()),
        ChangeNotifierProvider(create: (context) => ApiBuscar()),
        ChangeNotifierProvider(
            create: (context) => ApiConsumo()), // Agregar aquí
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Lecturador',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/buscar': (context) => BuscarPage(),
        '/lista_cliente': (context) => ListaClientePageWrapper(),
      },
    );
  }
}

class ListaClientePageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Asegurarte de manejar el caso donde `args` sea nulo o no sea un Map.
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('No se encontraron datos del cliente.')),
      );
    }

    return ListaClientePage(cliente: args);
  }
}
