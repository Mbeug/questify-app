import 'package:flutter/material.dart';

import '../../../theme.dart';

/// Avatar definition for profile avatar picker.
class AvatarDef {
  final String id;
  final String emoji;
  final Color color;
  const AvatarDef(this.id, this.emoji, this.color);
}

/// Available avatar options.
const avatars = [
  AvatarDef('sword', '\u2694\uFE0F', kAccentPurple),
  AvatarDef('shield', '\uD83D\uDEE1\uFE0F', kAccentGold),
  AvatarDef('bow', '\uD83C\uDFF9', kAccentMint),
  AvatarDef('crystal', '\uD83D\uDD2E', kAccentRed),
  AvatarDef('star', '\u2B50', kAccentCyan),
];

/// Finds an avatar by its ID, defaulting to the first one.
AvatarDef avatarById(String? id) {
  if (id == null) return avatars[0];
  return avatars.firstWhere((a) => a.id == id, orElse: () => avatars[0]);
}

/// Returns a title based on the player's level.
String levelTitle(int level) {
  if (level < 5) return 'Novice Heroique';
  if (level < 10) return 'Apprenti Legendaire';
  if (level < 15) return 'Artisan du Succes';
  if (level < 20) return 'Expert Mythique';
  return 'Maitre Absolu';
}
