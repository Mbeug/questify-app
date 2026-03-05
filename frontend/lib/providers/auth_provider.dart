import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_response.dart';
import '../models/user.dart';
import '../services/api_service.dart';
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
    ref,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _api;
  final FlutterSecureStorage _storage;
  final Ref _ref;

  AuthNotifier(this._api, this._storage, this._ref) : super(const AuthState()) {
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
                user: User(
                  id: authResp.user.id,
                  email: authResp.user.email,
                  displayName: authResp.user.displayName,
                  xp: authResp.user.xp,
                  level: authResp.user.level,
                ),
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
        user: User(
          id: authResp.user.id,
          email: authResp.user.email,
          displayName: authResp.user.displayName,
          xp: authResp.user.xp,
          level: authResp.user.level,
        ),
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
        user: User(
          id: authResp.user.id,
          email: authResp.user.email,
          displayName: authResp.user.displayName,
          xp: authResp.user.xp,
          level: authResp.user.level,
        ),
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
    state = const AuthState();
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
