import 'package:app_lecturador/app/theme/app_theme.dart';
import 'package:app_lecturador/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lecturador JASS',
      theme: AppTheme.light,
      home: const LoginPage(),
    );
  }
}
