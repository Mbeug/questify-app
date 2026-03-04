import 'package:flutter/material.dart';

// ----------  Questify color palette (RPG / fantasy)  ----------
// Primary: Deep Indigo — evokes mystery & quests
// Secondary: Amber / Gold — XP, rewards, treasure
// Tertiary: Emerald — success, nature, level-up

const _seedColor = Color(0xFF4F46E5); // Indigo 600

final ThemeData appLightTheme = _buildTheme(Brightness.light);
final ThemeData appDarkTheme = _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: brightness,
    secondary: const Color(0xFFF59E0B), // Amber 500
    tertiary: const Color(0xFF10B981), // Emerald 500
  );

  final isDark = brightness == Brightness.dark;

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    brightness: brightness,

    // --- Typography ---
    fontFamily: 'Roboto',
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        color: isDark ? Colors.white : colorScheme.onSurface,
      ),
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: isDark ? Colors.white : colorScheme.onSurface,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: isDark ? Colors.white : colorScheme.onSurface,
      ),
      headlineSmall: const TextStyle(fontWeight: FontWeight.w600),
      titleLarge: const TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      titleMedium: const TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      titleSmall: const TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      bodyLarge: const TextStyle(
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: const TextStyle(
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      labelLarge: const TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),

    // --- AppBar ---
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        letterSpacing: -0.25,
        color: colorScheme.onSurface,
      ),
    ),

    // --- Cards ---
    cardTheme: CardThemeData(
      elevation: isDark ? 2 : 1,
      shadowColor: colorScheme.shadow.withAlpha(isDark ? 80 : 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 4),
    ),

    // --- Elevated button ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // --- Filled button ---
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // --- Outlined button ---
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: colorScheme.outline),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // --- Text button ---
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.25,
        ),
      ),
    ),

    // --- Input decoration ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withAlpha(isDark ? 60 : 80),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.outline.withAlpha(60)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      floatingLabelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: colorScheme.primary,
      ),
    ),

    // --- Navigation bar ---
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      height: 72,
      indicatorColor: colorScheme.primaryContainer,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          );
        }
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurfaceVariant,
        );
      }),
    ),

    // --- SnackBar ---
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
    ),

    // --- Dialog ---
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: colorScheme.onSurface,
      ),
    ),

    // --- FloatingActionButton ---
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 3,
      highlightElevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // --- Divider ---
    dividerTheme: DividerThemeData(
      space: 1,
      thickness: 1,
      color: colorScheme.outlineVariant.withAlpha(80),
    ),

    // --- Chip ---
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
    ),

    // --- Progress indicator ---
    progressIndicatorTheme: ProgressIndicatorThemeData(
      linearTrackColor: colorScheme.surfaceContainerHighest,
      circularTrackColor: colorScheme.surfaceContainerHighest,
    ),

    // --- Page transitions ---
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}
