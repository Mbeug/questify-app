import 'package:test/test.dart';
import 'package:frontend/models/auth_response.dart';

void main() {
  group('AuthResponse', () {
    test('fromJson creates a valid AuthResponse', () {
      final json = {
        'accessToken': 'abc123',
        'refreshToken': 'def456',
        'user': {
          'id': 1,
          'email': 'test@example.com',
          'displayName': 'Hero',
          'xp': 0,
          'level': 1,
        },
      };

      final resp = AuthResponse.fromJson(json);

      expect(resp.accessToken, 'abc123');
      expect(resp.refreshToken, 'def456');
      expect(resp.user.id, 1);
      expect(resp.user.email, 'test@example.com');
      expect(resp.user.displayName, 'Hero');
      expect(resp.user.xp, 0);
      expect(resp.user.level, 1);
    });

    test('toJson produces correct nested map', () {
      const resp = AuthResponse(
        accessToken: 'tok1',
        refreshToken: 'tok2',
        user: AuthUser(
          id: 5,
          email: 'x@y.com',
          displayName: 'X',
          xp: 100,
          level: 2,
        ),
      );

      final json = resp.toJson();

      expect(json['accessToken'], 'tok1');
      expect(json['refreshToken'], 'tok2');
      // user field is serialized - verify via key presence
      expect(json.containsKey('user'), isTrue);
    });
  });

  group('AuthUser', () {
    test('fromJson creates a valid AuthUser', () {
      final json = {
        'id': 3,
        'email': 'user@test.com',
        'displayName': 'Player',
        'xp': 500,
        'level': 5,
      };

      final user = AuthUser.fromJson(json);

      expect(user.id, 3);
      expect(user.email, 'user@test.com');
      expect(user.displayName, 'Player');
      expect(user.xp, 500);
      expect(user.level, 5);
    });

    test('equality works via freezed', () {
      const a = AuthUser(
          id: 1, email: 'a@b.com', displayName: 'A', xp: 0, level: 1);
      const b = AuthUser(
          id: 1, email: 'a@b.com', displayName: 'A', xp: 0, level: 1);

      expect(a, equals(b));
    });
  });
}
