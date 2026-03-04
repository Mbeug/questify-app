import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/models/quest.dart';

void main() {
  group('ApiService', () {
    test('login sends correct request and parses response', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/auth/login');
        expect(request.method, 'POST');
        final body = json.decode(request.body);
        expect(body['email'], 'test@example.com');
        expect(body['password'], 'pass123');

        return http.Response(
          json.encode({
            'accessToken': 'access_tok',
            'refreshToken': 'refresh_tok',
            'user': {
              'id': 1,
              'email': 'test@example.com',
              'displayName': 'Hero',
              'xp': 0,
              'level': 1,
            },
          }),
          200,
        );
      });

      final api = ApiService(
          baseUrl: 'http://localhost:8080', client: mockClient);
      final resp = await api.login('test@example.com', 'pass123');

      expect(resp.accessToken, 'access_tok');
      expect(resp.refreshToken, 'refresh_tok');
      expect(resp.user.email, 'test@example.com');
    });

    test('signup sends correct request', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/auth/signup');
        final body = json.decode(request.body);
        expect(body['email'], 'new@test.com');
        expect(body['password'], 'secret');
        expect(body['displayName'], 'NewUser');

        return http.Response(
          json.encode({
            'accessToken': 'at',
            'refreshToken': 'rt',
            'user': {
              'id': 2,
              'email': 'new@test.com',
              'displayName': 'NewUser',
              'xp': 0,
              'level': 1,
            },
          }),
          200,
        );
      });

      final api = ApiService(
          baseUrl: 'http://localhost:8080', client: mockClient);
      final resp = await api.signup('new@test.com', 'secret', 'NewUser');

      expect(resp.user.id, 2);
      expect(resp.user.displayName, 'NewUser');
    });

    test('getMe sends auth header and parses user', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/users/me');
        expect(request.headers['Authorization'], 'Bearer my_token');

        return http.Response(
          json.encode({
            'id': 1,
            'email': 'a@b.com',
            'displayName': 'A',
            'xp': 100,
            'level': 2,
          }),
          200,
        );
      });

      final api = ApiService(
          baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('my_token');
      final user = await api.getMe();

      expect(user.id, 1);
      expect(user.xp, 100);
    });

    test('getQuests parses list of quests', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/quests');

        return http.Response(
          json.encode([
            {
              'id': 1,
              'title': 'Q1',
              'status': 'PENDING',
              'difficulty': 'EASY',
              'xpReward': 50,
            },
            {
              'id': 2,
              'title': 'Q2',
              'status': 'COMPLETED',
              'difficulty': 'HARD',
              'xpReward': 200,
            },
          ]),
          200,
        );
      });

      final api = ApiService(
          baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final quests = await api.getQuests();

      expect(quests.length, 2);
      expect(quests[0].title, 'Q1');
      expect(quests[1].status, QuestStatus.COMPLETED);
    });

    test('createQuest sends correct body', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/quests');
        expect(request.method, 'POST');
        final body = json.decode(request.body);
        expect(body['title'], 'New Quest');
        expect(body['difficulty'], 'MEDIUM');
        expect(body.containsKey('description'), false);

        return http.Response(
          json.encode({
            'id': 10,
            'title': 'New Quest',
            'status': 'PENDING',
            'difficulty': 'MEDIUM',
            'xpReward': 100,
          }),
          201,
        );
      });

      final api = ApiService(
          baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final quest = await api.createQuest(
        title: 'New Quest',
        difficulty: QuestDifficulty.MEDIUM,
      );

      expect(quest.id, 10);
      expect(quest.difficulty, QuestDifficulty.MEDIUM);
    });

    test('completeQuest sends POST and parses response', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/quests/5/complete');
        expect(request.method, 'POST');

        return http.Response(
          json.encode({
            'id': 5,
            'title': 'Done',
            'status': 'COMPLETED',
            'difficulty': 'EASY',
            'xpReward': 50,
            'levelUpResult': {
              'totalXp': 150,
              'level': 2,
              'leveledUp': true,
              'xpGained': 50,
              'xpToNextLevel': 100,
            },
          }),
          200,
        );
      });

      final api = ApiService(
          baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final quest = await api.completeQuest(5);

      expect(quest.status, QuestStatus.COMPLETED);
      expect(quest.levelUpResult!.leveledUp, true);
    });

    test('deleteQuest sends DELETE request', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/quests/3');
        expect(request.method, 'DELETE');
        return http.Response('', 204);
      });

      final api = ApiService(
          baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      await api.deleteQuest(3); // Should not throw
    });

    test('error response throws ApiException', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          json.encode({'error': 'Non autorise'}),
          401,
        );
      });

      final api = ApiService(
          baseUrl: 'http://localhost:8080', client: mockClient);
      expect(
        () => api.login('bad@email.com', 'wrong'),
        throwsA(isA<ApiException>()),
      );
    });

    test('getHello returns plain text', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/hello');
        return http.Response('Hello World!', 200);
      });

      final api = ApiService(
          baseUrl: 'http://localhost:8080', client: mockClient);
      final hello = await api.getHello();

      expect(hello, 'Hello World!');
    });

    test('getMyStats parses stats response', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/users/me/stats');

        return http.Response(
          json.encode({
            'xp': 500,
            'level': 3,
            'xpToNextLevel': 150,
            'xpForCurrentLevel': 100,
            'totalQuestsCompleted': 10,
            'progressPercent': 0.6,
          }),
          200,
        );
      });

      final api = ApiService(
          baseUrl: 'http://localhost:8080', client: mockClient);
      api.setAccessToken('tok');
      final stats = await api.getMyStats();

      expect(stats.xp, 500);
      expect(stats.level, 3);
      expect(stats.progressPercent, 0.6);
    });
  });
}
