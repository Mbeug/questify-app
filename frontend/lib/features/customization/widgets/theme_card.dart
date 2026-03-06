import 'package:flutter/material.dart';

import '../../../models/app_theme.dart';
import '../../../theme.dart';
import 'customization_helpers.dart';

/// Card for a single theme in the list.
/// Includes a built-in day/night toggle to preview both colour variants.
class ThemeCard extends StatefulWidget {
  final AppThemeModel theme;
  final String status; // active | unlocked | locked
  final bool isSelected;
  final QuestifyColors q;
  final VoidCallback onSelect;
  final VoidCallback? onApply;

  /// Called when the user toggles between day/night inside this card.
  final ValueChanged<bool>? onVariantChanged;

  /// Whether to show the night variant (controlled by parent).
  final bool showNight;

  const ThemeCard({
    super.key,
    required this.theme,
    required this.status,
    required this.isSelected,
    required this.q,
    required this.onSelect,
    required this.onApply,
    this.onVariantChanged,
    this.showNight = false,
  });

  @override
  State<ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> {
  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final q = widget.q;
    final rarity = rarityOf(t.rarity);
    final isNight = widget.showNight;

    // Pick colours based on current variant
    final bgColor =
        hexToColor(isNight ? t.nightBackgroundColor : t.dayBackgroundColor);
    final primaryColor =
        hexToColor(isNight ? t.nightPrimaryColor : t.dayPrimaryColor);
    final surfaceColor =
        hexToColor(isNight ? t.nightSurfaceColor : t.daySurfaceColor);
    final secondaryColor =
        hexToColor(isNight ? t.nightSecondaryColor : t.daySecondaryColor);

    return GestureDetector(
      onTap: widget.onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: q.bgSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: widget.isSelected ? rarity.color : q.borderDefault,
            width: 2,
          ),
          boxShadow: widget.isSelected
              ? [
                  BoxShadow(
                    color: rarity.color.withAlpha(50),
                    blurRadius: 16,
                  )
                ]
              : [],
        ),
        child: Opacity(
          opacity: widget.status == 'locked' ? 0.6 : 1,
          child: Column(
            children: [
              // Top row: emoji + name + rarity + status
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bgColor,
                      border: Border.all(color: primaryColor, width: 2),
                    ),
                    child: Center(
                      child: Text(themeEmoji(t.themeKey),
                          style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.name,
                            style: TextStyle(
                                color: q.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: rarity.color.withAlpha(40),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(rarity.icon,
                                  size: 10, color: rarity.color),
                              const SizedBox(width: 3),
                              Text(rarity.label,
                                  style: TextStyle(
                                      color: rarity.color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badges
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.status == 'active')
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: q.accentMint,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check,
                                  size: 12, color: Colors.white),
                              SizedBox(width: 3),
                              Text('Actif',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      if (widget.status == 'locked' && t.price > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: q.accentGold.withAlpha(40),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.monetization_on,
                                  size: 12, color: q.accentGold),
                              const SizedBox(width: 3),
                              Text('${t.price}',
                                  style: TextStyle(
                                      color: q.accentGold,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      if (widget.status == 'locked')
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child:
                              Icon(Icons.lock, size: 16, color: q.textMuted),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Day / Night toggle row
              Row(
                children: [
                  Icon(
                    isNight ? Icons.dark_mode : Icons.light_mode,
                    size: 16,
                    color: q.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isNight ? 'Nuit' : 'Jour',
                    style: TextStyle(
                      color: q.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 28,
                    child: Switch(
                      value: isNight,
                      onChanged: (val) {
                        widget.onVariantChanged?.call(val);
                      },
                      activeColor: q.accentPurple,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Color preview strip
              Row(
                children: [bgColor, surfaceColor, primaryColor, secondaryColor]
                    .map((c) => Expanded(
                          child: Container(
                            height: 36,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: c,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.white.withAlpha(30),
                                  width: 1.5),
                            ),
                          ),
                        ))
                    .toList(),
              ),

              // Action button (only if selected)
              if (widget.isSelected && widget.onApply != null) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: widget.status == 'locked'
                      ? ElevatedButton.icon(
                          onPressed: widget.onApply,
                          icon: const Icon(Icons.lock_open, size: 16),
                          label: Text(
                              'Debloquer (${t.price} pieces)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: q.borderDefault,
                            foregroundColor: q.textMuted,
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              rarity.color,
                              rarity.color.withAlpha(200),
                            ]),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: rarity.color.withAlpha(60),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: widget.onApply,
                            icon: const Icon(Icons.auto_awesome,
                                size: 16),
                            label: const Text('Appliquer ce theme'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                            ),
                          ),
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
