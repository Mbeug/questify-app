import 'package:flutter/material.dart';

import '../../../models/group.dart';
import '../../../theme.dart';

/// Podium section showing the top 3 members by weekly XP.
class PodiumSection extends StatelessWidget {
  final List<GroupMember> sorted;
  final QuestifyColors q;

  const PodiumSection({super.key, required this.sorted, required this.q});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Classement hebdo',
                  style: TextStyle(
                      color: q.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              Icon(Icons.sports_kabaddi, size: 20, color: q.accentGold),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 2nd place
                if (sorted.length > 1)
                  Expanded(child: _PodiumPlace(
                    member: sorted[1],
                    rank: 2,
                    height: 100,
                    medalColor: const Color(0xFFC0C0C0),
                    q: q,
                  ))
                else
                  const Expanded(child: SizedBox()),
                // 1st place
                if (sorted.isNotEmpty)
                  Expanded(child: _PodiumPlace(
                    member: sorted[0],
                    rank: 1,
                    height: 140,
                    medalColor: const Color(0xFFFFD166),
                    q: q,
                    isFirst: true,
                  )),
                // 3rd place
                if (sorted.length > 2)
                  Expanded(child: _PodiumPlace(
                    member: sorted[2],
                    rank: 3,
                    height: 80,
                    medalColor: const Color(0xFFCD7F32),
                    q: q,
                  ))
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumPlace extends StatelessWidget {
  final GroupMember member;
  final int rank;
  final double height;
  final Color medalColor;
  final QuestifyColors q;
  final bool isFirst;

  const _PodiumPlace({
    required this.member,
    required this.rank,
    required this.height,
    required this.medalColor,
    required this.q,
    this.isFirst = false,
  });

  Color get _avatarColor {
    final colors = [kAccentPurple, kAccentGold, kAccentMint, kAccentCyan, kAccentRed];
    return colors[member.userId % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = isFirst ? 56.0 : rank == 2 ? 48.0 : 42.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Crown for 1st place
        if (isFirst)
          Icon(Icons.auto_awesome, size: 28, color: q.accentGold),
        if (isFirst) const SizedBox(height: 4),

        // Avatar
        Container(
          padding: isFirst ? const EdgeInsets.all(6) : EdgeInsets.zero,
          decoration: isFirst
              ? BoxDecoration(
                  color: q.accentGold.withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: q.accentGold.withAlpha(60)),
                  boxShadow: [
                    BoxShadow(color: q.glowGold, blurRadius: 12),
                  ],
                )
              : null,
          child: CircleAvatar(
            radius: avatarSize / 2,
            backgroundColor: _avatarColor,
            child: Text(
              member.displayName.isNotEmpty
                  ? member.displayName[0].toUpperCase()
                  : '?',
              style: TextStyle(
                color: Colors.white,
                fontSize: avatarSize * 0.4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Podium block
        Container(
          width: double.infinity,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: medalColor.withAlpha(50),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            boxShadow: isFirst
                ? [BoxShadow(color: q.glowGold, blurRadius: 16)]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                rank == 1 ? Icons.emoji_events : Icons.military_tech,
                size: isFirst ? 28 : 22,
                color: medalColor,
              ),
              const SizedBox(height: 2),
              Text('#$rank',
                  style: TextStyle(
                      color: q.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(
                '${member.weeklyXp}',
                style: TextStyle(
                  color: q.textPrimary,
                  fontSize: isFirst ? 20 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('XP',
                  style: TextStyle(color: q.textMuted, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}
