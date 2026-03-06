import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

enum GroupRole { LEADER, MEMBER }

@freezed
abstract class QuestGroup with _$QuestGroup {
  const factory QuestGroup({
    required int id,
    required String name,
    String? description,
    String? bannerEmoji,
    required String inviteCode,
    @Default(10) int weeklyGoal,
    @Default(0) int weeklyProgress,
    @Default(0) int memberCount,
    String? createdAt,
    @Default([]) List<GroupMember> members,
  }) = _QuestGroup;

  factory QuestGroup.fromJson(Map<String, dynamic> json) =>
      _$QuestGroupFromJson(json);
}

@freezed
abstract class GroupMember with _$GroupMember {
  const factory GroupMember({
    required int userId,
    required String displayName,
    String? avatarId,
    @Default(1) int level,
    @Default(0) int weeklyXp,
    @Default(0) int weeklyQuestsCompleted,
    @Default(GroupRole.MEMBER) GroupRole role,
    String? joinedAt,
  }) = _GroupMember;

  factory GroupMember.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberFromJson(json);
}
