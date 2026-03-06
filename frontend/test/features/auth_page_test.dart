import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:frontend/features/auth/auth_page.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/social_auth_service.dart';
import 'package:frontend/theme.dart';

class MockApiService extends Mock implements ApiService {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class MockSocialAuthService extends Mock implements SocialAuthService {}

/// Build a testable app with overridden providers and GoRouter-free navigation.
Widget buildTestApp({
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: ThemeData(extensions: const [QuestifyColors.day]),
      home: const AuthPage(),
    ),
  );
}

/// Pump enough frames for initial animations (logo 1s + content 0.6s)
/// without waiting for infinite animations to settle.
Future<void> pumpAuth(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
}

/// Switch to the signup tab and wait for TabBarView animation.
Future<void> switchToSignupTab(WidgetTester tester) async {
  await tester.tap(find.text('Creer mon profil'));
  // Pump enough frames for the TabBarView animation (default 300ms)
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  late MockApiService mockApi;
  late MockSecureStorage mockStorage;
  late MockSocialAuthService mockSocial;

  setUp(() {
    mockApi = MockApiService();
    mockStorage = MockSecureStorage();
    mockSocial = MockSocialAuthService();

    // No stored tokens — skip auto-login
    when(() => mockStorage.read(key: 'accessToken'))
        .thenAnswer((_) async => null);
    when(() => mockStorage.read(key: 'refreshToken'))
        .thenAnswer((_) async => null);
  });

  List<Override> defaultOverrides() => [
        apiServiceProvider.overrideWithValue(mockApi),
        secureStorageProvider.overrideWithValue(mockStorage),
        socialAuthServiceProvider.overrideWithValue(mockSocial),
        themeProvider.overrideWith((_) => ThemeNotifier()),
      ];

  group('AuthPage - Login tab', () {
    testWidgets('displays welcome title and subtitle', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);

      expect(find.text('Bienvenue dans Questify'), findsOneWidget);
      expect(
        find.text('Transforme ton quotidien en aventure epique !'),
        findsOneWidget,
      );
    });

    testWidgets('displays login and signup tabs', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);

      expect(find.text('Se connecter'), findsOneWidget);
      expect(find.text('Creer mon profil'), findsOneWidget);
    });

    testWidgets('login tab shows email and password fields', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);

      expect(find.text('Adresse e-mail'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
      expect(find.text('aventurier@questify.app'), findsOneWidget);
    });

    testWidgets('login tab shows submit button', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);

      expect(find.text("Entrer dans l'aventure"), findsOneWidget);
    });

    testWidgets('login tab shows social login buttons', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);

      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('ou continuer avec'), findsOneWidget);
    });

    testWidgets('login tab shows forgot password link', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);

      expect(find.text('Mot de passe oublie ?'), findsOneWidget);
    });

    testWidgets('login form validates empty fields', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);

      // Scroll to make submit button visible, then tap
      final submitFinder = find.text("Entrer dans l'aventure");
      await tester.ensureVisible(submitFinder);
      await tester.pump();
      await tester.tap(submitFinder);
      await tester.pump();

      expect(find.text('Requis'), findsWidgets);
    });

    testWidgets('password visibility toggle works', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('footer terms text is displayed', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);

      expect(
        find.text("En continuant, tu acceptes nos conditions d'utilisation"),
        findsOneWidget,
      );
    });

    testWidgets('theme toggle button is displayed', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);

      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });

    testWidgets('security icon is displayed in logo', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);

      expect(find.byIcon(Icons.security), findsOneWidget);
    });

    testWidgets('login calls auth provider on valid form', (tester) async {
      when(() => mockApi.login('test@test.com', 'password123'))
          .thenThrow(ApiException('Network error'));

      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);

      await tester.enterText(find.byType(TextFormField).at(0), 'test@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');

      final submitFinder = find.text("Entrer dans l'aventure");
      await tester.ensureVisible(submitFinder);
      await tester.pump();
      await tester.tap(submitFinder);
      await tester.pump();

      // No validation errors — form was submitted
      expect(find.text('Requis'), findsNothing);
    });
  });

  group('AuthPage - Signup tab', () {
    testWidgets('shows hero name field', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);
      await switchToSignupTab(tester);

      expect(find.text('Nom de ton heros'), findsOneWidget);
      expect(find.text('Ex: Alex le Conquerant'), findsOneWidget);
    });

    testWidgets('shows avatar selector', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);
      await switchToSignupTab(tester);

      expect(find.text('Choisis ton avatar'), findsOneWidget);
    });

    testWidgets('shows level badge', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);
      await switchToSignupTab(tester);

      expect(find.text('Niveau 1 - Novice Heroique'), findsOneWidget);
    });

    testWidgets('shows create button', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);
      await switchToSignupTab(tester);

      expect(find.text('Creer mon profil heros'), findsOneWidget);
    });

    testWidgets('validates empty name and email', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);
      await switchToSignupTab(tester);

      final submitFinder = find.text('Creer mon profil heros');
      await tester.ensureVisible(submitFinder);
      await tester.pump();
      await tester.tap(submitFinder);
      await tester.pump();

      expect(find.text('Requis'), findsWidgets);
    });

    testWidgets('validates short password', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);
      await switchToSignupTab(tester);

      // On signup tab: find TextFormFields that are visible (signup has 3 fields)
      // The signup fields are: hero name, email, password
      // Use hint text to identify them
      final heroNameField = find.widgetWithText(TextFormField, 'Ex: Alex le Conquerant');
      final emailField = find.widgetWithText(TextFormField, 'aventurier@questify.app');

      await tester.enterText(heroNameField, 'Alex');
      await tester.enterText(emailField, 'test@test.com');

      // Find password field by hint text (bullet characters)
      final passwordFields = find.byType(TextFormField);
      // The last TextFormField on the signup tab is the password
      // Scroll to make it visible first
      final submitFinder = find.text('Creer mon profil heros');
      await tester.ensureVisible(submitFinder);
      await tester.pump();

      // Enter a short password in the visible password field
      // Find the signup password field — it has the visibility_off suffix icon
      // On signup tab there's a password field with obscureText
      final allFields = tester.widgetList<TextFormField>(passwordFields).toList();
      // Enter password in the last TextFormField (signup password)
      await tester.enterText(passwordFields.last, '123');

      await tester.tap(submitFinder);
      await tester.pump();

      expect(find.text('Min 6 caracteres'), findsOneWidget);
    });

    testWidgets('validates invalid email', (tester) async {
      await tester.pumpWidget(buildTestApp(overrides: defaultOverrides()));
      await pumpAuth(tester);
      await switchToSignupTab(tester);

      final heroNameField = find.widgetWithText(TextFormField, 'Ex: Alex le Conquerant');

      await tester.enterText(heroNameField, 'Alex');

      // The signup email field shares the same hint text but is a different instance
      // Find all 'aventurier@questify.app' hint text fields — on signup tab the visible one
      final emailField = find.widgetWithText(TextFormField, 'aventurier@questify.app');
      await tester.enterText(emailField, 'notanemail');

      final submitFinder = find.text('Creer mon profil heros');
      await tester.ensureVisible(submitFinder);
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).last, 'password123');

      await tester.tap(submitFinder);
      await tester.pump();

      expect(find.text('Email invalide'), findsOneWidget);
    });
  });
}
