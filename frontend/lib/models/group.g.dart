// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestGroup _$QuestGroupFromJson(Map<String, dynamic> json) => _QuestGroup(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      bannerEmoji: json['bannerEmoji'] as String?,
      inviteCode: json['inviteCode'] as String,
      weeklyGoal: (json['weeklyGoal'] as num?)?.toInt() ?? 10,
      weeklyProgress: (json['weeklyProgress'] as num?)?.toInt() ?? 0,
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String?,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => GroupMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$QuestGroupToJson(_QuestGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'bannerEmoji': instance.bannerEmoji,
      'inviteCode': instance.inviteCode,
      'weeklyGoal': instance.weeklyGoal,
      'weeklyProgress': instance.weeklyProgress,
      'memberCount': instance.memberCount,
      'createdAt': instance.createdAt,
      'members': instance.members,
    };

_GroupMember _$GroupMemberFromJson(Map<String, dynamic> json) => _GroupMember(
      userId: (json['userId'] as num).toInt(),
      displayName: json['displayName'] as String,
      avatarId: json['avatarId'] as String?,
      level: (json['level'] as num?)?.toInt() ?? 1,
      weeklyXp: (json['weeklyXp'] as num?)?.toInt() ?? 0,
      weeklyQuestsCompleted:
          (json['weeklyQuestsCompleted'] as num?)?.toInt() ?? 0,
      role: $enumDecodeNullable(_$GroupRoleEnumMap, json['role']) ??
          GroupRole.MEMBER,
      joinedAt: json['joinedAt'] as String?,
    );

Map<String, dynamic> _$GroupMemberToJson(_GroupMember instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'avatarId': instance.avatarId,
      'level': instance.level,
      'weeklyXp': instance.weeklyXp,
      'weeklyQuestsCompleted': instance.weeklyQuestsCompleted,
      'role': _$GroupRoleEnumMap[instance.role]!,
      'joinedAt': instance.joinedAt,
    };

const _$GroupRoleEnumMap = {
  GroupRole.LEADER: 'LEADER',
  GroupRole.MEMBER: 'MEMBER',
};
