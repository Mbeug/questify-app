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
      createdAt: json['createdAt'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'xp': instance.xp,
      'level': instance.level,
      'createdAt': instance.createdAt,
      'notificationsEnabled': instance.notificationsEnabled,
    };
