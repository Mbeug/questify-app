import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/models/quest.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/providers/quests_provider.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApi;
  late QuestsNotifier notifier;

  setUpAll(() {
    registerFallbackValue(QuestDifficulty.EASY);
    registerFallbackValue(QuestStatus.PENDING);
  });

  const quest1 = Quest(
    id: 1,
    title: 'Quest A',
    status: QuestStatus.PENDING,
    difficulty: QuestDifficulty.EASY,
    xpReward: 50,
  );

  const quest2 = Quest(
    id: 2,
    title: 'Quest B',
    description: 'A harder quest',
    status: QuestStatus.IN_PROGRESS,
    difficulty: QuestDifficulty.HARD,
    xpReward: 200,
  );

  const completedQuest = Quest(
    id: 1,
    title: 'Quest A',
    status: QuestStatus.COMPLETED,
    difficulty: QuestDifficulty.EASY,
    xpReward: 50,
    completedAt: '2025-06-01T12:00:00',
    levelUpResult: LevelUpResult(
      totalXp: 150,
      level: 2,
      leveledUp: true,
      xpGained: 50,
      xpToNextLevel: 100,
    ),
  );

  setUp(() {
    mockApi = MockApiService();
    notifier = QuestsNotifier(mockApi);
  });

  group('QuestsNotifier', () {
    test('initial state is empty and not loading', () {
      expect(notifier.state.quests, isEmpty);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.error, isNull);
    });

    test('loadQuests success populates quests', () async {
      when(() => mockApi.getQuests()).thenAnswer((_) async => [quest1, quest2]);

      await notifier.loadQuests();

      expect(notifier.state.quests, [quest1, quest2]);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.error, isNull);
    });

    test('loadQuests ApiException sets error', () async {
      when(() => mockApi.getQuests())
          .thenThrow(ApiException('Erreur serveur', statusCode: 500));

      await notifier.loadQuests();

      expect(notifier.state.quests, isEmpty);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.error, 'Erreur serveur');
    });

    test('loadQuests generic exception sets default error', () async {
      when(() => mockApi.getQuests()).thenThrow(Exception('network failure'));

      await notifier.loadQuests();

      expect(notifier.state.error, 'Erreur de chargement des quetes');
    });

    test('createQuest success prepends quest', () async {
      when(() => mockApi.createQuest(
            title: 'New Quest',
            description: null,
            difficulty: QuestDifficulty.MEDIUM,
            dueDate: null,
          )).thenAnswer((_) async => const Quest(
            id: 3,
            title: 'New Quest',
            status: QuestStatus.PENDING,
            difficulty: QuestDifficulty.MEDIUM,
            xpReward: 100,
          ));

      // Pre-populate state
      when(() => mockApi.getQuests()).thenAnswer((_) async => [quest1]);
      await notifier.loadQuests();

      final result = await notifier.createQuest(
        title: 'New Quest',
        difficulty: QuestDifficulty.MEDIUM,
      );

      expect(result, isNotNull);
      expect(result!.id, 3);
      expect(notifier.state.quests.length, 2);
      expect(notifier.state.quests.first.id, 3);
    });

    test('createQuest ApiException returns null and sets error', () async {
      when(() => mockApi.createQuest(
            title: any(named: 'title'),
            description: any(named: 'description'),
            difficulty: any(named: 'difficulty'),
            dueDate: any(named: 'dueDate'),
          )).thenThrow(ApiException('Titre requis', statusCode: 400));

      final result = await notifier.createQuest(
        title: '',
        difficulty: QuestDifficulty.EASY,
      );

      expect(result, isNull);
      expect(notifier.state.error, 'Titre requis');
    });

    test('completeQuest success updates quest in list', () async {
      when(() => mockApi.getQuests(status: any(named: 'status')))
          .thenAnswer((_) async => [quest1, quest2]);
      when(() => mockApi.getQuests())
          .thenAnswer((_) async => [quest1, quest2]);
      await notifier.loadQuests();

      when(() => mockApi.completeQuest(1))
          .thenAnswer((_) async => completedQuest);

      final result = await notifier.completeQuest(1);

      expect(result, isNotNull);
      expect(result!.status, QuestStatus.COMPLETED);
      expect(result.levelUpResult, isNotNull);
      expect(result.levelUpResult!.leveledUp, true);

      final updated = notifier.state.quests.firstWhere((q) => q.id == 1);
      expect(updated.status, QuestStatus.COMPLETED);
    });

    test('completeQuest ApiException returns null', () async {
      when(() => mockApi.getQuests()).thenAnswer((_) async => [quest1]);
      await notifier.loadQuests();

      when(() => mockApi.completeQuest(1))
          .thenThrow(ApiException('Deja completee', statusCode: 409));

      final result = await notifier.completeQuest(1);

      expect(result, isNull);
      expect(notifier.state.error, 'Deja completee');
    });

    test('deleteQuest success removes quest from list', () async {
      when(() => mockApi.getQuests()).thenAnswer((_) async => [quest1, quest2]);
      await notifier.loadQuests();

      when(() => mockApi.deleteQuest(1)).thenAnswer((_) async {});

      final result = await notifier.deleteQuest(1);

      expect(result, true);
      expect(notifier.state.quests.length, 1);
      expect(notifier.state.quests.first.id, 2);
    });

    test('deleteQuest ApiException returns false', () async {
      when(() => mockApi.getQuests()).thenAnswer((_) async => [quest1]);
      await notifier.loadQuests();

      when(() => mockApi.deleteQuest(1))
          .thenThrow(ApiException('Non autorise', statusCode: 403));

      final result = await notifier.deleteQuest(1);

      expect(result, false);
      expect(notifier.state.error, 'Non autorise');
      expect(notifier.state.quests.length, 1); // Not removed
    });
  });
}
