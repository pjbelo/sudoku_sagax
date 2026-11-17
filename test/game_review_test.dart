import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_sagax/game/game_review.dart';
import 'package:sudoku_sagax/game/logic_coach.dart';
import 'package:sudoku_sagax/game/sudoku_game.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';

void main() {
  test('techniques needed: one step per empty cell, in technique order', () {
    for (final level in [1, 6, 9]) {
      final puzzle = generatePuzzle(level, seed: 2);
      final needed = techniquesNeeded(puzzle);
      expect(needed.values.fold(0, (sum, n) => sum + n), 81 - puzzle.clueCount);
      final order = needed.keys.map((t) => t.index).toList();
      expect(order, [...order]..sort());
      expect(needed.containsKey(CoachTechnique.fromSolution), isFalse);
      expect(needed.containsKey(CoachTechnique.mistake), isFalse);
    }
    // Level 9 needs an X-Wing somewhere.
    expect(
      techniquesNeeded(generatePuzzle(9, seed: 2)),
      contains(CoachTechnique.xWing),
    );
  });

  test('a hint and a mistake keep what the review needs', () {
    final game = SudokuGame(generatePuzzle(1, seed: 3));
    final step = findCoachStep(game)!;
    final hint = ReviewEvent.hint(step, 75);
    expect(hint.kind, ReviewEventKind.hint);
    expect(hint.cell, step.cell);
    expect(hint.digit, step.digit);
    expect(hint.technique, step.technique);

    final cell = game.values.indexOf(0);
    final available = findCoachStep(game, preferred: cell)!;
    final mistake = ReviewEvent.mistake(cell, 5, 120, available);
    expect(mistake.kind, ReviewEventKind.mistake);
    expect(mistake.digit, 5);
    expect(mistake.stepCell, available.cell);
    expect(mistake.stepDigit, available.digit);
  });

  test('events survive JSON, and damaged ones are refused', () {
    final game = SudokuGame(generatePuzzle(1, seed: 3));
    final event = ReviewEvent.hint(findCoachStep(game)!, 75);
    final copy = ReviewEvent.fromJson(
      jsonDecode(jsonEncode(event.toJson())) as Map<String, dynamic>,
    );
    expect(copy.toJson(), event.toJson());
    expect(
      () => ReviewEvent.fromJson({...event.toJson(), 'technique': 'magic'}),
      throwsArgumentError,
    );
  });
}
