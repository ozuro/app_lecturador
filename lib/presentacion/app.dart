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

          // '/home': (context) => HomePage(),
        });
  }
}
