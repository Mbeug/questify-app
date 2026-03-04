import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _obscure = true;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).signup(
          _emailCtrl.text.trim(),
          _pwdCtrl.text,
          _nameCtrl.text.trim(),
        );

    if (success && mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              cs.tertiary,
                              cs.tertiary.withAlpha(180),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: cs.tertiary.withAlpha(60),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.auto_awesome,
                            size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Text('Rejoins Questify',
                          style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Cree ton compte et commence tes quetes',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: cs.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Form
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: _nameCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Nom d\'aventurier',
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? 'Requis'
                                          : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email_outlined),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Requis';
                                    }
                                    if (!v.contains('@')) {
                                      return 'Email invalide';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _pwdCtrl,
                                  decoration: InputDecoration(
                                    labelText: 'Mot de passe',
                                    prefixIcon:
                                        const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscure
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () => setState(
                                          () => _obscure = !_obscure),
                                    ),
                                  ),
                                  obscureText: _obscure,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Requis';
                                    }
                                    if (v.length < 6) {
                                      return 'Min 6 caracteres';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 8),

                                // Error
                                if (auth.error != null) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: cs.errorContainer,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.error_outline,
                                            size: 18,
                                            color: cs.onErrorContainer),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(auth.error!,
                                              style: TextStyle(
                                                  color:
                                                      cs.onErrorContainer,
                                                  fontSize: 13)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: FilledButton(
                                    onPressed:
                                        auth.isLoading ? null : _submit,
                                    child: auth.isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child:
                                                CircularProgressIndicator(
                                                    strokeWidth: 2))
                                        : const Text('Creer mon compte'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child:
                            const Text('Deja un compte ? Se connecter'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
