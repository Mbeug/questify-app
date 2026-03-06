import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/models/group.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/providers/group_provider.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApi;
  late GroupNotifier notifier;

  const group1 = QuestGroup(
    id: 1,
    name: 'Les Aventuriers',
    description: 'Un groupe cool',
    inviteCode: 'ABC123',
    weeklyGoal: 10,
    weeklyProgress: 3,
    memberCount: 2,
  );

  const group2 = QuestGroup(
    id: 2,
    name: 'Les Champions',
    inviteCode: 'XYZ789',
    weeklyGoal: 20,
  );

  setUp(() {
    mockApi = MockApiService();
    notifier = GroupNotifier(mockApi);
  });

  group('GroupNotifier', () {
    test('initial state is empty and not loading', () {
      expect(notifier.state.groups, isEmpty);
      expect(notifier.state.selectedGroup, isNull);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.error, isNull);
    });

    test('loadGroups success populates groups', () async {
      when(() => mockApi.getMyGroups())
          .thenAnswer((_) async => [group1, group2]);

      await notifier.loadGroups();

      expect(notifier.state.groups.length, 2);
      expect(notifier.state.groups[0].name, 'Les Aventuriers');
      expect(notifier.state.groups[1].name, 'Les Champions');
      expect(notifier.state.isLoading, false);
      expect(notifier.state.error, isNull);
    });

    test('loadGroups ApiException sets error', () async {
      when(() => mockApi.getMyGroups())
          .thenThrow(ApiException('Erreur serveur', statusCode: 500));

      await notifier.loadGroups();

      expect(notifier.state.groups, isEmpty);
      expect(notifier.state.error, 'Erreur serveur');
    });

    test('loadGroups generic exception sets default error', () async {
      when(() => mockApi.getMyGroups()).thenThrow(Exception('network'));

      await notifier.loadGroups();

      expect(notifier.state.error, 'Erreur de chargement');
    });

    test('loadGroup success sets selectedGroup', () async {
      when(() => mockApi.getGroup(1)).thenAnswer((_) async => group1);

      await notifier.loadGroup(1);

      expect(notifier.state.selectedGroup, isNotNull);
      expect(notifier.state.selectedGroup!.id, 1);
      expect(notifier.state.selectedGroup!.name, 'Les Aventuriers');
      expect(notifier.state.isLoading, false);
    });

    test('loadGroup ApiException sets error', () async {
      when(() => mockApi.getGroup(999))
          .thenThrow(ApiException('Groupe non trouvé', statusCode: 404));

      await notifier.loadGroup(999);

      expect(notifier.state.error, 'Groupe non trouvé');
    });

    test('createGroup success prepends group and returns it', () async {
      when(() => mockApi.createGroup(
            name: 'Nouveau Groupe',
            description: 'Desc',
            bannerEmoji: '🎮',
            weeklyGoal: 15,
          )).thenAnswer((_) async => const QuestGroup(
            id: 3,
            name: 'Nouveau Groupe',
            description: 'Desc',
            bannerEmoji: '🎮',
            inviteCode: 'NEW123',
            weeklyGoal: 15,
          ));

      // Pre-populate
      when(() => mockApi.getMyGroups()).thenAnswer((_) async => [group1]);
      await notifier.loadGroups();

      final result = await notifier.createGroup(
        name: 'Nouveau Groupe',
        description: 'Desc',
        bannerEmoji: '🎮',
        weeklyGoal: 15,
      );

      expect(result, isNotNull);
      expect(result!.id, 3);
      expect(notifier.state.groups.length, 2);
      expect(notifier.state.groups.first.id, 3);
    });

    test('createGroup ApiException returns null and sets error', () async {
      when(() => mockApi.createGroup(
            name: any(named: 'name'),
            description: any(named: 'description'),
            bannerEmoji: any(named: 'bannerEmoji'),
            weeklyGoal: any(named: 'weeklyGoal'),
          )).thenThrow(ApiException('Nom requis', statusCode: 400));

      final result = await notifier.createGroup(name: '');

      expect(result, isNull);
      expect(notifier.state.error, 'Nom requis');
    });

    test('joinGroup success prepends group and returns it', () async {
      when(() => mockApi.joinGroup('JOIN01'))
          .thenAnswer((_) async => group2);

      final result = await notifier.joinGroup('JOIN01');

      expect(result, isNotNull);
      expect(result!.name, 'Les Champions');
      expect(notifier.state.groups.contains(group2), true);
    });

    test('joinGroup ApiException returns null and sets error', () async {
      when(() => mockApi.joinGroup('BAD'))
          .thenThrow(ApiException('Code invalide', statusCode: 404));

      final result = await notifier.joinGroup('BAD');

      expect(result, isNull);
      expect(notifier.state.error, 'Code invalide');
    });

    test('leaveGroup success removes group from list', () async {
      when(() => mockApi.getMyGroups())
          .thenAnswer((_) async => [group1, group2]);
      await notifier.loadGroups();
      expect(notifier.state.groups.length, 2);

      when(() => mockApi.leaveGroup(1)).thenAnswer((_) async {});

      await notifier.leaveGroup(1);

      expect(notifier.state.groups.length, 1);
      expect(notifier.state.groups.first.id, 2);
    });

    test('leaveGroup ApiException sets error and keeps group', () async {
      when(() => mockApi.getMyGroups()).thenAnswer((_) async => [group1]);
      await notifier.loadGroups();

      when(() => mockApi.leaveGroup(1))
          .thenThrow(ApiException('Non autorisé', statusCode: 403));

      await notifier.leaveGroup(1);

      expect(notifier.state.error, 'Non autorisé');
      expect(notifier.state.groups.length, 1);
    });
  });
}
