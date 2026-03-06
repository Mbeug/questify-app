import 'dart:math';

import 'package:flutter/material.dart';

/// Data for an XP reward notification.
class XpRewardData {
  final int xp;
  final int coins;
  final int gems;
  final bool leveledUp;
  final int? newLevel;
  final String message;

  const XpRewardData({
    required this.xp,
    this.coins = 0,
    this.gems = 0,
    this.leveledUp = false,
    this.newLevel,
    this.message = 'XP gagne!',
  });
}

/// Shows a floating XP notification overlay on top of the current screen.
///
/// Usage:
/// ```dart
/// showXpNotification(context, XpRewardData(xp: 50, coins: 20));
/// ```
void showXpNotification(BuildContext context, XpRewardData data) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => _XpNotificationOverlay(
      data: data,
      onDismissed: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
}

// ---------------------------------------------------------------------------
//  Overlay widget — manages its own animation lifecycle
// ---------------------------------------------------------------------------

class _XpNotificationOverlay extends StatefulWidget {
  final XpRewardData data;
  final VoidCallback onDismissed;

  const _XpNotificationOverlay({
    required this.data,
    required this.onDismissed,
  });

  @override
  State<_XpNotificationOverlay> createState() => _XpNotificationOverlayState();
}

class _XpNotificationOverlayState extends State<_XpNotificationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeOut;
  late Animation<double> _slideIn;
  late Animation<double> _slideOut;
  late Animation<double> _scaleIn;
  late Animation<double> _scaleOut;
  late Animation<double> _particleProgress;

  @override
  void initState() {
    super.initState();

    // Total duration: 0-400ms in, 400-2000ms hold, 2000-2500ms out
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Enter: 0 → 0.16 (400ms)
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.16, curve: Curves.easeOut)),
    );
    _slideIn = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.16, curve: Curves.elasticOut)),
    );
    _scaleIn = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.16, curve: Curves.elasticOut)),
    );

    // Exit: 0.80 → 1.0 (500ms)
    _fadeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.80, 1.0, curve: Curves.easeIn)),
    );
    _slideOut = Tween<double>(begin: 0, end: -50).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.80, 1.0, curve: Curves.easeIn)),
    );
    _scaleOut = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.80, 1.0, curve: Curves.easeIn)),
    );

    // Particles: expand during 0 → 0.35 (875ms)
    _particleProgress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.35, curve: Curves.easeOut)),
    );

    _controller.forward().then((_) {
      widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Combine enter/exit: during hold phase both are at their resting values
        final opacity = (_controller.value <= 0.80)
            ? _fadeIn.value
            : _fadeOut.value;
        final slide = (_controller.value <= 0.80)
            ? _slideIn.value
            : _slideOut.value;
        final scale = (_controller.value <= 0.80)
            ? _scaleIn.value
            : _scaleOut.value;

        return Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: const Alignment(0, -0.3), // upper third of screen
              child: Transform.translate(
                offset: Offset(0, slide),
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: _buildCard(context),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Particles layer (behind card)
          ..._buildParticles(),
          // Main card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFA75EFF), Color(0xFF7B3FD9)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xCCA75EFF),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Sparkle icon + message
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, color: Color(0xFFFFD166), size: 28),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.data.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '+${widget.data.xp}',
                                style: const TextStyle(
                                  color: Color(0xFFFFD166),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.star, color: Color(0xFFFFD166), size: 24),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Coins + gems row (if any)
                if (widget.data.coins > 0 || widget.data.gems > 0) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.data.coins > 0)
                        _RewardChip(
                          icon: '\u{1FA99}',
                          label: '+${widget.data.coins}',
                          color: const Color(0xFFFFD166),
                        ),
                      if (widget.data.coins > 0 && widget.data.gems > 0)
                        const SizedBox(width: 10),
                      if (widget.data.gems > 0)
                        _RewardChip(
                          icon: '\u{1F48E}',
                          label: '+${widget.data.gems}',
                          color: const Color(0xFF4ECDC4),
                        ),
                    ],
                  ),
                ],

                // Level up!
                if (widget.data.leveledUp) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD166),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '\u{1F31F} Niveau ${widget.data.newLevel ?? ""}!',
                      style: const TextStyle(
                        color: Color(0xFF1B1B2F),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 8 gold particles radiating outward in a circle
  List<Widget> _buildParticles() {
    const int count = 8;
    const double maxRadius = 70;
    const double particleSize = 8;

    return List.generate(count, (i) {
      final angle = (i / count) * 2 * pi;
      final progress = _particleProgress.value;
      final dx = cos(angle) * maxRadius * progress;
      final dy = sin(angle) * maxRadius * progress;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      final scale = progress;

      return Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: Align(
          alignment: Alignment.center,
          child: Transform.translate(
            offset: Offset(dx, dy),
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: particleSize,
                  height: particleSize,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD166),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

// ---------------------------------------------------------------------------
//  Small chip for coins / gems
// ---------------------------------------------------------------------------

class _RewardChip extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;

  const _RewardChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14, decoration: TextDecoration.none)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
