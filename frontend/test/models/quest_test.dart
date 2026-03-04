import 'package:test/test.dart';
import 'package:frontend/models/quest.dart';

void main() {
  group('Quest', () {
    test('fromJson creates a valid Quest', () {
      final json = {
        'id': 10,
        'title': 'Defeat the Dragon',
        'description': 'Slay the ancient dragon',
        'status': 'PENDING',
        'difficulty': 'EPIC',
        'xpReward': 500,
        'dueDate': '2025-12-31',
        'completedAt': null,
        'createdAt': '2025-01-01T00:00:00',
      };

      final quest = Quest.fromJson(json);

      expect(quest.id, 10);
      expect(quest.title, 'Defeat the Dragon');
      expect(quest.description, 'Slay the ancient dragon');
      expect(quest.status, QuestStatus.PENDING);
      expect(quest.difficulty, QuestDifficulty.EPIC);
      expect(quest.xpReward, 500);
      expect(quest.dueDate, '2025-12-31');
      expect(quest.completedAt, isNull);
    });

    test('fromJson with COMPLETED status', () {
      final json = {
        'id': 11,
        'title': 'Gather herbs',
        'status': 'COMPLETED',
        'difficulty': 'EASY',
        'xpReward': 50,
        'completedAt': '2025-06-15T14:00:00',
      };

      final quest = Quest.fromJson(json);

      expect(quest.status, QuestStatus.COMPLETED);
      expect(quest.completedAt, '2025-06-15T14:00:00');
    });

    test('fromJson with levelUpResult', () {
      final json = {
        'id': 12,
        'title': 'Boss fight',
        'status': 'COMPLETED',
        'difficulty': 'HARD',
        'xpReward': 200,
        'levelUpResult': {
          'totalXp': 1200,
          'level': 4,
          'leveledUp': true,
          'xpGained': 200,
          'xpToNextLevel': 300,
        },
      };

      final quest = Quest.fromJson(json);

      expect(quest.levelUpResult, isNotNull);
      expect(quest.levelUpResult!.leveledUp, true);
      expect(quest.levelUpResult!.level, 4);
      expect(quest.levelUpResult!.totalXp, 1200);
      expect(quest.levelUpResult!.xpGained, 200);
      expect(quest.levelUpResult!.xpToNextLevel, 300);
    });

    test('toJson produces correct map', () {
      const quest = Quest(
        id: 1,
        title: 'Test',
        status: QuestStatus.IN_PROGRESS,
        difficulty: QuestDifficulty.MEDIUM,
        xpReward: 100,
      );

      final json = quest.toJson();

      expect(json['id'], 1);
      expect(json['title'], 'Test');
      expect(json['status'], 'IN_PROGRESS');
      expect(json['difficulty'], 'MEDIUM');
      expect(json['xpReward'], 100);
    });

    test('all QuestStatus values deserialize correctly', () {
      for (final status in QuestStatus.values) {
        final json = {
          'id': 1,
          'title': 'T',
          'status': status.name,
          'difficulty': 'EASY',
          'xpReward': 10,
        };
        final quest = Quest.fromJson(json);
        expect(quest.status, status);
      }
    });

    test('all QuestDifficulty values deserialize correctly', () {
      for (final difficulty in QuestDifficulty.values) {
        final json = {
          'id': 1,
          'title': 'T',
          'status': 'PENDING',
          'difficulty': difficulty.name,
          'xpReward': 10,
        };
        final quest = Quest.fromJson(json);
        expect(quest.difficulty, difficulty);
      }
    });

    test('equality works via freezed', () {
      const a = Quest(
        id: 1,
        title: 'A',
        status: QuestStatus.PENDING,
        difficulty: QuestDifficulty.EASY,
        xpReward: 50,
      );
      const b = Quest(
        id: 1,
        title: 'A',
        status: QuestStatus.PENDING,
        difficulty: QuestDifficulty.EASY,
        xpReward: 50,
      );

      expect(a, equals(b));
    });
  });

  group('LevelUpResult', () {
    test('fromJson creates a valid LevelUpResult', () {
      final json = {
        'totalXp': 500,
        'level': 3,
        'leveledUp': true,
        'xpGained': 100,
        'xpToNextLevel': 200,
      };

      final result = LevelUpResult.fromJson(json);

      expect(result.totalXp, 500);
      expect(result.level, 3);
      expect(result.leveledUp, true);
      expect(result.xpGained, 100);
      expect(result.xpToNextLevel, 200);
    });

    test('toJson roundtrip is consistent', () {
      const original = LevelUpResult(
        totalXp: 800,
        level: 5,
        leveledUp: false,
        xpGained: 50,
        xpToNextLevel: 150,
      );

      final json = original.toJson();
      final restored = LevelUpResult.fromJson(json);

      expect(restored, equals(original));
    });
  });
}
