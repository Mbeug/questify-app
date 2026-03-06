import 'package:flutter/material.dart';

import '../../../models/group.dart';
import '../../../theme.dart';

/// Guild header with banner, info and weekly progress bar.
class GuildHeader extends StatelessWidget {
  final QuestGroup group;
  final bool isLeader;
  final QuestifyColors q;

  const GuildHeader({
    super.key,
    required this.group,
    required this.isLeader,
    required this.q,
  });

  @override
  Widget build(BuildContext context) {
    final progress = group.weeklyGoal > 0
        ? (group.weeklyProgress / group.weeklyGoal).clamp(0.0, 1.0)
        : 0.0;
    final remaining = (group.weeklyGoal - group.weeklyProgress).clamp(0, 9999);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [q.bgSecondary, q.bgPrimary],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Column(
            children: [
              // Guild info row
              Row(
                children: [
                  // Shield icon
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: q.bgSecondary,
                      border: Border.all(color: q.accentGold, width: 3),
                      boxShadow: [
                        BoxShadow(color: q.glowGold, blurRadius: 10),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        group.bannerEmoji ?? '\uD83D\uDEE1\uFE0F',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: TextStyle(
                            color: q.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            SmallBadge(
                              color: q.accentGold,
                              icon: Icons.people,
                              text: '${group.memberCount} membres',
                            ),
                            const SizedBox(width: 8),
                            SmallBadge(
                              color: q.accentMint,
                              icon: Icons.local_fire_department,
                              text: 'Actif',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isLeader)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: q.bgSecondary,
                      ),
                      child: Icon(Icons.settings,
                          size: 20, color: q.textMuted),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Weekly objective card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: q.bgSecondary,
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: q.accentGold.withAlpha(60), width: 2),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.gps_fixed,
                                size: 18, color: q.accentGold),
                            const SizedBox(width: 8),
                            Text('Objectif hebdomadaire',
                                style: TextStyle(
                                    color: q.textPrimary, fontSize: 14)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: q.accentGold,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${group.weeklyProgress}/${group.weeklyGoal}',
                            style: TextStyle(
                              color: q.bgPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Stack(
                        children: [
                          Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: q.bgPrimary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: progress,
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  q.accentGold,
                                  q.accentMint,
                                ]),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: q.glowGold,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      remaining > 0
                          ? 'Plus que $remaining quetes pour debloquer le coffre legendaire!'
                          : 'Objectif atteint! Bravo a toute la guilde!',
                      style: TextStyle(color: q.textMuted, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small colored badge with icon and text.
class SmallBadge extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  const SmallBadge(
      {super.key,
      required this.color,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
