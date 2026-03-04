// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Quest _$QuestFromJson(Map<String, dynamic> json) => _Quest(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      status: $enumDecode(_$QuestStatusEnumMap, json['status']),
      difficulty: $enumDecode(_$QuestDifficultyEnumMap, json['difficulty']),
      xpReward: (json['xpReward'] as num).toInt(),
      dueDate: json['dueDate'] as String?,
      completedAt: json['completedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      calendarEventId: json['calendarEventId'] as String?,
      levelUpResult: json['levelUpResult'] == null
          ? null
          : LevelUpResult.fromJson(
              json['levelUpResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuestToJson(_Quest instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': _$QuestStatusEnumMap[instance.status]!,
      'difficulty': _$QuestDifficultyEnumMap[instance.difficulty]!,
      'xpReward': instance.xpReward,
      'dueDate': instance.dueDate,
      'completedAt': instance.completedAt,
      'createdAt': instance.createdAt,
      'calendarEventId': instance.calendarEventId,
      'levelUpResult': instance.levelUpResult,
    };

const _$QuestStatusEnumMap = {
  QuestStatus.PENDING: 'PENDING',
  QuestStatus.IN_PROGRESS: 'IN_PROGRESS',
  QuestStatus.COMPLETED: 'COMPLETED',
};

const _$QuestDifficultyEnumMap = {
  QuestDifficulty.EASY: 'EASY',
  QuestDifficulty.MEDIUM: 'MEDIUM',
  QuestDifficulty.HARD: 'HARD',
  QuestDifficulty.EPIC: 'EPIC',
};

_LevelUpResult _$LevelUpResultFromJson(Map<String, dynamic> json) =>
    _LevelUpResult(
      totalXp: (json['totalXp'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      leveledUp: json['leveledUp'] as bool,
      xpGained: (json['xpGained'] as num).toInt(),
      xpToNextLevel: (json['xpToNextLevel'] as num).toInt(),
    );

Map<String, dynamic> _$LevelUpResultToJson(_LevelUpResult instance) =>
    <String, dynamic>{
      'totalXp': instance.totalXp,
      'level': instance.level,
      'leveledUp': instance.leveledUp,
      'xpGained': instance.xpGained,
      'xpToNextLevel': instance.xpToNextLevel,
    };
