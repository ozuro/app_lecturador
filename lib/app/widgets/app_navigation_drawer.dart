import 'package:flutter/material.dart';

class NavigationSection {
  const NavigationSection({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({
    super.key,
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
    return Drawer(
      backgroundColor: const Color(0xFFF7FAFD),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0F4C81),
                    Color(0xFF0E5A74),
                    Color(0xFF2F80ED)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F4C81).withAlpha(42),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.water_drop_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    'Lecturador JASS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Panel para control de lecturas, busqueda por cliente y seguimiento del periodo.',
                    style: TextStyle(
                      color: Colors.white70,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: sections.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final section = sections[index];
                  final selected = currentIndex == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFE6F2F7) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFFB9DAE7)
                            : const Color(0xFFE2EAF2),
                      ),
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF0E5A74)
                              : const Color(0xFFF3F7FB),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          section.icon,
                          color:
                              selected ? Colors.white : const Color(0xFF526074),
                        ),
                      ),
                      title: Text(
                        section.label,
                        style: TextStyle(
                          color: selected
                              ? const Color(0xFF0E5A74)
                              : const Color(0xFF243447),
                          fontWeight:
                              selected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: selected
                            ? const Color(0xFF0E5A74)
                            : const Color(0xFF90A0B4),
                      ),
                      onTap: () => onDestinationSelected(index),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2EAF2)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    color: Color(0xFF0E5A74),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Acceso activo listo para operar.',
                      style: TextStyle(
                        color: Color(0xFF526074),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
              child: FilledButton.tonalIcon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Cerrar sesion'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
