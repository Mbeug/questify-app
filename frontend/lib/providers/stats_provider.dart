import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_stats.dart';
import '../services/api_service.dart';

final statsProvider =
    StateNotifierProvider<StatsNotifier, AsyncValue<UserStats>>((ref) {
  return StatsNotifier(ref.read(apiServiceProvider));
});

class StatsNotifier extends StateNotifier<AsyncValue<UserStats>> {
  final ApiService _api;

  StatsNotifier(this._api) : super(const AsyncValue.loading());

  Future<void> loadStats() async {
    state = const AsyncValue.loading();
    try {
      final stats = await _api.getMyStats();
      state = AsyncValue.data(stats);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
