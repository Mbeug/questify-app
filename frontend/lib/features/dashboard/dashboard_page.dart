import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/quest.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quests_provider.dart';
import '../../providers/stats_provider.dart';
import '../../theme.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(questsProvider.notifier).loadQuests();
      ref.read(statsProvider.notifier).loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final q = context.q;

    if (!auth.isAuthenticated && !auth.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/login');
      });
    }

    return Scaffold(
      backgroundColor: q.bgPrimary,
      body: SafeArea(child: _DashboardBody()),
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final statsAsync = ref.watch(statsProvider);
    final questsState = ref.watch(questsProvider);
    final q = context.q;

    final activeQuests = questsState.quests
        .where((quest) => quest.status != QuestStatus.COMPLETED)
        .toList();
    final completedToday = questsState.quests
        .where((quest) => quest.status == QuestStatus.COMPLETED)
        .toList();

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          ref.read(statsProvider.notifier).loadStats(),
          ref.read(questsProvider.notifier).loadQuests(),
          ref.read(authProvider.notifier).refreshUser(),
        ]);
      },
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header with gradient background
          _buildHeader(context, auth, statsAsync, q),

          // Streak card
          statsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (stats) => _buildStreakCard(context, stats, q),
          ),

          // Quick stats summary
          statsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (stats) => _buildQuickStats(stats, q),
          ),

          // Quest summary section (compact, not full list)
          _buildQuestSummary(context, activeQuests, completedToday, q),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, AuthState auth, AsyncValue statsAsync, QuestifyColors q) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [q.bgSecondary, q.bgPrimary],
        ),
      ),
      child: Column(
        children: [
          // Avatar row
          Row(
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: q.accentPurple,
                    child: Text(
                      (auth.user?.displayName ?? 'A')[0].toUpperCase(),
                      style: TextStyle(
                          color: q.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: q.accentGold,
                        shape: BoxShape.circle,
                        border: Border.all(color: q.bgPrimary, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          '${auth.user?.level ?? 1}',
                          style: TextStyle(
                              color: q.bgPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Salut, ${auth.user?.displayName ?? "Aventurier"}! \u{1F44B}',
                      style: TextStyle(
                          color: q.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_getLevelTitle(auth.user?.level ?? 1)} \u00B7 Niveau ${auth.user?.level ?? 1}',
                      style: TextStyle(color: q.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              // Coins display
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: q.accentGold.withAlpha(40),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: q.accentGold, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('\u{1FA99}', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text('${auth.user?.coins ?? 0}',
                            style: TextStyle(
                                color: q.accentGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => context.go('/customization'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: q.bgTertiary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.shopping_bag_outlined,
                          color: q.textMuted, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // XP bar
          statsAsync.when(
            loading: () => const SizedBox(height: 50),
            error: (_, __) => const SizedBox.shrink(),
            data: (stats) => _buildXpBar(stats, q),
          ),
        ],
      ),
    );
  }

  Widget _buildXpBar(dynamic stats, QuestifyColors q) {
    final progress = (stats.progressPercent as num).toDouble() / 100.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.bolt, color: q.accentGold, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Progression vers Niveau ${stats.level + 1}',
                  style: TextStyle(color: q.textPrimary, fontSize: 13),
                ),
              ],
            ),
            Text(
              '${stats.xp} / ${stats.xp + stats.xpToNextLevel} XP',
              style: TextStyle(color: q.textMuted, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 12,
            child: Stack(
              children: [
                Container(color: q.bgTertiary),
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [q.accentPurple, q.accentGold],
                      ),
                      boxShadow: [
                        BoxShadow(color: q.glowPurple, blurRadius: 10)
                      ],
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: q.accentMint, size: 12),
                const SizedBox(width: 4),
                Text(
                  '${stats.totalQuestsCompleted} quetes completees',
                  style: TextStyle(color: q.accentMint, fontSize: 11),
                ),
              ],
            ),
            Text(
              '${stats.progressPercent.toStringAsFixed(0)}%',
              style: TextStyle(color: q.textMuted, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakCard(
      BuildContext context, dynamic stats, QuestifyColors q) {
    if (stats.currentStreak <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              q.accentPurple.withAlpha(30),
              q.accentGold.withAlpha(30)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border:
              Border.all(color: q.accentPurple.withAlpha(60), width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: q.accentGold,
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.auto_awesome, color: q.bgPrimary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Serie de ${stats.currentStreak} jours! \u{1F525}',
                    style: TextStyle(
                        color: q.textPrimary,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Continue comme ca!',
                    style: TextStyle(color: q.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: q.accentMint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '+50 XP',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(dynamic stats, QuestifyColors q) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.check_circle_outline,
              label: 'Completees',
              value: '${stats.totalQuestsCompleted}',
              color: q.accentMint,
              q: q,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.bolt,
              label: 'XP total',
              value: '${stats.xp}',
              color: q.accentGold,
              q: q,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.local_fire_department,
              label: 'Meilleure serie',
              value: '${stats.bestStreak}j',
              color: q.accentPurple,
              q: q,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestSummary(BuildContext context, List<Quest> activeQuests,
      List<Quest> completedToday, QuestifyColors q) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title with link to quests tab
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Apercu des quetes',
                style: TextStyle(
                    color: q.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => context.go('/quests'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: q.accentPurple.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: q.accentPurple.withAlpha(60)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Voir tout',
                        style: TextStyle(
                            color: q.accentPurple,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios,
                          color: q.accentPurple, size: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Active quests count
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: q.bgSecondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: q.borderDefault),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: q.accentPurple.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.assignment, color: q.accentPurple, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${activeQuests.length} ${activeQuests.length <= 1 ? "quete active" : "quetes actives"}',
                        style: TextStyle(
                            color: q.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        activeQuests.isEmpty
                            ? 'Cree une quete pour commencer!'
                            : 'Prochaine: ${activeQuests.first.title}',
                        style: TextStyle(color: q.textMuted, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => context.go('/quests/create'),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [q.accentPurple, const Color(0xFF7B3FD9)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: q.glowPurple, blurRadius: 8)
                      ],
                    ),
                    child:
                        const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // Completed today summary
          if (completedToday.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: q.bgSecondary,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: q.borderDefault),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF06D6A0).withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.check_circle,
                        color: Color(0xFF06D6A0), size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${completedToday.length} ${completedToday.length <= 1 ? "quete completee" : "quetes completees"} aujourd\'hui',
                          style: TextStyle(
                              color: q.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Derniere: ${completedToday.last.title}',
                          style: TextStyle(color: q.textMuted, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getLevelTitle(int level) {
    if (level < 5) return 'Novice';
    if (level < 10) return 'Apprenti';
    if (level < 15) return 'Artisan';
    if (level < 20) return 'Expert';
    return 'Maitre';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final QuestifyColors q;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.q,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: q.bgSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: q.borderDefault),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                color: q.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: q.textMuted, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
