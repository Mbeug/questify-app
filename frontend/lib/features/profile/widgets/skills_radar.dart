import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

/// Skills computed from stats for the radar chart.
class Skill {
  final String name;
  final double value;
  const Skill(this.name, this.value);
}

/// Builds the list of skills from stats.
List<Skill> buildSkills({
  required int totalQuests,
  required int currentStreak,
  required int bestStreak,
  required int level,
}) {
  double clamp(double v) => v.clamp(0, 100);
  return [
    Skill('Force', clamp(min(totalQuests * 2.0, 100))),
    Skill('Constance', clamp(min(bestStreak * 10.0, 100))),
    Skill('Rapidite', clamp(min(level * 5.0, 100))),
    Skill('Sagesse', clamp(min(totalQuests * 1.5, 100))),
    Skill('Creativite', clamp(min((totalQuests + level) * 1.8, 100))),
    Skill('Charisme', clamp(min(currentStreak * 8.0, 100))),
  ];
}

/// Skills radar chart widget.
class SkillsRadar extends StatelessWidget {
  final dynamic stats;
  final QuestifyColors q;
  final int currentStreak;
  final int bestStreak;

  const SkillsRadar({
    super.key,
    required this.stats,
    required this.q,
    required this.currentStreak,
    required this.bestStreak,
  });

  @override
  Widget build(BuildContext context) {
    final skills = buildSkills(
      totalQuests: stats.totalQuestsCompleted as int,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      level: stats.level as int,
    );

    final sorted = [...skills]..sort((a, b) => b.value.compareTo(a.value));
    final strengths = sorted.take(2).map((s) => s.name).join(', ');
    final weaknesses =
        sorted.reversed.take(2).toList().reversed.map((s) => s.name).join(', ');

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Competences',
                    style: TextStyle(
                        color: q.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      dataEntries: skills
                          .map((s) => RadarEntry(value: s.value))
                          .toList(),
                      fillColor: q.accentPurple.withAlpha(100),
                      borderColor: q.accentPurple,
                      borderWidth: 2,
                      entryRadius: 3,
                    ),
                  ],
                  radarBackgroundColor: Colors.transparent,
                  borderData: FlBorderData(show: false),
                  radarBorderData:
                      BorderSide(color: q.accentPurple.withAlpha(60)),
                  tickBorderData:
                      BorderSide(color: q.accentPurple.withAlpha(40)),
                  gridBorderData:
                      BorderSide(color: q.accentPurple.withAlpha(40)),
                  tickCount: 4,
                  ticksTextStyle: TextStyle(
                      color: q.textMuted, fontSize: 8),
                  titlePositionPercentageOffset: 0.2,
                  getTitle: (index, angle) => RadarChartTitle(
                    text: skills[index].name,
                    angle: 0,
                  ),
                  titleTextStyle: TextStyle(
                      color: q.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.trending_up, size: 16, color: q.accentMint),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('Forces : $strengths',
                      style: TextStyle(color: q.textMuted, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.trending_down, size: 16, color: q.accentRed),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('A developper : $weaknesses',
                      style: TextStyle(color: q.textMuted, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
