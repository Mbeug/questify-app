import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_theme.dart';
import '../services/api_service.dart';

class CustomizationState {
  final List<AppThemeModel> themes;
  final bool isLoading;
  final String? error;

  const CustomizationState({
    this.themes = const [],
    this.isLoading = false,
    this.error,
  });

  CustomizationState copyWith({
    List<AppThemeModel>? themes,
    bool? isLoading,
    String? error,
  }) {
    return CustomizationState(
      themes: themes ?? this.themes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final customizationProvider =
    StateNotifierProvider<CustomizationNotifier, CustomizationState>((ref) {
  return CustomizationNotifier(ref.read(apiServiceProvider));
});

class CustomizationNotifier extends StateNotifier<CustomizationState> {
  final ApiService _api;

  CustomizationNotifier(this._api) : super(const CustomizationState());

  Future<void> loadThemes() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final themes = await _api.getThemes();
      state = CustomizationState(themes: themes, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erreur de chargement');
    }
  }

  Future<bool> buyTheme(int themeId) async {
    try {
      await _api.buyTheme(themeId);
      await loadThemes(); // Reload to get updated ownership
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }

  Future<bool> applyTheme(int themeId) async {
    try {
      await _api.applyTheme(themeId);
      await loadThemes();
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }
}
