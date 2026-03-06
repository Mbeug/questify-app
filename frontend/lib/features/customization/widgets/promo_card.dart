import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme.dart';

/// Bottom promotional card encouraging quest completion.
class PromoCard extends StatelessWidget {
  final QuestifyColors q;
  const PromoCard({super.key, required this.q});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: q.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: q.accentPurple.withAlpha(60), width: 2),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: [q.accentPurple, q.accentGold]),
                    boxShadow: [
                      BoxShadow(color: q.glowPurple, blurRadius: 8),
                    ],
                  ),
                  child: const Icon(Icons.shopping_bag,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Decouvre plus d\'ambiances',
                          style: TextStyle(
                              color: q.textPrimary,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        'De nouveaux themes legendaires arrivent bientot ! Gagne des pieces et des gemmes en accomplissant tes quetes.',
                        style: TextStyle(color: q.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _PromoTip(
              q: q,
              color: q.accentGold,
              icon: Icons.auto_awesome,
              text: 'Chaque quete te rapporte des pieces d\'or',
            ),
            const SizedBox(height: 8),
            _PromoTip(
              q: q,
              color: q.accentPurple,
              icon: Icons.auto_awesome,
              text: 'Les quetes epiques donnent des gemmes rares',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [q.accentPurple, const Color(0xFF7B3FD9)]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: q.glowPurple, blurRadius: 12),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/quests'),
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('Voir mes quetes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoTip extends StatelessWidget {
  final QuestifyColors q;
  final Color color;
  final IconData icon;
  final String text;

  const _PromoTip({
    required this.q,
    required this.color,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(color: q.textMuted, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
