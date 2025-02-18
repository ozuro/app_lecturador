import 'package:flutter/material.dart';
import 'package:app_lecturador/presentacion/screen/screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'App Lecturador',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          HomePage.routeName: (_) => const HomePage(),
          BuscarPage.routeName: (_) => const BuscarPage(),
          '/lista_cliente': (context) => ListaClientePageWrapper(),
          // '/home': (context) => HomePage(),
        });
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
