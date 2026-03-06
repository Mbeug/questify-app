import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/quests/quest_card.dart';
import 'package:frontend/models/quest.dart';
import 'package:frontend/theme.dart';

Widget buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: ThemeData(
        extensions: const [QuestifyColors.day],
      ),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

void main() {
  group('QuestCard', () {
    const pendingQuest = Quest(
      id: 1,
      title: 'Defeat the Dragon',
      description: 'Slay the ancient dragon in the mountain cave',
      status: QuestStatus.PENDING,
      difficulty: QuestDifficulty.EPIC,
      xpReward: 500,
    );

    const completedQuest = Quest(
      id: 2,
      title: 'Gather Herbs',
      status: QuestStatus.COMPLETED,
      difficulty: QuestDifficulty.EASY,
      xpReward: 50,
      completedAt: '2025-06-01T12:00:00',
    );

    testWidgets('displays quest title and XP reward', (tester) async {
      await tester.pumpWidget(buildTestApp(
        QuestCard(quest: pendingQuest),
      ));

      expect(find.text('Defeat the Dragon'), findsOneWidget);
      expect(find.text('+500 XP'), findsOneWidget);
    });

    testWidgets('displays difficulty label', (tester) async {
      await tester.pumpWidget(buildTestApp(
        QuestCard(quest: pendingQuest),
      ));

      expect(find.text('Epique'), findsOneWidget);
    });

    testWidgets('displays rarity badge for pending EPIC quest',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        QuestCard(quest: pendingQuest),
      ));

      // EPIC maps to 'legendary' rarity, label = 'Legendaire'
      expect(find.text('\u{1F534} Legendaire'), findsOneWidget);
    });

    testWidgets('completed quest is rendered with reduced opacity',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        QuestCard(quest: completedQuest),
      ));

      // The whole content column is wrapped in Opacity(0.5) for completed quests
      final opacityWidget = tester.widget<Opacity>(find.byType(Opacity).first);
      expect(opacityWidget.opacity, 0.5);
    });

    testWidgets(
        'completion checkbox is tappable for non-completed quest',
        (tester) async {
      bool completed = false;
      await tester.pumpWidget(buildTestApp(
        QuestCard(
          quest: pendingQuest,
          onComplete: () => completed = true,
        ),
      ));

      // The _CompletionCheckbox is a GestureDetector wrapping a 28x28 AnimatedContainer
      // For a non-completed quest, the checkbox shows an empty box (no check icon)
      // Find the AnimatedContainer with tight 28x28 constraints (the checkbox)
      final checkboxFinder = find.byWidgetPredicate((widget) =>
          widget is AnimatedContainer &&
          widget.constraints == BoxConstraints.tightFor(width: 28, height: 28));

      expect(checkboxFinder, findsOneWidget);

      // Tap the checkbox
      await tester.tap(checkboxFinder);
      expect(completed, isTrue);
    });

    testWidgets('completion checkbox is not tappable for completed quest',
        (tester) async {
      bool completed = false;
      await tester.pumpWidget(buildTestApp(
        QuestCard(
          quest: completedQuest,
          onComplete: () => completed = true,
        ),
      ));

      // For a completed quest, the checkbox shows a green check icon
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Tapping it should NOT trigger onComplete (the GestureDetector's onTap is null)
      await tester.tap(find.byIcon(Icons.check));
      expect(completed, isFalse);
    });

    testWidgets('shows delete button and calls callback', (tester) async {
      bool deleted = false;
      await tester.pumpWidget(buildTestApp(
        QuestCard(
          quest: pendingQuest,
          onDelete: () => deleted = true,
        ),
      ));

      final deleteBtn = find.byIcon(Icons.delete_outline);
      expect(deleteBtn, findsOneWidget);

      await tester.tap(deleteBtn);
      expect(deleted, isTrue);
    });

    testWidgets('calls onTap callback when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildTestApp(
        QuestCard(
          quest: pendingQuest,
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.text('Defeat the Dragon'));
      expect(tapped, isTrue);
    });

    testWidgets('shows all difficulty labels correctly', (tester) async {
      final difficulties = {
        QuestDifficulty.EASY: 'Facile',
        QuestDifficulty.MEDIUM: 'Moyen',
        QuestDifficulty.HARD: 'Difficile',
        QuestDifficulty.EPIC: 'Epique',
      };

      for (final entry in difficulties.entries) {
        await tester.pumpWidget(buildTestApp(
          QuestCard(
            quest: Quest(
              id: 1,
              title: 'Test',
              status: QuestStatus.PENDING,
              difficulty: entry.key,
              xpReward: 100,
            ),
          ),
        ));

        expect(find.text(entry.value), findsOneWidget);
      }
    });

    testWidgets('shows rarity labels for all difficulties', (tester) async {
      final rarityLabels = {
        QuestDifficulty.EASY: '\u{1F7E2} Commune',
        QuestDifficulty.MEDIUM: '\u{1F7E1} Rare',
        QuestDifficulty.HARD: '\u{1F7E3} Epique',
        QuestDifficulty.EPIC: '\u{1F534} Legendaire',
      };

      for (final entry in rarityLabels.entries) {
        await tester.pumpWidget(buildTestApp(
          QuestCard(
            quest: Quest(
              id: 1,
              title: 'Test',
              status: QuestStatus.PENDING,
              difficulty: entry.key,
              xpReward: 100,
            ),
          ),
        ));

        expect(find.text(entry.value), findsOneWidget);
      }
    });

    testWidgets('hides delete button when onDelete is null',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        QuestCard(quest: pendingQuest),
      ));

      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('shows coin reward badge when coinReward > 0',
        (tester) async {
      const questWithCoins = Quest(
        id: 3,
        title: 'Gold Quest',
        status: QuestStatus.PENDING,
        difficulty: QuestDifficulty.MEDIUM,
        xpReward: 100,
        coinReward: 25,
      );

      await tester.pumpWidget(buildTestApp(
        QuestCard(quest: questWithCoins),
      ));

      expect(find.text('+25 \u{1FA99}'), findsOneWidget);
    });

    testWidgets('hides coin reward badge when coinReward is 0',
        (tester) async {
      await tester.pumpWidget(buildTestApp(
        QuestCard(quest: pendingQuest),
      ));

      // pendingQuest has default coinReward = 0, so no coin badge
      expect(find.textContaining('\u{1FA99}'), findsNothing);
    });
  });
}
