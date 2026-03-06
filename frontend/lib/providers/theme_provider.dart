import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================================
//  Auto / Light / Dark theme provider — persists choice via SharedPreferences
// ============================================================================

const _kThemeKey = 'questify_theme_mode';

/// Three appearance modes: auto follows the OS, light/dark are explicit.
enum QuestifyThemeMode { auto, light, dark }

class ThemeNotifier extends StateNotifier<QuestifyThemeMode> {
  ThemeNotifier() : super(QuestifyThemeMode.auto) {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemeKey);
    switch (saved) {
      case 'light':
        state = QuestifyThemeMode.light;
        break;
      case 'dark':
        state = QuestifyThemeMode.dark;
        break;
      default:
        state = QuestifyThemeMode.auto;
    }
  }

  Future<void> setMode(QuestifyThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeKey, mode.name);
  }

  /// Whether the effective theme is dark right now (resolves "auto" using OS).
  bool get isDark {
    if (state == QuestifyThemeMode.dark) return true;
    if (state == QuestifyThemeMode.light) return false;
    // auto — check platform brightness
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  /// Converts to [ThemeMode] for MaterialApp.
  ThemeMode get themeMode {
    switch (state) {
      case QuestifyThemeMode.light:
        return ThemeMode.light;
      case QuestifyThemeMode.dark:
        return ThemeMode.dark;
      case QuestifyThemeMode.auto:
        return ThemeMode.system;
    }
  }
}

final themeProvider =
    StateNotifierProvider<ThemeNotifier, QuestifyThemeMode>((ref) {
  return ThemeNotifier();
});
