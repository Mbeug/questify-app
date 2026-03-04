// lib/providers/calendar_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;

import 'package:http/http.dart' as http;

import '../models/quest.dart';
import '../services/api_service.dart';

/// State for Google Calendar integration
class CalendarState {
  final bool isConnected;
  final bool isLoading;
  final String? error;
  final String? googleEmail;

  const CalendarState({
    this.isConnected = false,
    this.isLoading = false,
    this.error,
    this.googleEmail,
  });

  CalendarState copyWith({
    bool? isConnected,
    bool? isLoading,
    String? error,
    String? googleEmail,
  }) {
    return CalendarState(
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      googleEmail: googleEmail ?? this.googleEmail,
    );
  }
}

final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn(
      scopes: [gcal.CalendarApi.calendarEventsScope],
    ));

final calendarProvider =
    StateNotifierProvider<CalendarNotifier, CalendarState>((ref) {
  return CalendarNotifier(
    ref.read(apiServiceProvider),
    ref.read(googleSignInProvider),
  );
});

class CalendarNotifier extends StateNotifier<CalendarState> {
  final ApiService _api;
  final GoogleSignIn _googleSignIn;

  CalendarNotifier(this._api, this._googleSignIn)
      : super(const CalendarState()) {
    _checkExistingSignIn();
  }

  Future<void> _checkExistingSignIn() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        state = CalendarState(
          isConnected: true,
          googleEmail: account.email,
        );
      }
    } catch (_) {
      // Not signed in
    }
  }

  /// Sign in with Google and request Calendar scope
  Future<bool> connectGoogleCalendar() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        state = state.copyWith(isLoading: false, error: 'Connexion annulee');
        return false;
      }

      state = CalendarState(
        isConnected: true,
        isLoading: false,
        googleEmail: account.email,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Erreur connexion Google: $e');
      return false;
    }
  }

  /// Disconnect from Google Calendar
  Future<void> disconnectGoogleCalendar() async {
    await _googleSignIn.signOut();
    state = const CalendarState();
  }

  /// Create a Google Calendar event for a quest and link it on the backend.
  Future<Quest?> syncQuestToCalendar(Quest quest) async {
    if (!state.isConnected) return null;

    try {
      final account = _googleSignIn.currentUser;
      if (account == null) return null;

      final authHeaders = await account.authHeaders;
      final authenticatedClient = GoogleAuthClient(authHeaders);

      final calendarApi = gcal.CalendarApi(authenticatedClient);

      // Parse due date or use today + 1 day
      DateTime eventDate;
      if (quest.dueDate != null && quest.dueDate!.isNotEmpty) {
        eventDate = DateTime.parse(quest.dueDate!);
      } else {
        eventDate = DateTime.now().add(const Duration(days: 1));
      }

      final event = gcal.Event()
        ..summary = '[Questify] ${quest.title}'
        ..description = quest.description ?? 'Quete Questify'
        ..start = (gcal.EventDateTime()
          ..dateTime = eventDate
          ..timeZone = 'Europe/Paris')
        ..end = (gcal.EventDateTime()
          ..dateTime = eventDate.add(const Duration(hours: 1))
          ..timeZone = 'Europe/Paris')
        ..reminders = (gcal.EventReminders()
          ..useDefault = false
          ..overrides = [
            gcal.EventReminder()
              ..method = 'popup'
              ..minutes = 60,
          ]);

      final createdEvent =
          await calendarApi.events.insert(event, 'primary');

      if (createdEvent.id != null) {
        // Link the calendar event ID to the quest on the backend
        final updatedQuest =
            await _api.linkCalendarEvent(quest.id, createdEvent.id!);
        return updatedQuest;
      }
      return null;
    } catch (e) {
      state = state.copyWith(error: 'Erreur sync calendrier: $e');
      return null;
    }
  }

  /// Remove a quest's calendar event and unlink it.
  Future<Quest?> removeQuestFromCalendar(Quest quest) async {
    if (!state.isConnected || quest.calendarEventId == null) return null;

    try {
      final account = _googleSignIn.currentUser;
      if (account == null) return null;

      final authHeaders = await account.authHeaders;
      final authenticatedClient = GoogleAuthClient(authHeaders);

      final calendarApi = gcal.CalendarApi(authenticatedClient);

      try {
        await calendarApi.events.delete('primary', quest.calendarEventId!);
      } catch (_) {
        // Event might already be deleted — continue to unlink
      }

      final updatedQuest = await _api.unlinkCalendarEvent(quest.id);
      return updatedQuest;
    } catch (e) {
      state = state.copyWith(error: 'Erreur suppression calendrier: $e');
      return null;
    }
  }
}

/// Wraps Google Auth headers into an HTTP client for googleapis.
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}
