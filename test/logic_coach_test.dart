import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_sagax/game/logic_coach.dart';
import 'package:sudoku_sagax/game/sudoku_game.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';

int bit(int digit) => 1 << (digit - 1);

/// An empty grid where every digit is still possible everywhere.
List<int> openGrid() => List.filled(81, 0x1FF);

/// Takes [digit] out of [cells].
void rule(List<int> cand, int digit, Iterable<int> cells) {
  for (final c in cells) {
    cand[c] &= ~bit(digit);
  }
}

List<int> rowCells(int r) => [for (int c = 0; c < 9; c++) r * 9 + c];

void main() {
  group('whole games', () {
    test('every step places the right digit, at every level', () {
      for (int level = 1; level <= 9; level++) {
        for (int seed = 0; seed < 25; seed++) {
          final game = SudokuGame(generatePuzzle(level, seed: seed));
          var steps = 0;
          while (true) {
            final step = findCoachStep(game);
            if (step == null) break;
            expect(step.digit, game.solution[step.cell]);
            expect(game.values[step.cell], 0);
            // Nothing harder than the level needs, never a guess.
            final (_, hardest) = techniqueRange(
              sudokuLevels[level - 1].technique,
            );
            expect(
              step.technique.index,
              lessThanOrEqualTo(hardest.index),
              reason: 'level $level, seed $seed: ${step.technique.name}',
            );
            game.applyHint(step.cell, noteRemovals: step.removals);
            steps++;
          }
          expect(game.isSolved, isTrue);
          expect(steps, 81 - sudokuLevels[level - 1].clues);
        }
      }
    });

    test('levels 1–5 need nothing but singles', () {
      for (int level = 1; level <= 5; level++) {
        final game = SudokuGame(generatePuzzle(level, seed: 11));
        while (true) {
          final step = findCoachStep(game);
          if (step == null) break;
          expect(step.eliminations, isEmpty);
          expect(step.singleTechnique, isNot(CoachTechnique.fromSolution));
          game.applyHint(step.cell);
        }
      }
    });
  });

  group('the step chosen', () {
    late SudokuGame game;
    late int empty;

    setUp(() {
      game = SudokuGame(generatePuzzle(1, seed: 3));
      empty = game.values.indexOf(0);
    });

    test('a wrong digit comes first, the selected one if it is wrong', () {
      final other = game.values.lastIndexOf(0);
      game.enterDigit(empty, game.solution[empty] % 9 + 1);
      game.enterDigit(other, game.solution[other] % 9 + 1);
      final step = findCoachStep(game, preferred: other)!;
      expect(step.technique, CoachTechnique.mistake);
      expect(step.cell, other);
      expect(step.wrongDigit, game.values[other]);
      expect(step.digit, game.solution[other]);
      expect(findCoachStep(game)!.cell, empty);
    });

    test('a single for the selected cell when there is one', () {
      final first = findCoachStep(game)!.cell;
      // Another empty cell that has a single of its own.
      final cell = [
        for (int i = 0; i < 81; i++)
          if (game.values[i] == 0 && i != first) i,
      ].firstWhere((i) => findCoachStep(game, preferred: i)!.cell == i);
      expect(cell, isNot(first));
    });

    test('nothing left on a solved grid', () {
      for (int i = 0; i < 81; i++) {
        if (game.values[i] == 0) game.enterDigit(i, game.solution[i]);
      }
      expect(findCoachStep(game), isNull);
    });

    test('a hidden single names its unit and looks there', () {
      final step = findCoachStep(game)!;
      expect(step.technique, CoachTechnique.hiddenSingle);
      expect(step.singleUnit, isNotNull);
      expect(step.lookAt.cells, contains(step.cell));
      expect(step.focusCells, {step.cell});
      expect(step.candidatesToShow.keys, [step.cell]);
    });
  });

  group('techniques', () {
    test('pointing pair: a box digit in one row leaves the rest of it', () {
      final cand = openGrid();
      // Box 0: the 5 only in cells 0 and 1, both in row 0.
      rule(cand, 5, [2, 9, 10, 11, 18, 19, 20]);
      final e = eliminationsFor(CoachTechnique.pointingPair, cand).single;
      expect(e.patternCells, [0, 1]);
      expect(e.units.first.kind, UnitKind.box);
      expect(e.units[1].kind, UnitKind.row);
      expect(e.removals, {for (int c = 3; c < 9; c++) c: bit(5)});
    });

    test('box-line reduction: a row digit in one box leaves the box', () {
      final cand = openGrid();
      // Row 0: the 5 only in cells 0 and 1, both in box 0.
      rule(cand, 5, [for (int c = 2; c < 9; c++) c]);
      final found = eliminationsFor(CoachTechnique.boxLineReduction, cand);
      final e = found.firstWhere((e) => e.units.first.kind == UnitKind.row);
      expect(e.patternCells, [0, 1]);
      expect(e.removals.keys.toSet(), {9, 10, 11, 18, 19, 20});
    });

    test('naked pair: two cells with the same two digits', () {
      final cand = openGrid();
      cand[0] = bit(1) | bit(2);
      cand[1] = bit(1) | bit(2);
      final found = eliminationsFor(CoachTechnique.nakedPair, cand);
      // Cells 0 and 1 share row 0 and box 0.
      expect(found.map((e) => e.units.first.kind).toSet(), {
        UnitKind.row,
        UnitKind.box,
      });
      final row = found.firstWhere((e) => e.units.first.kind == UnitKind.row);
      expect(row.digits, [1, 2]);
      expect(row.removals, {for (int c = 2; c < 9; c++) c: bit(1) | bit(2)});
    });

    test('hidden pair: two digits in only the same two cells', () {
      final cand = openGrid();
      rule(cand, 1, [for (int c = 2; c < 9; c++) c]);
      rule(cand, 2, [for (int c = 2; c < 9; c++) c]);
      final e = eliminationsFor(
        CoachTechnique.hiddenPair,
        cand,
      ).firstWhere((e) => e.units.first.kind == UnitKind.row);
      expect(e.digits, [1, 2]);
      expect(e.patternCells, [0, 1]);
      expect(e.removals, {0: 0x1FF & ~3, 1: 0x1FF & ~3});
    });

    test('naked triple: three cells sharing three digits', () {
      final cand = openGrid();
      cand[0] = bit(1) | bit(2);
      cand[1] = bit(2) | bit(3);
      cand[2] = bit(1) | bit(3);
      final e = eliminationsFor(
        CoachTechnique.nakedTriple,
        cand,
      ).firstWhere((e) => e.units.first.kind == UnitKind.row);
      expect(e.digits, [1, 2, 3]);
      expect(e.removals.keys.toSet(), {3, 4, 5, 6, 7, 8});
    });

    test('X-Wing: a digit in the same two columns of two rows', () {
      final cand = openGrid();
      // Rows 0 and 4: the 7 only in columns 1 and 6.
      for (final r in [0, 4]) {
        rule(cand, 7, rowCells(r).where((c) => c % 9 != 1 && c % 9 != 6));
      }
      final e = eliminationsFor(
        CoachTechnique.xWing,
        cand,
      ).firstWhere((e) => e.units.first.kind == UnitKind.row);
      expect(e.patternCells.toSet(), {1, 6, 37, 42});
      expect(e.units.map((u) => u.index).toList(), [0, 4, 1, 6]);
      // The 7 leaves columns 1 and 6 in the other seven rows.
      expect(e.removals.length, 14);
      expect(e.removals.values.toSet(), {bit(7)});
    });
  });

  test('an elimination step shows its pattern and the cell to fill', () {
    // Find a real elimination step in the harder levels.
    CoachStep? found;
    for (int seed = 0; seed < 40 && found == null; seed++) {
      final game = SudokuGame(generatePuzzle(9, seed: seed));
      while (found == null) {
        final step = findCoachStep(game);
        if (step == null) break;
        if (step.eliminations.isNotEmpty) found = step;
        game.applyHint(step.cell, noteRemovals: step.removals);
      }
    }
    final step = found!;
    final e = step.eliminations.first;
    expect(step.lookAt, e.units.first);
    expect(step.focusCells, containsAll([...e.patternCells, step.cell]));
    expect(step.removedCells, isNotEmpty);
    expect(step.areaCells, containsAll(step.lookAt.cells));
    // The cell to fill keeps its digit among the candidates shown, and a
    // naked single shows it alone.
    final shown = step.candidatesToShow[step.cell]!;
    expect(shown & bit(step.digit), isNonZero);
    if (step.singleTechnique == CoachTechnique.nakedSingle) {
      expect(bitCount(shown), 1);
    }
  });
}
