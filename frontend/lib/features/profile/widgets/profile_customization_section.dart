import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme.dart';

/// Section with links to customization/shop.
class ProfileCustomizationSection extends StatelessWidget {
  final QuestifyColors q;
  const ProfileCustomizationSection({super.key, required this.q});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personnalisation',
              style: TextStyle(
                  color: q.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          _LinkCard(
            q: q,
            icon: Icons.palette,
            gradientColors: [q.accentPurple, q.accentGold],
            title: 'Themes',
            subtitle: 'Debloque de nouvelles ambiances',
            borderColor: q.accentPurple.withAlpha(60),
            onTap: () => context.go('/customization'),
          ),
          const SizedBox(height: 10),
          _LinkCard(
            q: q,
            icon: Icons.shopping_bag,
            gradientColors: [q.accentGold, q.accentGold],
            title: 'Boutique',
            subtitle: 'Items premium et bonus',
            borderColor: q.accentGold.withAlpha(60),
            onTap: () => context.go('/customization'),
          ),
        ],
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final QuestifyColors q;
  final IconData icon;
  final List<Color> gradientColors;
  final String title;
  final String subtitle;
  final Color borderColor;
  final VoidCallback onTap;

  const _LinkCard({
    required this.q,
    required this.icon,
    required this.gradientColors,
    required this.title,
    required this.subtitle,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: q.bgSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: gradientColors),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: q.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  Text(subtitle,
                      style: TextStyle(color: q.textMuted, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: q.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
