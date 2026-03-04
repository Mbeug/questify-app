import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/quest.dart';

class QuestCard extends ConsumerWidget {
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

  Color _difficultyColor(QuestDifficulty d, ColorScheme cs) {
    switch (d) {
      case QuestDifficulty.EASY:
        return Colors.green;
      case QuestDifficulty.MEDIUM:
        return Colors.orange;
      case QuestDifficulty.HARD:
        return Colors.redAccent;
      case QuestDifficulty.EPIC:
        return Colors.deepPurple;
    }
  }

  String _difficultyLabel(QuestDifficulty d) {
    switch (d) {
      case QuestDifficulty.EASY:
        return 'Facile';
      case QuestDifficulty.MEDIUM:
        return 'Moyen';
      case QuestDifficulty.HARD:
        return 'Difficile';
      case QuestDifficulty.EPIC:
        return 'Epique';
    }
  }

  String _statusLabel(QuestStatus s) {
    switch (s) {
      case QuestStatus.PENDING:
        return 'En attente';
      case QuestStatus.IN_PROGRESS:
        return 'En cours';
      case QuestStatus.COMPLETED:
        return 'Terminee';
    }
  }

  IconData _statusIcon(QuestStatus s) {
    switch (s) {
      case QuestStatus.PENDING:
        return Icons.hourglass_empty;
      case QuestStatus.IN_PROGRESS:
        return Icons.play_circle_outline;
      case QuestStatus.COMPLETED:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isCompleted = quest.status == QuestStatus.COMPLETED;
    final diffColor = _difficultyColor(quest.difficulty, cs);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      quest.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                        color: isCompleted
                            ? cs.onSurface.withAlpha(128)
                            : null,
                      ),
                    ),
                  ),
                  // XP badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+${quest.xpReward} XP',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              if (quest.description != null &&
                  quest.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  quest.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // Bottom row: difficulty + status + actions
              Row(
                children: [
                  // Difficulty chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: diffColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: diffColor.withAlpha(100)),
                    ),
                    child: Text(
                      _difficultyLabel(quest.difficulty),
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: diffColor),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Status
                  Icon(_statusIcon(quest.status),
                      size: 16,
                      color: isCompleted ? Colors.green : cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    _statusLabel(quest.status),
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),

                  const Spacer(),

                  // Actions
                  if (!isCompleted && onComplete != null)
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      tooltip: 'Completer',
                      onPressed: onComplete,
                      iconSize: 22,
                      visualDensity: VisualDensity.compact,
                      color: Colors.green,
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Supprimer',
                      onPressed: onDelete,
                      iconSize: 22,
                      visualDensity: VisualDensity.compact,
                      color: cs.error,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
