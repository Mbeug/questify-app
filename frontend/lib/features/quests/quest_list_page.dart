import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/quest.dart';
import '../../providers/quests_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/stats_provider.dart';
import '../shared/xp_notification.dart';
import 'quest_card.dart';

class QuestListPage extends ConsumerStatefulWidget {
  const QuestListPage({super.key});

  @override
  ConsumerState<QuestListPage> createState() => _QuestListPageState();
}

class _QuestListPageState extends ConsumerState<QuestListPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _listCtrl;

  @override
  void initState() {
    super.initState();
    _listCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.microtask(() async {
      await ref.read(questsProvider.notifier).loadQuests();
      _listCtrl.forward();
    });
  }

  @override
  void dispose() {
    _listCtrl.dispose();
    super.dispose();
  }

  Future<void> _onComplete(Quest quest) async {
    final result =
        await ref.read(questsProvider.notifier).completeQuest(quest.id);
    if (result != null && result.levelUpResult != null && mounted) {
      final r = result.levelUpResult!;
      showXpNotification(
        context,
        XpRewardData(
          xp: r.xpGained,
          coins: r.coinsEarned,
          gems: r.gemsEarned,
          leveledUp: r.leveledUp,
          newLevel: r.leveledUp ? r.level : null,
        ),
      );
      ref.read(statsProvider.notifier).loadStats();
      ref.read(authProvider.notifier).refreshUser();
    }
  }

  Future<void> _onDelete(Quest quest) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.delete_outline,
            size: 36, color: Theme.of(context).colorScheme.error),
        title: const Text('Supprimer la quete ?'),
        content: Text('Supprimer "${quest.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(questsProvider.notifier).deleteQuest(quest.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final questsState = ref.watch(questsProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final activeQuests = questsState.quests
        .where((q) => q.status != QuestStatus.COMPLETED)
        .toList();
    final completedQuests = questsState.quests
        .where((q) => q.status == QuestStatus.COMPLETED)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Quetes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/quests'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/quests/create'),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle quete'),
      ),
      body: questsState.isLoading
          ? _buildLoadingSkeleton()
          : questsState.error != null
              ? _buildError(questsState.error!, cs, theme)
              : questsState.quests.isEmpty
                  ? _buildEmpty(theme, cs)
                  : FadeTransition(
                      opacity: CurvedAnimation(
                          parent: _listCtrl, curve: Curves.easeOut),
                      child: RefreshIndicator(
                        onRefresh: () =>
                            ref.read(questsProvider.notifier).loadQuests(),
                        child: ListView(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 100),
                          children: [
                            if (activeQuests.isNotEmpty) ...[
                              _SectionHeader(
                                icon: Icons.play_circle_outline,
                                label: 'Actives',
                                count: activeQuests.length,
                                color: cs.primary,
                              ),
                              const SizedBox(height: 8),
                              ...activeQuests.map((q) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 4),
                                    child: QuestCard(
                                      quest: q,
                                      onComplete: () => _onComplete(q),
                                      onDelete: () => _onDelete(q),
                                    ),
                                  )),
                            ],
                            if (completedQuests.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              _SectionHeader(
                                icon: Icons.check_circle,
                                label: 'Terminees',
                                count: completedQuests.length,
                                color: cs.tertiary,
                              ),
                              const SizedBox(height: 8),
                              ...completedQuests.map((q) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 4),
                                    child: QuestCard(
                                      quest: q,
                                      onDelete: () => _onDelete(q),
                                    ),
                                  )),
                            ],
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          4,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SkeletonCard(delay: i * 200),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String error, ColorScheme cs, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: cs.errorContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.error_outline,
                  size: 36, color: cs.onErrorContainer),
            ),
            const SizedBox(height: 16),
            Text('Quelque chose a mal tourne',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(error,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () =>
                  ref.read(questsProvider.notifier).loadQuests(),
              child: const Text('Reessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme, ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.explore_outlined,
                  size: 40, color: cs.onPrimaryContainer),
            ),
            const SizedBox(height: 20),
            Text('Aucune quete pour l\'instant',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Cree ta premiere quete pour gagner de l\'XP !',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => context.go('/quests/create'),
              icon: const Icon(Icons.add),
              label: const Text('Creer une quete'),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────── Section header ────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text('$label ($count)', style: theme.textTheme.titleSmall),
      ],
    );
  }
}

// ──────────────── Skeleton card ────────────────

class _SkeletonCard extends StatefulWidget {
  final int delay;
  const _SkeletonCard({this.delay = 0});

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Card(
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _ctrl.value, 0),
              end: Alignment(1.0 + 2.0 * _ctrl.value, 0),
              colors: [
                cs.surfaceContainerHighest.withAlpha(50),
                cs.surfaceContainerHighest.withAlpha(110),
                cs.surfaceContainerHighest.withAlpha(50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
