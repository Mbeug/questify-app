import 'package:flutter/material.dart';

import '../../../theme.dart';

/// Gradient dialog button used in group dialogs.
class GradientButton extends StatelessWidget {
  final QuestifyColors q;
  final String label;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.q,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [q.accentPurple, q.accentGold]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

/// Gradient action button used in the group action bar.
class GradientActionButton extends StatelessWidget {
  final QuestifyColors q;
  final IconData icon;
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  const GradientActionButton({
    super.key,
    required this.q,
    required this.icon,
    required this.label,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: colors[0].withAlpha(80), blurRadius: 12),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

/// Outline action button used in the group action bar.
class OutlineActionButton extends StatelessWidget {
  final QuestifyColors q;
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const OutlineActionButton({
    super.key,
    required this.q,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
