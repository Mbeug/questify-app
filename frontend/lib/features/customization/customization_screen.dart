import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/customization_provider.dart';
import '../../theme.dart';
import 'widgets/customization_helpers.dart';
import 'widgets/live_preview.dart';
import 'widgets/promo_card.dart';
import 'widgets/shop_header.dart';
import 'widgets/theme_card.dart';

// ═══════════════════════════════════════════════════════════════════
//  CustomizationScreen — themes grouped by rarity
// ═══════════════════════════════════════════════════════════════════

/// Display order for rarity sections.
const _rarityOrder = [
  ThemeRarity.COMMON,
  ThemeRarity.UNCOMMON,
  ThemeRarity.RARE,
  ThemeRarity.EPIC,
  ThemeRarity.LEGENDARY,
];

class CustomizationScreen extends ConsumerStatefulWidget {
  const CustomizationScreen({super.key});

  @override
  ConsumerState<CustomizationScreen> createState() =>
      _CustomizationScreenState();
}

class _CustomizationScreenState extends ConsumerState<CustomizationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  int? _selectedThemeId;

  /// Tracks which themes are showing the night variant (key = theme id).
  final Map<int, bool> _nightVariantMap = {};

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();

    Future.microtask(() {
      ref.read(customizationProvider.notifier).loadThemes();
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  String _statusOf(AppThemeModel t) {
    if (t.active) return 'active';
    if (t.owned || t.isDefault) return 'unlocked';
    return 'locked';
  }

  bool _isNight(int themeId) => _nightVariantMap[themeId] ?? false;

  Future<void> _onBuy(AppThemeModel theme) async {
    final q = context.q;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: q.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: rarityOf(theme.rarity).color),
        ),
        title: Text('Acheter ${theme.name} ?',
            style: TextStyle(color: q.textPrimary)),
        content: Text(
          'Ce theme coute ${theme.price} pieces d\'or.',
          style: TextStyle(color: q.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Annuler', style: TextStyle(color: q.textMuted)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [q.accentPurple, q.accentGold]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Acheter',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final ok = await ref
          .read(customizationProvider.notifier)
          .buyTheme(theme.id);
      if (ok && mounted) {
        await ref.read(authProvider.notifier).refreshUser();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${theme.name} debloque!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      final err = ref.read(customizationProvider).error;
      if (err != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _onApply(AppThemeModel theme) async {
    final ok = await ref
        .read(customizationProvider.notifier)
        .applyTheme(theme.id);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Theme ${theme.name} applique!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final customState = ref.watch(customizationProvider);
    final user = ref.watch(authProvider).user;
    final q = context.q;
    final themes = customState.themes;

    // Find active or selected
    final selectedTheme = _selectedThemeId != null
        ? themes.where((t) => t.id == _selectedThemeId).firstOrNull
        : themes.where((t) => t.active).firstOrNull ?? themes.firstOrNull;

    final unlockedCount =
        themes.where((t) => t.owned || t.isDefault || t.active).length;

    // Group themes by rarity
    final Map<ThemeRarity, List<AppThemeModel>> grouped = {};
    for (final t in themes) {
      grouped.putIfAbsent(t.rarity, () => []).add(t);
    }

    return Scaffold(
      backgroundColor: q.bgPrimary,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: customState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ───────────────────────────
                    ShopHeader(
                      q: q,
                      coins: user?.coins ?? 0,
                      gems: user?.gems ?? 0,
                    ),

                    // ── Live preview ────────────────────
                    if (selectedTheme != null)
                      LivePreview(
                        theme: selectedTheme,
                        q: q,
                        showNight: _isNight(selectedTheme.id),
                        onVariantChanged: (val) {
                          setState(() {
                            _nightVariantMap[selectedTheme.id] = val;
                          });
                        },
                      ),

                    // ── Theme list header ───────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Themes disponibles',
                              style: TextStyle(
                                  color: q.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: q.bgSecondary,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: q.borderDefault),
                            ),
                            child: Text(
                              '$unlockedCount / ${themes.length}',
                              style: TextStyle(
                                  color: q.textMuted, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Rarity sections ─────────────────
                    ..._rarityOrder
                        .where((r) => grouped.containsKey(r))
                        .expand((r) {
                      final rConf = rarityOf(r);
                      final sectionThemes = grouped[r]!;
                      return [
                        // Section header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 6),
                          child: Row(
                            children: [
                              Icon(rConf.icon,
                                  size: 16, color: rConf.color),
                              const SizedBox(width: 6),
                              Text(
                                rConf.label,
                                style: TextStyle(
                                  color: rConf.color,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: rConf.color.withAlpha(60),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Theme cards in this section
                        ...sectionThemes.map((t) {
                          final status = _statusOf(t);
                          final isSelected =
                              t.id == (selectedTheme?.id ?? -1);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 4),
                            child: ThemeCard(
                              theme: t,
                              status: status,
                              isSelected: isSelected,
                              q: q,
                              showNight: _isNight(t.id),
                              onVariantChanged: (val) {
                                setState(() {
                                  _nightVariantMap[t.id] = val;
                                });
                              },
                              onSelect: () =>
                                  setState(() => _selectedThemeId = t.id),
                              onApply: status == 'locked'
                                  ? () => _onBuy(t)
                                  : status == 'active'
                                      ? null
                                      : () => _onApply(t),
                            ),
                          );
                        }),
                      ];
                    }),

                    // ── Bottom promo card ───────────────
                    PromoCard(q: q),
                  ],
                ),
              ),
      ),
    );
  }
}
