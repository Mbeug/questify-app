import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/achievement.dart';
import '../../../theme.dart';

/// Section displaying the achievements grid.
class AchievementsSection extends StatelessWidget {
  final AsyncValue<List<Achievement>> achievementsAsync;
  final QuestifyColors q;

  const AchievementsSection({
    super.key,
    required this.achievementsAsync,
    required this.q,
  });

  Color _rarityColor(Achievement a) {
    switch (a.category) {
      case AchievementCategory.QUESTS:
        return kAccentMint;
      case AchievementCategory.STREAKS:
        return kAccentGold;
      case AchievementCategory.LEVELS:
        return kAccentPurple;
      case AchievementCategory.SOCIAL:
        return kAccentCyan;
      case AchievementCategory.COLLECTION:
        return kAccentRed;
    }
  }

  IconData _achievementIcon(Achievement a) {
    switch (a.category) {
      case AchievementCategory.QUESTS:
        return Icons.star;
      case AchievementCategory.STREAKS:
        return Icons.emoji_events;
      case AchievementCategory.LEVELS:
        return Icons.shield;
      case AchievementCategory.SOCIAL:
        return Icons.auto_awesome;
      case AchievementCategory.COLLECTION:
        return Icons.collections;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Accomplissements',
              style: TextStyle(
                  color: q.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          achievementsAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Text('Erreur: $e', style: TextStyle(color: q.accentRed)),
            data: (achievements) {
              if (achievements.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: q.bgSecondary,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: q.borderDefault),
                  ),
                  child: Center(
                    child: Text('Aucun accomplissement pour l\'instant',
                        style: TextStyle(color: q.textMuted)),
                  ),
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemCount: achievements.length,
                itemBuilder: (ctx, i) {
                  final a = achievements[i];
                  final color = _rarityColor(a);
                  final icon = _achievementIcon(a);
                  return AnimatedOpacity(
                    duration: Duration(milliseconds: 300 + i * 80),
                    opacity: 1,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: q.bgSecondary,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: a.unlocked ? color : q.borderDefault,
                          width: 2,
                        ),
                      ),
                      child: Opacity(
                        opacity: a.unlocked ? 1 : 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: a.unlocked
                                    ? color.withAlpha(50)
                                    : q.bgTertiary,
                                border: Border.all(
                                  color: a.unlocked
                                      ? color
                                      : q.borderDefault,
                                  width: 2,
                                ),
                              ),
                              child: Icon(icon,
                                  size: 22,
                                  color:
                                      a.unlocked ? color : q.borderDefault),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              a.name,
                              style: TextStyle(
                                  color: q.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
