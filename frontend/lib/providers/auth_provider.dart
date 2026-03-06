import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_response.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/social_auth_service.dart';
import 'notification_provider.dart';

// State pour l'auth
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Provider for FlutterSecureStorage — can be overridden in tests
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(apiServiceProvider),
    ref.read(secureStorageProvider),
    ref.read(socialAuthServiceProvider),
    ref,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _api;
  final FlutterSecureStorage _storage;
  final SocialAuthService _socialAuth;
  final Ref _ref;

  AuthNotifier(this._api, this._storage, this._socialAuth, this._ref) : super(const AuthState()) {
    _tryAutoLogin();
  }

  /// Initialize push notifications after successful authentication.
  void _initNotifications() {
    try {
      _ref.read(notificationProvider.notifier).initialize();
    } catch (_) {
      // Firebase may not be configured — silently ignore
    }
  }

  /// Maps an [AuthResponse] user into a domain [User].
  User _userFromAuth(AuthResponse authResp) {
    return User(
      id: authResp.user.id,
      email: authResp.user.email,
      displayName: authResp.user.displayName,
      xp: authResp.user.xp,
      level: authResp.user.level,
      coins: authResp.user.coins,
      gems: authResp.user.gems,
      avatarId: authResp.user.avatarId,
    );
  }

  Future<void> _tryAutoLogin() async {
    state = state.copyWith(isLoading: true);
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      final refreshToken = await _storage.read(key: 'refreshToken');

      if (accessToken != null) {
        _api.setAccessToken(accessToken);
        try {
          final user = await _api.getMe();
          state = AuthState(
            user: user,
            isAuthenticated: true,
            isLoading: false,
          );
          _initNotifications();
          return;
        } catch (_) {
          // Token expire, essayer le refresh
          if (refreshToken != null) {
            try {
              final authResp = await _api.refresh(refreshToken);
              await _saveTokens(authResp);
              state = AuthState(
                user: _userFromAuth(authResp),
                isAuthenticated: true,
                isLoading: false,
              );
              _initNotifications();
              return;
            } catch (_) {
              // Refresh echoue
            }
          }
        }
      }
    } catch (_) {
      // Erreur de storage
    }
    state = const AuthState(isLoading: false);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authResp = await _api.login(email, password);
      await _saveTokens(authResp);
      state = AuthState(
        user: _userFromAuth(authResp),
        isAuthenticated: true,
        isLoading: false,
      );
      _initNotifications();
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Erreur de connexion');
      return false;
    }
  }

  Future<bool> signup(
      String email, String password, String displayName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authResp = await _api.signup(email, password, displayName);
      await _saveTokens(authResp);
      state = AuthState(
        user: _userFromAuth(authResp),
        isAuthenticated: true,
        isLoading: false,
      );
      _initNotifications();
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Erreur lors de l\'inscription');
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    _api.setAccessToken(null);
    await _socialAuth.signOutGoogle();
    state = const AuthState();
  }

  /// Social login (Google or Apple).
  /// Triggers the native sign-in flow, then sends the ID token to the backend.
  Future<bool> socialLogin(String provider) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // 1. Client-side social sign-in
      final SocialSignInResult result;
      if (provider == 'google') {
        result = await _socialAuth.signInWithGoogle();
      } else if (provider == 'apple') {
        result = await _socialAuth.signInWithApple();
      } else {
        throw Exception('Provider inconnu: $provider');
      }

      // 2. Send token to backend
      final authResp = await _api.socialLogin(
        idToken: result.idToken,
        accessToken: result.accessToken,
        provider: result.provider,
        displayName: result.displayName,
      );

      // 3. Save tokens and update state
      await _saveTokens(authResp);
      state = AuthState(
        user: _userFromAuth(authResp),
        isAuthenticated: true,
        isLoading: false,
      );
      _initNotifications();
      return true;
    } on SocialAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Erreur de connexion sociale');
      return false;
    }
  }

  Future<void> refreshUser() async {
    try {
      final user = await _api.getMe();
      state = state.copyWith(user: user);
    } catch (_) {}
  }

  Future<void> _saveTokens(AuthResponse authResp) async {
    await _storage.write(key: 'accessToken', value: authResp.accessToken);
    await _storage.write(key: 'refreshToken', value: authResp.refreshToken);
    _api.setAccessToken(authResp.accessToken);
  }
}
