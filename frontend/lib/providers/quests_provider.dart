import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quest.dart';
import '../services/api_service.dart';

class QuestsState {
  final List<Quest> quests;
  final bool isLoading;
  final String? error;

  const QuestsState({
    this.quests = const [],
    this.isLoading = false,
    this.error,
  });

  QuestsState copyWith({
    List<Quest>? quests,
    bool? isLoading,
    String? error,
  }) {
    return QuestsState(
      quests: quests ?? this.quests,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final questsProvider =
    StateNotifierProvider<QuestsNotifier, QuestsState>((ref) {
  return QuestsNotifier(ref.read(apiServiceProvider));
});

class QuestsNotifier extends StateNotifier<QuestsState> {
  final ApiService _api;

  QuestsNotifier(this._api) : super(const QuestsState());

  Future<void> loadQuests() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final quests = await _api.getQuests();
      state = QuestsState(quests: quests, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Erreur de chargement des quetes');
    }
  }

  Future<Quest?> createQuest({
    required String title,
    String? description,
    required QuestDifficulty difficulty,
    String? dueDate,
    QuestCategory? category,
    QuestRecurrence? recurrence,
  }) async {
    try {
      final quest = await _api.createQuest(
        title: title,
        description: description,
        difficulty: difficulty,
        dueDate: dueDate,
        category: category,
        recurrence: recurrence,
      );
      state = state.copyWith(quests: [quest, ...state.quests]);
      return quest;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  Future<Quest?> completeQuest(int id) async {
    try {
      final quest = await _api.completeQuest(id);
      final updated = state.quests
          .map((q) => q.id == id ? quest : q)
          .toList();
      state = state.copyWith(quests: updated);
      return quest;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  Future<bool> deleteQuest(int id) async {
    try {
      await _api.deleteQuest(id);
      final updated = state.quests.where((q) => q.id != id).toList();
      state = state.copyWith(quests: updated);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }
}
