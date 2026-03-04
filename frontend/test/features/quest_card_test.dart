import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/quests/quest_card.dart';
import 'package:frontend/models/quest.dart';

Widget buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(body: child),
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

    testWidgets('displays quest description', (tester) async {
      await tester.pumpWidget(buildTestApp(
        QuestCard(quest: pendingQuest),
      ));

      expect(find.text('Slay the ancient dragon in the mountain cave'),
          findsOneWidget);
    });

    testWidgets('displays difficulty label', (tester) async {
      await tester.pumpWidget(buildTestApp(
        QuestCard(quest: pendingQuest),
      ));

      expect(find.text('Epique'), findsOneWidget);
    });

    testWidgets('displays status label for pending quest', (tester) async {
      await tester.pumpWidget(buildTestApp(
        QuestCard(quest: pendingQuest),
      ));

      expect(find.text('En attente'), findsOneWidget);
    });

    testWidgets('displays status label for completed quest', (tester) async {
      await tester.pumpWidget(buildTestApp(
        QuestCard(quest: completedQuest),
      ));

      expect(find.text('Terminee'), findsOneWidget);
    });

    testWidgets('shows complete button for non-completed quest',
        (tester) async {
      bool completed = false;
      await tester.pumpWidget(buildTestApp(
        QuestCard(
          quest: pendingQuest,
          onComplete: () => completed = true,
        ),
      ));

      final completeBtn = find.byIcon(Icons.check_circle_outline);
      expect(completeBtn, findsOneWidget);

      await tester.tap(completeBtn);
      expect(completed, isTrue);
    });

    testWidgets('hides complete button for completed quest', (tester) async {
      await tester.pumpWidget(buildTestApp(
        QuestCard(
          quest: completedQuest,
          onComplete: () {},
        ),
      ));

      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
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
  });
}
