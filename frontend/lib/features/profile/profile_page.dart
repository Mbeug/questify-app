import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/stats_provider.dart';
import '../../services/api_service.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _isEditing = false;
  final _nameCtrl = TextEditingController();
  bool _isSaving = false;

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
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveDisplayName() async {
    final newName = _nameCtrl.text.trim();
    if (newName.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      final api = ref.read(apiServiceProvider);
      await api.updateProfile(newName);
      await ref.read(authProvider.notifier).refreshUser();
      if (mounted) {
        setState(() {
          _isEditing = false;
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nom mis a jour'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.logout,
            size: 36, color: Theme.of(context).colorScheme.error),
        title: const Text('Se deconnecter ?'),
        content: const Text('Tu devras te reconnecter ensuite.'),
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

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final statsAsync = ref.watch(statsProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se deconnecter',
            onPressed: _logout,
          ),
        ],
      ),
      body: auth.isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text('Non connecte'))
              : FadeTransition(
                  opacity: _fadeAnim,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Avatar with gradient ring
                        Container(
                          width: 108,
                          height: 108,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                cs.primary,
                                cs.tertiary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: cs.primary.withAlpha(50),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: cs.surface,
                              child: Text(
                                user.displayName.isNotEmpty
                                    ? user.displayName[0].toUpperCase()
                                    : '?',
                                style:
                                    theme.textTheme.headlineLarge?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Display name (editable)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isEditing
                              ? _buildEditName()
                              : _buildDisplayName(user.displayName),
                        ),
                        const SizedBox(height: 4),
                        Text(user.email,
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: cs.onSurfaceVariant)),
                        const SizedBox(height: 32),

                        // Stats section
                        statsAsync.when(
                          loading: () =>
                              const CircularProgressIndicator(),
                          error: (e, _) => Text('Erreur: $e'),
                          data: (stats) => Column(
                            children: [
                              // Level card with gradient
                              Card(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      colors: [
                                        cs.primaryContainer,
                                        cs.primaryContainer
                                            .withAlpha(180),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: cs
                                                .onPrimaryContainer
                                                .withAlpha(20),
                                            borderRadius:
                                                BorderRadius.circular(
                                                    14),
                                          ),
                                          child: Icon(Icons.shield,
                                              size: 28,
                                              color: cs
                                                  .onPrimaryContainer),
                                        ),
                                        const SizedBox(height: 12),
                                        Text('Niveau ${stats.level}',
                                            style: theme.textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    color: cs
                                                        .onPrimaryContainer,
                                                    fontWeight:
                                                        FontWeight
                                                            .bold)),
                                        const SizedBox(height: 16),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child:
                                              LinearProgressIndicator(
                                            value:
                                                stats.progressPercent /
                                                    100.0,
                                            minHeight: 10,
                                            backgroundColor: cs
                                                .onPrimaryContainer
                                                .withAlpha(25),
                                            valueColor:
                                                AlwaysStoppedAnimation<
                                                    Color>(cs
                                                        .onPrimaryContainer),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          '${stats.xp} XP total — ${stats.xpToNextLevel} XP avant le prochain niveau',
                                          style: theme
                                              .textTheme.bodySmall
                                              ?.copyWith(
                                                  color: cs
                                                      .onPrimaryContainer
                                                      .withAlpha(
                                                          180)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Stats details
                              Card(
                                child: Column(
                                  children: [
                                    _ProfileRow(
                                      icon: Icons.check_circle,
                                      label: 'Quetes terminees',
                                      value:
                                          '${stats.totalQuestsCompleted}',
                                      color: cs.tertiary,
                                    ),
                                    Divider(
                                        height: 1,
                                        color: cs.outlineVariant
                                            .withAlpha(80)),
                                    _ProfileRow(
                                      icon: Icons.bolt,
                                      label: 'XP total',
                                      value: '${stats.xp}',
                                      color: const Color(0xFFF59E0B),
                                    ),
                                    Divider(
                                        height: 1,
                                        color: cs.outlineVariant
                                            .withAlpha(80)),
                                    _ProfileRow(
                                      icon: Icons.trending_up,
                                      label: 'Niveau actuel',
                                      value: '${stats.level}',
                                      color: cs.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Logout button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout),
                            label: const Text('Se deconnecter'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: cs.error,
                              side: BorderSide(color: cs.error),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildDisplayName(String name) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      key: const ValueKey('display'),
      onTap: () {
        _nameCtrl.text = name;
        setState(() => _isEditing = true);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: theme.textTheme.headlineSmall),
          const SizedBox(width: 8),
          Icon(Icons.edit, size: 18, color: cs.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _buildEditName() {
    return Row(
      key: const ValueKey('edit'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nouveau nom',
              isDense: true,
            ),
            textAlign: TextAlign.center,
            autofocus: true,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.check),
          onPressed: _isSaving ? null : _saveDisplayName,
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() => _isEditing = false),
        ),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Text(label, style: theme.textTheme.bodyMedium),
          const Spacer(),
          Text(value,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
