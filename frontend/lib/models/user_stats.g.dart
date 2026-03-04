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
    );

Map<String, dynamic> _$UserStatsToJson(_UserStats instance) =>
    <String, dynamic>{
      'xp': instance.xp,
      'level': instance.level,
      'xpToNextLevel': instance.xpToNextLevel,
      'xpForCurrentLevel': instance.xpForCurrentLevel,
      'totalQuestsCompleted': instance.totalQuestsCompleted,
      'progressPercent': instance.progressPercent,
    };
