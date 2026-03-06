import 'package:flutter/material.dart';

import '../../../models/app_theme.dart';
import '../../../theme.dart';
import 'customization_helpers.dart';

/// Live preview card showing a mini-mockup of the selected theme.
/// [showNight] controls which colour variant (day / night) is displayed.
class LivePreview extends StatelessWidget {
  final AppThemeModel theme;
  final QuestifyColors q;
  final bool showNight;
  final ValueChanged<bool>? onVariantChanged;

  const LivePreview({
    super.key,
    required this.theme,
    required this.q,
    this.showNight = false,
    this.onVariantChanged,
  });

  @override
  Widget build(BuildContext context) {
    final rarity = rarityOf(theme.rarity);

    final bgColor = hexToColor(
        showNight ? theme.nightBackgroundColor : theme.dayBackgroundColor);
    final surfaceColor = hexToColor(
        showNight ? theme.nightSurfaceColor : theme.daySurfaceColor);
    final primaryColor = hexToColor(
        showNight ? theme.nightPrimaryColor : theme.dayPrimaryColor);
    final secondaryColor = hexToColor(
        showNight ? theme.nightSecondaryColor : theme.daySecondaryColor);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title + day/night toggle
          Row(
            children: [
              Text('Apercu en direct',
                  style: TextStyle(
                      color: q.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(
                showNight ? Icons.dark_mode : Icons.light_mode,
                size: 16,
                color: q.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                showNight ? 'Nuit' : 'Jour',
                style: TextStyle(
                  color: q.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                height: 28,
                child: Switch(
                  value: showNight,
                  onChanged: onVariantChanged,
                  activeColor: q.accentPurple,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: q.bgSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: rarity.color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: rarity.color.withAlpha(50),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              children: [
                // Theme info
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bgColor,
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: Center(
                        child: Text(themeEmoji(theme.themeKey),
                            style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(theme.name,
                              style: TextStyle(
                                  color: q.textPrimary,
                                  fontWeight: FontWeight.w600)),
                          Text(theme.description ?? '',
                              style: TextStyle(
                                  color: q.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: rarity.color.withAlpha(40),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(rarity.label,
                          style: TextStyle(
                              color: rarity.color,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Mini preview
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: primaryColor.withAlpha(60)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 10,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 8,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: primaryColor.withAlpha(60)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 8,
                              width: 100,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 8,
                              width: 70,
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Color palette
                Row(
                  children: [
                    bgColor,
                    surfaceColor,
                    primaryColor,
                    secondaryColor,
                  ]
                      .map((c) => Expanded(
                            child: Container(
                              height: 32,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 3),
                              decoration: BoxDecoration(
                                color: c,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.white.withAlpha(40),
                                    width: 2),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
