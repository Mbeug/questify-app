import 'package:flutter/material.dart';

import '../../../models/group.dart';
import '../../../theme.dart';

/// Section displaying group statistics (weekly quests, average level).
class GroupStatsSection extends StatelessWidget {
  final QuestGroup group;
  final QuestifyColors q;

  const GroupStatsSection({super.key, required this.group, required this.q});

  @override
  Widget build(BuildContext context) {
    final avgLevel = group.members.isEmpty
        ? 0
        : (group.members.map((m) => m.level).reduce((a, b) => a + b) /
                group.members.length)
            .round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Statistiques',
              style: TextStyle(
                  color: q.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: '${group.weeklyProgress}',
                  label: 'Quetes cette semaine',
                  color: q.accentGold,
                  q: q,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  value: '$avgLevel',
                  label: 'Niveau moyen',
                  color: q.accentMint,
                  q: q,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final QuestifyColors q;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
    required this.q,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: q.bgSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(60), width: 2),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(color: q.textMuted, fontSize: 11),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
