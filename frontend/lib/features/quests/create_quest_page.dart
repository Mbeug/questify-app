import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/quest.dart';
import '../../providers/quests_provider.dart';

class CreateQuestPage extends ConsumerStatefulWidget {
  const CreateQuestPage({super.key});

  @override
  ConsumerState<CreateQuestPage> createState() => _CreateQuestPageState();
}

class _CreateQuestPageState extends ConsumerState<CreateQuestPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  QuestDifficulty _difficulty = QuestDifficulty.MEDIUM;
  DateTime? _dueDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  String _difficultyLabel(QuestDifficulty d) {
    switch (d) {
      case QuestDifficulty.EASY:
        return 'Facile (+25 XP)';
      case QuestDifficulty.MEDIUM:
        return 'Moyen (+50 XP)';
      case QuestDifficulty.HARD:
        return 'Difficile (+100 XP)';
      case QuestDifficulty.EPIC:
        return 'Epique (+200 XP)';
    }
  }

  IconData _difficultyIcon(QuestDifficulty d) {
    switch (d) {
      case QuestDifficulty.EASY:
        return Icons.star_border;
      case QuestDifficulty.MEDIUM:
        return Icons.star_half;
      case QuestDifficulty.HARD:
        return Icons.star;
      case QuestDifficulty.EPIC:
        return Icons.auto_awesome;
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final quest = await ref.read(questsProvider.notifier).createQuest(
          title: _titleCtrl.text.trim(),
          description:
              _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          difficulty: _difficulty,
          dueDate: _dueDate?.toIso8601String().split('T').first,
        );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (quest != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quete "${quest.title}" creee !'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/quests');
      } else {
        final error = ref.read(questsProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Erreur lors de la creation'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Quete'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/quests'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Titre de la quete',
                    prefixIcon: Icon(Icons.title),
                    hintText: 'Ex: Finir le chapitre 3',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requis' : null,
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Description (optionnel)',
                    prefixIcon: Icon(Icons.description_outlined),
                    hintText: 'Details de la quete...',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Difficulty
                Text('Difficulte', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                SegmentedButton<QuestDifficulty>(
                  segments: QuestDifficulty.values.map((d) {
                    return ButtonSegment(
                      value: d,
                      label: Text(_difficultyLabel(d)),
                      icon: Icon(_difficultyIcon(d)),
                    );
                  }).toList(),
                  selected: {_difficulty},
                  onSelectionChanged: (set) {
                    setState(() => _difficulty = set.first);
                  },
                ),
                const SizedBox(height: 24),

                // Due date
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: Text(_dueDate != null
                      ? 'Echeance : ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                      : 'Ajouter une echeance (optionnel)'),
                  trailing: _dueDate != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _dueDate = null),
                        )
                      : null,
                  onTap: _pickDate,
                ),
                const SizedBox(height: 32),

                // Submit
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _isSubmitting ? null : _submit,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.add_task),
                    label: const Text('Creer la quete'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
