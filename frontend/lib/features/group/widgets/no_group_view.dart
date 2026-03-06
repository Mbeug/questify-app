import 'package:flutter/material.dart';

import '../../../theme.dart';

/// View shown when the user has no group.
class NoGroupView extends StatelessWidget {
  final QuestifyColors q;
  final Animation<double> fadeAnim;
  final VoidCallback onCreate;
  final VoidCallback onJoin;

  const NoGroupView({
    super.key,
    required this.q,
    required this.fadeAnim,
    required this.onCreate,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: q.bgPrimary,
      body: FadeTransition(
        opacity: fadeAnim,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: q.accentGold.withAlpha(25),
                      border: Border.all(color: q.accentGold, width: 3),
                    ),
                    child: Icon(Icons.shield,
                        size: 40, color: q.accentGold),
                  ),
                  const SizedBox(height: 24),
                  Text('Aucune guilde',
                      style: TextStyle(
                          color: q.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'Rejoins une guilde ou cree la tienne pour accomplir des quetes en equipe !',
                    style: TextStyle(color: q.textMuted, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [q.accentPurple, const Color(0xFF7B3FD9)]),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: q.glowPurple,
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: onCreate,
                        icon: const Icon(Icons.add),
                        label: const Text('Creer une guilde'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onJoin,
                      icon: Icon(Icons.login, color: q.accentGold),
                      label: Text('Rejoindre avec un code',
                          style: TextStyle(color: q.accentGold)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: q.accentGold, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
