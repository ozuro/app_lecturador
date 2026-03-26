import 'package:app_lecturador/presentation/providers/auth_provider.dart';
import 'package:app_lecturador/presentation/providers/consumo/consumo_provider.dart';
import 'package:app_lecturador/presentation/providers/home/home_provider.dart';
import 'package:app_lecturador/presentation/screens/auth_notifier.dart';
import 'package:app_lecturador/presentation/screens/buscar_consumo_screen.dart';
import 'package:app_lecturador/presentation/screens/consumos/lista_consumo.dart';
import 'package:app_lecturador/presentation/screens/home.dart';
import 'package:app_lecturador/presentation/widget/navegacion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;

  late final List<NavigationSection> _sections = const [
    NavigationSection(label: 'Inicio', icon: Icons.dashboard_rounded),
    NavigationSection(label: 'Consumos', icon: Icons.receipt_long_rounded),
    NavigationSection(label: 'Buscar', icon: Icons.search_rounded),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final now = DateTime.now();
      ref.read(consumoNotifierProvider.notifier).loadConsumos(
            year: now.year.toString(),
            month: now.month.toString().padLeft(2, '0'),
            direccionId: null,
          );
    });
  }

  void _selectIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _refreshCurrentSection() async {
    if (_currentIndex == 0) {
      await ref.read(reporteHomeProvider.notifier).loadReporte();
      return;
    }

    final consumoState = ref.read(consumoNotifierProvider);
    final parts = consumoState.month.split('-');
    await ref.read(consumoNotifierProvider.notifier).loadConsumos(
          year: parts.first,
          month: parts.last,
          direccionId: consumoState.direccionId,
        );
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final screens = [
      HomeScreen(onOpenConsumos: () => _selectIndex(1)),
      const ConsumosView(),
      const BuscarConsumoScreen(),
    ];

    return Scaffold(
      drawer: isWide
          ? null
          : AppNavigationDrawer(
              currentIndex: _currentIndex,
              sections: _sections,
              onDestinationSelected: (index) {
                Navigator.of(context).pop();
                _selectIndex(index);
              },
              onLogout: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
      appBar: AppBar(
        title: Text(_sections[_currentIndex].label),
        actions: [
          IconButton(
            onPressed: _refreshCurrentSection,
            tooltip: 'Actualizar',
            icon: const Icon(Icons.refresh_rounded),
          ),
          if (!isWide)
            IconButton(
              onPressed: _logout,
              tooltip: 'Cerrar sesión',
              icon: const Icon(Icons.logout_rounded),
            ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            if (isWide)
              Container(
                width: 108,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _selectIndex,
                  labelType: NavigationRailLabelType.all,
                  leading: Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF2FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.water_drop_outlined,
                      color: Color(0xFF0F4C81),
                    ),
                  ),
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: IconButton.filledTonal(
                          onPressed: _logout,
                          tooltip: 'Cerrar sesión',
                          icon: const Icon(Icons.logout_rounded),
                        ),
                      ),
                    ),
                  ),
                  destinations: _sections
                      .map(
                        (section) => NavigationRailDestination(
                          icon: Icon(section.icon),
                          label: Text(section.label),
                        ),
                      )
                      .toList(),
                ),
              ),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: screens,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: _selectIndex,
              destinations: _sections
                  .map(
                    (section) => NavigationDestination(
                      icon: Icon(section.icon),
                      label: section.label,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
