import 'package:flutter/material.dart';

import '../../../models/app_theme.dart';
import '../../../theme.dart';

/// Rarity display config (color, label, icon).
class RarityConfig {
  final Color color;
  final String label;
  final IconData icon;
  const RarityConfig(this.color, this.label, this.icon);
}

/// Returns visual config for a given theme rarity.
RarityConfig rarityOf(ThemeRarity r) {
  switch (r) {
    case ThemeRarity.COMMON:
      return RarityConfig(kAccentMint, 'Commune', Icons.auto_awesome);
    case ThemeRarity.UNCOMMON:
      return RarityConfig(kAccentCyan, 'Peu commune', Icons.auto_awesome);
    case ThemeRarity.RARE:
      return RarityConfig(kAccentGold, 'Rare', Icons.auto_awesome);
    case ThemeRarity.EPIC:
      return RarityConfig(kAccentPurple, 'Epique', Icons.diamond);
    case ThemeRarity.LEGENDARY:
      return RarityConfig(kAccentRed, 'Legendaire', Icons.diamond);
  }
}

/// Maps theme key to a fallback emoji.
String themeEmoji(String key) {
  const map = {
    'default': '\u2728',
    'ocean_depths': '\uD83C\uDF0A',
    'emerald_forest': '\uD83C\uDF3F',
    'solar_flare': '\u2600\uFE0F',
    'cyber_neon': '\uD83D\uDD2E',
    'legendary_gold': '\uD83D\uDC51',
  };
  return map[key] ?? '\uD83C\uDFA8';
}

/// Parses a hex color string into a [Color].
Color hexToColor(String hex) {
  hex = hex.replaceFirst('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.parse(hex, radix: 16));
}
