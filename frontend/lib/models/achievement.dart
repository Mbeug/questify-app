import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

enum AchievementCategory { QUESTS, STREAKS, LEVELS, SOCIAL, COLLECTION }

@freezed
abstract class Achievement with _$Achievement {
  const factory Achievement({
    required int id,
    required String achievementKey,
    required String name,
    String? description,
    String? icon,
    required AchievementCategory category,
    required int threshold,
    @Default(0) int coinReward,
    @Default(0) int gemReward,
    @Default(0) int progress,
    @Default(false) bool unlocked,
    String? unlockedAt,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
}
