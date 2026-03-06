import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest.freezed.dart';
part 'quest.g.dart';

enum QuestStatus { PENDING, IN_PROGRESS, COMPLETED }

enum QuestDifficulty { EASY, MEDIUM, HARD, EPIC }

enum QuestCategory { HOME, SPORT, PERSONAL, WORK }

enum QuestRecurrence { ONE_TIME, DAILY, WEEKLY }

@freezed
abstract class Quest with _$Quest {
  const factory Quest({
    required int id,
    required String title,
    String? description,
    required QuestStatus status,
    required QuestDifficulty difficulty,
    required int xpReward,
    @Default(0) int coinReward,
    QuestCategory? category,
    @Default(QuestRecurrence.ONE_TIME) QuestRecurrence recurrence,
    String? rarity,
    String? dueDate,
    String? completedAt,
    String? createdAt,
    String? calendarEventId,
    LevelUpResult? levelUpResult,
  }) = _Quest;

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
}

@freezed
abstract class LevelUpResult with _$LevelUpResult {
  const factory LevelUpResult({
    required int totalXp,
    required int level,
    required bool leveledUp,
    required int xpGained,
    required int xpToNextLevel,
    @Default(0) int coinsEarned,
    @Default(0) int gemsEarned,
  }) = _LevelUpResult;

  factory LevelUpResult.fromJson(Map<String, dynamic> json) =>
      _$LevelUpResultFromJson(json);
}
