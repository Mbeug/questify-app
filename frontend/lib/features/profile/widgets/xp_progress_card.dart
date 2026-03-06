import 'package:flutter/material.dart';

import '../../../theme.dart';

/// XP progress card showing level progress.
class XpProgressCard extends StatelessWidget {
  final dynamic stats;
  final QuestifyColors q;
  const XpProgressCard({super.key, required this.stats, required this.q});

  @override
  Widget build(BuildContext context) {
    final progress = (stats.progressPercent as double) / 100.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: q.bgSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: q.accentPurple.withAlpha(60), width: 2),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Niveau suivant',
                    style: TextStyle(
                        color: q.textPrimary, fontSize: 14)),
                Text(
                  '${stats.xp} / ${stats.xpForCurrentLevel + stats.xpToNextLevel} XP',
                  style: TextStyle(color: q.textMuted, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: q.bgTertiary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress.clamp(0, 1),
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [q.accentPurple, q.accentGold]),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: q.glowPurple,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
