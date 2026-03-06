// lib/services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/achievement.dart';
import '../models/app_theme.dart';
import '../models/auth_response.dart';
import '../models/group.dart';
import '../models/quest.dart';
import '../models/user.dart';
import '../models/user_stats.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  ApiService({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ??
            const String.fromEnvironment('API_BASE_URL',
                defaultValue: 'http://localhost:8080'),
        _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;
  final Duration timeout = const Duration(seconds: 10);

  String? _accessToken;

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  // ── Auth ──────────────────────────────────────────

  Future<AuthResponse> signup(
      String email, String password, String displayName) async {
    final resp = await _post('/api/auth/signup', {
      'email': email,
      'password': password,
      'displayName': displayName,
    });
    return AuthResponse.fromJson(resp);
  }

  Future<AuthResponse> login(String email, String password) async {
    final resp = await _post('/api/auth/login', {
      'email': email,
      'password': password,
    });
    return AuthResponse.fromJson(resp);
  }

  Future<AuthResponse> refresh(String refreshToken) async {
    final resp = await _post('/api/auth/refresh', {
      'refreshToken': refreshToken,
    });
    return AuthResponse.fromJson(resp);
  }

  Future<AuthResponse> socialLogin({
    String? idToken,
    String? accessToken,
    required String provider,
    String? displayName,
  }) async {
    final body = <String, dynamic>{
      'provider': provider,
    };
    if (idToken != null) body['idToken'] = idToken;
    if (accessToken != null) body['accessToken'] = accessToken;
    if (displayName != null) body['displayName'] = displayName;
    final resp = await _post('/api/auth/social', body);
    return AuthResponse.fromJson(resp);
  }

  // ── User ──────────────────────────────────────────

  Future<User> getMe() async {
    final resp = await _get('/api/users/me');
    return User.fromJson(resp);
  }

  Future<UserStats> getMyStats() async {
    final resp = await _get('/api/users/me/stats');
    return UserStats.fromJson(resp);
  }

  Future<User> updateProfile({String? displayName, String? avatarId}) async {
    final body = <String, dynamic>{};
    if (displayName != null) body['displayName'] = displayName;
    if (avatarId != null) body['avatarId'] = avatarId;
    final resp = await _patch('/api/users/me', body);
    return User.fromJson(resp);
  }

  // ── Quests ────────────────────────────────────────

  Future<List<Quest>> getQuests({QuestStatus? status}) async {
    final query = status != null ? '?status=${status.name}' : '';
    final resp = await _getList('/api/quests$query');
    return resp.map((q) => Quest.fromJson(q)).toList();
  }

  Future<Quest> getQuest(int id) async {
    final resp = await _get('/api/quests/$id');
    return Quest.fromJson(resp);
  }

  Future<Quest> createQuest({
    required String title,
    String? description,
    required QuestDifficulty difficulty,
    String? dueDate,
    QuestCategory? category,
    QuestRecurrence? recurrence,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'difficulty': difficulty.name,
    };
    if (description != null) body['description'] = description;
    if (dueDate != null) body['dueDate'] = dueDate;
    if (category != null) body['category'] = category.name;
    if (recurrence != null) body['recurrence'] = recurrence.name;

    final resp = await _post('/api/quests', body);
    return Quest.fromJson(resp);
  }

  Future<Quest> updateQuest(int id, Map<String, dynamic> updates) async {
    final resp = await _put('/api/quests/$id', updates);
    return Quest.fromJson(resp);
  }

  Future<Quest> completeQuest(int id) async {
    final resp = await _post('/api/quests/$id/complete', {});
    return Quest.fromJson(resp);
  }

  Future<void> deleteQuest(int id) async {
    await _delete('/api/quests/$id');
  }

  // ── Groups ──────────────────────────────────────────

  Future<List<QuestGroup>> getMyGroups() async {
    final resp = await _getList('/api/groups');
    return resp.map((g) => QuestGroup.fromJson(g as Map<String, dynamic>)).toList();
  }

  Future<QuestGroup> getGroup(int id) async {
    final resp = await _get('/api/groups/$id');
    return QuestGroup.fromJson(resp);
  }

  Future<QuestGroup> createGroup({
    required String name,
    String? description,
    String? bannerEmoji,
    int? weeklyGoal,
  }) async {
    final body = <String, dynamic>{'name': name};
    if (description != null) body['description'] = description;
    if (bannerEmoji != null) body['bannerEmoji'] = bannerEmoji;
    if (weeklyGoal != null) body['weeklyGoal'] = weeklyGoal;
    final resp = await _post('/api/groups', body);
    return QuestGroup.fromJson(resp);
  }

  Future<QuestGroup> joinGroup(String inviteCode) async {
    final resp = await _post('/api/groups/join', {'inviteCode': inviteCode});
    return QuestGroup.fromJson(resp);
  }

  Future<void> leaveGroup(int groupId) async {
    await _post('/api/groups/$groupId/leave', {});
  }

  Future<void> removeMember(int groupId, int userId) async {
    await _delete('/api/groups/$groupId/members/$userId');
  }

  // ── Themes ──────────────────────────────────────────

  Future<List<AppThemeModel>> getThemes() async {
    final resp = await _getList('/api/themes');
    return resp.map((t) => AppThemeModel.fromJson(t as Map<String, dynamic>)).toList();
  }

  Future<AppThemeModel> buyTheme(int themeId) async {
    final resp = await _post('/api/themes/$themeId/buy', {});
    return AppThemeModel.fromJson(resp);
  }

  Future<AppThemeModel> applyTheme(int themeId) async {
    final resp = await _post('/api/themes/$themeId/apply', {});
    return AppThemeModel.fromJson(resp);
  }

  // ── Achievements ────────────────────────────────────

  Future<List<Achievement>> getAchievements() async {
    final resp = await _getList('/api/achievements');
    return resp.map((a) => Achievement.fromJson(a as Map<String, dynamic>)).toList();
  }

  // ── Hello (test) ──────────────────────────────────

  Future<String> getHello() async {
    final uri = Uri.parse('$baseUrl/api/hello');
    try {
      final resp = await _client
          .get(uri, headers: {'Accept': 'text/plain'}).timeout(timeout);
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return resp.body.trim();
      }
      throw ApiException('Erreur serveur (${resp.statusCode})');
    } on TimeoutException {
      throw ApiException('La requete a expire. Reessaie dans un instant.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
          'Impossible de joindre le serveur. Verifie ta connexion.');
    }
  }

  // ── Calendar ─────────────────────────────────────

  /// Link a Google Calendar event ID to a quest on the backend.
  Future<Quest> linkCalendarEvent(int questId, String calendarEventId) async {
    final resp = await _post('/api/calendar/link/$questId', {
      'calendarEventId': calendarEventId,
    });
    return Quest.fromJson(resp);
  }

  /// Unlink a Google Calendar event from a quest.
  Future<Quest> unlinkCalendarEvent(int questId) async {
    final resp = await _delete2('/api/calendar/link/$questId');
    return Quest.fromJson(resp);
  }

  // ── Notifications ────────────────────────────────

  /// Register the FCM token with the backend.
  Future<void> registerFcmToken(String fcmToken) async {
    await _post('/api/notifications/register', {'fcmToken': fcmToken});
  }

  /// Get notification preferences.
  Future<Map<String, dynamic>> getNotificationPreferences() async {
    return await _get('/api/notifications/preferences');
  }

  /// Update notification preferences.
  Future<Map<String, dynamic>> updateNotificationPreferences(
      {required bool enabled}) async {
    return await _patch(
        '/api/notifications/preferences', {'enabled': enabled});
  }

  // ── HTTP helpers ──────────────────────────────────

  Future<Map<String, dynamic>> _get(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final resp =
        await _client.get(uri, headers: _headers).timeout(timeout);
    return _handleResponse(resp);
  }

  Future<List<dynamic>> _getList(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final resp =
        await _client.get(uri, headers: _headers).timeout(timeout);
    return _handleListResponse(resp);
  }

  Future<Map<String, dynamic>> _post(
      String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final resp = await _client
        .post(uri, headers: _headers, body: json.encode(body))
        .timeout(timeout);
    return _handleResponse(resp);
  }

  Future<Map<String, dynamic>> _put(
      String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final resp = await _client
        .put(uri, headers: _headers, body: json.encode(body))
        .timeout(timeout);
    return _handleResponse(resp);
  }

  Future<Map<String, dynamic>> _patch(
      String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final resp = await _client
        .patch(uri, headers: _headers, body: json.encode(body))
        .timeout(timeout);
    return _handleResponse(resp);
  }

  Future<void> _delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final resp =
        await _client.delete(uri, headers: _headers).timeout(timeout);
    if (resp.statusCode >= 300) {
      _throwApiError(resp);
    }
  }

  Future<Map<String, dynamic>> _delete2(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final resp =
        await _client.delete(uri, headers: _headers).timeout(timeout);
    return _handleResponse(resp);
  }

  Map<String, dynamic> _handleResponse(http.Response resp) {
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      if (resp.body.isEmpty) return {};
      return json.decode(resp.body) as Map<String, dynamic>;
    }
    _throwApiError(resp);
  }

  List<dynamic> _handleListResponse(http.Response resp) {
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      if (resp.body.isEmpty) return [];
      return json.decode(resp.body) as List<dynamic>;
    }
    _throwApiError(resp);
  }

  Never _throwApiError(http.Response resp) {
    String message;
    try {
      final body = json.decode(resp.body);
      message = body['error'] ?? body['message'] ?? 'Erreur serveur';
    } catch (_) {
      message = 'Erreur serveur (${resp.statusCode})';
    }
    throw ApiException(message, statusCode: resp.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});
  @override
  String toString() => message;
}
