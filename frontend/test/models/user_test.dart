import 'package:test/test.dart';
import 'package:frontend/models/user.dart';

void main() {
  group('User', () {
    test('fromJson creates a valid User', () {
      final json = {
        'id': 1,
        'email': 'test@example.com',
        'displayName': 'Hero',
        'xp': 250,
        'level': 3,
        'createdAt': '2025-01-15T10:00:00',
      };

      final user = User.fromJson(json);

      expect(user.id, 1);
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Hero');
      expect(user.xp, 250);
      expect(user.level, 3);
      expect(user.createdAt, '2025-01-15T10:00:00');
    });

    test('fromJson works without optional createdAt', () {
      final json = {
        'id': 2,
        'email': 'bob@example.com',
        'displayName': 'Bob',
        'xp': 0,
        'level': 1,
      };

      final user = User.fromJson(json);

      expect(user.id, 2);
      expect(user.createdAt, isNull);
    });

    test('toJson produces correct map', () {
      const user = User(
        id: 1,
        email: 'test@example.com',
        displayName: 'Hero',
        xp: 250,
        level: 3,
        createdAt: '2025-01-15T10:00:00',
      );

      final json = user.toJson();

      expect(json['id'], 1);
      expect(json['email'], 'test@example.com');
      expect(json['displayName'], 'Hero');
      expect(json['xp'], 250);
      expect(json['level'], 3);
      expect(json['createdAt'], '2025-01-15T10:00:00');
    });

    test('toJson omits null createdAt', () {
      const user = User(
        id: 1,
        email: 'a@b.com',
        displayName: 'A',
        xp: 0,
        level: 1,
      );

      final json = user.toJson();

      expect(json.containsKey('createdAt'), isTrue);
      expect(json['createdAt'], isNull);
    });

    test('equality works via freezed', () {
      const a = User(
          id: 1,
          email: 'a@b.com',
          displayName: 'A',
          xp: 0,
          level: 1);
      const b = User(
          id: 1,
          email: 'a@b.com',
          displayName: 'A',
          xp: 0,
          level: 1);
      const c = User(
          id: 2,
          email: 'a@b.com',
          displayName: 'A',
          xp: 0,
          level: 1);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('copyWith creates modified copy', () {
      const user = User(
          id: 1,
          email: 'a@b.com',
          displayName: 'A',
          xp: 100,
          level: 2);

      final updated = user.copyWith(displayName: 'B', xp: 200);

      expect(updated.displayName, 'B');
      expect(updated.xp, 200);
      expect(updated.id, 1);
      expect(updated.email, 'a@b.com');
    });
  });
}
