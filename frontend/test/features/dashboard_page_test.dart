import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:frontend/features/dashboard/dashboard_page.dart';
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

const activeQuest = Quest(
  id: 1,
  title: 'Vaincre le dragon',
  status: QuestStatus.PENDING,
  difficulty: QuestDifficulty.HARD,
  xpReward: 200,
  coinReward: 50,
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
  QuestsState questsState = const QuestsState(),
  UserStats? stats,
  User? user,
  bool statsLoading = false,
}) {
  final api = mockApi;

  // Mock getQuests to return current quests state
  when(() => api.getQuests())
      .thenAnswer((_) async => questsState.quests);

  // Mock getMyStats
  when(() => api.getMyStats())
      .thenAnswer((_) async => stats ?? testStats);

  // Mock refreshUser — use provided user or default testUser
  when(() => api.getMe())
      .thenAnswer((_) async => user ?? testUser);
  when(() => api.setAccessToken(any())).thenReturn(null);

  return ProviderScope(
    overrides: [
      apiServiceProvider.overrideWithValue(api),
      secureStorageProvider.overrideWithValue(mockStorage),
      socialAuthServiceProvider.overrideWithValue(mockSocial),
    ],
    child: MaterialApp(
      theme: ThemeData(extensions: const [QuestifyColors.day]),
      home: const DashboardPage(),
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

    // Auto-login: simulate already authenticated user
    when(() => mockStorage.read(key: 'accessToken'))
        .thenAnswer((_) async => 'valid_token');
    when(() => mockStorage.read(key: 'refreshToken'))
        .thenAnswer((_) async => 'valid_refresh');
    when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});

    // getMe for auto-login
    when(() => mockApi.getMe())
        .thenAnswer((_) async => testUser);

    // setAccessToken
    when(() => mockApi.setAccessToken(any())).thenReturn(null);

    // getQuests
    when(() => mockApi.getQuests())
        .thenAnswer((_) async => [activeQuest]);

    // getMyStats
    when(() => mockApi.getMyStats())
        .thenAnswer((_) async => testStats);
  });

  group('DashboardPage', () {
    testWidgets('displays user greeting with name', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        questsState: const QuestsState(quests: [activeQuest]),
      ));
      // Pump a few frames to let providers initialize
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Salut, Hero42!'), findsOneWidget);
    });

    testWidgets('displays user level in header', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Level badge shows "5"
      expect(find.text('5'), findsOneWidget);
      expect(find.textContaining('Niveau 5'), findsOneWidget);
    });

    testWidgets('displays user coins', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('120'), findsOneWidget);
    });

    testWidgets('displays XP progress bar info', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Progression vers Niveau 6'), findsOneWidget);
      expect(find.text('350 / 500 XP'), findsOneWidget);
      expect(find.text('70%'), findsOneWidget);
    });

    testWidgets('displays total quests completed', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('23 quetes completees'), findsOneWidget);
    });

    testWidgets('displays streak card when streak > 0', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Serie de 3 jours!'), findsOneWidget);
      expect(find.text('Continue comme ca!'), findsOneWidget);
    });

    testWidgets('hides streak card when streak is 0', (tester) async {
      const noStreakStats = UserStats(
        xp: 100,
        level: 1,
        xpToNextLevel: 100,
        xpForCurrentLevel: 0,
        totalQuestsCompleted: 0,
        progressPercent: 50.0,
        currentStreak: 0,
        bestStreak: 0,
      );

      when(() => mockApi.getMyStats())
          .thenAnswer((_) async => noStreakStats);

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        stats: noStreakStats,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Serie de'), findsNothing);
    });

    testWidgets('displays empty state when no active quests', (tester) async {
      when(() => mockApi.getQuests()).thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        questsState: const QuestsState(),
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Aucune quete active'), findsOneWidget);
      expect(find.text('Creer ta premiere quete'), findsOneWidget);
    });

    testWidgets('displays active quests section header', (tester) async {
      when(() => mockApi.getQuests())
          .thenAnswer((_) async => [activeQuest]);

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        questsState: const QuestsState(quests: [activeQuest]),
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Quetes actives'), findsOneWidget);
      expect(find.text('1 quete disponible'), findsOneWidget);
    });

    testWidgets('displays plural quest count text', (tester) async {
      const quest2 = Quest(
        id: 3,
        title: 'Deuxieme quete',
        status: QuestStatus.PENDING,
        difficulty: QuestDifficulty.MEDIUM,
        xpReward: 100,
      );

      when(() => mockApi.getQuests())
          .thenAnswer((_) async => [activeQuest, quest2]);

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        questsState: const QuestsState(quests: [activeQuest, quest2]),
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('2 quetes disponibles'), findsOneWidget);
    });

    testWidgets('renders active quest card with title', (tester) async {
      when(() => mockApi.getQuests())
          .thenAnswer((_) async => [activeQuest]);

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        questsState: const QuestsState(quests: [activeQuest]),
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Vaincre le dragon'), findsOneWidget);
    });

    testWidgets('displays completed quests section', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        questsState: const QuestsState(quests: [completedQuest]),
      ));
      // Multiple pumps: first resolves auto-login, second resolves loadQuests
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // The completed section may be below the viewport — scroll down
      await tester.scrollUntilVisible(
        find.text('Ramasser des herbes'),
        200,
      );
      await tester.pump();

      expect(find.text('Ramasser des herbes'), findsOneWidget);
      expect(find.text('+30 XP'), findsOneWidget);
    });

    testWidgets('displays Nouvelle quete button', (tester) async {
      when(() => mockApi.getQuests())
          .thenAnswer((_) async => [activeQuest]);

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        questsState: const QuestsState(quests: [activeQuest]),
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Nouvelle quete'), findsOneWidget);
    });

    testWidgets('FAB is visible', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(FloatingActionButton), findsOneWidget);
      // Icons.add appears in both the FAB (size 28) and _NewQuestButton (size 18)
      expect(find.byIcon(Icons.add), findsAtLeast(1));
    });

    testWidgets('displays level title Novice for level < 5', (tester) async {
      const lowLevelUser = User(
        id: 1,
        email: 'test@questify.app',
        displayName: 'Newbie',
        xp: 10,
        level: 1,
        coins: 0,
        gems: 0,
      );

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        user: lowLevelUser,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Novice'), findsOneWidget);
    });

    testWidgets('displays first letter of user name in avatar',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // "H" from "Hero42"
      expect(find.text('H'), findsOneWidget);
    });
  });
}
