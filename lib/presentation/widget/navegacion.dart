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
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F4C81), Color(0xFF2F80ED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.water_drop_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Lecturador JASS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Panel claro para consumir tus APIs de Laravel y gestionar lecturas.',
                    style: TextStyle(
                      color: Colors.white70,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: sections.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final section = sections[index];
                  final selected = currentIndex == index;

                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    selected: selected,
                    selectedTileColor: const Color(0xFFEAF2FF),
                    leading: Icon(
                      section.icon,
                      color: selected ? const Color(0xFF0F4C81) : Colors.blueGrey,
                    ),
                    title: Text(
                      section.label,
                      style: TextStyle(
                        color: selected
                            ? const Color(0xFF0F4C81)
                            : Colors.blueGrey.shade800,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    onTap: () => onDestinationSelected(index),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
              child: FilledButton.tonalIcon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
