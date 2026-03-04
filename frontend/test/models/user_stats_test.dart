import 'package:test/test.dart';
import 'package:frontend/models/user_stats.dart';

void main() {
  group('UserStats', () {
    test('fromJson creates a valid UserStats', () {
      final json = {
        'xp': 750,
        'level': 4,
        'xpToNextLevel': 250,
        'xpForCurrentLevel': 200,
        'totalQuestsCompleted': 15,
        'progressPercent': 0.75,
      };

      final stats = UserStats.fromJson(json);

      expect(stats.xp, 750);
      expect(stats.level, 4);
      expect(stats.xpToNextLevel, 250);
      expect(stats.xpForCurrentLevel, 200);
      expect(stats.totalQuestsCompleted, 15);
      expect(stats.progressPercent, 0.75);
    });

    test('fromJson handles integer progressPercent', () {
      final json = {
        'xp': 0,
        'level': 1,
        'xpToNextLevel': 100,
        'xpForCurrentLevel': 0,
        'totalQuestsCompleted': 0,
        'progressPercent': 0,
      };

      final stats = UserStats.fromJson(json);

      expect(stats.progressPercent, 0.0);
    });

    test('toJson produces correct map', () {
      const stats = UserStats(
        xp: 500,
        level: 3,
        xpToNextLevel: 150,
        xpForCurrentLevel: 100,
        totalQuestsCompleted: 10,
        progressPercent: 0.5,
      );

      final json = stats.toJson();

      expect(json['xp'], 500);
      expect(json['level'], 3);
      expect(json['xpToNextLevel'], 150);
      expect(json['xpForCurrentLevel'], 100);
      expect(json['totalQuestsCompleted'], 10);
      expect(json['progressPercent'], 0.5);
    });

    test('toJson/fromJson roundtrip is consistent', () {
      const original = UserStats(
        xp: 1200,
        level: 6,
        xpToNextLevel: 350,
        xpForCurrentLevel: 300,
        totalQuestsCompleted: 25,
        progressPercent: 0.85,
      );

      final json = original.toJson();
      final restored = UserStats.fromJson(json);

      expect(restored, equals(original));
    });

    test('equality works via freezed', () {
      const a = UserStats(
        xp: 100,
        level: 2,
        xpToNextLevel: 50,
        xpForCurrentLevel: 50,
        totalQuestsCompleted: 5,
        progressPercent: 0.5,
      );
      const b = UserStats(
        xp: 100,
        level: 2,
        xpToNextLevel: 50,
        xpForCurrentLevel: 50,
        totalQuestsCompleted: 5,
        progressPercent: 0.5,
      );

      expect(a, equals(b));
    });
  });
}
