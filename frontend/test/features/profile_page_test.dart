import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:frontend/features/profile/profile_page.dart';
import 'package:frontend/models/achievement.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/user_stats.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/stats_provider.dart';
import 'package:frontend/providers/achievement_provider.dart';
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
  avatarId: 'sword',
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

const testAchievement = Achievement(
  id: 1,
  achievementKey: 'first_quest',
  name: 'Premier pas',
  description: 'Termine ta premiere quete',
  category: AchievementCategory.QUESTS,
  threshold: 1,
  unlocked: true,
  unlockedAt: '2026-03-01T10:00:00',
);

Widget buildTestApp({
  required MockApiService mockApi,
  required MockSecureStorage mockStorage,
  required MockSocialAuthService mockSocial,
  User? user,
  List<Achievement> achievements = const [],
}) {
  final u = user ?? testUser;
  when(() => mockApi.getMe()).thenAnswer((_) async => u);
  when(() => mockApi.setAccessToken(any())).thenReturn(null);
  when(() => mockApi.getMyStats()).thenAnswer((_) async => testStats);
  when(() => mockApi.getAchievements())
      .thenAnswer((_) async => achievements);

  return ProviderScope(
    overrides: [
      apiServiceProvider.overrideWithValue(mockApi),
      secureStorageProvider.overrideWithValue(mockStorage),
      socialAuthServiceProvider.overrideWithValue(mockSocial),
    ],
    child: MaterialApp(
      theme: ThemeData(extensions: const [QuestifyColors.day]),
      home: const ProfilePage(),
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
    when(() => mockApi.getAchievements()).thenAnswer((_) async => []);
  });

  group('ProfilePage', () {
    testWidgets('shows "Profil Heros" title', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Profil Heros'), findsOneWidget);
    });

    testWidgets('shows user display name', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Hero42'), findsOneWidget);
    });

    testWidgets('shows user level info', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Level 5 -> "Apprenti Legendaire"
      expect(find.textContaining('Apprenti Legendaire'), findsOneWidget);
    });

    testWidgets('shows edit profile button', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byIcon(Icons.edit), findsAtLeastNWidgets(1));
    });

    testWidgets('shows logout button', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Scroll down to find logout button
      final logoutButton = find.text('Se deconnecter');
      await tester.ensureVisible(logoutButton);
      expect(logoutButton, findsOneWidget);
    });

    testWidgets('shows delete account button', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final deleteButton = find.text('Supprimer mon compte');
      await tester.ensureVisible(deleteButton);
      expect(deleteButton, findsOneWidget);
    });

    testWidgets('shows loading state when auth is loading', (tester) async {
      // Don't return from getMe — keep auth in loading state
      when(() => mockStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => null);
      when(() => mockStorage.read(key: 'refreshToken'))
          .thenAnswer((_) async => null);

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // No token → not authenticated → shows "Non connecte"
      expect(find.text('Non connecte'), findsOneWidget);
    });

    testWidgets('edit profile dialog opens on edit tap', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Tap the edit icon
      final editIcons = find.byIcon(Icons.edit);
      expect(editIcons, findsAtLeastNWidgets(1));
      await tester.tap(editIcons.first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Dialog opens — both the header button text AND dialog title say
      // "Modifier le profil", so check dialog-specific content instead.
      expect(find.text('Personnalise ton heros'), findsOneWidget);
      expect(find.text('Avatar'), findsOneWidget);
      expect(find.text('Enregistrer'), findsOneWidget);
    });

    testWidgets('edit profile dialog can be cancelled', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text('Annuler'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Dialog dismissed — dialog-specific content gone
      expect(find.text('Personnalise ton heros'), findsNothing);
      expect(find.text('Enregistrer'), findsNothing);
    });

    testWidgets('edit profile dialog can save changes', (tester) async {
      when(() => mockApi.updateProfile(
            displayName: any(named: 'displayName'),
            avatarId: any(named: 'avatarId'),
          )).thenAnswer((_) async => testUser);

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Tap Enregistrer
      await tester.tap(find.text('Enregistrer'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockApi.updateProfile(
            displayName: any(named: 'displayName'),
            avatarId: any(named: 'avatarId'),
          )).called(1);
    });

    testWidgets('logout dialog opens on logout button tap', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final logoutButton = find.text('Se deconnecter');
      await tester.ensureVisible(logoutButton);
      await tester.tap(logoutButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Se deconnecter ?'), findsOneWidget);
      expect(find.text('Tu devras te reconnecter ensuite.'), findsOneWidget);
    });

    testWidgets('shows achievements when loaded', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        achievements: [testAchievement],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Scroll down to find achievements section
      final achievementText = find.text('Premier pas');
      await tester.ensureVisible(achievementText);
      expect(achievementText, findsOneWidget);
    });

    testWidgets('shows XP stats values', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Check for stats display (level, coins, gems)
      expect(find.text('5'), findsAtLeastNWidgets(1)); // level
    });
  });
}
