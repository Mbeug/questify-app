// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      xp: (json['xp'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      gems: (json['gems'] as num?)?.toInt() ?? 0,
      avatarId: json['avatarId'] as String?,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      bestStreak: (json['bestStreak'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'xp': instance.xp,
      'level': instance.level,
      'coins': instance.coins,
      'gems': instance.gems,
      'avatarId': instance.avatarId,
      'currentStreak': instance.currentStreak,
      'bestStreak': instance.bestStreak,
      'createdAt': instance.createdAt,
      'notificationsEnabled': instance.notificationsEnabled,
    };
