import 'package:app_lecturador/provider/home_riverpod.dart';
import 'package:app_lecturador/services/login/prueba_riverpod/auth_state.dart';
import 'package:app_lecturador/services/login/prueba_riverpod/logiin_vista.dart'
    show LoginPage;
import 'package:app_lecturador/services/login/prueba_riverpod/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
