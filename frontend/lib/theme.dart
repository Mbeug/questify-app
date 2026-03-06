import 'package:flutter/material.dart';

// ============================================================================
//  Questify RPG Theme — matches Figma mockup palette
// ============================================================================

// ──── Accent colors (same in day & night) ────
const kAccentPurple = Color(0xFFA75EFF);
const kAccentGold = Color(0xFFFFD166);
const kAccentMint = Color(0xFF06D6A0);
const kAccentRed = Color(0xFFFF6B6B);
const kAccentCyan = Color(0xFF4ECDC4);

// ──── Day palette ────
const _dayBgPrimary = Color(0xFFF5F7FA);
const _dayBgSecondary = Color(0xFFFFFFFF);
const _dayBgTertiary = Color(0xFFF9FAFB);
const _dayTextPrimary = Color(0xFF1B1B2F);
const _dayTextSecondary = Color(0xFF404968);
const _dayTextMuted = Color(0xFF6B7280);
const _dayBorderDefault = Color(0xFFE5E7EB);
const _dayBorderSubtle = Color(0xFFF3F4F6);

// ──── Night palette ────
const _nightBgPrimary = Color(0xFF1B1B2F);
const _nightBgSecondary = Color(0xFF25274D);
const _nightBgTertiary = Color(0xFF2E3158);
const _nightTextPrimary = Color(0xFFFFFFFF);
const _nightTextSecondary = Color(0xFFE8EAFF);
const _nightTextMuted = Color(0xFFA8AAC5);
const _nightBorderDefault = Color(0xFF3A3D5C);
const _nightBorderSubtle = Color(0xFF2E3158);

// ============================================================================
//  ThemeExtension — extra RPG colors accessible via Theme.of(context)
// ============================================================================

@immutable
class QuestifyColors extends ThemeExtension<QuestifyColors> {
  final Color bgPrimary;
  final Color bgSecondary;
  final Color bgTertiary;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accentPurple;
  final Color accentGold;
  final Color accentMint;
  final Color accentRed;
  final Color accentCyan;
  final Color borderDefault;
  final Color borderSubtle;
  final Color glowPurple;
  final Color glowGold;

  const QuestifyColors({
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgTertiary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accentPurple,
    required this.accentGold,
    required this.accentMint,
    required this.accentRed,
    required this.accentCyan,
    required this.borderDefault,
    required this.borderSubtle,
    required this.glowPurple,
    required this.glowGold,
  });

  static const day = QuestifyColors(
    bgPrimary: _dayBgPrimary,
    bgSecondary: _dayBgSecondary,
    bgTertiary: _dayBgTertiary,
    textPrimary: _dayTextPrimary,
    textSecondary: _dayTextSecondary,
    textMuted: _dayTextMuted,
    accentPurple: kAccentPurple,
    accentGold: kAccentGold,
    accentMint: kAccentMint,
    accentRed: kAccentRed,
    accentCyan: kAccentCyan,
    borderDefault: _dayBorderDefault,
    borderSubtle: _dayBorderSubtle,
    glowPurple: Color(0x4DA75EFF), // 30% opacity
    glowGold: Color(0x4DFFD166),
  );

  static const night = QuestifyColors(
    bgPrimary: _nightBgPrimary,
    bgSecondary: _nightBgSecondary,
    bgTertiary: _nightBgTertiary,
    textPrimary: _nightTextPrimary,
    textSecondary: _nightTextSecondary,
    textMuted: _nightTextMuted,
    accentPurple: kAccentPurple,
    accentGold: kAccentGold,
    accentMint: kAccentMint,
    accentRed: kAccentRed,
    accentCyan: kAccentCyan,
    borderDefault: _nightBorderDefault,
    borderSubtle: _nightBorderSubtle,
    glowPurple: Color(0x66A75EFF), // 40% opacity
    glowGold: Color(0x66FFD166),
  );

  @override
  QuestifyColors copyWith({
    Color? bgPrimary,
    Color? bgSecondary,
    Color? bgTertiary,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accentPurple,
    Color? accentGold,
    Color? accentMint,
    Color? accentRed,
    Color? accentCyan,
    Color? borderDefault,
    Color? borderSubtle,
    Color? glowPurple,
    Color? glowGold,
  }) {
    return QuestifyColors(
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgTertiary: bgTertiary ?? this.bgTertiary,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accentPurple: accentPurple ?? this.accentPurple,
      accentGold: accentGold ?? this.accentGold,
      accentMint: accentMint ?? this.accentMint,
      accentRed: accentRed ?? this.accentRed,
      accentCyan: accentCyan ?? this.accentCyan,
      borderDefault: borderDefault ?? this.borderDefault,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      glowPurple: glowPurple ?? this.glowPurple,
      glowGold: glowGold ?? this.glowGold,
    );
  }

  @override
  QuestifyColors lerp(covariant QuestifyColors? other, double t) {
    if (other == null) return this;
    return QuestifyColors(
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t)!,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t)!,
      bgTertiary: Color.lerp(bgTertiary, other.bgTertiary, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accentPurple: Color.lerp(accentPurple, other.accentPurple, t)!,
      accentGold: Color.lerp(accentGold, other.accentGold, t)!,
      accentMint: Color.lerp(accentMint, other.accentMint, t)!,
      accentRed: Color.lerp(accentRed, other.accentRed, t)!,
      accentCyan: Color.lerp(accentCyan, other.accentCyan, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      glowPurple: Color.lerp(glowPurple, other.glowPurple, t)!,
      glowGold: Color.lerp(glowGold, other.glowGold, t)!,
    );
  }
}

// ============================================================================
//  Helper — quick access from any widget
// ============================================================================

extension QuestifyColorsX on BuildContext {
  QuestifyColors get q =>
      Theme.of(this).extension<QuestifyColors>() ?? QuestifyColors.day;
}

// ============================================================================
//  Build the actual ThemeData (light / dark)
// ============================================================================

final ThemeData questifyLightTheme = _buildTheme(Brightness.light);
final ThemeData questifyDarkTheme = _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final q = isDark ? QuestifyColors.night : QuestifyColors.day;

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: kAccentPurple,
    onPrimary: Colors.white,
    primaryContainer: isDark ? const Color(0xFF3D2B6B) : const Color(0xFFEDE0FF),
    onPrimaryContainer: isDark ? const Color(0xFFE0CCFF) : const Color(0xFF4A1D96),
    secondary: kAccentGold,
    onSecondary: const Color(0xFF1B1B2F),
    secondaryContainer:
        isDark ? const Color(0xFF4D3D1A) : const Color(0xFFFFF3D6),
    onSecondaryContainer:
        isDark ? const Color(0xFFFFE8A3) : const Color(0xFF5C4A1E),
    tertiary: kAccentMint,
    onTertiary: Colors.white,
    tertiaryContainer:
        isDark ? const Color(0xFF0A4D3A) : const Color(0xFFD4F7EC),
    onTertiaryContainer:
        isDark ? const Color(0xFF80EFC8) : const Color(0xFF0A4D3A),
    error: kAccentRed,
    onError: Colors.white,
    errorContainer: isDark ? const Color(0xFF4D2020) : const Color(0xFFFFE0E0),
    onErrorContainer:
        isDark ? const Color(0xFFFFAAAA) : const Color(0xFF5C1A1A),
    surface: q.bgPrimary,
    onSurface: q.textPrimary,
    surfaceContainerHighest: q.bgTertiary,
    onSurfaceVariant: q.textSecondary,
    outline: q.borderDefault,
    outlineVariant: q.borderSubtle,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: isDark ? _dayBgPrimary : _nightBgPrimary,
    onInverseSurface: isDark ? _dayTextPrimary : _nightTextPrimary,
    inversePrimary: isDark ? const Color(0xFF7B3FCC) : const Color(0xFFC99EFF),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    brightness: brightness,
    extensions: [q],

    // --- Typography ---
    fontFamily: 'Roboto',
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        color: q.textPrimary,
      ),
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: q.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: q.textPrimary,
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
      bodyLarge: TextStyle(
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: q.textSecondary,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: q.textSecondary,
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.w400,
        color: q.textMuted,
      ),
      labelLarge: const TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),

    scaffoldBackgroundColor: q.bgPrimary,

    // --- AppBar ---
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: q.bgSecondary,
      foregroundColor: q.textPrimary,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        letterSpacing: -0.25,
        color: q.textPrimary,
      ),
    ),

    // --- Cards ---
    cardTheme: CardThemeData(
      elevation: isDark ? 2 : 1,
      shadowColor: Colors.black.withAlpha(isDark ? 80 : 40),
      color: q.bgSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: q.borderSubtle, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 4),
    ),

    // --- Elevated button ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: kAccentPurple,
        foregroundColor: Colors.white,
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
        backgroundColor: kAccentPurple,
        foregroundColor: Colors.white,
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
        side: BorderSide(color: q.borderDefault),
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
        foregroundColor: kAccentPurple,
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
      fillColor: q.bgTertiary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: q.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kAccentPurple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kAccentRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kAccentRed, width: 2),
      ),
      floatingLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: kAccentPurple,
      ),
    ),

    // --- Navigation bar (bottom) ---
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      height: 72,
      backgroundColor: q.bgSecondary,
      indicatorColor: kAccentPurple.withAlpha(30),
      surfaceTintColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kAccentPurple,
          );
        }
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: q.textMuted,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: kAccentPurple, size: 24);
        }
        return IconThemeData(color: q.textMuted, size: 24);
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
      backgroundColor: q.bgSecondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: q.textPrimary,
      ),
    ),

    // --- FAB ---
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 3,
      highlightElevation: 6,
      backgroundColor: kAccentPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // --- Divider ---
    dividerTheme: DividerThemeData(
      space: 1,
      thickness: 1,
      color: q.borderSubtle,
    ),

    // --- Chip ---
    chipTheme: ChipThemeData(
      backgroundColor: q.bgTertiary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: q.textSecondary,
      ),
      side: BorderSide(color: q.borderDefault),
    ),

    // --- Progress indicator ---
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: kAccentPurple,
      linearTrackColor: q.bgTertiary,
      circularTrackColor: q.bgTertiary,
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
