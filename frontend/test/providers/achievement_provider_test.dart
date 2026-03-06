import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/achievement.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/providers/achievement_provider.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApi;
  late AchievementNotifier notifier;

  const achievement1 = Achievement(
    id: 1,
    achievementKey: 'first_quest',
    name: 'Première Quête',
    description: 'Complète ta première quête',
    category: AchievementCategory.QUESTS,
    threshold: 1,
    coinReward: 50,
    progress: 1,
    unlocked: true,
    unlockedAt: '2025-03-01T12:00:00',
  );

  const achievement2 = Achievement(
    id: 2,
    achievementKey: 'streak_7',
    name: 'Semaine de feu',
    category: AchievementCategory.STREAKS,
    threshold: 7,
    coinReward: 100,
    progress: 3,
    unlocked: false,
  );

  setUp(() {
    mockApi = MockApiService();
    notifier = AchievementNotifier(mockApi);
  });

  group('AchievementNotifier', () {
    test('initial state is loading', () {
      expect(notifier.state, isA<AsyncLoading>());
    });

    test('loadAchievements success sets data', () async {
      when(() => mockApi.getAchievements())
          .thenAnswer((_) async => [achievement1, achievement2]);

      await notifier.loadAchievements();

      expect(notifier.state, isA<AsyncData<List<Achievement>>>());
      final data = notifier.state.value!;
      expect(data.length, 2);
      expect(data[0].achievementKey, 'first_quest');
      expect(data[0].unlocked, true);
      expect(data[1].achievementKey, 'streak_7');
      expect(data[1].unlocked, false);
    });

    test('loadAchievements error sets AsyncError', () async {
      when(() => mockApi.getAchievements())
          .thenThrow(ApiException('Erreur serveur', statusCode: 500));

      await notifier.loadAchievements();

      expect(notifier.state, isA<AsyncError>());
    });

    test('loadAchievements empty list sets empty data', () async {
      when(() => mockApi.getAchievements()).thenAnswer((_) async => []);

      await notifier.loadAchievements();

      expect(notifier.state, isA<AsyncData<List<Achievement>>>());
      expect(notifier.state.value, isEmpty);
    });

    test('loadAchievements reloading replaces previous data', () async {
      // First load
      when(() => mockApi.getAchievements())
          .thenAnswer((_) async => [achievement1]);
      await notifier.loadAchievements();
      expect(notifier.state.value!.length, 1);

      // Second load with more data
      when(() => mockApi.getAchievements())
          .thenAnswer((_) async => [achievement1, achievement2]);
      await notifier.loadAchievements();
      expect(notifier.state.value!.length, 2);
    });
  });
}
