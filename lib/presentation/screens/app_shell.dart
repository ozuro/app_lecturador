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

  Future<void> _openPendingConsumosForMonth(String month) async {
    final parts = month.split('-');
    if (parts.length != 2) {
      _selectIndex(1);
      return;
    }

    ref.read(consumoSearchProvider.notifier).state = '';
    ref.read(consumoOnlyPendingProvider.notifier).state = true;
    await ref.read(consumoNotifierProvider.notifier).loadConsumos(
          year: parts.first,
          month: parts.last,
          direccionId: null,
        );

    if (!mounted) {
      return;
    }

    _selectIndex(1);
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

  String _sectionSubtitle() {
    switch (_currentIndex) {
      case 0:
        return 'Resumen general y seguimiento del sistema';
      case 1:
        return 'Registro, filtros y control del periodo actual';
      case 2:
        return 'Busqueda puntual por DNI y revision historica';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final currentSection = _sections[_currentIndex];
    final screens = [
      HomeScreen(
        onOpenConsumos: () {
          ref.read(consumoSearchProvider.notifier).state = '';
          ref.read(consumoOnlyPendingProvider.notifier).state = false;
          _selectIndex(1);
        },
        onOpenPendingConsumos: _openPendingConsumosForMonth,
      ),
      const ConsumosView(),
      const BuscarConsumoScreen(),
    ];

    return Scaffold(
      extendBody: true,
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
        toolbarHeight: 82,
        titleSpacing: isWide ? 20 : 8,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentSection.label),
            const SizedBox(height: 4),
            Text(
              _sectionSubtitle(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF5F6F82),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton.filledTonal(
              onPressed: _refreshCurrentSection,
              tooltip: 'Actualizar',
              icon: const Icon(Icons.refresh_rounded),
            ),
          ),
          if (!isWide)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: IconButton.filledTonal(
                onPressed: _logout,
                tooltip: 'Cerrar sesion',
                icon: const Icon(Icons.logout_rounded),
              ),
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6FAFD), Color(0xFFEEF4F8), Color(0xFFF8FBFE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              if (isWide)
                _ShellSidebar(
                  currentIndex: _currentIndex,
                  sections: _sections,
                  onDestinationSelected: _selectIndex,
                  onLogout: _logout,
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isWide ? 0 : 14,
                    6,
                    isWide ? 18 : 14,
                    isWide ? 18 : 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(210),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withAlpha(150)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF102A43).withAlpha(18),
                          blurRadius: 26,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: IndexedStack(
                        index: _currentIndex,
                        children: screens,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isWide
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: NavigationBar(
                  height: 74,
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
              ),
            ),
    );
  }
}

class _ShellSidebar extends StatelessWidget {
  const _ShellSidebar({
    required this.currentIndex,
    required this.sections,
    required this.onDestinationSelected,
    required this.onLogout,
  });

  final int currentIndex;
  final List<NavigationSection> sections;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      margin: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF0E3758),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E3758).withAlpha(50),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: NavigationRail(
        backgroundColor: Colors.transparent,
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        labelType: NavigationRailLabelType.all,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(24),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'JASS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Panel',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        trailing: Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(16),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.monitor_heart_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Operacion diaria',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  IconButton.filledTonal(
                    onPressed: onLogout,
                    tooltip: 'Cerrar sesion',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0E3758),
                    ),
                    icon: const Icon(Icons.logout_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
        selectedIconTheme: const IconThemeData(color: Color(0xFF0E3758)),
        unselectedIconTheme: const IconThemeData(color: Colors.white70),
        selectedLabelTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w600,
        ),
        indicatorColor: Colors.white,
        destinations: sections
            .map(
              (section) => NavigationRailDestination(
                icon: Icon(section.icon),
                label: Text(section.label),
              ),
            )
            .toList(),
      ),
    );
  }
}
