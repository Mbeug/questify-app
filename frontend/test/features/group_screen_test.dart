import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:frontend/features/group/group_screen.dart';
import 'package:frontend/models/group.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/group_provider.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/social_auth_service.dart';
import 'package:frontend/theme.dart';

class MockApiService extends Mock implements ApiService {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class MockSocialAuthService extends Mock implements SocialAuthService {}

const testUser = User(
  id: 1,
  email: 'hero@questify.app',
  displayName: 'Hero42',
  xp: 350,
  level: 5,
  coins: 120,
  gems: 10,
  avatarId: 'sword',
);

final testGroup = const QuestGroup(
  id: 10,
  name: 'Les Conquerants',
  description: 'Une guilde de heros',
  inviteCode: 'QUEST-1234',
  weeklyGoal: 10,
  weeklyProgress: 6,
  memberCount: 3,
  members: [
    GroupMember(
      userId: 1,
      displayName: 'Hero42',
      level: 5,
      weeklyXp: 500,
      weeklyQuestsCompleted: 4,
      role: GroupRole.LEADER,
    ),
    GroupMember(
      userId: 2,
      displayName: 'AllyOne',
      level: 3,
      weeklyXp: 300,
      weeklyQuestsCompleted: 2,
      role: GroupRole.MEMBER,
    ),
    GroupMember(
      userId: 3,
      displayName: 'AllyTwo',
      level: 7,
      weeklyXp: 150,
      weeklyQuestsCompleted: 1,
      role: GroupRole.MEMBER,
    ),
  ],
);

/// Builds the test widget with all required provider overrides.
Widget buildTestApp({
  required MockApiService mockApi,
  required MockSecureStorage mockStorage,
  required MockSocialAuthService mockSocial,
  List<QuestGroup> groups = const [],
}) {
  // Auth: auto-login will read token → call setAccessToken → call getMe
  when(() => mockApi.getMe()).thenAnswer((_) async => testUser);
  when(() => mockApi.setAccessToken(any())).thenReturn(null);
  // Group: loadGroups called in initState
  when(() => mockApi.getMyGroups()).thenAnswer((_) async => groups);

  return ProviderScope(
    overrides: [
      apiServiceProvider.overrideWithValue(mockApi),
      secureStorageProvider.overrideWithValue(mockStorage),
      socialAuthServiceProvider.overrideWithValue(mockSocial),
    ],
    child: MaterialApp(
      theme: ThemeData(extensions: const [QuestifyColors.day]),
      home: const GroupScreen(),
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

    // Secure storage for auto-login
    when(() => mockStorage.read(key: 'accessToken'))
        .thenAnswer((_) async => 'valid_token');
    when(() => mockStorage.read(key: 'refreshToken'))
        .thenAnswer((_) async => 'valid_refresh');
    when(() => mockStorage.write(
            key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});

    // Default API stubs
    when(() => mockApi.getMe()).thenAnswer((_) async => testUser);
    when(() => mockApi.setAccessToken(any())).thenReturn(null);
    when(() => mockApi.getMyGroups()).thenAnswer((_) async => []);
  });

  // ═══════════════════════════════════════════════════════════════
  //  No group view
  // ═══════════════════════════════════════════════════════════════
  group('GroupScreen - no group', () {
    testWidgets('shows "Aucune guilde" when user has no group',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Aucune guilde'), findsOneWidget);
      expect(find.text('Creer une guilde'), findsOneWidget);
      expect(find.text('Rejoindre avec un code'), findsOneWidget);
    });

    testWidgets('tapping "Creer une guilde" opens create dialog',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Creer une guilde'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Creer une guilde'), findsNWidgets(2)); // button + dialog title
      expect(
        find.text('Rassemble tes allies pour de nouvelles aventures'),
        findsOneWidget,
      );
      expect(find.text('Nom de la guilde'), findsOneWidget);
      expect(find.text('Description (optionnel)'), findsOneWidget);
    });

    testWidgets('create dialog can be cancelled', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Creer une guilde'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text('Annuler'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Dialog-specific content gone
      expect(find.text('Nom de la guilde'), findsNothing);
    });

    testWidgets('create dialog submits when name is entered', (tester) async {
      final newGroup = const QuestGroup(
        id: 20,
        name: 'Nouvelle Guilde',
        inviteCode: 'QUEST-5678',
        members: [],
      );
      when(() => mockApi.createGroup(
            name: any(named: 'name'),
            description: any(named: 'description'),
            bannerEmoji: any(named: 'bannerEmoji'),
            weeklyGoal: any(named: 'weeklyGoal'),
          )).thenAnswer((_) async => newGroup);
      // After creation, loadGroups is called again
      when(() => mockApi.getMyGroups())
          .thenAnswer((_) async => [newGroup]);

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Creer une guilde'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Enter group name
      await tester.enterText(
          find.widgetWithText(TextField, 'Nom de la guilde'),
          'Nouvelle Guilde');
      await tester.pump();

      // Tap "Creer" button
      await tester.tap(find.text('Creer'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockApi.createGroup(
            name: 'Nouvelle Guilde',
            description: any(named: 'description'),
            bannerEmoji: any(named: 'bannerEmoji'),
            weeklyGoal: any(named: 'weeklyGoal'),
          )).called(1);
    });

    testWidgets('tapping "Rejoindre" opens join dialog', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Rejoindre avec un code'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Rejoindre une guilde'), findsOneWidget);
      expect(
        find.text("Entre le code d'invitation de la guilde"),
        findsOneWidget,
      );
      expect(find.text("Code d'invitation"), findsOneWidget);
    });

    testWidgets('join dialog submits code', (tester) async {
      when(() => mockApi.joinGroup(any()))
          .thenAnswer((_) async => testGroup);

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Rejoindre avec un code'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.enterText(
          find.widgetWithText(TextField, "Code d'invitation"), 'QUEST-1234');
      await tester.pump();

      await tester.tap(find.text('Rejoindre'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockApi.joinGroup('QUEST-1234')).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  Group view (with group)
  // ═══════════════════════════════════════════════════════════════
  group('GroupScreen - with group', () {
    testWidgets('shows group name and member count', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Les Conquerants'), findsOneWidget);
      expect(find.text('3 membres'), findsOneWidget);
    });

    testWidgets('shows weekly objective progress', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Objectif hebdomadaire'), findsOneWidget);
      expect(find.text('6/10'), findsOneWidget);
    });

    testWidgets('shows podium section with "Classement hebdo"',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Classement hebdo'), findsOneWidget);
      // 3 podium ranks
      expect(find.text('#1'), findsOneWidget);
      expect(find.text('#2'), findsOneWidget);
      expect(find.text('#3'), findsOneWidget);
    });

    testWidgets('shows "Tous les membres" section', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final membersHeader = find.text('Tous les membres');
      await tester.ensureVisible(membersHeader);
      expect(membersHeader, findsOneWidget);
    });

    testWidgets('shows member names in members section', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Members section shows display names
      // Hero42 appears in both podium + member section
      final hero42 = find.text('Hero42');
      expect(hero42, findsAtLeastNWidgets(1));

      final ally1 = find.text('AllyOne');
      await tester.ensureVisible(ally1);
      expect(ally1, findsAtLeastNWidgets(1));
    });

    testWidgets('shows "Toi" badge for current user', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Current user (id=1) gets "Toi" badge
      final toiBadge = find.text('Toi');
      await tester.ensureVisible(toiBadge);
      expect(toiBadge, findsOneWidget);
    });

    testWidgets('shows statistics section', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final statsHeader = find.text('Statistiques');
      await tester.ensureVisible(statsHeader);
      expect(statsHeader, findsOneWidget);
      expect(find.text('Quetes cette semaine'), findsOneWidget);
      expect(find.text('Niveau moyen'), findsOneWidget);
    });

    testWidgets('leader sees "Dissoudre" button, not "Quitter"',
        (tester) async {
      // testUser (id=1) is LEADER in testGroup
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Dissoudre'), findsOneWidget);
      expect(find.text('Quitter'), findsNothing);
    });

    testWidgets('non-leader sees "Quitter" button, not "Dissoudre"',
        (tester) async {
      // Create a group where current user (id=1) is a MEMBER, not LEADER
      final groupAsMember = const QuestGroup(
        id: 10,
        name: 'Autre Guilde',
        inviteCode: 'QUEST-9999',
        memberCount: 2,
        members: [
          GroupMember(
            userId: 99,
            displayName: 'LeaderGuy',
            level: 10,
            weeklyXp: 800,
            role: GroupRole.LEADER,
          ),
          GroupMember(
            userId: 1,
            displayName: 'Hero42',
            level: 5,
            weeklyXp: 300,
            role: GroupRole.MEMBER,
          ),
        ],
      );

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [groupAsMember],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Quitter'), findsOneWidget);
      expect(find.text('Dissoudre'), findsNothing);
    });

    testWidgets('shows "Inviter" button', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Inviter'), findsOneWidget);
    });

    testWidgets('invite dialog shows invite code', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Inviter'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Inviter des membres'), findsOneWidget);
      expect(find.text("Code d'invitation"), findsOneWidget);
      expect(find.text('QUEST-1234'), findsOneWidget);
      expect(find.text('Fermer'), findsOneWidget);
    });

    testWidgets('invite dialog close button works', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Inviter'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text('Fermer'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Inviter des membres'), findsNothing);
    });

    testWidgets('dissolve dialog opens on "Dissoudre" tap', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Dissoudre'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Dissoudre le groupe ?'), findsOneWidget);
      expect(
        find.textContaining('Cette action est irreversible'),
        findsOneWidget,
      );
    });

    testWidgets('leave dialog opens on "Quitter" tap', (tester) async {
      final groupAsMember = const QuestGroup(
        id: 10,
        name: 'Autre Guilde',
        inviteCode: 'QUEST-9999',
        memberCount: 2,
        members: [
          GroupMember(
            userId: 99,
            displayName: 'LeaderGuy',
            level: 10,
            weeklyXp: 800,
            role: GroupRole.LEADER,
          ),
          GroupMember(
            userId: 1,
            displayName: 'Hero42',
            level: 5,
            weeklyXp: 300,
            role: GroupRole.MEMBER,
          ),
        ],
      );

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [groupAsMember],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Quitter'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Quitter le groupe ?'), findsOneWidget);
      expect(
        find.textContaining('tu perdras ta progression'),
        findsOneWidget,
      );
    });

    testWidgets('dissolve dialog confirm calls leaveGroup', (tester) async {
      when(() => mockApi.leaveGroup(any())).thenAnswer((_) async {});
      // After leave, loadGroups returns empty
      int loadGroupsCalls = 0;
      when(() => mockApi.getMyGroups()).thenAnswer((_) async {
        loadGroupsCalls++;
        if (loadGroupsCalls > 1) return [];
        return [testGroup];
      });

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Dissoudre'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Tap the confirm "Dissoudre" button in dialog
      // There are two: one in the action bar and one in the dialog
      final dissolveButtons = find.text('Dissoudre');
      await tester.tap(dissolveButtons.last);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockApi.leaveGroup(10)).called(1);
    });

    testWidgets('shows settings icon for leader', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Guild header shows settings icon for leader
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('weekly progress message shows remaining quests',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [testGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // 10 - 6 = 4 remaining
      expect(
        find.textContaining('Plus que 4 quetes'),
        findsOneWidget,
      );
    });

    testWidgets('completed weekly goal shows congrats message',
        (tester) async {
      final completedGroup = const QuestGroup(
        id: 10,
        name: 'Winners',
        inviteCode: 'QUEST-WIN',
        weeklyGoal: 10,
        weeklyProgress: 10,
        memberCount: 1,
        members: [
          GroupMember(
            userId: 1,
            displayName: 'Hero42',
            level: 5,
            weeklyXp: 1000,
            role: GroupRole.LEADER,
          ),
        ],
      );

      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        groups: [completedGroup],
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.textContaining('Objectif atteint'),
        findsOneWidget,
      );
    });
  });
}
