import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/login/login_page.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/api_service.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

/// Helper to build a testable widget with overridden providers
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

  group('LoginPage', () {
    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const LoginPage(),
        mockApi: mockApi,
        mockStorage: mockStorage,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Questify'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
      expect(find.text('Se connecter'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        const LoginPage(),
        mockApi: mockApi,
        mockStorage: mockStorage,
      ));
      await tester.pumpAndSettle();

      // Tap submit without filling in fields
      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      // Should show 'Requis' validation errors
      expect(find.text('Requis'), findsWidgets);
    });

    testWidgets('has a link to signup page', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const LoginPage(),
        mockApi: mockApi,
        mockStorage: mockStorage,
      ));
      await tester.pumpAndSettle();

      expect(find.text("Pas de compte ? S'inscrire"), findsOneWidget);
    });

    testWidgets('toggles password visibility', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const LoginPage(),
        mockApi: mockApi,
        mockStorage: mockStorage,
      ));
      await tester.pumpAndSettle();

      // Initially password is obscured — find visibility_off icon
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap to toggle
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Now should show visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}
