import 'package:test/test.dart';
import 'package:frontend/models/group.dart';

void main() {
  group('QuestGroup', () {
    test('fromJson creates a valid QuestGroup with all fields', () {
      final json = {
        'id': 1,
        'name': 'Les Aventuriers',
        'description': 'Un groupe de quêteurs',
        'bannerEmoji': '⚔️',
        'inviteCode': 'ABC123',
        'weeklyGoal': 20,
        'weeklyProgress': 5,
        'memberCount': 3,
        'createdAt': '2025-01-15T10:00:00',
        'members': [
          {
            'userId': 10,
            'displayName': 'Alice',
            'avatarId': 'avatar_1',
            'level': 5,
            'weeklyXp': 300,
            'weeklyQuestsCompleted': 7,
            'role': 'LEADER',
            'joinedAt': '2025-01-15T10:00:00',
          },
          {
            'userId': 20,
            'displayName': 'Bob',
            'level': 3,
            'weeklyXp': 100,
            'weeklyQuestsCompleted': 2,
            'role': 'MEMBER',
          },
        ],
      };

      final group = QuestGroup.fromJson(json);

      expect(group.id, 1);
      expect(group.name, 'Les Aventuriers');
      expect(group.description, 'Un groupe de quêteurs');
      expect(group.bannerEmoji, '⚔️');
      expect(group.inviteCode, 'ABC123');
      expect(group.weeklyGoal, 20);
      expect(group.weeklyProgress, 5);
      expect(group.memberCount, 3);
      expect(group.createdAt, '2025-01-15T10:00:00');
      expect(group.members.length, 2);
    });

    test('fromJson with minimal fields uses defaults', () {
      final json = {
        'id': 2,
        'name': 'Solo',
        'inviteCode': 'XYZ',
      };

      final group = QuestGroup.fromJson(json);

      expect(group.id, 2);
      expect(group.name, 'Solo');
      expect(group.description, isNull);
      expect(group.bannerEmoji, isNull);
      expect(group.weeklyGoal, 10);
      expect(group.weeklyProgress, 0);
      expect(group.memberCount, 0);
      expect(group.createdAt, isNull);
      expect(group.members, isEmpty);
    });

    test('toJson produces correct map', () {
      const group = QuestGroup(
        id: 1,
        name: 'Test',
        inviteCode: 'CODE',
        weeklyGoal: 15,
      );

      final json = group.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Test');
      expect(json['inviteCode'], 'CODE');
      expect(json['weeklyGoal'], 15);
      expect(json['weeklyProgress'], 0);
      expect(json['memberCount'], 0);
      expect(json['members'], isEmpty);
    });

    test('toJson/fromJson roundtrip is consistent', () {
      const original = QuestGroup(
        id: 5,
        name: 'Roundtrip',
        description: 'Test roundtrip',
        inviteCode: 'RT01',
        weeklyGoal: 25,
        weeklyProgress: 10,
        memberCount: 4,
      );

      final json = original.toJson();
      final restored = QuestGroup.fromJson(json);

      expect(restored, equals(original));
    });

    test('equality works via freezed', () {
      const a = QuestGroup(id: 1, name: 'A', inviteCode: 'X');
      const b = QuestGroup(id: 1, name: 'A', inviteCode: 'X');

      expect(a, equals(b));
    });
  });

  group('GroupMember', () {
    test('fromJson creates a valid GroupMember', () {
      final json = {
        'userId': 42,
        'displayName': 'Charlie',
        'avatarId': 'av_3',
        'level': 10,
        'weeklyXp': 500,
        'weeklyQuestsCompleted': 12,
        'role': 'LEADER',
        'joinedAt': '2025-02-01T08:00:00',
      };

      final member = GroupMember.fromJson(json);

      expect(member.userId, 42);
      expect(member.displayName, 'Charlie');
      expect(member.avatarId, 'av_3');
      expect(member.level, 10);
      expect(member.weeklyXp, 500);
      expect(member.weeklyQuestsCompleted, 12);
      expect(member.role, GroupRole.LEADER);
      expect(member.joinedAt, '2025-02-01T08:00:00');
    });

    test('fromJson with defaults', () {
      final json = {
        'userId': 1,
        'displayName': 'Default',
      };

      final member = GroupMember.fromJson(json);

      expect(member.level, 1);
      expect(member.weeklyXp, 0);
      expect(member.weeklyQuestsCompleted, 0);
      expect(member.role, GroupRole.MEMBER);
      expect(member.avatarId, isNull);
      expect(member.joinedAt, isNull);
    });

    test('all GroupRole values deserialize correctly', () {
      for (final role in GroupRole.values) {
        final json = {
          'userId': 1,
          'displayName': 'T',
          'role': role.name,
        };
        final member = GroupMember.fromJson(json);
        expect(member.role, role);
      }
    });

    test('toJson/fromJson roundtrip is consistent', () {
      const original = GroupMember(
        userId: 7,
        displayName: 'Round',
        level: 3,
        weeklyXp: 150,
        weeklyQuestsCompleted: 4,
        role: GroupRole.LEADER,
      );

      final json = original.toJson();
      final restored = GroupMember.fromJson(json);

      expect(restored, equals(original));
    });
  });
}
