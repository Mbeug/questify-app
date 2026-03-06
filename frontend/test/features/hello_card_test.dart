import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:frontend/features/dashboard/hello_card.dart';
import 'package:frontend/services/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApi;

  setUp(() {
    mockApi = MockApiService();
  });

  Widget buildApp() {
    return MaterialApp(
      home: Scaffold(
        body: HelloCard(api: mockApi),
      ),
    );
  }

  group('HelloCard', () {
    testWidgets('shows loading indicator while waiting', (tester) async {
      final completer = Completer<String>();
      when(() => mockApi.getHello())
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildApp());
      // Don't settle — we want the loading state
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Connexion au serveur...'), findsOneWidget);

      // Clean up to avoid dangling future
      completer.complete('done');
    });

    testWidgets('shows server response on success', (tester) async {
      when(() => mockApi.getHello())
          .thenAnswer((_) async => 'Bienvenue sur Questify!');

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Bienvenue sur Questify!'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('shows error text and retry button on failure',
        (tester) async {
      when(() => mockApi.getHello())
          .thenAnswer((_) async => throw ApiException('Serveur indisponible'));

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text("Erreur lors de l'appel API"), findsOneWidget);
      expect(find.text('Reessayer'), findsOneWidget);
    });

    testWidgets('retry button re-fetches data', (tester) async {
      // First call fails
      when(() => mockApi.getHello())
          .thenAnswer((_) async => throw ApiException('Erreur'));

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text("Erreur lors de l'appel API"), findsOneWidget);

      // Now make it succeed on retry
      when(() => mockApi.getHello())
          .thenAnswer((_) async => 'Hello World');

      await tester.tap(find.text('Reessayer'));
      await tester.pumpAndSettle();

      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('refresh icon button on success re-fetches data',
        (tester) async {
      when(() => mockApi.getHello())
          .thenAnswer((_) async => 'Message 1');

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Message 1'), findsOneWidget);

      when(() => mockApi.getHello())
          .thenAnswer((_) async => 'Message 2');

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      expect(find.text('Message 2'), findsOneWidget);
    });

    testWidgets('shows snackbar on error', (tester) async {
      when(() => mockApi.getHello())
          .thenAnswer((_) async => throw ApiException('Timeout serveur'));

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // The snackbar is shown via addPostFrameCallback
      expect(find.text('Timeout serveur'), findsOneWidget);
    });
  });
}
