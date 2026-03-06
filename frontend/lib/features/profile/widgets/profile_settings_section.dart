import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_provider.dart';
import '../../../services/api_service.dart';
import '../../../theme.dart';

/// Settings section with notifications and privacy toggles.
class ProfileSettingsSection extends ConsumerWidget {
  final QuestifyColors q;
  const ProfileSettingsSection({super.key, required this.q});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final notificationsEnabled = user?.notificationsEnabled ?? true;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Parametres',
              style: TextStyle(
                  color: q.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: q.bgSecondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: q.borderDefault, width: 2),
            ),
            child: Column(
              children: [
                _SettingRow(
                  q: q,
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  trailing: Switch(
                    value: notificationsEnabled,
                    activeTrackColor: q.accentPurple,
                    onChanged: (val) async {
                      try {
                        final api = ref.read(apiServiceProvider);
                        await api.updateNotificationPreferences(
                            enabled: val);
                        await ref
                            .read(authProvider.notifier)
                            .refreshUser();
                      } catch (_) {}
                    },
                  ),
                ),
                Divider(color: q.borderDefault, height: 1),
                _SettingRow(
                  q: q,
                  icon: Icons.lock_outline,
                  label: 'Profil prive',
                  trailing: Switch(
                    value: false,
                    activeTrackColor: q.accentPurple,
                    onChanged: (val) {
                      // TODO: implement private profile toggle
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final QuestifyColors q;
  final IconData icon;
  final String label;
  final Widget trailing;

  const _SettingRow({
    required this.q,
    required this.icon,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: q.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: TextStyle(color: q.textPrimary, fontSize: 14)),
          ),
          trailing,
        ],
      ),
    );
  }
}
