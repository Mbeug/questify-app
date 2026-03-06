import 'package:test/test.dart';
import 'package:frontend/models/achievement.dart';

void main() {
  group('Achievement', () {
    test('fromJson creates a valid Achievement with all fields', () {
      final json = {
        'id': 1,
        'achievementKey': 'first_quest',
        'name': 'Première Quête',
        'description': 'Complète ta première quête',
        'icon': '🏆',
        'category': 'QUESTS',
        'threshold': 1,
        'coinReward': 50,
        'gemReward': 5,
        'progress': 1,
        'unlocked': true,
        'unlockedAt': '2025-03-01T12:00:00',
      };

      final achievement = Achievement.fromJson(json);

      expect(achievement.id, 1);
      expect(achievement.achievementKey, 'first_quest');
      expect(achievement.name, 'Première Quête');
      expect(achievement.description, 'Complète ta première quête');
      expect(achievement.icon, '🏆');
      expect(achievement.category, AchievementCategory.QUESTS);
      expect(achievement.threshold, 1);
      expect(achievement.coinReward, 50);
      expect(achievement.gemReward, 5);
      expect(achievement.progress, 1);
      expect(achievement.unlocked, true);
      expect(achievement.unlockedAt, '2025-03-01T12:00:00');
    });

    test('fromJson with minimal fields uses defaults', () {
      final json = {
        'id': 2,
        'achievementKey': 'streak_7',
        'name': 'Semaine de feu',
        'category': 'STREAKS',
        'threshold': 7,
      };

      final achievement = Achievement.fromJson(json);

      expect(achievement.id, 2);
      expect(achievement.description, isNull);
      expect(achievement.icon, isNull);
      expect(achievement.coinReward, 0);
      expect(achievement.gemReward, 0);
      expect(achievement.progress, 0);
      expect(achievement.unlocked, false);
      expect(achievement.unlockedAt, isNull);
    });

    test('toJson produces correct map', () {
      const achievement = Achievement(
        id: 1,
        achievementKey: 'lvl_10',
        name: 'Niveau 10',
        category: AchievementCategory.LEVELS,
        threshold: 10,
        coinReward: 100,
        progress: 7,
        unlocked: false,
      );

      final json = achievement.toJson();

      expect(json['id'], 1);
      expect(json['achievementKey'], 'lvl_10');
      expect(json['category'], 'LEVELS');
      expect(json['threshold'], 10);
      expect(json['coinReward'], 100);
      expect(json['progress'], 7);
      expect(json['unlocked'], false);
    });

    test('all AchievementCategory values deserialize correctly', () {
      for (final category in AchievementCategory.values) {
        final json = {
          'id': 1,
          'achievementKey': 'test',
          'name': 'Test',
          'category': category.name,
          'threshold': 1,
        };
        final achievement = Achievement.fromJson(json);
        expect(achievement.category, category);
      }
    });

    test('toJson/fromJson roundtrip is consistent', () {
      const original = Achievement(
        id: 5,
        achievementKey: 'social_king',
        name: 'Roi du social',
        description: 'Rejoins 5 groupes',
        icon: '👑',
        category: AchievementCategory.SOCIAL,
        threshold: 5,
        coinReward: 200,
        gemReward: 20,
        progress: 3,
        unlocked: false,
      );

      final json = original.toJson();
      final restored = Achievement.fromJson(json);

      expect(restored, equals(original));
    });

    test('equality works via freezed', () {
      const a = Achievement(
        id: 1,
        achievementKey: 'k',
        name: 'N',
        category: AchievementCategory.COLLECTION,
        threshold: 10,
      );
      const b = Achievement(
        id: 1,
        achievementKey: 'k',
        name: 'N',
        category: AchievementCategory.COLLECTION,
        threshold: 10,
      );

      expect(a, equals(b));
    });
  });
}
