// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'services/auth.dart';
// import 'services/consumo_service.dart';
// import 'services/api_buscar.dart';
// import 'services/api_consumo.dart'; // Importar el nuevo servicio
// import 'home_page.dart';
// import 'login_page.dart';
// import 'buscar.dart';
// import 'lista_cliente.dart';
// import 'formulario_consumo.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => AuthService()),
//         ChangeNotifierProvider(create: (context) => ConsumoService()),
//         ChangeNotifierProvider(create: (context) => ApiBuscar()),
//         ChangeNotifierProvider(
//             create: (context) => ApiConsumo()), // Agregar aquí
//       ],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'App Lecturador',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => LoginPage(),
//         '/home': (context) => HomePage(),
//         '/buscar': (context) => BuscarPage(),
//         // '/lista_cliente': (context) => ListaClientePageWrapper(),
//         // '/formulario_consumo': (context) => FormularioConsumo(),
//       },
//     );
//   }
// }

// class ListaClientePageWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Asegurarte de manejar el caso donde `args` sea nulo o no sea un Map.
//     final args =
//         ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

//     if (args == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text('Error')),
//         body: Center(child: Text('No se encontraron datos del cliente.')),
//       );
//     }

//     return ListaClientePage(cliente: args);
//   }
// }
import 'package:app_lecturador/editarconsumo.dart';
import 'package:app_lecturador/services/editconsumo_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_lecturador/services/createconsumo_api.dart';
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
import 'formulario_consumo.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ConsumoService()),
        ChangeNotifierProvider(create: (context) => ApiBuscar()),
        ChangeNotifierProvider(create: (context) => ApiConsumo()),
        ChangeNotifierProvider(create: (context) => ApiConsumocreate()),
        // ChangeNotifierProvider(create: (context) => ApiConsumoUpdate()),

        // Agregar aquí
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
        // '/editaconsumo': (context) => EditarConsumoPage(),

        // '/formulario_consumo': (context) =>
        //     FormularioConsumo(clienteId:),
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
