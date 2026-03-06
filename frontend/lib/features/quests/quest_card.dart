import 'package:flutter/material.dart';

import '../../models/quest.dart';
import '../../theme.dart';

class QuestCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const QuestCard({
    super.key,
    required this.quest,
    this.onComplete,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final q = context.q;
    final rarity = _getRarity(quest.difficulty);
    final config = _rarityConfig(rarity);
    final isCompleted = quest.status == QuestStatus.COMPLETED;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: q.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: config.color.withAlpha(isCompleted ? 60 : 180), width: 2),
          boxShadow: isCompleted
              ? []
              : [BoxShadow(color: config.color.withAlpha(60), blurRadius: 15, spreadRadius: 0)],
        ),
        child: Stack(
          children: [
            // Shimmer overlay
            if (!isCompleted)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: _ShimmerEffect(color: config.color),
                ),
              ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Opacity(
                opacity: isCompleted ? 0.5 : 1.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: badges + icon + checkbox
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              _Badge(
                                text: '${config.icon} ${config.label}',
                                color: config.color,
                              ),
                              _Badge(
                                text: '+${quest.xpReward} XP',
                                color: q.accentGold,
                              ),
                              if (quest.coinReward > 0)
                                _Badge(
                                  text: '+${quest.coinReward} \u{1FA99}',
                                  color: q.accentGold,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(config.iconData, color: config.color, size: 22),
                        const SizedBox(width: 8),
                        _CompletionCheckbox(
                          isCompleted: isCompleted,
                          color: config.color,
                          onComplete: onComplete,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Title
                    Text(
                      quest.title,
                      style: TextStyle(
                        color: q.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    // Category + recurrence
                    if (quest.category != null || quest.recurrence != QuestRecurrence.ONE_TIME) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (quest.category != null)
                            Text(
                              _categoryLabel(quest.category!),
                              style: TextStyle(color: q.textMuted, fontSize: 12),
                            ),
                          if (quest.category != null && quest.recurrence != QuestRecurrence.ONE_TIME)
                            Text(' \u00B7 ', style: TextStyle(color: q.textMuted, fontSize: 12)),
                          if (quest.recurrence != QuestRecurrence.ONE_TIME)
                            Text(
                              _recurrenceLabel(quest.recurrence),
                              style: TextStyle(color: q.accentCyan, fontSize: 12),
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),
                    // Difficulty badge at bottom
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: q.borderDefault),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _difficultyLabel(quest.difficulty),
                            style: TextStyle(color: q.textMuted, fontSize: 11),
                          ),
                        ),
                        const Spacer(),
                        if (onDelete != null)
                          GestureDetector(
                            onTap: onDelete,
                            child: Icon(Icons.delete_outline, size: 18, color: q.accentRed.withAlpha(150)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _getRarity(QuestDifficulty d) {
    return switch (d) {
      QuestDifficulty.EASY => 'common',
      QuestDifficulty.MEDIUM => 'rare',
      QuestDifficulty.HARD => 'epic',
      QuestDifficulty.EPIC => 'legendary',
    };
  }

  static _RarityConfig _rarityConfig(String rarity) {
    return switch (rarity) {
      'common' => _RarityConfig(Color(0xFF06D6A0), '\u{1F7E2}', 'Commune', Icons.star_outline),
      'rare' => _RarityConfig(Color(0xFFFFD166), '\u{1F7E1}', 'Rare', Icons.local_fire_department),
      'epic' => _RarityConfig(Color(0xFFA75EFF), '\u{1F7E3}', 'Epique', Icons.bolt),
      'legendary' => _RarityConfig(Color(0xFFFF6B6B), '\u{1F534}', 'Legendaire', Icons.workspace_premium),
      _ => _RarityConfig(Color(0xFF06D6A0), '\u{1F7E2}', 'Commune', Icons.star_outline),
    };
  }

  static String _difficultyLabel(QuestDifficulty d) {
    return switch (d) {
      QuestDifficulty.EASY => 'Facile',
      QuestDifficulty.MEDIUM => 'Moyen',
      QuestDifficulty.HARD => 'Difficile',
      QuestDifficulty.EPIC => 'Epique',
    };
  }

  static String _categoryLabel(QuestCategory c) {
    return switch (c) {
      QuestCategory.HOME => '\u{1F3E0} Maison',
      QuestCategory.SPORT => '\u{1F4AA} Sport',
      QuestCategory.PERSONAL => '\u2728 Personnel',
      QuestCategory.WORK => '\u{1F4CB} Travail',
    };
  }

  static String _recurrenceLabel(QuestRecurrence r) {
    return switch (r) {
      QuestRecurrence.ONE_TIME => 'Unique',
      QuestRecurrence.DAILY => '\u{1F4C5} Quotidienne',
      QuestRecurrence.WEEKLY => '\u{1F4C6} Hebdomadaire',
    };
  }
}

class _RarityConfig {
  final Color color;
  final String icon;
  final String label;
  final IconData iconData;
  const _RarityConfig(this.color, this.icon, this.label, this.iconData);
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _CompletionCheckbox extends StatelessWidget {
  final bool isCompleted;
  final Color color;
  final VoidCallback? onComplete;
  const _CompletionCheckbox({required this.isCompleted, required this.color, this.onComplete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCompleted ? null : onComplete,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isCompleted ? const Color(0xFF06D6A0) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCompleted ? const Color(0xFF06D6A0) : color,
            width: 2,
          ),
        ),
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : null,
      ),
    );
  }
}

class _ShimmerEffect extends StatefulWidget {
  final Color color;
  const _ShimmerEffect({required this.color});

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(1.0 + 2.0 * _controller.value, 0),
              colors: [
                Colors.transparent,
                widget.color.withAlpha(25),
                Colors.transparent,
              ],
            ),
          ),
        );
      },
    );
  }
}
