// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserStats _$UserStatsFromJson(Map<String, dynamic> json) => _UserStats(
      xp: (json['xp'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      xpToNextLevel: (json['xpToNextLevel'] as num).toInt(),
      xpForCurrentLevel: (json['xpForCurrentLevel'] as num).toInt(),
      totalQuestsCompleted: (json['totalQuestsCompleted'] as num).toInt(),
      progressPercent: (json['progressPercent'] as num).toDouble(),
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      gems: (json['gems'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      bestStreak: (json['bestStreak'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserStatsToJson(_UserStats instance) =>
    <String, dynamic>{
      'xp': instance.xp,
      'level': instance.level,
      'xpToNextLevel': instance.xpToNextLevel,
      'xpForCurrentLevel': instance.xpForCurrentLevel,
      'totalQuestsCompleted': instance.totalQuestsCompleted,
      'progressPercent': instance.progressPercent,
      'coins': instance.coins,
      'gems': instance.gems,
      'currentStreak': instance.currentStreak,
      'bestStreak': instance.bestStreak,
    };
