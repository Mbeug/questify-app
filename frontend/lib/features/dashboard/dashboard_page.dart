import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/quest.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quests_provider.dart';
import '../../providers/stats_provider.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _currentIndex = 0;

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

    // Rediriger si pas auth
    if (!auth.isAuthenticated && !auth.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/login');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Questify'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Parametres',
            onPressed: () => context.go('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Profil',
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _DashboardHome(),
            const SizedBox.shrink(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          if (i == 1) {
            context.go('/quests');
          } else {
            setState(() => _currentIndex = i);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Quetes',
          ),
        ],
      ),
    );
  }
}

class _DashboardHome extends ConsumerStatefulWidget {
  @override
  ConsumerState<_DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends ConsumerState<_DashboardHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _staggerCtrl;

  @override
  void initState() {
    super.initState();
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _staggerCtrl.forward();
  }

  @override
  void dispose() {
    _staggerCtrl.dispose();
    super.dispose();
  }

  /// Creates a staggered animation for each child element
  Animation<double> _stagger(int index, int total) {
    final begin = index / total;
    final end = (index + 1) / total;
    return CurvedAnimation(
      parent: _staggerCtrl,
      curve: Interval(begin, end, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final statsAsync = ref.watch(statsProvider);
    final questsState = ref.watch(questsProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          ref.read(statsProvider.notifier).loadStats(),
          ref.read(questsProvider.notifier).loadQuests(),
          ref.read(authProvider.notifier).refreshUser(),
        ]);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Greeting — stagger 0
          FadeTransition(
            opacity: _stagger(0, 5),
            child: SlideTransition(
              position: _stagger(0, 5).drive(
                Tween(begin: const Offset(0, 0.1), end: Offset.zero),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Salut, ${auth.user?.displayName ?? 'Aventurier'} !',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pret pour de nouvelles quetes ?',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // XP / Level card — stagger 1
          FadeTransition(
            opacity: _stagger(1, 5),
            child: SlideTransition(
              position: _stagger(1, 5).drive(
                Tween(begin: const Offset(0, 0.1), end: Offset.zero),
              ),
              child: statsAsync.when(
                loading: () => const _ShimmerCard(height: 120),
                error: (e, _) => _ErrorCard(
                  message: 'Impossible de charger les stats',
                  onRetry: () =>
                      ref.read(statsProvider.notifier).loadStats(),
                ),
                data: (stats) => _AnimatedXpCard(stats: stats),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Stats row — stagger 2
          FadeTransition(
            opacity: _stagger(2, 5),
            child: SlideTransition(
              position: _stagger(2, 5).drive(
                Tween(begin: const Offset(0, 0.1), end: Offset.zero),
              ),
              child: statsAsync.when(
                loading: () => Row(
                  children: [
                    const Expanded(child: _ShimmerCard(height: 90)),
                    const SizedBox(width: 12),
                    const Expanded(child: _ShimmerCard(height: 90)),
                    const SizedBox(width: 12),
                    const Expanded(child: _ShimmerCard(height: 90)),
                  ],
                ),
                error: (_, __) => const SizedBox.shrink(),
                data: (stats) => Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        icon: Icons.check_circle,
                        label: 'Terminees',
                        value: '${stats.totalQuestsCompleted}',
                        color: cs.tertiary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatTile(
                        icon: Icons.pending_actions,
                        label: 'En cours',
                        value:
                            '${questsState.quests.where((q) => q.status != QuestStatus.COMPLETED).length}',
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatTile(
                        icon: Icons.bolt,
                        label: 'Total XP',
                        value: '${stats.xp}',
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recent quests header — stagger 3
          FadeTransition(
            opacity: _stagger(3, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quetes recentes',
                    style: theme.textTheme.titleMedium),
                TextButton(
                  onPressed: () => context.go('/quests'),
                  child: const Text('Voir tout'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Recent quests list — stagger 4
          FadeTransition(
            opacity: _stagger(4, 5),
            child: _buildQuestsList(questsState, theme, cs),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestsList(
      QuestsState questsState, ThemeData theme, ColorScheme cs) {
    if (questsState.isLoading) {
      return Column(
        children: List.generate(
            3,
            (_) => const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: _ShimmerCard(height: 64),
                )),
      );
    }

    if (questsState.error != null) {
      return _ErrorCard(
        message: questsState.error!,
        onRetry: () =>
            ref.read(questsProvider.notifier).loadQuests(),
      );
    }

    if (questsState.quests.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.explore_outlined,
                    size: 32, color: cs.onPrimaryContainer),
              ),
              const SizedBox(height: 16),
              Text('Aucune quete',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Lance-toi dans ta premiere aventure !',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () => context.go('/quests/create'),
                child: const Text('Creer une quete'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: questsState.quests.take(5).map((q) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: q.status == QuestStatus.COMPLETED
                    ? cs.tertiary.withAlpha(30)
                    : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                q.status == QuestStatus.COMPLETED
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: q.status == QuestStatus.COMPLETED
                    ? cs.tertiary
                    : cs.onSurfaceVariant,
                size: 22,
              ),
            ),
            title: Text(
              q.title,
              style: q.status == QuestStatus.COMPLETED
                  ? TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: cs.onSurface.withAlpha(128))
                  : null,
            ),
            subtitle: Text('+${q.xpReward} XP',
                style: TextStyle(
                    color: cs.primary, fontWeight: FontWeight.w500)),
            trailing: _difficultyBadge(q.difficulty, cs),
            onTap: () => context.go('/quests'),
          ),
        );
      }).toList(),
    );
  }

  Widget _difficultyBadge(QuestDifficulty d, ColorScheme cs) {
    Color color;
    String label;
    switch (d) {
      case QuestDifficulty.EASY:
        color = Colors.green;
        label = 'F';
        break;
      case QuestDifficulty.MEDIUM:
        color = Colors.orange;
        label = 'M';
        break;
      case QuestDifficulty.HARD:
        color = Colors.redAccent;
        label = 'D';
        break;
      case QuestDifficulty.EPIC:
        color = Colors.deepPurple;
        label = 'E';
        break;
    }
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        shape: BoxShape.circle,
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Center(
        child: Text(label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }
}

// ──────────────── Animated XP Card ────────────────

class _AnimatedXpCard extends StatefulWidget {
  final dynamic stats;
  const _AnimatedXpCard({required this.stats});

  @override
  State<_AnimatedXpCard> createState() => _AnimatedXpCardState();
}

class _AnimatedXpCardState extends State<_AnimatedXpCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _xpCtrl;
  late Animation<double> _xpAnim;

  @override
  void initState() {
    super.initState();
    _xpCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _xpAnim = Tween<double>(
      begin: 0.0,
      end: (widget.stats.progressPercent as num).toDouble() / 100.0,
    ).animate(CurvedAnimation(parent: _xpCtrl, curve: Curves.easeOutCubic));
    _xpCtrl.forward();
  }

  @override
  void didUpdateWidget(_AnimatedXpCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stats.progressPercent != widget.stats.progressPercent) {
      _xpAnim = Tween<double>(
        begin: _xpAnim.value,
        end: (widget.stats.progressPercent as num).toDouble() / 100.0,
      ).animate(
          CurvedAnimation(parent: _xpCtrl, curve: Curves.easeOutCubic));
      _xpCtrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _xpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              cs.primaryContainer,
              cs.primaryContainer.withAlpha(180),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: cs.onPrimaryContainer.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.shield,
                        color: cs.onPrimaryContainer, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Niveau ${widget.stats.level}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: cs.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.stats.xp} XP total',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onPrimaryContainer.withAlpha(180),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Animated XP progress bar
              AnimatedBuilder(
                animation: _xpAnim,
                builder: (_, __) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _xpAnim.value,
                    minHeight: 12,
                    backgroundColor: cs.onPrimaryContainer.withAlpha(25),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        cs.onPrimaryContainer),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.stats.xpToNextLevel} XP avant le niveau ${widget.stats.level + 1} '
                '(${widget.stats.progressPercent.toStringAsFixed(0)}%)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onPrimaryContainer.withAlpha(160),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────── Stat tile ────────────────

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────── Shimmer / skeleton loading card ────────────────

class _ShimmerCard extends StatefulWidget {
  final double height;
  const _ShimmerCard({required this.height});

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (_, __) {
        return Card(
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment(-1.0 + 2.0 * _shimmerCtrl.value, 0),
                end: Alignment(1.0 + 2.0 * _shimmerCtrl.value, 0),
                colors: [
                  cs.surfaceContainerHighest.withAlpha(60),
                  cs.surfaceContainerHighest.withAlpha(120),
                  cs.surfaceContainerHighest.withAlpha(60),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ──────────────── Error card ────────────────

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorCard({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Card(
      color: cs.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: cs.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: cs.onErrorContainer)),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text('Reessayer',
                    style: TextStyle(color: cs.onErrorContainer)),
              ),
          ],
        ),
      ),
    );
  }
}
