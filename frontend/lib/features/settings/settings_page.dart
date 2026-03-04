import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/notification_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animCtrl.forward();

    // Load notification preferences
    Future.microtask(() {
      ref.read(notificationProvider.notifier).loadPreferences();
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final calendarState = ref.watch(calendarProvider);
    final notifState = ref.watch(notificationProvider);

    final fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parametres'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: FadeTransition(
        opacity: fadeAnim,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Google Calendar Section ──
            _SectionHeader(
              icon: Icons.calendar_month,
              title: 'Google Calendar',
              color: cs.primary,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.event, color: cs.onPrimaryContainer),
                    ),
                    title: Text(
                      calendarState.isConnected
                          ? 'Connecte'
                          : 'Non connecte',
                      style: theme.textTheme.titleSmall,
                    ),
                    subtitle: calendarState.googleEmail != null
                        ? Text(calendarState.googleEmail!)
                        : const Text(
                            'Synchronise tes quetes avec ton agenda'),
                    trailing: calendarState.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Switch(
                            value: calendarState.isConnected,
                            onChanged: (val) async {
                              if (val) {
                                await ref
                                    .read(calendarProvider.notifier)
                                    .connectGoogleCalendar();
                              } else {
                                await ref
                                    .read(calendarProvider.notifier)
                                    .disconnectGoogleCalendar();
                              }
                            },
                          ),
                  ),
                  if (calendarState.error != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cs.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                size: 16, color: cs.onErrorContainer),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                calendarState.error!,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: cs.onErrorContainer),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (calendarState.isConnected)
              Card(
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: cs.tertiaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.info_outline,
                        color: cs.onTertiaryContainer),
                  ),
                  title: const Text('Sync automatique'),
                  subtitle: const Text(
                    'Les quetes avec date limite seront ajoutees a ton agenda Google automatiquement.',
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // ── Notifications Section ──
            _SectionHeader(
              icon: Icons.notifications_active,
              title: 'Notifications',
              color: cs.secondary,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.notifications,
                          color: cs.onSecondaryContainer),
                    ),
                    title: const Text('Push notifications'),
                    subtitle: const Text('Rappels de quetes et niveaux'),
                    trailing: notifState.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Switch(
                            value: notifState.isEnabled,
                            onChanged: (val) {
                              ref
                                  .read(notificationProvider.notifier)
                                  .setEnabled(val);
                            },
                          ),
                  ),
                  if (notifState.error != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cs.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                size: 16, color: cs.onErrorContainer),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                notifState.error!,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: cs.onErrorContainer),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(Icons.schedule, color: cs.onSurfaceVariant),
                ),
                title: const Text('Rappels'),
                subtitle: const Text(
                  'Tu recevras un rappel 24h avant l\'echeance de tes quetes.',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Account Section ──
            _SectionHeader(
              icon: Icons.person,
              title: 'Compte',
              color: cs.error,
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: cs.errorContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.logout, color: cs.onErrorContainer),
                ),
                title: Text('Se deconnecter',
                    style: TextStyle(color: cs.error)),
                onTap: () => _showLogoutDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se deconnecter ?'),
        content: const Text('Es-tu sur de vouloir te deconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: cs.error),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
            child: Text('Deconnecter',
                style: TextStyle(color: cs.onError)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
