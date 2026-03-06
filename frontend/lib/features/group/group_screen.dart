import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/group.dart';
import '../../providers/auth_provider.dart';
import '../../providers/group_provider.dart';
import '../../theme.dart';
import 'widgets/group_buttons.dart';
import 'widgets/group_stats_section.dart';
import 'widgets/guild_header.dart';
import 'widgets/members_section.dart';
import 'widgets/no_group_view.dart';
import 'widgets/podium_section.dart';

// ═══════════════════════════════════════════════════════════════════
//  GroupScreen — full Figma implementation
// ═══════════════════════════════════════════════════════════════════

class GroupScreen extends ConsumerStatefulWidget {
  const GroupScreen({super.key});

  @override
  ConsumerState<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends ConsumerState<GroupScreen>
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

    Future.microtask(() => ref.read(groupProvider.notifier).loadGroups());
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ─── Create group ─────────────────────────────────────────────
  Future<void> _showCreateDialog() async {
    final q = context.q;
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: q.bgSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: q.accentPurple),
          ),
          title:
              Text('Creer une guilde', style: TextStyle(color: q.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Rassemble tes allies pour de nouvelles aventures',
                  style: TextStyle(color: q.textMuted, fontSize: 13)),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nom de la guilde'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description (optionnel)'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Annuler', style: TextStyle(color: q.textMuted)),
            ),
            GradientButton(
              q: q,
              label: 'Creer',
              onPressed: () {
                if (nameCtrl.text.trim().isNotEmpty) {
                  Navigator.pop(ctx, {
                    'name': nameCtrl.text.trim(),
                    'desc': descCtrl.text.trim(),
                  });
                }
              },
            ),
          ],
        );
      },
    );

    if (result != null && mounted) {
      final group = await ref.read(groupProvider.notifier).createGroup(
            name: result['name']!,
            description:
                result['desc']!.isNotEmpty ? result['desc'] : null,
          );
      if (group != null && mounted) {
        ref.read(groupProvider.notifier).loadGroups();
      }
    }

    // nameCtrl and descCtrl are local — no need to dispose explicitly.
    // Disposing here caused "used after being disposed" errors when
    // the dialog's exit animation triggered a rebuild.
  }

  // ─── Join group ───────────────────────────────────────────────
  Future<void> _showJoinDialog() async {
    final q = context.q;
    final codeCtrl = TextEditingController();

    final code = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: q.bgSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: q.accentGold),
          ),
          title: Text('Rejoindre une guilde',
              style: TextStyle(color: q.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Entre le code d\'invitation de la guilde',
                  style: TextStyle(color: q.textMuted, fontSize: 13)),
              const SizedBox(height: 16),
              TextField(
                controller: codeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Code d\'invitation',
                  hintText: 'QUEST-XXXX',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    letterSpacing: 3, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Annuler', style: TextStyle(color: q.textMuted)),
            ),
            GradientButton(
              q: q,
              label: 'Rejoindre',
              onPressed: () {
                if (codeCtrl.text.trim().isNotEmpty) {
                  Navigator.pop(ctx, codeCtrl.text.trim());
                }
              },
            ),
          ],
        );
      },
    );

    if (code != null && mounted) {
      final group = await ref.read(groupProvider.notifier).joinGroup(code);
      if (group != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tu as rejoint ${group.name}!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      final err = ref.read(groupProvider).error;
      if (err != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    // codeCtrl is local — no need to dispose explicitly.
  }

  // ─── Invite dialog ────────────────────────────────────────────
  Future<void> _showInviteDialog(QuestGroup group) async {
    final q = context.q;
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: q.bgSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: q.accentPurple),
          ),
          title: Text('Inviter des membres',
              style: TextStyle(color: q.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Partage ce code avec tes amis pour qu\'ils rejoignent la guilde',
                style: TextStyle(color: q.textMuted, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text('Code d\'invitation',
                  style: TextStyle(
                      color: q.textPrimary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: q.bgPrimary,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: q.accentGold, width: 2),
                      ),
                      child: Text(
                        group.inviteCode,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: q.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: q.accentGold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: group.inviteCode));
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Code copie!'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: Icon(Icons.share, color: q.bgPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: q.accentPurple.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: q.accentPurple.withAlpha(60)),
                ),
                child: Text(
                  'Les membres pourront rejoindre en entrant ce code dans l\'onglet Groupe',
                  style: TextStyle(color: q.textMuted, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Fermer', style: TextStyle(color: q.textMuted)),
            ),
          ],
        );
      },
    );
  }

  // ─── Leave group ──────────────────────────────────────────────
  Future<void> _showLeaveDialog(QuestGroup group) async {
    final q = context.q;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: q.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: q.accentRed),
        ),
        title: Text('Quitter le groupe ?',
            style: TextStyle(color: q.textPrimary)),
        content: Text(
          'Tu pourras toujours rejoindre un autre groupe plus tard, mais tu perdras ta progression actuelle dans ce groupe.',
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
            child: const Text('Quitter'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(groupProvider.notifier).leaveGroup(group.id);
    }
  }

  // ─── Dissolve group ───────────────────────────────────────────
  Future<void> _showDissolveDialog(QuestGroup group) async {
    final q = context.q;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: q.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: q.accentRed),
        ),
        title: Text('Dissoudre le groupe ?',
            style: TextStyle(color: q.textPrimary)),
        content: Text(
          'Cette action est irreversible. Tous les membres perdront acces au groupe et leur progression collective sera perdue.',
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
            child: const Text('Dissoudre'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(groupProvider.notifier).leaveGroup(group.id);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final groupState = ref.watch(groupProvider);
    final q = context.q;

    if (groupState.isLoading) {
      return Scaffold(
        backgroundColor: q.bgPrimary,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // No group → show create/join screen
    if (groupState.groups.isEmpty) {
      return NoGroupView(
        q: q,
        fadeAnim: _fadeAnim,
        onCreate: _showCreateDialog,
        onJoin: _showJoinDialog,
      );
    }

    // Show first group (primary group view)
    final group = groupState.groups.first;
    final currentUserId = ref.watch(authProvider).user?.id;

    // Check if current user is leader
    final currentMember = group.members.where(
      (m) => m.userId == currentUserId,
    );
    final isLeader = currentMember.isNotEmpty &&
        currentMember.first.role == GroupRole.LEADER;

    // Sort members by weeklyXp
    final sorted = [...group.members]
      ..sort((a, b) => b.weeklyXp.compareTo(a.weeklyXp));

    return Scaffold(
      backgroundColor: q.bgPrimary,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(groupProvider.notifier).loadGroups();
            if (group.id > 0) {
              await ref.read(groupProvider.notifier).loadGroup(group.id);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                // ── Guild banner header ───────────────────
                GuildHeader(
                  group: group,
                  isLeader: isLeader,
                  q: q,
                ),

                // ── Action buttons ────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: GradientActionButton(
                          q: q,
                          icon: Icons.person_add,
                          label: 'Inviter',
                          colors: [q.accentPurple, const Color(0xFF7B3FD9)],
                          onTap: () => _showInviteDialog(group),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: isLeader
                            ? OutlineActionButton(
                                q: q,
                                icon: Icons.delete_outline,
                                label: 'Dissoudre',
                                color: q.accentRed,
                                onTap: () => _showDissolveDialog(group),
                              )
                            : OutlineActionButton(
                                q: q,
                                icon: Icons.logout,
                                label: 'Quitter',
                                color: q.textMuted,
                                onTap: () => _showLeaveDialog(group),
                              ),
                      ),
                    ],
                  ),
                ),

                // ── Podium top 3 ─────────────────────────
                if (sorted.isNotEmpty)
                  PodiumSection(sorted: sorted, q: q),

                // ── All members ──────────────────────────
                AllMembersSection(
                  members: group.members,
                  currentUserId: currentUserId,
                  isLeader: isLeader,
                  q: q,
                  groupId: group.id,
                ),

                // ── Group stats ──────────────────────────
                GroupStatsSection(group: group, q: q),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
