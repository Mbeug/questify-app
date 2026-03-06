// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Achievement _$AchievementFromJson(Map<String, dynamic> json) => _Achievement(
      id: (json['id'] as num).toInt(),
      achievementKey: json['achievementKey'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      category: $enumDecode(_$AchievementCategoryEnumMap, json['category']),
      threshold: (json['threshold'] as num).toInt(),
      coinReward: (json['coinReward'] as num?)?.toInt() ?? 0,
      gemReward: (json['gemReward'] as num?)?.toInt() ?? 0,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      unlocked: json['unlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] as String?,
    );

Map<String, dynamic> _$AchievementToJson(_Achievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'achievementKey': instance.achievementKey,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'category': _$AchievementCategoryEnumMap[instance.category]!,
      'threshold': instance.threshold,
      'coinReward': instance.coinReward,
      'gemReward': instance.gemReward,
      'progress': instance.progress,
      'unlocked': instance.unlocked,
      'unlockedAt': instance.unlockedAt,
    };

const _$AchievementCategoryEnumMap = {
  AchievementCategory.QUESTS: 'QUESTS',
  AchievementCategory.STREAKS: 'STREAKS',
  AchievementCategory.LEVELS: 'LEVELS',
  AchievementCategory.SOCIAL: 'SOCIAL',
  AchievementCategory.COLLECTION: 'COLLECTION',
};
