import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/achievement.dart';
import '../services/api_service.dart';

final achievementProvider =
    StateNotifierProvider<AchievementNotifier, AsyncValue<List<Achievement>>>((ref) {
  return AchievementNotifier(ref.read(apiServiceProvider));
});

class AchievementNotifier extends StateNotifier<AsyncValue<List<Achievement>>> {
  final ApiService _api;

  AchievementNotifier(this._api) : super(const AsyncValue.loading());

  Future<void> loadAchievements() async {
    state = const AsyncValue.loading();
    try {
      final achievements = await _api.getAchievements();
      state = AsyncValue.data(achievements);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
