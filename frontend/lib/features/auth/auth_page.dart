import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme.dart';

// ============================================================================
//  AuthPage — merged Login / Signup with TabBar (matches Figma mockup)
// ============================================================================

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with TickerProviderStateMixin {
  // Tab controller
  late TabController _tabCtrl;

  // Login form
  final _loginFormKey = GlobalKey<FormState>();
  final _loginEmail = TextEditingController();
  final _loginPwd = TextEditingController();
  bool _loginObscure = true;

  // Signup form
  final _signupFormKey = GlobalKey<FormState>();
  final _signupName = TextEditingController();
  final _signupEmail = TextEditingController();
  final _signupPwd = TextEditingController();
  bool _signupObscure = true;
  int _selectedAvatar = 0;

  // Animations
  late AnimationController _logoCtrl;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late AnimationController _contentCtrl;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;
  late AnimationController _floatCtrl;

  static const _avatars = [
    _AvatarDef(emoji: '\u2694\uFE0F', color: kAccentPurple),   // crossed swords
    _AvatarDef(emoji: '\uD83D\uDEE1\uFE0F', color: kAccentGold),    // shield
    _AvatarDef(emoji: '\uD83C\uDFF9', color: kAccentMint),     // bow
    _AvatarDef(emoji: '\uD83D\uDD2E', color: kAccentRed),      // crystal ball
    _AvatarDef(emoji: '\u2B50', color: kAccentCyan),            // star
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) setState(() {});
    });

    // Logo animation: spring scale + rotation
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoScale = CurvedAnimation(
      parent: _logoCtrl,
      curve: Curves.elasticOut,
    );
    _logoRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutBack),
    );

    // Content fade + slide
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _contentFade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);
    _contentSlide = Tween(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOutCubic));

    // Floating icons animation (infinite loop)
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    // Stagger the start
    _logoCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _contentCtrl.forward();
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _logoCtrl.dispose();
    _contentCtrl.dispose();
    _floatCtrl.dispose();
    _loginEmail.dispose();
    _loginPwd.dispose();
    _signupName.dispose();
    _signupEmail.dispose();
    _signupPwd.dispose();
    super.dispose();
  }

  // ── Login submit ──
  Future<void> _loginSubmit() async {
    if (!_loginFormKey.currentState!.validate()) return;
    final success = await ref.read(authProvider.notifier).login(
          _loginEmail.text.trim(),
          _loginPwd.text,
        );
    if (success && mounted) context.go('/dashboard');
  }

  // ── Signup submit ──
  Future<void> _signupSubmit() async {
    if (!_signupFormKey.currentState!.validate()) return;
    final success = await ref.read(authProvider.notifier).signup(
          _signupEmail.text.trim(),
          _signupPwd.text,
          _signupName.text.trim(),
        );
    if (success && mounted) context.go('/dashboard');
  }

  // ── Social login (Google / Apple) ──
  Future<void> _socialLogin(String provider) async {
    final success = await ref.read(authProvider.notifier).socialLogin(provider);
    if (success && mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final q = context.q;

    // Auto-redirect if already authenticated
    if (auth.isAuthenticated && !auth.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/dashboard');
      });
    }

    return Scaffold(
      backgroundColor: q.bgPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Background blurred circles ──
            _BackgroundDecoration(q: q),

            // ── Theme toggle ──
            Positioned(
              top: 12,
              right: 12,
              child: _ThemeToggleButton(),
            ),

            // ── Main content ──
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),

                      // ── Animated Logo ──
                      _buildLogo(q),
                      const SizedBox(height: 24),

                      // ── Title ──
                      FadeTransition(
                        opacity: _contentFade,
                        child: SlideTransition(
                          position: _contentSlide,
                          child: Column(
                            children: [
                              Text(
                                'Bienvenue dans Questify',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: q.textPrimary),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Transforme ton quotidien en aventure epique !',
                                style: TextStyle(color: q.textMuted, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Tab bar ──
                      FadeTransition(
                        opacity: _contentFade,
                        child: SlideTransition(
                          position: _contentSlide,
                          child: _buildTabBar(q),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Tab content ──
                      FadeTransition(
                        opacity: _contentFade,
                        child: SlideTransition(
                          position: _contentSlide,
                          child: SizedBox(
                            // Give tabs a max height so they're scrollable if needed
                            height: _tabCtrl.index == 1 ? 620 : 520,
                            child: TabBarView(
                              controller: _tabCtrl,
                              children: [
                                _buildLoginTab(auth, q),
                                _buildSignupTab(auth, q),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // ── Footer ──
                      const SizedBox(height: 16),
                      Text(
                        'En continuant, tu acceptes nos conditions d\'utilisation',
                        style: TextStyle(color: q.textMuted, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Logo with spring animation + floating icons ──
  Widget _buildLogo(QuestifyColors q) {
    return ScaleTransition(
      scale: _logoScale,
      child: AnimatedBuilder(
        animation: _logoRotation,
        builder: (_, child) => Transform.rotate(
          angle: _logoRotation.value * pi,
          child: child,
        ),
        child: SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Glow
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: q.glowPurple,
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
              // Main circle
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [kAccentPurple, kAccentGold],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: kAccentGold, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(60),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.security, size: 56, color: Colors.white),
                ),
              ),
              // Floating shield icon
              Positioned(
                top: -8,
                left: -8,
                child: AnimatedBuilder(
                  animation: _floatCtrl,
                  builder: (_, child) {
                    final dy = -10.0 + 20.0 * _floatCtrl.value;
                    return Transform.translate(
                      offset: Offset(0, dy),
                      child: child,
                    );
                  },
                  child: Icon(Icons.shield, size: 32, color: q.accentMint),
                ),
              ),
              // Floating bolt icon
              Positioned(
                bottom: -8,
                right: -8,
                child: AnimatedBuilder(
                  animation: _floatCtrl,
                  builder: (_, child) {
                    final dy = 10.0 - 20.0 * _floatCtrl.value;
                    return Transform.translate(
                      offset: Offset(0, dy),
                      child: child,
                    );
                  },
                  child: Icon(Icons.bolt, size: 32, color: q.accentGold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Tab bar ──
  Widget _buildTabBar(QuestifyColors q) {
    return Container(
      decoration: BoxDecoration(
        color: q.bgSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: q.borderDefault),
      ),
      child: TabBar(
        controller: _tabCtrl,
        onTap: (_) => setState(() {}), // rebuild to resize TabBarView
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: kAccentPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: q.textMuted,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: 'Se connecter'),
          Tab(text: 'Creer mon profil'),
        ],
      ),
    );
  }

  // ──────────── LOGIN TAB ────────────
  Widget _buildLoginTab(AuthState auth, QuestifyColors q) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: q.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kAccentPurple.withAlpha(64)),
          boxShadow: [
            BoxShadow(
              color: q.glowPurple.withAlpha(30),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email
                  _FieldLabel(
                    icon: Icons.email_outlined,
                    label: 'Adresse e-mail',
                    color: kAccentPurple,
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _loginEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'aventurier@questify.app',
                      hintStyle: TextStyle(color: q.textMuted),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Requis' : null,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  _FieldLabel(
                    icon: Icons.lock_outline,
                    label: 'Mot de passe',
                    color: kAccentPurple,
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _loginPwd,
                    obscureText: _loginObscure,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _loginSubmit(),
                    decoration: InputDecoration(
                      hintText: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                      hintStyle: TextStyle(color: q.textMuted),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _loginObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: q.textMuted,
                        ),
                        onPressed: () =>
                            setState(() => _loginObscure = !_loginObscure),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Requis' : null,
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        textStyle:
                            TextStyle(fontSize: 12, color: q.textMuted),
                      ),
                      child: Text('Mot de passe oublie ?',
                          style: TextStyle(
                              color: q.textMuted, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),

            // Error
            if (auth.error != null && _tabCtrl.index == 0) ...[
              const SizedBox(height: 8),
              _ErrorBanner(message: auth.error!),
            ],

            const SizedBox(height: 12),

            // Submit
            _GradientButton(
              onPressed: auth.isLoading ? null : _loginSubmit,
              isLoading: auth.isLoading,
              gradient: const LinearGradient(
                colors: [kAccentPurple, Color(0xFF7B3FD9)],
              ),
              shadowColor: kAccentPurple.withAlpha(80),
              label: 'Entrer dans l\'aventure',
              icon: Icons.auto_awesome,
            ),

            // Divider
            const SizedBox(height: 20),
            _OrDivider(q: q, text: 'ou continuer avec'),
            const SizedBox(height: 16),

            // Social buttons
            _SocialButtons(
              q: q,
              isLoading: auth.isLoading,
              onGooglePressed: () => _socialLogin('google'),
              onApplePressed: () => _socialLogin('apple'),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────── SIGNUP TAB ────────────
  Widget _buildSignupTab(AuthState auth, QuestifyColors q) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: q.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kAccentGold.withAlpha(64)),
          boxShadow: [
            BoxShadow(
              color: q.glowGold.withAlpha(30),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _signupFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero name
                  _FieldLabel(
                    icon: Icons.person_outline,
                    label: 'Nom de ton heros',
                    color: kAccentGold,
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _signupName,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Ex: Alex le Conquerant',
                      hintStyle: TextStyle(color: q.textMuted),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Requis' : null,
                  ),
                  const SizedBox(height: 12),

                  // Avatar selector
                  Text('Choisis ton avatar',
                      style: TextStyle(
                          color: q.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_avatars.length, (i) {
                      final av = _avatars[i];
                      final selected = i == _selectedAvatar;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedAvatar = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: av.color,
                            shape: BoxShape.circle,
                            border: selected
                                ? Border.all(color: Colors.white, width: 3)
                                : null,
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: av.color.withAlpha(120),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: AnimatedOpacity(
                              opacity: selected ? 1.0 : 0.5,
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                av.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),

                  // Email
                  _FieldLabel(
                    icon: Icons.email_outlined,
                    label: 'Adresse e-mail',
                    color: kAccentGold,
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _signupEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'aventurier@questify.app',
                      hintStyle: TextStyle(color: q.textMuted),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Requis';
                      if (!v.contains('@')) return 'Email invalide';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Password
                  _FieldLabel(
                    icon: Icons.lock_outline,
                    label: 'Mot de passe',
                    color: kAccentGold,
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _signupPwd,
                    obscureText: _signupObscure,
                    decoration: InputDecoration(
                      hintText: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                      hintStyle: TextStyle(color: q.textMuted),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _signupObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: q.textMuted,
                        ),
                        onPressed: () =>
                            setState(() => _signupObscure = !_signupObscure),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Requis';
                      if (v.length < 6) return 'Min 6 caracteres';
                      return null;
                    },
                  ),
                ],
              ),
            ),

            // Level badge
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kAccentMint.withAlpha(32),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kAccentMint.withAlpha(64)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 24, color: kAccentMint),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tu commences au',
                            style: TextStyle(color: q.textMuted, fontSize: 12)),
                        const Text(
                          'Niveau 1 - Novice Heroique',
                          style: TextStyle(
                            color: kAccentMint,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Error
            if (auth.error != null && _tabCtrl.index == 1) ...[
              const SizedBox(height: 8),
              _ErrorBanner(message: auth.error!),
            ],

            const SizedBox(height: 12),

            // Submit
            _GradientButton(
              onPressed: auth.isLoading ? null : _signupSubmit,
              isLoading: auth.isLoading,
              gradient: const LinearGradient(
                colors: [kAccentGold, Color(0xFFFFA500)],
              ),
              shadowColor: kAccentGold.withAlpha(80),
              label: 'Creer mon profil heros',
              icon: Icons.auto_awesome,
              textColor: const Color(0xFF1B1B2F),
            ),

            // Divider
            const SizedBox(height: 20),
            _OrDivider(q: q, text: 'ou creer avec'),
            const SizedBox(height: 16),

            // Social buttons
            _SocialButtons(
              q: q,
              isLoading: auth.isLoading,
              onGooglePressed: () => _socialLogin('google'),
              onApplePressed: () => _socialLogin('apple'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
//  Small sub-widgets
// ============================================================================

class _AvatarDef {
  final String emoji;
  final Color color;
  const _AvatarDef({required this.emoji, required this.color});
}

class _FieldLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FieldLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: context.q.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: kAccentRed.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kAccentRed.withAlpha(60)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: kAccentRed),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: const TextStyle(color: kAccentRed, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final LinearGradient gradient;
  final Color shadowColor;
  final String label;
  final IconData icon;
  final Color textColor;

  const _GradientButton({
    required this.onPressed,
    required this.isLoading,
    required this.gradient,
    required this.shadowColor,
    required this.label,
    required this.icon,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: onPressed != null ? gradient : null,
        color: onPressed == null ? Colors.grey : null,
        borderRadius: BorderRadius.circular(14),
        boxShadow: onPressed != null
            ? [BoxShadow(color: shadowColor, blurRadius: 15, offset: const Offset(0, 4))]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: textColor),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 18, color: textColor),
                      const SizedBox(width: 8),
                      Text(label,
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  final QuestifyColors q;
  final String text;
  const _OrDivider({required this.q, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: q.borderDefault)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text, style: TextStyle(color: q.textMuted, fontSize: 12)),
        ),
        Expanded(child: Divider(color: q.borderDefault)),
      ],
    );
  }
}

class _SocialButtons extends StatelessWidget {
  final QuestifyColors q;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final bool isLoading;

  const _SocialButtons({
    required this.q,
    this.onGooglePressed,
    this.onApplePressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onGooglePressed,
            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('G',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF4285F4))),
            label: Text('Google', style: TextStyle(color: q.textMuted)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: q.borderDefault),
              backgroundColor: q.bgPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onApplePressed,
            icon: Icon(Icons.apple, size: 22, color: q.textPrimary),
            label: Text('Apple', style: TextStyle(color: q.textMuted)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: q.borderDefault),
              backgroundColor: q.bgPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Background blurred circles ──
class _BackgroundDecoration extends StatelessWidget {
  final QuestifyColors q;
  const _BackgroundDecoration({required this.q});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.2,
      child: Stack(
        children: [
          Positioned(
            top: 80,
            left: 20,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: q.accentPurple,
              ),
            ),
          ),
          Positioned(
            top: 160,
            right: 20,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: q.accentGold,
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: MediaQuery.of(context).size.width / 2 - 160,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: q.accentMint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Theme toggle button ──
class _ThemeToggleButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeProvider);
    final isDark = mode == QuestifyThemeMode.dark;
    final q = context.q;

    return GestureDetector(
      onTap: () => ref.read(themeProvider.notifier).setMode(
            isDark ? QuestifyThemeMode.light : QuestifyThemeMode.dark,
          ),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: q.bgSecondary,
          shape: BoxShape.circle,
          border: Border.all(color: q.borderDefault),
          boxShadow: [
            BoxShadow(
              color: q.glowPurple.withAlpha(40),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          isDark ? Icons.dark_mode : Icons.light_mode,
          size: 22,
          color: isDark ? kAccentGold : kAccentPurple,
        ),
      ),
    );
  }
}
