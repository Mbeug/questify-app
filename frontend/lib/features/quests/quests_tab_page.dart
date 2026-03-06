import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/quest.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quests_provider.dart';
import '../../providers/stats_provider.dart';
import '../../theme.dart';
import '../shared/xp_notification.dart';
import 'quest_card.dart';

// ============================================================================
//  QuestsTabPage — main quests management tab (standalone)
// ============================================================================

class QuestsTabPage extends ConsumerStatefulWidget {
  const QuestsTabPage({super.key});

  @override
  ConsumerState<QuestsTabPage> createState() => _QuestsTabPageState();
}

class _QuestsTabPageState extends ConsumerState<QuestsTabPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  _QuestFilter _filter = _QuestFilter.all;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.microtask(() async {
      await ref.read(questsProvider.notifier).loadQuests();
      if (mounted) _animCtrl.forward();
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
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
    final q = context.q;

    final allQuests = questsState.quests;
    final activeQuests =
        allQuests.where((quest) => quest.status != QuestStatus.COMPLETED).toList();
    final completedQuests =
        allQuests.where((quest) => quest.status == QuestStatus.COMPLETED).toList();

    final displayedActive = _filterQuests(activeQuests);
    final displayedCompleted = _filterQuests(completedQuests);

    return Scaffold(
      backgroundColor: q.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(q, activeQuests.length, completedQuests.length),

            // Filter chips
            _buildFilterChips(q),

            // Quest list
            Expanded(
              child: questsState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : allQuests.isEmpty
                      ? _buildEmpty(q)
                      : FadeTransition(
                          opacity: CurvedAnimation(
                              parent: _animCtrl, curve: Curves.easeOut),
                          child: RefreshIndicator(
                            onRefresh: () =>
                                ref.read(questsProvider.notifier).loadQuests(),
                            child: ListView(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 100),
                              children: [
                                if (displayedActive.isNotEmpty) ...[
                                  _SectionHeader(
                                    icon: Icons.play_circle_outline,
                                    label: 'Actives',
                                    count: displayedActive.length,
                                    color: q.accentPurple,
                                  ),
                                  const SizedBox(height: 8),
                                  ...displayedActive.map((quest) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: QuestCard(
                                          quest: quest,
                                          onComplete: () =>
                                              _onComplete(quest),
                                          onDelete: () => _onDelete(quest),
                                        ),
                                      )),
                                ],
                                if (displayedCompleted.isNotEmpty) ...[
                                  const SizedBox(height: 20),
                                  _SectionHeader(
                                    icon: Icons.check_circle,
                                    label: 'Terminees',
                                    count: displayedCompleted.length,
                                    color: q.accentMint,
                                  ),
                                  const SizedBox(height: 8),
                                  ...displayedCompleted.map((quest) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: QuestCard(
                                          quest: quest,
                                          onDelete: () => _onDelete(quest),
                                        ),
                                      )),
                                ],
                                if (displayedActive.isEmpty &&
                                    displayedCompleted.isEmpty)
                                  _buildNoResults(q),
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(q),
    );
  }

  Widget _buildHeader(QuestifyColors q, int activeCount, int completedCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [q.bgSecondary, q.bgPrimary],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mes Quetes',
              style: TextStyle(
                  color: q.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            '$activeCount actives \u00B7 $completedCount terminees',
            style: TextStyle(color: q.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(QuestifyColors q) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: _QuestFilter.values.map((filter) {
          final selected = _filter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _filter = filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? q.accentPurple.withAlpha(30)
                      : q.bgSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? q.accentPurple : q.borderDefault,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Text(
                  filter.label,
                  style: TextStyle(
                    color: selected ? q.accentPurple : q.textMuted,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Quest> _filterQuests(List<Quest> quests) {
    return switch (_filter) {
      _QuestFilter.all => quests,
      _QuestFilter.daily =>
        quests.where((q) => q.recurrence == QuestRecurrence.DAILY).toList(),
      _QuestFilter.weekly =>
        quests.where((q) => q.recurrence == QuestRecurrence.WEEKLY).toList(),
      _QuestFilter.oneTime =>
        quests.where((q) => q.recurrence == QuestRecurrence.ONE_TIME).toList(),
    };
  }

  Widget _buildEmpty(QuestifyColors q) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.explore_outlined, size: 64, color: q.textMuted),
            const SizedBox(height: 16),
            Text('Aucune quete pour l\'instant',
                style: TextStyle(color: q.textMuted, fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              'Cree ta premiere quete pour gagner de l\'XP !',
              style: TextStyle(color: q.textMuted, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => context.go('/quests/create'),
              icon: const Icon(Icons.add),
              label: const Text('Creer une quete'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: q.accentPurple),
                foregroundColor: q.accentPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults(QuestifyColors q) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.filter_list_off, size: 48, color: q.textMuted),
            const SizedBox(height: 12),
            Text('Aucune quete avec ce filtre',
                style: TextStyle(color: q.textMuted, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(QuestifyColors q) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [q.accentPurple, const Color(0xFF7B3FD9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: q.glowPurple, blurRadius: 20, spreadRadius: 2)
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => context.go('/quests/create'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

enum _QuestFilter {
  all('Toutes'),
  daily('Quotidiennes'),
  weekly('Hebdomadaires'),
  oneTime('Uniques');

  final String label;
  const _QuestFilter(this.label);
}

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
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text('$label ($count)',
            style: TextStyle(
                color: color, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
