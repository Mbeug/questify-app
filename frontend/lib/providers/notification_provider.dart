// lib/providers/notification_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/api_service.dart';

/// State for push notification settings
class NotificationState {
  final bool isEnabled;
  final bool isLoading;
  final String? error;
  final String? fcmToken;

  const NotificationState({
    this.isEnabled = true,
    this.isLoading = false,
    this.error,
    this.fcmToken,
  });

  NotificationState copyWith({
    bool? isEnabled,
    bool? isLoading,
    String? error,
    String? fcmToken,
  }) {
    return NotificationState(
      isEnabled: isEnabled ?? this.isEnabled,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}

final firebaseMessagingProvider = Provider<FirebaseMessaging>(
  (ref) => FirebaseMessaging.instance,
);

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(
    ref.read(apiServiceProvider),
    ref.read(firebaseMessagingProvider),
  );
});

class NotificationNotifier extends StateNotifier<NotificationState> {
  final ApiService _api;
  final FirebaseMessaging _messaging;

  NotificationNotifier(this._api, this._messaging)
      : super(const NotificationState());

  /// Initialize Firebase Messaging: request permission, get token, register.
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    try {
      // Request notification permission
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        state = state.copyWith(
          isLoading: false,
          isEnabled: false,
          error: 'Notifications refusees par l\'utilisateur',
        );
        return;
      }

      // Get FCM token
      final token = await _messaging.getToken();
      if (token != null) {
        // Register token on backend
        await _api.registerFcmToken(token);
        state = state.copyWith(
          isLoading: false,
          isEnabled: true,
          fcmToken: token,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Impossible d\'obtenir le token FCM',
        );
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) async {
        try {
          await _api.registerFcmToken(newToken);
          if (mounted) {
            state = state.copyWith(fcmToken: newToken);
          }
        } catch (_) {}
      });
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur initialisation notifications: $e',
      );
    }
  }

  /// Load notification preferences from backend.
  Future<void> loadPreferences() async {
    try {
      final prefs = await _api.getNotificationPreferences();
      state = state.copyWith(
        isEnabled: prefs['notificationsEnabled'] as bool? ?? true,
      );
    } catch (_) {}
  }

  /// Toggle notifications on/off.
  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(isLoading: true);
    try {
      await _api.updateNotificationPreferences(enabled: enabled);
      state = state.copyWith(isLoading: false, isEnabled: enabled);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur mise a jour preferences: $e',
      );
    }
  }
}
