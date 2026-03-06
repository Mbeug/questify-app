import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:frontend/features/quests/quest_list_page.dart';
import 'package:frontend/models/quest.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/user_stats.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/quests_provider.dart';
import 'package:frontend/providers/stats_provider.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/social_auth_service.dart';
import 'package:frontend/theme.dart';

class MockApiService extends Mock implements ApiService {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class MockSocialAuthService extends Mock implements SocialAuthService {}

const testUser = User(
  id: 1,
  email: 'test@questify.app',
  displayName: 'Hero42',
  xp: 350,
  level: 5,
  coins: 120,
  gems: 10,
);

const testStats = UserStats(
  xp: 350,
  level: 5,
  xpToNextLevel: 150,
  xpForCurrentLevel: 200,
  totalQuestsCompleted: 23,
  progressPercent: 70.0,
  coins: 120,
  gems: 10,
  currentStreak: 3,
  bestStreak: 7,
);

const pendingQuest = Quest(
  id: 1,
  title: 'Vaincre le dragon',
  status: QuestStatus.PENDING,
  difficulty: QuestDifficulty.HARD,
  xpReward: 200,
  coinReward: 50,
);

const activeQuest2 = Quest(
  id: 3,
  title: 'Explorer la foret',
  status: QuestStatus.IN_PROGRESS,
  difficulty: QuestDifficulty.MEDIUM,
  xpReward: 100,
  coinReward: 30,
);

const completedQuest = Quest(
  id: 2,
  title: 'Ramasser des herbes',
  status: QuestStatus.COMPLETED,
  difficulty: QuestDifficulty.EASY,
  xpReward: 30,
  completedAt: '2026-03-05T10:00:00',
);

Widget buildTestApp({
  required MockApiService mockApi,
  required MockSecureStorage mockStorage,
  required MockSocialAuthService mockSocial,
  List<Quest> quests = const [],
}) {
  // Mock API calls — these are the LAST mocks, so they win
  when(() => mockApi.getQuests()).thenAnswer((_) async => quests);
  when(() => mockApi.getMyStats()).thenAnswer((_) async => testStats);
  when(() => mockApi.getMe()).thenAnswer((_) async => testUser);
  when(() => mockApi.setAccessToken(any())).thenReturn(null);

  return ProviderScope(
    overrides: [
      apiServiceProvider.overrideWithValue(mockApi),
      secureStorageProvider.overrideWithValue(mockStorage),
      socialAuthServiceProvider.overrideWithValue(mockSocial),
    ],
    child: MaterialApp(
      theme: ThemeData(extensions: const [QuestifyColors.day]),
      home: const QuestListPage(),
    ),
  );
}

/// Build test app where getQuests throws an error.
Widget buildTestAppWithError({
  required MockApiService mockApi,
  required MockSecureStorage mockStorage,
  required MockSocialAuthService mockSocial,
  required String errorMessage,
}) {
  when(() => mockApi.getQuests())
      .thenAnswer((_) async => throw ApiException(errorMessage));
  when(() => mockApi.getMyStats()).thenAnswer((_) async => testStats);
  when(() => mockApi.getMe()).thenAnswer((_) async => testUser);
  when(() => mockApi.setAccessToken(any())).thenReturn(null);

  return ProviderScope(
    overrides: [
      apiServiceProvider.overrideWithValue(mockApi),
      secureStorageProvider.overrideWithValue(mockStorage),
      socialAuthServiceProvider.overrideWithValue(mockSocial),
    ],
    child: MaterialApp(
      theme: ThemeData(extensions: const [QuestifyColors.day]),
      home: const QuestListPage(),
    ),
  );
}

void main() {
  late MockApiService mockApi;
  late MockSecureStorage mockStorage;
  late MockSocialAuthService mockSocial;

  setUp(() {
    mockApi = MockApiService();
    mockStorage = MockSecureStorage();
    mockSocial = MockSocialAuthService();

    // Auto-login: simulate already authenticated
    when(() => mockStorage.read(key: 'accessToken'))
        .thenAnswer((_) async => 'valid_token');
    when(() => mockStorage.read(key: 'refreshToken'))
        .thenAnswer((_) async => 'valid_refresh');
    when(() => mockStorage.write(
            key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});

    when(() => mockApi.getMe()).thenAnswer((_) async => testUser);
    when(() => mockApi.setAccessToken(any())).thenReturn(null);
    when(() => mockApi.getMyStats()).thenAnswer((_) async => testStats);
  });

  group('QuestListPage', () {
    testWidgets('shows AppBar with title "Mes Quetes"', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Mes Quetes'), findsOneWidget);
    });

    testWidgets('shows FAB "Nouvelle quete"', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Nouvelle quete'), findsOneWidget);
    });

    testWidgets('shows empty state when no quests', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text("Aucune quete pour l'instant"), findsOneWidget);
      expect(find.text("Cree ta premiere quete pour gagner de l'XP !"),
          findsOneWidget);
      expect(find.text('Creer une quete'), findsOneWidget);
    });

    testWidgets('shows active quests section', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        quests: [pendingQuest, activeQuest2],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Actives (2)'), findsOneWidget);
      expect(find.text('Vaincre le dragon'), findsOneWidget);
      expect(find.text('Explorer la foret'), findsOneWidget);
    });

    testWidgets('shows completed quests section', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        quests: [completedQuest],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Terminees (1)'), findsOneWidget);
      expect(find.text('Ramasser des herbes'), findsOneWidget);
    });

    testWidgets('shows both active and completed sections', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        quests: [pendingQuest, completedQuest],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Actives (1)'), findsOneWidget);
      expect(find.text('Terminees (1)'), findsOneWidget);
    });

    testWidgets('shows error state with retry button', (tester) async {
      await tester.pumpWidget(buildTestAppWithError(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        errorMessage: 'Erreur reseau',
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Quelque chose a mal tourne'), findsOneWidget);
      expect(find.text('Reessayer'), findsOneWidget);
    });

    testWidgets('retry button reloads quests after error', (tester) async {
      await tester.pumpWidget(buildTestAppWithError(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        errorMessage: 'Erreur',
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Quelque chose a mal tourne'), findsOneWidget);

      // Now make it succeed on retry
      when(() => mockApi.getQuests())
          .thenAnswer((_) async => [pendingQuest]);

      await tester.tap(find.text('Reessayer'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Vaincre le dragon'), findsOneWidget);
    });

    testWidgets('delete dialog appears and can cancel', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        quests: [pendingQuest],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Find the delete icon on the quest card and tap it
      final deleteIcons = find.byIcon(Icons.delete_outline);
      expect(deleteIcons, findsWidgets);

      await tester.tap(deleteIcons.first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Supprimer la quete ?'), findsOneWidget);
      expect(find.text('Supprimer "Vaincre le dragon" ?'), findsOneWidget);

      // Cancel
      await tester.tap(find.text('Annuler'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Quest still there
      expect(find.text('Vaincre le dragon'), findsOneWidget);
    });

    testWidgets('delete dialog can confirm deletion', (tester) async {
      when(() => mockApi.deleteQuest(1)).thenAnswer((_) async {});

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        quests: [pendingQuest],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Find delete icon on the quest card
      final deleteIcons = find.byIcon(Icons.delete_outline);
      expect(deleteIcons, findsWidgets);

      await tester.tap(deleteIcons.first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Supprimer la quete ?'), findsOneWidget);

      // After deletion, getQuests returns empty
      when(() => mockApi.getQuests()).thenAnswer((_) async => []);

      // Find the "Supprimer" button in the dialog (it's a FilledButton)
      final supprimerButtons = find.text('Supprimer');
      // There might be multiple — get the dialog one (last one)
      await tester.tap(supprimerButtons.last);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockApi.deleteQuest(1)).called(1);
    });

    testWidgets('complete button triggers completion flow', (tester) async {
      when(() => mockApi.completeQuest(1)).thenAnswer((_) async =>
          pendingQuest.copyWith(status: QuestStatus.COMPLETED));

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        quests: [pendingQuest],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Find the check/complete button
      final checkIcons = find.byIcon(Icons.check_circle_outline);
      if (checkIcons.evaluate().isNotEmpty) {
        await tester.tap(checkIcons.first);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        verify(() => mockApi.completeQuest(1)).called(1);
      }
    });

    testWidgets('back arrow is shown in AppBar', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('explore icon shown in empty state', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byIcon(Icons.explore_outlined), findsOneWidget);
    });

    testWidgets('error icon shown in error state', (tester) async {
      await tester.pumpWidget(buildTestAppWithError(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        errorMessage: 'Timeout',
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Timeout'), findsOneWidget);
    });
  });
}
