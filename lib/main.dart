import 'package:app_lecturador/presentacion/app.dart';
import 'package:app_lecturador/services/consumos/api_buscar.dart';
import 'package:app_lecturador/services/consumos/api_consumo.dart';
import 'package:app_lecturador/services/consumos/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ApiBuscar()),
        ChangeNotifierProvider(create: (context) => ApiConsumo()),
      ],
      child: const MyApp(),
    ),
  );
}
