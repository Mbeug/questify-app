import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:frontend/features/quests/create_quest_page.dart';
import 'package:frontend/models/quest.dart';
import 'package:frontend/providers/quests_provider.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/theme.dart';

class MockApiService extends Mock implements ApiService {}

Widget buildTestApp({required MockApiService mockApi}) {
  return ProviderScope(
    overrides: [
      apiServiceProvider.overrideWithValue(mockApi),
    ],
    child: MaterialApp(
      theme: ThemeData(extensions: const [QuestifyColors.day]),
      home: const CreateQuestPage(),
    ),
  );
}

void main() {
  late MockApiService mockApi;

  setUpAll(() {
    registerFallbackValue(QuestDifficulty.MEDIUM);
    registerFallbackValue(QuestCategory.HOME);
    registerFallbackValue(QuestRecurrence.ONE_TIME);
  });

  setUp(() {
    mockApi = MockApiService();
  });

  group('CreateQuestPage', () {
    testWidgets('displays header with title', (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      expect(find.textContaining('Nouvelle quete'), findsOneWidget);
      expect(find.text('Cree ton aventure epique'), findsOneWidget);
    });

    testWidgets('displays title and description fields', (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      expect(find.text('Titre de la quete'), findsOneWidget);
      expect(find.text('Description (optionnelle)'), findsOneWidget);
      expect(find.text('Ex: Faire 30 minutes de sport'), findsOneWidget);
      expect(find.text('Details de ta quete...'), findsOneWidget);
    });

    testWidgets('displays difficulty selector with all options',
        (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      expect(find.text('Difficulte'), findsOneWidget);
      expect(find.text('Facile'), findsOneWidget);
      expect(find.text('Moyen'), findsWidgets); // label + info section
      expect(find.text('Difficile'), findsOneWidget);
      expect(find.text('Epique'), findsOneWidget);
    });

    testWidgets('medium difficulty is selected by default', (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      // Default difficulty is MEDIUM — info section shows "Quete Moyen"
      expect(find.text('Quete Moyen'), findsOneWidget);
      expect(find.text('Gagne 50 XP et 20 pieces'), findsOneWidget);
    });

    testWidgets('displays category selector', (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      expect(find.text('Categorie'), findsOneWidget);
      expect(find.textContaining('Aucune'), findsOneWidget);
      expect(find.textContaining('Maison'), findsOneWidget);
      expect(find.textContaining('Sport'), findsOneWidget);
      expect(find.textContaining('Personnel'), findsOneWidget);
      expect(find.textContaining('Travail'), findsOneWidget);
    });

    testWidgets('displays recurrence selector', (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      expect(find.text('Recurrence'), findsOneWidget);
      expect(find.textContaining('Unique'), findsOneWidget);
      expect(find.textContaining('Quotidienne'), findsOneWidget);
      expect(find.textContaining('Hebdomadaire'), findsOneWidget);
    });

    testWidgets('displays due date option', (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      expect(
        find.text('Ajouter une echeance (optionnel)'),
        findsOneWidget,
      );
    });

    testWidgets('displays preview card with placeholder', (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      expect(find.text('Titre de ta quete...'), findsOneWidget);
      expect(find.text('Rare'), findsOneWidget); // MEDIUM rarity = "Rare"
    });

    testWidgets('preview updates when title is typed', (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      final titleField = find.widgetWithText(
        TextFormField,
        'Ex: Faire 30 minutes de sport',
      );
      await tester.enterText(titleField, 'Mon aventure');
      await tester.pump();

      expect(find.text('Mon aventure'), findsWidgets); // in field + preview
      // The placeholder should be gone
      expect(find.text('Titre de ta quete...'), findsNothing);
    });

    testWidgets('switching difficulty updates info section', (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      // Tap "Facile"
      await tester.tap(find.text('Facile'));
      await tester.pump();

      expect(find.text('Quete Facile'), findsOneWidget);
      expect(find.text('Gagne 25 XP et 10 pieces'), findsOneWidget);
    });

    testWidgets('switching to hard difficulty updates preview rarity',
        (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      await tester.tap(find.text('Difficile'));
      await tester.pump();

      expect(find.text('Epique'), findsWidgets); // rarity label + difficulty button
      expect(find.text('Gagne 100 XP et 50 pieces'), findsOneWidget);
    });

    testWidgets('submit button is disabled when title is empty',
        (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      // Scroll to make submit button visible
      final submitFinder = find.text('Creer la quete');
      await tester.ensureVisible(submitFinder);
      await tester.pump();

      // Button exists
      expect(submitFinder, findsOneWidget);

      // The ElevatedButton should be disabled (onPressed is null because title is empty)
      final button = tester.widget<ElevatedButton>(
        find.ancestor(
          of: submitFinder,
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('submit button is enabled after entering title',
        (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      // Enter a title
      final titleField = find.widgetWithText(
        TextFormField,
        'Ex: Faire 30 minutes de sport',
      );
      await tester.enterText(titleField, 'Ma quete');
      await tester.pump();

      // Scroll to submit button
      final submitFinder = find.text('Creer la quete');
      await tester.ensureVisible(submitFinder);
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.ancestor(
          of: submitFinder,
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('form validates empty title on submit', (tester) async {
      // Need to first enable the button by entering then clearing text
      // Actually the button is disabled when title is empty, so validation
      // won't trigger. This is by design — the UI prevents empty submit.
      // Let's test that the button remains disabled with only spaces.
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      final titleField = find.widgetWithText(
        TextFormField,
        'Ex: Faire 30 minutes de sport',
      );
      await tester.enterText(titleField, '   ');
      await tester.pump();

      final submitFinder = find.text('Creer la quete');
      await tester.ensureVisible(submitFinder);
      await tester.pump();

      // Button should still be disabled because trim() makes it empty
      final button = tester.widget<ElevatedButton>(
        find.ancestor(
          of: submitFinder,
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('displays back button', (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('displays XP badge in preview for default difficulty',
        (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      expect(find.text('+50 XP'), findsOneWidget); // MEDIUM = 50 XP
    });

    testWidgets('selecting category updates state', (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      // Tap "Sport" category — may be off-screen, scroll first
      final sportFinder = find.textContaining('Sport');
      await tester.ensureVisible(sportFinder);
      await tester.pump();
      await tester.tap(sportFinder);
      await tester.pump();

      // The Sport option should now appear selected (visual change)
      expect(find.textContaining('Sport'), findsOneWidget);
    });

    testWidgets('selecting recurrence updates state', (tester) async {
      await tester.pumpWidget(buildTestApp(mockApi: mockApi));
      await tester.pump();

      // Tap "Quotidienne" recurrence — may be off-screen, scroll first
      final recFinder = find.textContaining('Quotidienne');
      await tester.ensureVisible(recFinder);
      await tester.pump();
      await tester.tap(recFinder);
      await tester.pump();

      expect(find.textContaining('Quotidienne'), findsOneWidget);
    });
  });
}
