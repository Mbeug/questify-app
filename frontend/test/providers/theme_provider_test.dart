import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend/providers/theme_provider.dart';

void main() {
  group('ThemeNotifier', () {
    setUp(() {
      // Reset SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is day', () {
      final notifier = ThemeNotifier();
      expect(notifier.state, QuestifyThemeMode.day);
      expect(notifier.isDark, false);
      expect(notifier.themeMode, ThemeMode.light);
    });

    test('toggle switches from day to night', () async {
      final notifier = ThemeNotifier();
      await notifier.toggle();

      expect(notifier.state, QuestifyThemeMode.night);
      expect(notifier.isDark, true);
      expect(notifier.themeMode, ThemeMode.dark);
    });

    test('toggle switches from night back to day', () async {
      final notifier = ThemeNotifier();
      await notifier.toggle(); // day -> night
      await notifier.toggle(); // night -> day

      expect(notifier.state, QuestifyThemeMode.day);
      expect(notifier.isDark, false);
    });

    test('setMode sets explicit mode', () async {
      final notifier = ThemeNotifier();
      await notifier.setMode(QuestifyThemeMode.night);

      expect(notifier.state, QuestifyThemeMode.night);
      expect(notifier.isDark, true);
    });

    test('toggle persists choice in SharedPreferences', () async {
      final notifier = ThemeNotifier();
      await notifier.toggle(); // day -> night

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('questify_theme_mode'), 'night');
    });

    test('setMode persists choice in SharedPreferences', () async {
      final notifier = ThemeNotifier();
      await notifier.setMode(QuestifyThemeMode.night);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('questify_theme_mode'), 'night');
    });

    test('loads saved night mode from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'questify_theme_mode': 'night',
      });

      final notifier = ThemeNotifier();
      // _loadSaved runs in the constructor, need to wait for it
      await Future.delayed(Duration.zero);

      expect(notifier.state, QuestifyThemeMode.night);
      expect(notifier.isDark, true);
    });

    test('loads saved day mode (or no saved value) as day', () async {
      SharedPreferences.setMockInitialValues({
        'questify_theme_mode': 'day',
      });

      final notifier = ThemeNotifier();
      await Future.delayed(Duration.zero);

      expect(notifier.state, QuestifyThemeMode.day);
      expect(notifier.isDark, false);
    });

    test('unknown saved value defaults to day', () async {
      SharedPreferences.setMockInitialValues({
        'questify_theme_mode': 'something_else',
      });

      final notifier = ThemeNotifier();
      await Future.delayed(Duration.zero);

      expect(notifier.state, QuestifyThemeMode.day);
    });
  });
}
