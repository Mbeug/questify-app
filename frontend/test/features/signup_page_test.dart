import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/signup/signup_page.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/api_service.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

Widget buildTestApp(
  Widget child, {
  required MockApiService mockApi,
  required MockSecureStorage mockStorage,
}) {
  return ProviderScope(
    overrides: [
      apiServiceProvider.overrideWithValue(mockApi),
      secureStorageProvider.overrideWithValue(mockStorage),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  late MockApiService mockApi;
  late MockSecureStorage mockStorage;

  setUp(() {
    mockApi = MockApiService();
    mockStorage = MockSecureStorage();

    // _tryAutoLogin reads from storage — return null (no saved tokens)
    when(() => mockStorage.read(key: 'accessToken'))
        .thenAnswer((_) async => null);
    when(() => mockStorage.read(key: 'refreshToken'))
        .thenAnswer((_) async => null);
  });

  group('SignupPage', () {
    testWidgets('renders all fields', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const SignupPage(),
        mockApi: mockApi,
        mockStorage: mockStorage,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Rejoins Questify'), findsOneWidget);
      expect(find.text("Nom d'aventurier"), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
      expect(find.text('Creer mon compte'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        const SignupPage(),
        mockApi: mockApi,
        mockStorage: mockStorage,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Creer mon compte'));
      await tester.pumpAndSettle();

      expect(find.text('Requis'), findsWidgets);
    });

    testWidgets('shows email validation error for invalid email',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        const SignupPage(),
        mockApi: mockApi,
        mockStorage: mockStorage,
      ));
      await tester.pumpAndSettle();

      // Fill name and password but put invalid email
      await tester.enterText(
          find.widgetWithText(TextFormField, "Nom d'aventurier"), 'Hero');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'notemail');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Mot de passe'), 'password123');

      await tester.tap(find.text('Creer mon compte'));
      await tester.pumpAndSettle();

      expect(find.text('Email invalide'), findsOneWidget);
    });

    testWidgets('shows min length error for short password', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const SignupPage(),
        mockApi: mockApi,
        mockStorage: mockStorage,
      ));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, "Nom d'aventurier"), 'Hero');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'hero@test.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Mot de passe'), '123');

      await tester.tap(find.text('Creer mon compte'));
      await tester.pumpAndSettle();

      expect(find.text('Min 6 caracteres'), findsOneWidget);
    });

    testWidgets('has link to login page', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const SignupPage(),
        mockApi: mockApi,
        mockStorage: mockStorage,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Deja un compte ? Se connecter'), findsOneWidget);
    });
  });
}
