import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/models/user_stats.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/providers/stats_provider.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApi;
  late StatsNotifier notifier;

  const stats = UserStats(
    xp: 750,
    level: 4,
    xpToNextLevel: 250,
    xpForCurrentLevel: 200,
    totalQuestsCompleted: 15,
    progressPercent: 0.75,
  );

  setUp(() {
    mockApi = MockApiService();
    notifier = StatsNotifier(mockApi);
  });

  group('StatsNotifier', () {
    test('initial state is loading', () {
      expect(notifier.state, isA<AsyncLoading<UserStats>>());
    });

    test('loadStats success sets data', () async {
      when(() => mockApi.getMyStats()).thenAnswer((_) async => stats);

      await notifier.loadStats();

      expect(notifier.state, isA<AsyncData<UserStats>>());
      expect(notifier.state.value, stats);
      expect(notifier.state.value!.xp, 750);
      expect(notifier.state.value!.level, 4);
      expect(notifier.state.value!.totalQuestsCompleted, 15);
    });

    test('loadStats error sets error state', () async {
      when(() => mockApi.getMyStats())
          .thenThrow(ApiException('Non autorise', statusCode: 401));

      await notifier.loadStats();

      expect(notifier.state, isA<AsyncError<UserStats>>());
      expect(notifier.state.error, isA<ApiException>());
    });

    test('loadStats can be called again after error', () async {
      when(() => mockApi.getMyStats())
          .thenThrow(ApiException('Erreur', statusCode: 500));
      await notifier.loadStats();
      expect(notifier.state, isA<AsyncError<UserStats>>());

      // Now succeed
      when(() => mockApi.getMyStats()).thenAnswer((_) async => stats);
      await notifier.loadStats();
      expect(notifier.state, isA<AsyncData<UserStats>>());
      expect(notifier.state.value, stats);
    });
  });
}
