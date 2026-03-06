import 'package:flutter/material.dart';

import '../../../theme.dart';
import 'profile_helpers.dart';

/// Hero header displaying avatar, level, name and title.
class HeroHeader extends StatelessWidget {
  final dynamic user;
  final AvatarDef avatar;
  final QuestifyColors q;
  final VoidCallback onEdit;

  const HeroHeader({
    super.key,
    required this.user,
    required this.avatar,
    required this.q,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [q.bgSecondary, q.bgPrimary],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              // Title
              Text('Profil Heros',
                  style: TextStyle(
                    color: q.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 20),

              // Avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Glow
                  Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [q.accentPurple, q.accentGold]),
                      boxShadow: [
                        BoxShadow(
                          color: q.glowPurple,
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  // Avatar circle
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: avatar.color,
                          border:
                              Border.all(color: avatar.color, width: 4),
                        ),
                        child: Center(
                          child:
                              Text(avatar.emoji, style: const TextStyle(fontSize: 40)),
                        ),
                      ),
                    ),
                  ),
                  // Level badge
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: q.accentPurple,
                        border: Border.all(color: q.bgPrimary, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: q.glowPurple,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${user.level}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Camera / edit button
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: q.accentGold,
                          border: Border.all(color: q.bgPrimary, width: 3),
                        ),
                        child: Icon(Icons.camera_alt,
                            size: 18, color: q.bgPrimary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name
              Text(
                user.displayName,
                style: TextStyle(
                  color: q.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),

              // Title badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [q.accentPurple, q.accentGold]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome,
                        size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      levelTitle(user.level),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Edit profile button
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: Icon(Icons.edit, size: 16, color: q.accentPurple),
                label: Text('Modifier le profil',
                    style: TextStyle(color: q.accentPurple, fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: q.accentPurple, width: 2),
                  backgroundColor: q.accentPurple.withAlpha(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
