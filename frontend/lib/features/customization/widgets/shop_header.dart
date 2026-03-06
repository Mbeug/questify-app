import 'package:flutter/material.dart';

import '../../../theme.dart';

/// Top section showing title and wallet cards.
class ShopHeader extends StatelessWidget {
  final QuestifyColors q;
  final int coins;
  final int gems;

  const ShopHeader({
    super.key,
    required this.q,
    required this.coins,
    required this.gems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [q.bgSecondary, q.bgPrimary],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Boutique des Themes',
                  style: TextStyle(
                    color: q.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 4),
              Text(
                'Personnalise ton aventure avec des themes epiques',
                style: TextStyle(color: q.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Wallet
              Row(
                children: [
                  Expanded(
                    child: _WalletCard(
                      q: q,
                      icon: Icons.monetization_on,
                      label: 'Pieces d\'or',
                      value: '$coins',
                      color: q.accentGold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _WalletCard(
                      q: q,
                      icon: Icons.diamond,
                      label: 'Gemmes',
                      value: '$gems',
                      color: q.accentPurple,
                    ),
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

class _WalletCard extends StatelessWidget {
  final QuestifyColors q;
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _WalletCard({
    required this.q,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(color: q.textMuted, fontSize: 11)),
              Text(value,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
