import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:frontend/services/api_service.dart';

void main() {
  group('ApiService - Groups', () {
    test('getMyGroups parses list of groups', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/groups');
        expect(request.method, 'GET');

        return http.Response(
          json.encode([
            {
              'id': 1,
              'name': 'Groupe A',
              'inviteCode': 'ABC',
              'weeklyGoal': 10,
              'memberCount': 3,
            },
            {
              'id': 2,
              'name': 'Groupe B',
              'inviteCode': 'XYZ',
            },
          ]),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final groups = await api.getMyGroups();

      expect(groups.length, 2);
      expect(groups[0].name, 'Groupe A');
      expect(groups[0].memberCount, 3);
      expect(groups[1].inviteCode, 'XYZ');
    });

    test('getGroup parses single group', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/groups/1');
        return http.Response(
          json.encode({
            'id': 1,
            'name': 'Mon Groupe',
            'inviteCode': 'CODE',
            'weeklyGoal': 15,
            'members': [
              {
                'userId': 10,
                'displayName': 'Alice',
                'role': 'LEADER',
              },
            ],
          }),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final group = await api.getGroup(1);

      expect(group.id, 1);
      expect(group.name, 'Mon Groupe');
      expect(group.members.length, 1);
      expect(group.members[0].displayName, 'Alice');
    });

    test('createGroup sends correct body', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/groups');
        expect(request.method, 'POST');
        final body = json.decode(request.body);
        expect(body['name'], 'New Group');
        expect(body['description'], 'A group');
        expect(body['bannerEmoji'], '🎮');
        expect(body['weeklyGoal'], 20);

        return http.Response(
          json.encode({
            'id': 3,
            'name': 'New Group',
            'description': 'A group',
            'bannerEmoji': '🎮',
            'inviteCode': 'NEW01',
            'weeklyGoal': 20,
          }),
          201,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final group = await api.createGroup(
        name: 'New Group',
        description: 'A group',
        bannerEmoji: '🎮',
        weeklyGoal: 20,
      );

      expect(group.id, 3);
      expect(group.weeklyGoal, 20);
    });

    test('joinGroup sends invite code', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/groups/join');
        expect(request.method, 'POST');
        final body = json.decode(request.body);
        expect(body['inviteCode'], 'JOIN01');

        return http.Response(
          json.encode({
            'id': 5,
            'name': 'Joined Group',
            'inviteCode': 'JOIN01',
          }),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final group = await api.joinGroup('JOIN01');

      expect(group.id, 5);
      expect(group.name, 'Joined Group');
    });

    test('leaveGroup sends POST to leave endpoint', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/groups/1/leave');
        expect(request.method, 'POST');
        return http.Response('{}', 200);
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      await api.leaveGroup(1); // Should not throw
    });

    test('removeMember sends DELETE', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/groups/1/members/5');
        expect(request.method, 'DELETE');
        return http.Response('', 204);
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      await api.removeMember(1, 5); // Should not throw
    });
  });

  group('ApiService - Themes', () {
    test('getThemes parses list of themes', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/themes');
        return http.Response(
          json.encode([
            {
              'id': 1,
              'themeKey': 'default',
              'name': 'Défaut',
              'primaryColor': '#6200EE',
              'secondaryColor': '#03DAC5',
              'backgroundColor': '#FAFAFA',
              'surfaceColor': '#FFFFFF',
              'rarity': 'COMMON',
              'owned': true,
              'active': true,
            },
          ]),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final themes = await api.getThemes();

      expect(themes.length, 1);
      expect(themes[0].themeKey, 'default');
      expect(themes[0].owned, true);
    });

    test('buyTheme sends POST and parses response', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/themes/2/buy');
        expect(request.method, 'POST');
        return http.Response(
          json.encode({
            'id': 2,
            'themeKey': 'ocean',
            'name': 'Océan',
            'primaryColor': '#0077BE',
            'secondaryColor': '#00A6ED',
            'backgroundColor': '#E0F7FA',
            'surfaceColor': '#FFFFFF',
            'rarity': 'RARE',
            'owned': true,
          }),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final theme = await api.buyTheme(2);

      expect(theme.owned, true);
      expect(theme.themeKey, 'ocean');
    });

    test('applyTheme sends POST and parses response', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/themes/1/apply');
        expect(request.method, 'POST');
        return http.Response(
          json.encode({
            'id': 1,
            'themeKey': 'default',
            'name': 'Défaut',
            'primaryColor': '#6200EE',
            'secondaryColor': '#03DAC5',
            'backgroundColor': '#FAFAFA',
            'surfaceColor': '#FFFFFF',
            'rarity': 'COMMON',
            'active': true,
          }),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final theme = await api.applyTheme(1);

      expect(theme.active, true);
    });
  });

  group('ApiService - Achievements', () {
    test('getAchievements parses list', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/achievements');
        return http.Response(
          json.encode([
            {
              'id': 1,
              'achievementKey': 'first_quest',
              'name': 'Première Quête',
              'category': 'QUESTS',
              'threshold': 1,
              'progress': 1,
              'unlocked': true,
            },
            {
              'id': 2,
              'achievementKey': 'streak_7',
              'name': 'Semaine de feu',
              'category': 'STREAKS',
              'threshold': 7,
              'progress': 3,
              'unlocked': false,
            },
          ]),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final achievements = await api.getAchievements();

      expect(achievements.length, 2);
      expect(achievements[0].unlocked, true);
      expect(achievements[1].progress, 3);
    });
  });

  group('ApiService - Calendar', () {
    test('linkCalendarEvent sends POST with event ID', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/calendar/link/1');
        expect(request.method, 'POST');
        final body = json.decode(request.body);
        expect(body['calendarEventId'], 'gcal_123');

        return http.Response(
          json.encode({
            'id': 1,
            'title': 'My Quest',
            'status': 'PENDING',
            'difficulty': 'EASY',
            'xpReward': 50,
            'calendarEventId': 'gcal_123',
          }),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final quest = await api.linkCalendarEvent(1, 'gcal_123');

      expect(quest.id, 1);
      expect(quest.calendarEventId, 'gcal_123');
    });

    test('unlinkCalendarEvent sends DELETE', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/calendar/link/1');
        expect(request.method, 'DELETE');
        return http.Response(
          json.encode({
            'id': 1,
            'title': 'My Quest',
            'status': 'PENDING',
            'difficulty': 'EASY',
            'xpReward': 50,
          }),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final quest = await api.unlinkCalendarEvent(1);

      expect(quest.id, 1);
      expect(quest.calendarEventId, isNull);
    });
  });

  group('ApiService - Notifications', () {
    test('registerFcmToken sends POST', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/notifications/register');
        expect(request.method, 'POST');
        final body = json.decode(request.body);
        expect(body['fcmToken'], 'fcm_token_123');
        return http.Response('{}', 200);
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      await api.registerFcmToken('fcm_token_123'); // Should not throw
    });

    test('getNotificationPreferences parses response', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/notifications/preferences');
        expect(request.method, 'GET');
        return http.Response(
          json.encode({'notificationsEnabled': true}),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final prefs = await api.getNotificationPreferences();

      expect(prefs['notificationsEnabled'], true);
    });

    test('updateNotificationPreferences sends PATCH', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/notifications/preferences');
        expect(request.method, 'PATCH');
        final body = json.decode(request.body);
        expect(body['enabled'], false);
        return http.Response(
          json.encode({'notificationsEnabled': false}),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final prefs = await api.updateNotificationPreferences(enabled: false);

      expect(prefs['notificationsEnabled'], false);
    });
  });

  group('ApiService - User Profile', () {
    test('updateProfile sends PATCH with optional fields', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/users/me');
        expect(request.method, 'PATCH');
        final body = json.decode(request.body);
        expect(body['displayName'], 'New Name');
        expect(body.containsKey('avatarId'), false);

        return http.Response(
          json.encode({
            'id': 1,
            'email': 'test@example.com',
            'displayName': 'New Name',
            'xp': 100,
            'level': 2,
          }),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final user = await api.updateProfile(displayName: 'New Name');

      expect(user.displayName, 'New Name');
    });

    test('socialLogin sends correct body with provider', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/auth/social');
        expect(request.method, 'POST');
        final body = json.decode(request.body);
        expect(body['idToken'], 'google_token');
        expect(body['provider'], 'google');
        expect(body['displayName'], 'Google User');

        return http.Response(
          json.encode({
            'accessToken': 'at',
            'refreshToken': 'rt',
            'user': {
              'id': 1,
              'email': 'g@test.com',
              'displayName': 'Google User',
              'xp': 0,
              'level': 1,
            },
          }),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      final resp = await api.socialLogin(
        idToken: 'google_token',
        provider: 'google',
        displayName: 'Google User',
      );

      expect(resp.user.displayName, 'Google User');
    });

    test('refresh sends refreshToken and parses AuthResponse', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/auth/refresh');
        expect(request.method, 'POST');
        final body = json.decode(request.body);
        expect(body['refreshToken'], 'old_refresh');

        return http.Response(
          json.encode({
            'accessToken': 'new_access',
            'refreshToken': 'new_refresh',
            'user': {
              'id': 1,
              'email': 'test@test.com',
              'displayName': 'User',
              'xp': 50,
              'level': 1,
            },
          }),
          200,
        );
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      final resp = await api.refresh('old_refresh');

      expect(resp.accessToken, 'new_access');
      expect(resp.refreshToken, 'new_refresh');
    });
  });

  group('ApiService - Error handling edge cases', () {
    test('non-JSON error response returns status code message', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      expect(
        () => api.getMe(),
        throwsA(isA<ApiException>().having(
          (e) => e.message,
          'message',
          contains('500'),
        )),
      );
    });

    test('empty 200 response returns empty map', () async {
      final mockClient = MockClient((request) async {
        return http.Response('', 200);
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      await api.registerFcmToken('token'); // Uses _post which returns _handleResponse
      // Should not throw
    });

    test('empty 200 list response returns empty list', () async {
      final mockClient = MockClient((request) async {
        return http.Response('', 200);
      });

      final api = ApiService(baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final quests = await api.getQuests();

      expect(quests, isEmpty);
    });
  });
}
