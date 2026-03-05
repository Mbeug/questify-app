import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app_router.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase est optionnel : si non configuré (pas de google-services.json),
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

class QuestifyApp extends StatelessWidget {
  const QuestifyApp({super.key});

  static final _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Questify',
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      routerConfig: _router,
    );
  }
}
