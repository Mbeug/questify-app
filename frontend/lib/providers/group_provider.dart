import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/group.dart';
import '../services/api_service.dart';

class GroupState {
  final List<QuestGroup> groups;
  final QuestGroup? selectedGroup;
  final bool isLoading;
  final String? error;

  const GroupState({
    this.groups = const [],
    this.selectedGroup,
    this.isLoading = false,
    this.error,
  });

  GroupState copyWith({
    List<QuestGroup>? groups,
    QuestGroup? selectedGroup,
    bool? isLoading,
    String? error,
  }) {
    return GroupState(
      groups: groups ?? this.groups,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final groupProvider =
    StateNotifierProvider<GroupNotifier, GroupState>((ref) {
  return GroupNotifier(ref.read(apiServiceProvider));
});

class GroupNotifier extends StateNotifier<GroupState> {
  final ApiService _api;

  GroupNotifier(this._api) : super(const GroupState());

  Future<void> loadGroups() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final groups = await _api.getMyGroups();
      state = GroupState(groups: groups, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erreur de chargement');
    }
  }

  Future<void> loadGroup(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final group = await _api.getGroup(id);
      state = state.copyWith(selectedGroup: group, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<QuestGroup?> createGroup({
    required String name,
    String? description,
    String? bannerEmoji,
    int? weeklyGoal,
  }) async {
    try {
      final group = await _api.createGroup(
        name: name,
        description: description,
        bannerEmoji: bannerEmoji,
        weeklyGoal: weeklyGoal,
      );
      state = state.copyWith(groups: [group, ...state.groups]);
      return group;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  Future<QuestGroup?> joinGroup(String inviteCode) async {
    try {
      final group = await _api.joinGroup(inviteCode);
      state = state.copyWith(groups: [group, ...state.groups]);
      return group;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  Future<void> leaveGroup(int groupId) async {
    try {
      await _api.leaveGroup(groupId);
      final updated = state.groups.where((g) => g.id != groupId).toList();
      state = state.copyWith(groups: updated);
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
    }
  }
}
