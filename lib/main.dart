import 'package:app_lecturador/presentation/screens/auth_notifier.dart';
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
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0E5A74),
        brightness: Brightness.light,
      ).copyWith(
        primary: const Color(0xFF0E5A74),
        secondary: const Color(0xFF2F80ED),
        surface: Colors.white,
        surfaceContainerHighest: const Color(0xFFE8EEF5),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lecturador JASS',
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFFF2F5F9),
        textTheme: baseTheme.textTheme.apply(
          bodyColor: const Color(0xFF102A43),
          displayColor: const Color(0xFF102A43),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF102A43),
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF102A43),
            letterSpacing: -0.4,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7FAFC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          hintStyle: const TextStyle(color: Color(0xFF6B7A90)),
          labelStyle: const TextStyle(color: Color(0xFF526074)),
          prefixIconColor: const Color(0xFF526074),
          suffixIconColor: const Color(0xFF526074),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFD7E1EC)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFD7E1EC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0xFF0E5A74),
              width: 1.4,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFC44536)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0xFFC44536),
              width: 1.4,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0E5A74),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF102A43),
            side: const BorderSide(color: Color(0xFFD7E1EC)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF102A43),
          contentTextStyle: baseTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        chipTheme: baseTheme.chipTheme.copyWith(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide.none,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFDCEEFE),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              color:
                  selected ? const Color(0xFF0E5A74) : const Color(0xFF5F6F82),
            );
          }),
        ),
        navigationRailTheme: const NavigationRailThemeData(
          selectedIconTheme: IconThemeData(color: Color(0xFF0E5A74)),
          unselectedIconTheme: IconThemeData(color: Color(0xFF6B7A90)),
          selectedLabelTextStyle: TextStyle(
            color: Color(0xFF0E5A74),
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelTextStyle: TextStyle(
            color: Color(0xFF6B7A90),
            fontWeight: FontWeight.w600,
          ),
          indicatorColor: Color(0xFFDCEEFE),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
