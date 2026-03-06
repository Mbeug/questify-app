import 'package:flutter/material.dart';

import '../../../theme.dart';

/// Quick stat cards row (Quetes, Niveau, XP Total).
class QuickStats extends StatelessWidget {
  final dynamic stats;
  final QuestifyColors q;
  const QuickStats({super.key, required this.stats, required this.q});

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickStatItem(
          'Quetes', '${stats.totalQuestsCompleted}', q.accentMint, Icons.bolt),
      _QuickStatItem(
          'Niveau', '${stats.level}', q.accentPurple, Icons.star),
      _QuickStatItem('XP Total', '${stats.xp}', q.accentGold, Icons.emoji_events),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: items
            .map((item) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: q.bgSecondary,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: item.color, width: 2),
                      ),
                      child: Column(
                        children: [
                          Icon(item.icon, color: item.color, size: 24),
                          const SizedBox(height: 6),
                          Text(item.value,
                              style: TextStyle(
                                color: q.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 2),
                          Text(item.label,
                              style: TextStyle(
                                  color: q.textMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _QuickStatItem {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _QuickStatItem(this.label, this.value, this.color, this.icon);
}
