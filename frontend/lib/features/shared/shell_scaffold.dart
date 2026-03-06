import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';

// ============================================================================
//  ShellScaffold — persistent 5-tab bottom navigation bar
//  Tabs: Accueil, Quetes, Groupe, Themes, Profil
// ============================================================================

class ShellScaffold extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScaffold({super.key, required this.navigationShell});

  static const _tabs = [
    _TabDef(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Accueil'),
    _TabDef(icon: Icons.assignment_outlined, activeIcon: Icons.assignment, label: 'Quetes'),
    _TabDef(icon: Icons.groups_outlined, activeIcon: Icons.groups, label: 'Groupe'),
    _TabDef(icon: Icons.palette_outlined, activeIcon: Icons.palette, label: 'Themes'),
    _TabDef(icon: Icons.person_outlined, activeIcon: Icons.person, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = context.q;
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: q.bgSecondary,
          border: Border(
            top: BorderSide(color: q.borderDefault, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: q.glowPurple,
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final isSelected = i == currentIndex;
                return _NavTab(
                  tab: tab,
                  isSelected: isSelected,
                  onTap: () => navigationShell.goBranch(
                    i,
                    initialLocation: i == navigationShell.currentIndex,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabDef {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _TabDef({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _NavTab extends StatelessWidget {
  final _TabDef tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTab({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final q = context.q;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? tab.activeIcon : tab.icon,
                color: isSelected ? kAccentPurple : q.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? kAccentPurple : q.textMuted,
              ),
              child: Text(tab.label),
            ),
            // Active indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(top: 3),
              width: isSelected ? 5 : 0,
              height: isSelected ? 5 : 0,
              decoration: BoxDecoration(
                color: kAccentPurple,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: q.glowPurple,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
