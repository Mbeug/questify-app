import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/models/auth_response.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/social_auth_service.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockApiService extends Mock implements ApiService {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class MockSocialAuthService extends Mock implements SocialAuthService {}

/// A minimal Ref stub that throws on every call — AuthNotifier only uses
/// `_ref.read(notificationProvider.notifier)` inside `_initNotifications`,
/// and we expect that to silently fail in tests (Firebase not configured).
class FakeRef extends Fake implements Ref {}

void main() {
  late MockApiService mockApi;
  late MockSecureStorage mockStorage;
  late MockSocialAuthService mockSocial;
  late FakeRef fakeRef;

  const authResponse = AuthResponse(
    accessToken: 'access_tok',
    refreshToken: 'refresh_tok',
    user: AuthUser(
      id: 1,
      email: 'test@example.com',
      displayName: 'Hero',
      xp: 100,
      level: 2,
      coins: 50,
      gems: 5,
    ),
  );

  const user = User(
    id: 1,
    email: 'test@example.com',
    displayName: 'Hero',
    xp: 100,
    level: 2,
    coins: 50,
    gems: 5,
  );

  setUp(() {
    mockApi = MockApiService();
    mockStorage = MockSecureStorage();
    mockSocial = MockSocialAuthService();
    fakeRef = FakeRef();

    // Default: no stored tokens (skip auto-login)
    when(() => mockStorage.read(key: 'accessToken'))
        .thenAnswer((_) async => null);
    when(() => mockStorage.read(key: 'refreshToken'))
        .thenAnswer((_) async => null);
  });

  /// Helper that creates the notifier and waits for auto-login to finish.
  Future<AuthNotifier> createNotifier() async {
    final notifier = AuthNotifier(mockApi, mockStorage, mockSocial, fakeRef);
    // Auto-login runs in the constructor — give it time to complete
    await Future.delayed(const Duration(milliseconds: 50));
    return notifier;
  }

  group('AuthNotifier', () {
    test('initial state after construction (no stored tokens)', () async {
      final notifier = await createNotifier();

      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.user, isNull);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.error, isNull);
    });

    test('auto-login with valid access token', () async {
      when(() => mockStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => 'valid_token');
      when(() => mockApi.setAccessToken('valid_token')).thenReturn(null);
      when(() => mockApi.getMe()).thenAnswer((_) async => user);

      final notifier = await createNotifier();

      expect(notifier.state.isAuthenticated, true);
      expect(notifier.state.user, isNotNull);
      expect(notifier.state.user!.email, 'test@example.com');
    });

    test('auto-login with expired token falls back to refresh', () async {
      when(() => mockStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => 'expired_token');
      when(() => mockStorage.read(key: 'refreshToken'))
          .thenAnswer((_) async => 'refresh_tok');
      when(() => mockApi.setAccessToken('expired_token')).thenReturn(null);
      when(() => mockApi.getMe()).thenThrow(ApiException('Unauthorized', statusCode: 401));
      when(() => mockApi.refresh('refresh_tok'))
          .thenAnswer((_) async => authResponse);
      when(() => mockApi.setAccessToken('access_tok')).thenReturn(null);
      when(() => mockStorage.write(key: 'accessToken', value: 'access_tok'))
          .thenAnswer((_) async {});
      when(() => mockStorage.write(key: 'refreshToken', value: 'refresh_tok'))
          .thenAnswer((_) async {});

      final notifier = await createNotifier();

      expect(notifier.state.isAuthenticated, true);
      expect(notifier.state.user!.id, 1);
    });

    test('login success', () async {
      final notifier = await createNotifier();

      when(() => mockApi.login('test@example.com', 'password'))
          .thenAnswer((_) async => authResponse);
      when(() => mockApi.setAccessToken('access_tok')).thenReturn(null);
      when(() => mockStorage.write(key: 'accessToken', value: 'access_tok'))
          .thenAnswer((_) async {});
      when(() => mockStorage.write(key: 'refreshToken', value: 'refresh_tok'))
          .thenAnswer((_) async {});

      final result = await notifier.login('test@example.com', 'password');

      expect(result, true);
      expect(notifier.state.isAuthenticated, true);
      expect(notifier.state.user!.email, 'test@example.com');
      expect(notifier.state.isLoading, false);
      expect(notifier.state.error, isNull);
    });

    test('login ApiException sets error', () async {
      final notifier = await createNotifier();

      when(() => mockApi.login('bad@email.com', 'wrong'))
          .thenThrow(ApiException('Email ou mot de passe invalide', statusCode: 401));

      final result = await notifier.login('bad@email.com', 'wrong');

      expect(result, false);
      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.error, 'Email ou mot de passe invalide');
    });

    test('login generic exception sets default error', () async {
      final notifier = await createNotifier();

      when(() => mockApi.login(any(), any()))
          .thenThrow(Exception('network'));

      final result = await notifier.login('a@b.com', 'pass');

      expect(result, false);
      expect(notifier.state.error, 'Erreur de connexion');
    });

    test('signup success', () async {
      final notifier = await createNotifier();

      when(() => mockApi.signup('new@test.com', 'secret', 'NewUser'))
          .thenAnswer((_) async => authResponse);
      when(() => mockApi.setAccessToken('access_tok')).thenReturn(null);
      when(() => mockStorage.write(key: 'accessToken', value: 'access_tok'))
          .thenAnswer((_) async {});
      when(() => mockStorage.write(key: 'refreshToken', value: 'refresh_tok'))
          .thenAnswer((_) async {});

      final result = await notifier.signup('new@test.com', 'secret', 'NewUser');

      expect(result, true);
      expect(notifier.state.isAuthenticated, true);
      expect(notifier.state.user!.displayName, 'Hero');
    });

    test('signup ApiException sets error', () async {
      final notifier = await createNotifier();

      when(() => mockApi.signup(any(), any(), any()))
          .thenThrow(ApiException('Email deja utilisé', statusCode: 409));

      final result = await notifier.signup('dup@test.com', 'pass', 'Dup');

      expect(result, false);
      expect(notifier.state.error, 'Email deja utilisé');
    });

    test('signup generic exception sets default error', () async {
      final notifier = await createNotifier();

      when(() => mockApi.signup(any(), any(), any()))
          .thenThrow(Exception('network'));

      final result = await notifier.signup('a@b.com', 'p', 'N');

      expect(result, false);
      expect(notifier.state.error, "Erreur lors de l'inscription");
    });

    test('logout clears state and storage', () async {
      final notifier = await createNotifier();

      // First login
      when(() => mockApi.login('test@example.com', 'password'))
          .thenAnswer((_) async => authResponse);
      when(() => mockApi.setAccessToken(any())).thenReturn(null);
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});
      await notifier.login('test@example.com', 'password');
      expect(notifier.state.isAuthenticated, true);

      // Then logout
      when(() => mockStorage.deleteAll()).thenAnswer((_) async {});
      when(() => mockSocial.signOutGoogle()).thenAnswer((_) async {});

      await notifier.logout();

      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.user, isNull);
      verify(() => mockStorage.deleteAll()).called(1);
      verify(() => mockApi.setAccessToken(null)).called(1);
    });

    test('socialLogin google success', () async {
      final notifier = await createNotifier();

      when(() => mockSocial.signInWithGoogle()).thenAnswer(
        (_) async => SocialSignInResult(
          provider: 'google',
          idToken: 'google_id_token',
          displayName: 'Google User',
          email: 'google@test.com',
        ),
      );
      when(() => mockApi.socialLogin(
            idToken: 'google_id_token',
            accessToken: null,
            provider: 'google',
            displayName: 'Google User',
          )).thenAnswer((_) async => authResponse);
      when(() => mockApi.setAccessToken('access_tok')).thenReturn(null);
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      final result = await notifier.socialLogin('google');

      expect(result, true);
      expect(notifier.state.isAuthenticated, true);
    });

    test('socialLogin SocialAuthException sets error', () async {
      final notifier = await createNotifier();

      when(() => mockSocial.signInWithGoogle())
          .thenThrow(SocialAuthException('Connexion Google annulee'));

      final result = await notifier.socialLogin('google');

      expect(result, false);
      expect(notifier.state.error, 'Connexion Google annulee');
    });

    test('socialLogin unknown provider sets error', () async {
      final notifier = await createNotifier();

      final result = await notifier.socialLogin('facebook');

      expect(result, false);
      expect(notifier.state.error, 'Erreur de connexion sociale');
    });

    test('refreshUser updates user in state', () async {
      final notifier = await createNotifier();

      // Login first
      when(() => mockApi.login('test@example.com', 'password'))
          .thenAnswer((_) async => authResponse);
      when(() => mockApi.setAccessToken(any())).thenReturn(null);
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});
      await notifier.login('test@example.com', 'password');

      // Refresh user
      const updatedUser = User(
        id: 1,
        email: 'test@example.com',
        displayName: 'Hero Updated',
        xp: 200,
        level: 3,
      );
      when(() => mockApi.getMe()).thenAnswer((_) async => updatedUser);

      await notifier.refreshUser();

      expect(notifier.state.user!.displayName, 'Hero Updated');
      expect(notifier.state.user!.xp, 200);
    });
  });
}
