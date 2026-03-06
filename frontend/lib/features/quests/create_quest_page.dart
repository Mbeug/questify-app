import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/quest.dart';
import '../../providers/quests_provider.dart';
import '../../theme.dart';

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
  QuestCategory? _category;
  QuestRecurrence _recurrence = QuestRecurrence.ONE_TIME;
  DateTime? _dueDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  static const _difficultyConfig = {
    QuestDifficulty.EASY: (xp: 25, coins: 10, color: Color(0xFF06D6A0), icon: Icons.star_outline, label: 'Facile', rarity: 'Commune'),
    QuestDifficulty.MEDIUM: (xp: 50, coins: 20, color: Color(0xFFFFD166), icon: Icons.local_fire_department, label: 'Moyen', rarity: 'Rare'),
    QuestDifficulty.HARD: (xp: 100, coins: 50, color: Color(0xFFA75EFF), icon: Icons.bolt, label: 'Difficile', rarity: 'Epique'),
    QuestDifficulty.EPIC: (xp: 200, coins: 100, color: Color(0xFFFF6B6B), icon: Icons.workspace_premium, label: 'Epique', rarity: 'Legendaire'),
  };

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final quest = await ref.read(questsProvider.notifier).createQuest(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      difficulty: _difficulty,
      dueDate: _dueDate?.toIso8601String(),
      category: _category,
      recurrence: _recurrence,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (quest != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quete "${quest.title}" creee !'), behavior: SnackBarBehavior.floating),
        );
        context.go('/quests');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = context.q;
    final config = _difficultyConfig[_difficulty]!;

    return Scaffold(
      backgroundColor: q.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [q.bgSecondary, q.bgPrimary],
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/dashboard/quests'),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: q.bgSecondary, shape: BoxShape.circle),
                      child: Icon(Icons.arrow_back, color: q.textPrimary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\u2728 Nouvelle quete', style: TextStyle(color: q.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Cree ton aventure epique', style: TextStyle(color: q.textMuted, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Preview card
                      _buildPreview(q, config),
                      const SizedBox(height: 24),

                      // Title
                      _buildLabel('Titre de la quete', q),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleCtrl,
                        style: TextStyle(color: q.textPrimary),
                        decoration: _inputDecoration('Ex: Faire 30 minutes de sport', q),
                        onChanged: (_) => setState(() {}),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                      ),
                      const SizedBox(height: 20),

                      // Description
                      _buildLabel('Description (optionnelle)', q),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descCtrl,
                        style: TextStyle(color: q.textPrimary),
                        decoration: _inputDecoration('Details de ta quete...', q),
                        maxLines: 3,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 20),

                      // Difficulty
                      _buildLabel('Difficulte', q),
                      const SizedBox(height: 8),
                      _buildDifficultySelector(q),
                      const SizedBox(height: 8),
                      _buildDifficultyInfo(q, config),
                      const SizedBox(height: 20),

                      // Category
                      _buildLabel('Categorie', q),
                      const SizedBox(height: 8),
                      _buildCategorySelector(q),
                      const SizedBox(height: 20),

                      // Recurrence
                      _buildLabel('Recurrence', q),
                      const SizedBox(height: 8),
                      _buildRecurrenceSelector(q),
                      const SizedBox(height: 20),

                      // Due date
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.calendar_today, color: q.textMuted),
                        title: Text(
                          _dueDate != null
                              ? 'Echeance : ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                              : 'Ajouter une echeance (optionnel)',
                          style: TextStyle(color: q.textPrimary),
                        ),
                        trailing: _dueDate != null
                            ? IconButton(
                                icon: Icon(Icons.clear, color: q.textMuted),
                                onPressed: () => setState(() => _dueDate = null),
                              )
                            : null,
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 24),

                      // Submit
                      SizedBox(
                        height: 52,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [q.accentPurple, const Color(0xFF7B3FD9)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: q.glowPurple, blurRadius: 12)],
                          ),
                          child: ElevatedButton(
                            onPressed: _isSubmitting || _titleCtrl.text.trim().isEmpty ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.auto_awesome, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text('Creer la quete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(QuestifyColors q, dynamic config) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: q.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (config.color as Color), width: 2),
        boxShadow: [BoxShadow(color: (config.color as Color).withAlpha(50), blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (config.color as Color).withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(config.rarity as String, style: TextStyle(color: config.color as Color, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: q.accentGold.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('+${config.xp} XP', style: TextStyle(color: q.accentGold, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
              const Spacer(),
                Icon(config.icon, color: config.color, size: 22),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _titleCtrl.text.isEmpty ? 'Titre de ta quete...' : _titleCtrl.text,
            style: TextStyle(
              color: _titleCtrl.text.isEmpty ? q.textMuted : q.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (_descCtrl.text.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(_descCtrl.text, style: TextStyle(color: q.textMuted, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }

  Widget _buildDifficultySelector(QuestifyColors q) {
    return Wrap(
      spacing: 8,
      children: QuestDifficulty.values.map((d) {
        final c = _difficultyConfig[d]!;
        final selected = _difficulty == d;
        return GestureDetector(
          onTap: () => setState(() => _difficulty = d),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? c.color.withAlpha(30) : q.bgSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? c.color : q.borderDefault, width: selected ? 2 : 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(c.icon, size: 16, color: c.color),
                const SizedBox(width: 4),
                Text(c.label, style: TextStyle(color: selected ? c.color : q.textMuted, fontSize: 12, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDifficultyInfo(QuestifyColors q, dynamic config) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (config.color as Color).withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: (config.color as Color).withAlpha(50)),
      ),
      child: Row(
        children: [
          Icon(config.icon as IconData, color: config.color as Color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quete ${config.label}', style: TextStyle(color: config.color as Color, fontSize: 13)),
              Text('Gagne ${config.xp} XP et ${config.coins} pieces', style: TextStyle(color: q.textMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(QuestifyColors q) {
    const categories = [
      (value: null, label: 'Aucune', emoji: '\u{1F539}'),
      (value: QuestCategory.HOME, label: 'Maison', emoji: '\u{1F3E0}'),
      (value: QuestCategory.SPORT, label: 'Sport', emoji: '\u{1F4AA}'),
      (value: QuestCategory.PERSONAL, label: 'Personnel', emoji: '\u2728'),
      (value: QuestCategory.WORK, label: 'Travail', emoji: '\u{1F4CB}'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((c) {
        final selected = _category == c.value;
        return GestureDetector(
          onTap: () => setState(() => _category = c.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? q.accentPurple.withAlpha(30) : q.bgSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? q.accentPurple : q.borderDefault, width: selected ? 2 : 1),
            ),
            child: Text('${c.emoji} ${c.label}', style: TextStyle(color: selected ? q.accentPurple : q.textMuted, fontSize: 12)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecurrenceSelector(QuestifyColors q) {
    const recurrences = [
      (value: QuestRecurrence.ONE_TIME, label: 'Unique', emoji: '\u26A1'),
      (value: QuestRecurrence.DAILY, label: 'Quotidienne', emoji: '\u{1F4C5}'),
      (value: QuestRecurrence.WEEKLY, label: 'Hebdomadaire', emoji: '\u{1F4C6}'),
    ];

    return Wrap(
      spacing: 8,
      children: recurrences.map((r) {
        final selected = _recurrence == r.value;
        return GestureDetector(
          onTap: () => setState(() => _recurrence = r.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? q.accentCyan.withAlpha(30) : q.bgSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? q.accentCyan : q.borderDefault, width: selected ? 2 : 1),
            ),
            child: Text('${r.emoji} ${r.label}', style: TextStyle(color: selected ? q.accentCyan : q.textMuted, fontSize: 12)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLabel(String text, QuestifyColors q) {
    return Text(text, style: TextStyle(color: q.textPrimary, fontWeight: FontWeight.w600, fontSize: 14));
  }

  InputDecoration _inputDecoration(String hint, QuestifyColors q) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: q.textMuted),
      filled: true,
      fillColor: q.bgSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: q.accentPurple.withAlpha(60)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: q.accentPurple.withAlpha(60), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: q.accentPurple, width: 2),
      ),
    );
  }
}
