import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/group.dart';
import '../../../providers/group_provider.dart';
import '../../../services/api_service.dart';
import '../../../theme.dart';

/// Section displaying all group members.
class AllMembersSection extends ConsumerWidget {
  final List<GroupMember> members;
  final int? currentUserId;
  final bool isLeader;
  final QuestifyColors q;
  final int groupId;

  const AllMembersSection({
    super.key,
    required this.members,
    required this.currentUserId,
    required this.isLeader,
    required this.q,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tous les membres',
              style: TextStyle(
                  color: q.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...members.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MemberCard(
                  member: m,
                  isSelf: m.userId == currentUserId,
                  canManage: isLeader && m.userId != currentUserId,
                  q: q,
                  onRemove: () async {
                    final api = ref.read(apiServiceProvider);
                    try {
                      await api.removeMember(groupId, m.userId);
                      ref.read(groupProvider.notifier).loadGroups();
                    } catch (_) {}
                  },
                ),
              )),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final GroupMember member;
  final bool isSelf;
  final bool canManage;
  final QuestifyColors q;
  final VoidCallback onRemove;

  const _MemberCard({
    required this.member,
    required this.isSelf,
    required this.canManage,
    required this.q,
    required this.onRemove,
  });

  Color get _avatarColor {
    final colors = [kAccentPurple, kAccentGold, kAccentMint, kAccentCyan, kAccentRed];
    return colors[member.userId % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final memberIsLeader = member.role == GroupRole.LEADER;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: q.bgSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelf ? q.accentPurple : q.borderDefault,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Avatar with level badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: _avatarColor,
                child: Text(
                  member.displayName.isNotEmpty
                      ? member.displayName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              // Leader crown
              if (memberIsLeader)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: q.accentGold,
                      boxShadow: [
                        BoxShadow(color: q.glowGold, blurRadius: 6),
                      ],
                    ),
                    child: Icon(Icons.auto_awesome,
                        size: 12, color: q.bgPrimary),
                  ),
                ),
              // Level badge
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: q.accentPurple,
                    border: Border.all(color: q.bgSecondary, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '${member.level}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Name + XP
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(member.displayName,
                        style: TextStyle(
                            color: q.textPrimary,
                            fontWeight: FontWeight.w500)),
                    if (isSelf) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: q.accentMint,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Toi',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.star, size: 12, color: q.accentGold),
                    const SizedBox(width: 4),
                    Text('${member.weeklyXp} XP',
                        style: TextStyle(color: q.textMuted, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // Manage button
          if (canManage)
            PopupMenuButton<String>(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: q.bgTertiary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.more_vert, size: 16, color: q.textMuted),
              ),
              color: q.bgSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: q.accentPurple),
              ),
              onSelected: (val) {
                if (val == 'remove') onRemove();
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'remove',
                  child: Text('Retirer du groupe',
                      style: TextStyle(color: q.accentRed)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
