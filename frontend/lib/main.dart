import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app_router.dart';
import 'theme.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase est optionnel : si non configure (pas de google-services.json),
  // l'app fonctionne quand meme sans notifications push.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    debugPrint('Firebase non configure — notifications push desactivees.');
  }
  runApp(const ProviderScope(child: QuestifyApp()));
}

class QuestifyApp extends ConsumerWidget {
  const QuestifyApp({super.key});

  static final _router = buildRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeProvider);

    // Derive ThemeMode from our 3-state enum
    final ThemeMode themeMode;
    switch (mode) {
      case QuestifyThemeMode.light:
        themeMode = ThemeMode.light;
        break;
      case QuestifyThemeMode.dark:
        themeMode = ThemeMode.dark;
        break;
      case QuestifyThemeMode.auto:
        themeMode = ThemeMode.system;
        break;
    }

    return MaterialApp.router(
      title: 'Questify',
      theme: questifyLightTheme,
      darkTheme: questifyDarkTheme,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}
