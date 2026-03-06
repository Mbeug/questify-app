import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/achievement_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/stats_provider.dart';
import '../../services/api_service.dart';
import '../../theme.dart';
import 'widgets/achievements_section.dart';
import 'widgets/hero_header.dart';
import 'widgets/profile_customization_section.dart';
import 'widgets/profile_helpers.dart';
import 'widgets/profile_settings_section.dart';
import 'widgets/quick_stats.dart';
import 'widgets/skills_radar.dart';
import 'widgets/xp_progress_card.dart';

// ═══════════════════════════════════════════════════════════════════
//  ProfilePage
// ═══════════════════════════════════════════════════════════════════

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();

    // Load data
    Future.microtask(() {
      ref.read(statsProvider.notifier).loadStats();
      ref.read(achievementProvider.notifier).loadAchievements();
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ─── Edit profile dialog ──────────────────────────────────────
  Future<void> _showEditDialog() async {
    final auth = ref.read(authProvider);
    final user = auth.user;
    if (user == null) return;

    String selectedAvatarId = user.avatarId ?? avatars[0].id;
    final nameCtrl = TextEditingController(text: user.displayName);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setDialogState) {
          final q = ctx.q;
          return AlertDialog(
            backgroundColor: q.bgSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: q.accentPurple),
            ),
            title: Text('Modifier le profil',
                style: TextStyle(color: q.textPrimary)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Personnalise ton heros',
                    style: TextStyle(color: q.textMuted, fontSize: 13)),
                const SizedBox(height: 20),
                // Avatar picker
                Text('Avatar',
                    style: TextStyle(
                        color: q.textPrimary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: avatars.map((av) {
                    final isSelected = selectedAvatarId == av.id;
                    return GestureDetector(
                      onTap: () =>
                          setDialogState(() => selectedAvatarId = av.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: av.color,
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: av.color.withAlpha(120),
                                    blurRadius: 12,
                                  )
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(av.emoji,
                              style: TextStyle(
                                  fontSize: isSelected ? 22 : 18)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Annuler', style: TextStyle(color: q.textMuted)),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [q.accentPurple, q.accentGold]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () => Navigator.pop(ctx, {
                    'name': nameCtrl.text.trim(),
                    'avatarId': selectedAvatarId,
                  }),
                  child:
                      const Text('Enregistrer', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        });
      },
    );

    nameCtrl.dispose();

    if (result != null && mounted) {
      try {
        final api = ref.read(apiServiceProvider);
        final newName = result['name']!;
        final newAvatar = result['avatarId']!;
        await api.updateProfile(
          displayName: newName.isNotEmpty ? newName : null,
          avatarId: newAvatar,
        );
        await ref.read(authProvider.notifier).refreshUser();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil mis a jour'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: $e'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  // ─── Logout ───────────────────────────────────────────────────
  Future<void> _logout() async {
    final q = context.q;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: q.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: q.borderDefault),
        ),
        icon: Icon(Icons.logout, size: 36, color: q.accentRed),
        title:
            Text('Se deconnecter ?', style: TextStyle(color: q.textPrimary)),
        content: Text('Tu devras te reconnecter ensuite.',
            style: TextStyle(color: q.textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Annuler', style: TextStyle(color: q.textMuted)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: q.accentRed),
            child: const Text('Deconnexion'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(authProvider.notifier).logout();
      if (mounted) context.go('/login');
    }
  }

  // ─── Delete account ───────────────────────────────────────────
  Future<void> _showDeleteDialog() async {
    final q = context.q;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: q.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: q.accentRed),
        ),
        title: Text('Supprimer ton compte ?',
            style: TextStyle(color: q.textPrimary)),
        content: Text(
          'Cette action est irreversible. Toute ta progression sera perdue.',
          style: TextStyle(color: q.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Annuler', style: TextStyle(color: q.textMuted)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: q.accentRed),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      // TODO: call delete account API when backend supports it
      await ref.read(authProvider.notifier).logout();
      if (mounted) context.go('/login');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final statsAsync = ref.watch(statsProvider);
    final achievementsAsync = ref.watch(achievementProvider);
    final q = context.q;
    final user = auth.user;

    if (auth.isLoading) {
      return Scaffold(
        backgroundColor: q.bgPrimary,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (user == null) {
      return Scaffold(
        backgroundColor: q.bgPrimary,
        body: Center(
          child: Text('Non connecte', style: TextStyle(color: q.textMuted)),
        ),
      );
    }

    final avatar = avatarById(user.avatarId);

    return Scaffold(
      backgroundColor: q.bgPrimary,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              // ── Header hero ─────────────────────────────────
              HeroHeader(
                user: user,
                avatar: avatar,
                q: q,
                onEdit: _showEditDialog,
              ),

              // ── Quick stats ─────────────────────────────────
              statsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Erreur: $e',
                      style: TextStyle(color: q.accentRed)),
                ),
                data: (stats) => Column(
                  children: [
                    QuickStats(stats: stats, q: q),
                    XpProgressCard(stats: stats, q: q),
                    SkillsRadar(
                      stats: stats,
                      q: q,
                      currentStreak: user.currentStreak,
                      bestStreak: user.bestStreak,
                    ),
                  ],
                ),
              ),

              // ── Achievements ────────────────────────────────
              AchievementsSection(
                achievementsAsync: achievementsAsync,
                q: q,
              ),

              // ── Customization links ─────────────────────────
              ProfileCustomizationSection(q: q),

              // ── Settings ────────────────────────────────────
              ProfileSettingsSection(q: q),

              // ── Account actions ─────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout),
                        label: const Text('Se deconnecter'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: q.textMuted,
                          side: BorderSide(color: q.borderDefault, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _showDeleteDialog,
                      child: Text(
                        'Supprimer mon compte',
                        style: TextStyle(
                            color: q.accentRed, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
